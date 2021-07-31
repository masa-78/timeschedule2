//
//  PageViewController.swift
//  timeschedule2
//
//  Created by masahiro tono on 2021/03/07.
//

import UIKit
class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var nextIndex: Int!
    var nextVC: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([getSecond()], direction: .forward, animated: true, completion: nil)
        self.dataSource = self
        self.delegate = self
        
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
        
        let vc = storyboard!.instantiateViewController(withIdentifier: "View3") as! NyuryokuViewController
        vc.index = nextIndex
       print(nextIndex!)
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: NyuryokuViewController.self) {
            
            let nextVC = getSecond()
            return getSecond()
            
        } else {
            return nil }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: GraphViewController.self){
            
            let nextVC = getThird()
          
            return nextVC
        }
        else {
            return nil
        }
     
    }
}
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */
