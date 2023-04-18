//
//  SlideScreenPageViewController.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 25/09/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class SlideScreenPageViewController: UIPageViewController,UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var orderedViewControllers = [UIViewController]()
    var pageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let firstC : FirstPageVC = FirstPageVC()
        let secondC : SecondPageVC = SecondPageVC()

        let first = FirstPageVC(
            nibName: "FirstPageVC",
            bundle: nil)

        let second = SecondPageVC(
            nibName: "SecondPageVC",
            bundle: nil)

        self.dataSource = self
        self.delegate = self
        
        orderedViewControllers.append(firstC)
        orderedViewControllers.append(secondC)
        orderedViewControllers.append(firstC)
        
        

//        if let firstViewController = orderedViewControllers.first {
//            setViewControllers(orderedViewControllers,
//                               direction: .forward,
//                               animated: true,
//                               completion: nil)
//        }
    }
    

   
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.pageIndex
        
        if(index == 0 || index == NSNotFound)
        {
            return nil
        }
        
        self.pageIndex -= 1
        
        return self.orderedViewControllers[0]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        //        let viewController = viewController as! TutorialScreenViewController
        //        var index = viewController.pageIndex as Int
        //
        //
        //
        //        return self.pageTutorialAtIndex(index)
        
        return self.orderedViewControllers[0]
    }
    
    
    
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
        
    {
        
        return orderedViewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int // The selected item reflected in the page indicator.
        
    {
        return 0
        
    }

}
