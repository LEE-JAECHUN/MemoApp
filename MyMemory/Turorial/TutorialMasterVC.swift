//
//  TutorialMasterVC.swift
//  MyMemory
//
//  Created by JAECHUN LEE on 2019/11/02.
//  Copyright © 2019 JAECHUN LEE. All rights reserved.
//

import UIKit

class TutorialMasterVC: UIViewController {

    var pageVC: UIPageViewController!
    
    // 콘텐츠 뷰 컨트롤러에 들어갈 타이틀과 이미지
    var contentTitles = ["STEP 1", "STEP 2", "STEP 3", "STEP 4"]
    var contentImage = ["Page0", "Page1", "Page2", "Page3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1) 페이지 뷰 컨트롤러 객체 생성하기
        self.pageVC = (self.instanceTutorialVC(name: "PageVC") as! UIPageViewController)
        self.pageVC.dataSource = self
        // 2) 페이지 뷰 컨트롤러의 기본 페이지 지정
        if let startContentVC = self.getContentVC(atIndex: 0) {
            self.pageVC.setViewControllers([startContentVC], direction: .forward, animated: true, completion: nil)
        }
        // 3) 페이지 뷰 컨트롤러의 출력 영역 지정
        self.pageVC.view.frame.origin = CGPoint(x: 0, y: 0)
        self.pageVC.view.frame.size.width = self.view.frame.width
        self.pageVC.view.frame.size.height = self.view.frame.height - 100
        // 4) 페이지 뷰 컨트롤러를 마스터 뷰 컨트롤러의 자식 뷰 컨트롤러로 설정
        self.addChild(self.pageVC)
        self.view.addSubview(self.pageVC.view)
        self.pageVC.didMove(toParent: self)
    }
    
    func getContentVC(atIndex idx: Int) -> UIViewController? {
        // 인덱스가 데이터 배열 크기 범위를 벗어나면 nil 반환
        guard self.contentTitles.count >= idx && self.contentTitles.count > 0 else {
            return nil;
        }
        // "ContentsVC" 라는 스토리보드 식별자를 가진 뷰 컨트롤러의 인스턴스를 생성하고 캐스팅한다
        guard let cvc = self.instanceTutorialVC(name: "ContentsVC") as? TutorialContentsVC else {
            return nil
        }
        // 콘텐츠 뷰 컨트롤러의 내용을 구성
        cvc.titleText = self.contentTitles[idx]
        cvc.imageFile = self.contentImage[idx]
        cvc.pageIndex = idx
        return cvc
    }
    
}

extension TutorialMasterVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // 현재 페이지 인덱스
        guard var index = (viewController as! TutorialContentsVC).pageIndex else{
            return nil
        }
        // 현재의 인덱스가 맨 앞이라면 nil을 반환하고 종료
        guard index > 0 else {
            // 인덱스가 0 또는 음수
            return nil
        }
        // 현재의 인덱스에서 하나 뺌 (즉, 이전 페이지 인덱스)(
        index = index - 1
        return self.getContentVC(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        //현재 페이지 인덱스
        guard var index = (viewController as! TutorialContentsVC).pageIndex else{
            return nil
        }
        // 현재의 인댁스에 하나를 더함(즉, 다음페이지)
        index += 1
        guard index < self.contentTitles.count else {
            return nil
        }
        return self.getContentVC(atIndex: index)
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        // 페이지 뷰 컨트롤러가 출력할 페이지의 개수를 알려준다
        return self.contentTitles.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        // 최초에 출력할 컨텐츠 뷰의 개수
        return 0
    }
    
    @IBAction func close(_ sender: Any) {
        let ud  = UserDefaults.standard
        ud.set(true, forKey: UserInfoKey.tutorial)
        ud.synchronize()
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
