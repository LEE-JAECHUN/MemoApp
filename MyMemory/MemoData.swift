//
//  MemoData.swift
//  MyMemory
//
//  Created by JCLEE on 2019/10/28.
//  Copyright © 2019 JAECHUN LEE. All rights reserved.
//

import UIKit
import CoreData

class MemoData {
    var momoIdx:Int?        // 데이터 식별값
    var title:String?       // 메모 제족
    var contents:String?    // 메모 내용
    var image:UIImage?      // 이미지
    var regdate:Date?       // 작성일
    // 원본 MemoMO 객체를 참조하기 위한 속성
    var objectID: NSManagedObjectID?
}
