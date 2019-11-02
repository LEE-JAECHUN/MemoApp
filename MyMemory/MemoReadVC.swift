//
//  MemoReadVC.swift
//  MyMemory
//
//  Created by JCLEE on 2019/10/28.
//  Copyright © 2019 JAECHUN LEE. All rights reserved.
//

import UIKit

class MemoReadVC: UIViewController {

    // 콘텐츠 데이터를 저장하는 변수
    var param: MemoData?
    @IBOutlet var subject: UILabel!
    @IBOutlet var contents: UILabel!
    @IBOutlet var img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1) 제목과 내용, 이미지를 출력
        self.subject.text = param?.title
        self.contents.text = param?.contents
        self.img.image = param?.image
        // 2) 날짜 포맷 변환
        let formmatter = DateFormatter()
        formmatter.dateFormat = "dd일 HH:mm분에 작성됨"
        let dateString = formmatter.string(from: (param?.regdate)!)
        // 3) 네비게이션 타이틀에 날짜를 표시
        self.navigationItem.title = dateString
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
