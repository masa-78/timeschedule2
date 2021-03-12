//
//  PageViewController.swift
//  timeschedule2
//
//  Created by masahiro tono on 2021/03/07.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {

//    let date: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([getSecond()], direction: .forward, animated: true, completion: nil)
        self.dataSource = self
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getFirst() -> ViewController {
        return storyboard!.instantiateViewController(withIdentifier: "View1") as! ViewController
    }
    
    func getSecond() -> GraphViewController {
        return storyboard!.instantiateViewController(withIdentifier: "View2") as! GraphViewController
    }
    
    func getThird() -> NyuryokuViewController {
        return storyboard!.instantiateViewController(withIdentifier: "View3") as! NyuryokuViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        if viewController.isKind(of: NyuryokuViewController.self) {
//          let nextVC = getSecond() as? GraphViewController
//            nextVC.recieved = date
            return getSecond()
        }
        //        else if viewController.isKind(of: GraphViewController.self) {
        //            // 2 -> 1
        //            return getFirst()
        //        }
        guard let index = getFirst().index(of: viewController), index != NSNotFound else { return nil }
            let nextIndex = index - 1
            if index == 2 {
                if let nextVC = getThird()[nextIndex] as? NyuryokuViewController {
                    nextVC.received = nextIndex
                    return nextVC
                }
                return nil
            } else if index == 1 {
                if let nextVC = getSecond()[nextIndex] as? GraphViewController {
                    nextVC.received = nextIndex
                    return nextVC
                }
                return nil
                
            } else  {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        if viewController.isKind(of: ViewController.self) {
//                    // 1 -> 2
//                    return getSecond()
//                } else
        if viewController.isKind(of: GraphViewController.self){
//            let nextVC = getThird() as? NyuryokuViewController
//            nextVC.recieved = date
            return getThird()
       } else{
            return nil
        }
    
    guard let index = getFirst().index(of: viewController), index != NSNotFound else { return nil }
        let nextIndex = index + 1
        if index == 0 {
            if let nextVC = getSecond()[nextIndex] as? GraphViewController {
                nextVC.received = nextIndex
                return nextVC
            }
            return nil
        } else if index == 1 {
            if let nextVC = getThird()[nextIndex] as? NyuryokuViewController {
                nextVC.received = nextIndex
                return nextVC
            }
            return nil
        } else {
            return nil
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
}
