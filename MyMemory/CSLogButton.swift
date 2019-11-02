//
//  CSLogButton.swift
//  MyMemory
//
//  Created by JCLEE on 2019/10/29.
//  Copyright © 2019 JAECHUN LEE. All rights reserved.
//

import UIKit

public class CSLogButton: UIButton {
    
    public enum CSLogType: Int {
        case basic, title, tag
    }
    
    // 로그 출력 타입
    public var logType: CSLogType = .basic
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        // 버튼에 스타일 적용
        self.setBackgroundImage(UIImage(named: "button-bg"), for: .normal)
        self.tintColor = .white
        // 버튼의 클릭 이벤트에 logging(_:) 메소드 연결
        self.addTarget(self, action: #selector(logging(_:)), for: .touchUpInside)
    }
    
    @objc func logging(_ sender: UIButton) {
        switch self.logType {
        case .basic:
            print("버튼이 클릭되었습니다.")
        case .title:
            let btnTitle = sender.titleLabel?.text ?? "타이틀 없는"
            print("\(btnTitle)")
        case .tag:
            print("\(sender.tag)")
        }
    }
    
}
