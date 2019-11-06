//
//  MemoListVC.swift
//  MyMemory
//
//  Created by JCLEE on 2019/10/28.
//  Copyright © 2019 JAECHUN LEE. All rights reserved.
//

import UIKit

class MemoListVC: UITableViewController {

    @IBOutlet var searchBar: UISearchBar!
    
    lazy var dao = MemoDAO()
    
    // 앱 델리게이트 객체의 참조 정보를 얻어온다
    let appDelegate = UIApplication.shared.delegate as!  AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 검색 바의 키보드에서 리턴 키가 항상 활성화되어 있도록 처리
        searchBar.enablesReturnKeyAutomatically = false
        
        // SWRevealViewController 라이브러리의 RevealViewController 객체를 읽어온다
        if let revealVC = self.revealViewController() {
            // 바 버튼 아이템 객체를 정의한다
            let btn = UIBarButtonItem()
            btn.image = UIImage(named: "sidemenu.png")
            btn.target = revealVC   // 버튼 클릭 시 호출할 메소드가 정의된 객체를 지정
            btn.action = #selector(revealVC.revealToggle(_:))
            // 정의된 바 버튼을 네비게이션 바의 왼쪽 아이템으로 등록한다.
            self.navigationItem.leftBarButtonItem = btn
            // 제스처 객체를 뷰에 추가한다
            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        // 코어 데이터에 저장된 데이터를 가져온다
        self.appDelegate.memoList = self.dao.fetch()
        // 테이블 데이터를 다시 읽어온다. 이에 따라 행을 구성하는 로직이 다시 실행될 것이다.
        self.tableView.reloadData()
        let ud = UserDefaults.standard
        if ud.bool(forKey: UserInfoKey.tutorial) == false {
            let vc = self.instanceTutorialVC(name: "MasterVC")
            vc?.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: true, completion: nil)
        }
    }
}

extension MemoListVC: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyword = searchBar.text    // 검색 바에 입력된 키워드를 가져온다
        // 키워드를 적용하여 데이터를 검색하고, 테이블 뷰를 갱신한다'
        self.appDelegate.memoList = self.dao.fetch(keyword: keyword)
        self.tableView.reloadData()
    }
    
}

extension MemoListVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appDelegate.memoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1. memolist 배열 데이터에서 주어진 행에 맞는 데이터를 꺼낸다.
        let row: MemoData = self.appDelegate.memoList[indexPath.row]
        // 2. 이미지 속성이 비어 있을 경우 "memoCell" 아니면 "memoCellWithImage"
        // memoCell, memoCellWithImage는 프로토타입 셀의 식별자이다. (스토리보드에 정의되어 있음)
        let cellId = row.image == nil ? "memoCell" : "memoCellWithImage"
        // 3. 재사용 큐로부터 프로토타입 셀의 인스턴스를 전달받는다.
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? MemoCell
        // 4. memoCell의 내용을 구성한다
        cell?.subject.text = row.title
        cell?.conents.text = row.contents
        if let image = row.image {
            cell?.img.image = image
        }
        // 5. Date 타입의 날짜 포맷에 맞게 변경
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell?.regdate.text = formatter.string(from: row.regdate!)
        // 6. cell 객체를 리턴한다.
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1) memoList 배열에서 선택된 행에 맞는 데이터를 꺼낸다.
        let row:MemoData = self.appDelegate.memoList[indexPath.row]
        // 2) 상세 화면의 인스턴스를 생성한다
        guard let vc = self.storyboard?.instantiateViewController(identifier: "MemoRead") as? MemoReadVC else {
            return
        }
        // 3) 값을 전달한 다음, 상세 화면으로 이동한다.
        vc.param = row
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let data = self.appDelegate.memoList[indexPath.row]
        // 코어 데이터에서 삭제한 다음, 배열 데이터 및 테이블 뷰 행을 차례로 삭제한다
        if dao.delete(data.objectID!) {
            self.appDelegate.memoList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
