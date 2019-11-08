//
//  ProfileVC.swift
//  MyMemory
//
//  Created by JCLEE on 2019/10/31.
//  Copyright © 2019 JAECHUN LEE. All rights reserved.
//

import UIKit

    
class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let profileImage = UIImageView()
    let tv = UITableView()
    let uinfo = UserInfoManager()
    
    func drawBtn(){
        // 버튼을 감쌀 뷰를 정의한다
        let v = UIView()
        v.frame.size.width = self.view.frame.width
        v.frame.size.height = 40
        v.frame.origin.x = 0
        v.frame.origin.y = self.tv.frame.origin.y + self.tv.frame.height
        v.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        self.view.addSubview(v)
        
        // 버튼을 정의한다
        let btn = UIButton(type: .system)
        btn.frame.size.width = 100
        btn.frame.size.height = 30
        btn.center.x = v.frame.size.width / 2
        btn.center.y = v.frame.size.height / 2
        // 로그인 상태일 때는 로그아웃 버튼을, 로그아웃 상태일 때는 로그인 버튼을 만들어 주자
        if self.uinfo.isLogin == true {
            btn.setTitle("로그아웃", for: .normal)
            btn.addTarget(self, action: #selector(doLogout(_:)), for: .touchUpInside)
        }else{
            btn.setTitle("로그인", for: .normal)
            btn.addTarget(self, action: #selector(doLogin(_:)), for: .touchUpInside)
        }
        v.addSubview(btn)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 뒤로가기 버튼 처리
        let backBtn = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(close(_:)))
        self.navigationItem.leftBarButtonItem = backBtn
        
        // 배경 이미지 설정
        let bg = UIImage(named: "profile-bg")
        let bgImg = UIImageView(image: bg)
        bgImg.frame.size = CGSize(width: bgImg.frame.size.width, height: bgImg.frame.size.height)
        bgImg.center = CGPoint(x: self.view.frame.width / 2, y: 40)
        
        bgImg.layer.cornerRadius = bgImg.frame.size.width / 2
        bgImg.layer.borderWidth = 0
        bgImg.layer.masksToBounds = true
        self.view.addSubview(bgImg)
        
        // 1) 프로필 사진에 들어갈 기본 이미지
        //let image = UIImage(named: "account.jpg")
        let image = self.uinfo.profile
        // 2) 프로필 이미지 처리
        self.profileImage.image = image
        self.profileImage.frame.size = CGSize(width: 100, height: 100)
        self.profileImage.center = CGPoint(x: self.view.frame.width / 2, y: 270)
        // 3) 프로필 이미지 둥글게 만들기
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.layer.borderWidth = 0
        self.profileImage.layer.masksToBounds = true
        // 4) 루트 뷰에 추가
        self.view.addSubview(self.profileImage)
        
        // 테이블 뷰
        self.tv.frame = CGRect(x: 0, y: self.profileImage.frame.origin.y + self.profileImage.frame.size.height + 20, width: self.view.frame.width, height: 100)
        self.tv.dataSource = self
        self.tv.delegate = self
        self.view.addSubview(self.tv)
        
        // 최초 화면 로딩 시, 로그인 상태에 따라 적절히 로그인/로그아웃 버튼을 출력한다
        self.drawBtn()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(profile(_:)))
        self.profileImage.addGestureRecognizer(tap)
        self.profileImage.isUserInteractionEnabled = true

        self.navigationController?.navigationBar.isHidden = true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel?.font = .systemFont(ofSize: 14)
        cell.detailTextLabel?.font = .systemFont(ofSize: 13)
        cell.accessoryType = .disclosureIndicator
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "이름"
            cell.detailTextLabel?.text = self.uinfo.name ?? "please login"
        case 1:
            cell.textLabel?.text = "계정"
            //cell.detailTextLabel?.text = "jclee@naver.com"
            cell.detailTextLabel?.text = self.uinfo.account ?? "please login"
        default:
            ()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        if uinfo.isLogin == false {
            // 로그인 되지 않았다면 로그인 창을 띄어준다
            self.doLogin(self.tv)
        }
    }
        
    @objc func close(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension ProfileVC {
    
    @IBAction func backProfileVC (_ segue: UIStoryboardSegue) {
        // 단지 프로필 홤녀으로 되돌아오기 위한 표식 역할만 할 뿐이므로 아무 내용도 작성하지 않음.
    }

    @objc func doLogout(_ sender: Any) {
        let msg = "로그아웃 하시겠습니까?"
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { (_) in
            if self.uinfo.logout() {
                // 로그아웃 시 처리할 내용이 여기에 들어갈 예정입니다.
                self.tv.reloadData()    // 테이블 뷰를 갱신한다
                self.profileImage.image = self.uinfo.profile    // 이미지 프로필을 갱신한다
                self.drawBtn()  // 로그인 상태에 따라 적절히 로그인/로그아웃 버튼을 출력한다
            }
        }))
        self.present(alert, animated: false, completion: nil)
    }
    
    @objc func doLogin(_ sender: Any){
        let loginAlert = UIAlertController(title: "LOGIN", message: nil, preferredStyle: .alert)
        // 알림창에 들어갈 입력폼 추가
        loginAlert.addTextField(configurationHandler: { (tf) in
            tf.placeholder = "Your Account"
        })
        loginAlert.addTextField(configurationHandler: { (tf) in
            tf.placeholder = "Password"
            tf.isSecureTextEntry = true
        })
        // 알림창 버튼 추가
        loginAlert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        loginAlert.addAction(UIAlertAction(title: "Login", style: .destructive, handler: { (_) in
            let account = loginAlert.textFields?[0].text ?? ""  // 첫 번째 필드: 계정
            let passwd = loginAlert.textFields?[1].text ?? ""  // 두 번째 필드: 비밀번호
            
            if self.uinfo.login(account: account, passwd: passwd) {
                // 로그인 성공 시 처히할 내용이 들어갈 예정입니다.
                self.tv.reloadData()    // 테이블 뷰를 갱신한다
                self.profileImage.image = self.uinfo.profile    // 이미지 프로필을 갱신한다
                self.drawBtn()  // 로그인 상태에 따라 적절히 로그인/로그아웃 버튼을 출력한다
            }else{
                let msg = "로그인에 실패하였습니다."
                let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }))
        self.present(loginAlert, animated: false, completion: nil)
    }
}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imgPicker( _ source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func profile(_ sender: UIButton){
        // 로그인되어 있지 않을 경우, 프로필 이미지 등록을 막고 대신 로그인 창을 띄워준다
        guard self.uinfo.account != nil else{
            self.doLogin(self)
            return
        }
        
        let alert = UIAlertController(title: nil, message: "사진을 가져올 곳을 선택해주세요.", preferredStyle: .actionSheet)
        // 카메라를 사용할 수 있으면 ?
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "카메라", style: .default, handler: { (_) -> () in
                self.imgPicker(.camera)
            }))
        }
        // 저장된 앨범을 사용할 수 있으면?
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            alert.addAction(UIAlertAction(title: "저장된 앨범", style: .default, handler: { (action:UIAlertAction) -> Void in
                self.imgPicker(.savedPhotosAlbum)
            }))
            self.imgPicker(.savedPhotosAlbum)
        }
        // 포토 라이브러리를 사용할 수 있으면
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction((UIAlertAction(title: "포토 라이브러리", style: .default, handler: { (_) -> () in
                self.imgPicker(.photoLibrary)
            })))
        }
        // 액션 시트 창 실행
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.uinfo.profile = img
            self.profileImage.image = img
        }
        // 이 구문을 누락하면 이미지 피커 컨트롤러 창은 닫히지 않는다
        picker.dismiss(animated: true, completion: nil)
    }
}
