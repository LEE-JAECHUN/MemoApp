//
//  MemoCell.swift
//  MyMemory
//
//  Created by JCLEE on 2019/10/28.
//  Copyright © 2019 JAECHUN LEE. All rights reserved.
//

import UIKit

class MemoCell: UITableViewCell {
    
    @IBOutlet var subject: UILabel! // 메모 제목
    @IBOutlet var conents: UILabel! // 메모 내용
    @IBOutlet var img: UIImageView! // 이미지
    @IBOutlet var regdate: UILabel! // 등록 일자
    
}
