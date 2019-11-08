
import UIKit
import Alamofire
import Foundation

struct UserInfoKey {
    // 저장에 사용할 키
    static let loginId = "LOGINID"
    static let account = "ACCOUNT"
    static let name = "NAME"
    static let profile = "PROFILE"
    static let tutorial = "TUTORIAL"
}


class UserInfoManager {
    // 연산 프로퍼티 loginid 정의
    var loginid: Int {
        get{
            return UserDefaults.standard.integer(forKey: UserInfoKey.loginId)
        }
        set{
            let ud = UserDefaults.standard
            ud.set(newValue, forKey: UserInfoKey.loginId)
            ud.synchronize()
        }
    }
    
    var account: String? {
        get{
            return UserDefaults.standard.string(forKey: UserInfoKey.account)
        }
        set {
            let ud = UserDefaults.standard
            ud.set(newValue, forKey: UserInfoKey.account)
            ud.synchronize()
        }
    }
    
    var name: String? {
        get{
            return UserDefaults.standard.string(forKey: UserInfoKey.name)
        }
        set {
            let ud = UserDefaults.standard
            ud.set(newValue, forKey: UserInfoKey.name)
            ud.synchronize()
        }
    }
    
    var profile: UIImage? {
        get{
            let ud = UserDefaults.standard
            if let _profile = ud.data(forKey: UserInfoKey.profile) {
                return UIImage(data: _profile)
            }else{
                // 이미지가 없다면 기본 이미지로
                return UIImage(named: "account.jpg")
            }
        }
        set {
            if newValue != nil {
                let ud = UserDefaults.standard
                ud.set(newValue?.pngData()!, forKey: UserInfoKey.profile)
                ud.synchronize()
            }
        }
    }
    
    var isLogin: Bool {
        // 로그인 아이디가 0이거나 계정이 비어있으면
        if self.loginid == 0 || self.account == nil {
            return false
        }
        return true
    }

}

extension UserInfoManager {
    
    func login(account: String, passwd: String, success: (() -> Void)? = nil, fail: ((String) -> Void)? = nil) {
        // 1. URL과 전송할 값 준비
        let url = "http://swiftapi.rubypaper.co.kr:2029/userAccount/login"
        let param: Parameters = [
            "account" : account,
            "passwd" : passwd
        ]
        // 2. API 호출
        let call = Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil)
        // 3. API 호출과 결과 처리
        call.responseJSON(completionHandler: { res in
            // 3-1 JSON 형식으로 응답했는지 확인
            guard let jsonObject = res.result.value as? NSDictionary else {
                fail?("잘못된 응답 형식입니다.: \(res.result.value!)")
                return
            }
            // 3-2 응답 코드 확인. 0 이면 성공
            let resultCode = jsonObject["result_code"] as! Int
            if resultCode == 0 {
                // 3-3 user_info 이하 항목을 딕셔너리 형태로 추출하여 저장
                let user = jsonObject["user_info"] as! NSDictionary
                self.loginid = user["user_id"] as! Int
                self.account = user["account"] as? String
                self.name = user["name"] as? String
                // 3-4 user_info 항목 중에서 프로필 이미지 처리
                if let path = user["profile_path"] as? String {
                    if let imageData = try? Data(contentsOf: URL(string: path)!) {
                        self.profile = UIImage(data: imageData)
                    }
                }
                // 3-5 인자값으로 입력된 suceess 클로저 블록을 실행한다
                success?()
            }else {
                // 로그인 실패
                let msg = (jsonObject["error_msg"] as? String) ?? "로그인이 실패했습니다."
                fail?(msg)
            }
        })
    }
    
    func logout() -> Bool {
        let ud = UserDefaults.standard
        ud.removeObject(forKey: UserInfoKey.loginId)
        ud.removeObject(forKey: UserInfoKey.account)
        ud.removeObject(forKey: UserInfoKey.name)
        ud.removeObject(forKey: UserInfoKey.profile)
        ud.synchronize()
        return true
    }
}



