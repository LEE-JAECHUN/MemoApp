//
//  MemoDAO.swift
//  MyMemory
//
//  Created by JAECHUN LEE on 2019/11/06.
//  Copyright © 2019 JAECHUN LEE. All rights reserved.
//

import UIKit
import CoreData

class MemoDAO {
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    func fetch() -> [MemoData] {
        var memolist = [MemoData]()
        // 1. 요청 객체 생성
        let fetchReqeust:NSFetchRequest<MemoMO> = MemoMO.fetchRequest()
        // 1.1 최신 글 순으로 정렬하도록 정렬 객체 생성
        let regdateDesc = NSSortDescriptor(key: "regdate", ascending: false)
        fetchReqeust.sortDescriptors = [regdateDesc]
        
        do {
            let resultset = try self.context.fetch(fetchReqeust)
            // 2. 읽어온 결과 집합을 순회하면서 [MemoData] 타입으로 변환한다
            for record in resultset {
                // 3. MemoData 객체를 생성한다
                let data = MemoData()
                // 4. MemoMO 프포퍼티 값을 MemoData의 프로퍼티로 복사한다
                data.title = record.title
                data.contents = record.contents
                data.regdate = record.regdate! as Date
                data.objectID = record.objectID
                // 4.1 이미지가 있을 때에만 복사
                if let image = record.image as Data? {
                    data.image = UIImage(data: image)
                }
                // 5. MemoData 객체를 memolist 배열에 추가한다
                memolist.append(data)
            }
        } catch let e as NSError {
            print("An error has occurred: \(e.localizedDescription)")
        }
        return memolist
    }
    
    
    func insert(_ data: MemoData) {
        // 1. 관리 객체 인스턴스 생성
        let object = NSEntityDescription.insertNewObject(forEntityName: "Memo", into: self.context) as! MemoMO
        // 2. MemoData로부터 값을 복사한다
        object.title = data.title
        object.contents = data.contents
        object.regdate = data.regdate!
        if let image = data.image {
            object.image = image.pngData()
        }
        // 3. 영구 저장소에 변경사항을 반영한다
        do {
            try self.context.save()
        } catch let e as NSError {
            print("An error has occurred: \(e.localizedDescription)")
        }
    }
    
    func delete(_ objectID: NSManagedObjectID) -> Bool {
        // 삭제할 객체를 찾아 컨텍스트에서 삭제한다
        let object = self.context.object(with: objectID)
        self.context.delete(object)
        
        do {
            // 삭제된 내역을 영구저장소에 반영한다
            try self.context.save()
            return true
        } catch let e as NSError {
            print("An error has occurred: \(e.localizedDescription)")
            return false
        }
    }
}
