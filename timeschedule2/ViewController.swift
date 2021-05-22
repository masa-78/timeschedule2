//
//  ViewController.swift
//  timeschedule2
//
//  Created by masahiro tono on 2020/08/29.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate , UITableViewDataSource{
    
    var scheduleArray:Results<Schedule>!
    
    var addBarButtonItem: UIBarButtonItem!
    
    let realm = try! Realm()
    
    var plan: [String:[String]] = [:]
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var titleTextField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:  #selector(addBarButtonTapped(_:)))
        
        self.navigationItem.rightBarButtonItems = [addBarButtonItem]
        
        //        timeArray = realm.objects(Time.self)
        scheduleArray = realm.objects(Schedule.self)
        //        print(timeArray!)
        print(scheduleArray!)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "Day"
        
        table.register (UINib(nibName: "TableViewCell", bundle: nil),forCellReuseIdentifier: "TableViewCell")
        
        // Do any additional setup after loading the view.
        table.dataSource = self
        table.delegate = self
        
        if plan.isEmpty {
            print("plan dictionary is empty.")
        } else {
            print("plan dictionary is not empty.")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNextViewController" {
            //            _  = segue.destination as! PageViewController
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        print("ViewController Will Appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("ViewController Will Disappear")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func addBarButtonTapped(_ sender: UIBarButtonItem) {
        
        let time2 = Schedule()
        let task = Sum(value: plan)
        let results = realm.objects(Schedule.self)
        print(results)
        
        try! realm.write {
            realm.add(task)
            print(task)
        }
        
        try! realm.write {
            realm.add(time2)
        }
        
        try! realm.write {
            for task in results {
                task.all.append(task)
            }
        }
        
        print(scheduleArray.count)
        self.table.reloadData()
        print("【+】ボタンが押された!")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("タップされました")
        print(scheduleArray.count)
        return scheduleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
            as!TableViewCell
        print("cellが呼び出された")
        
        cell.textFieldShouldReturn(choice:indexPath)
        cell.dic(choice:indexPath)
        return cell
    }
    
    func taptransition(_ sender: Any) {
        performSegue(withIdentifier: "toNextViewController", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("/(indexPath.row)番目の行が選択されました。")
        
        print(indexPath.row)
        
        // セルの選択を解除
        table.deselectRow(at: indexPath, animated: true)
        //        indexpath.row
        performSegue(withIdentifier: "toNextViewController", sender: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
        
//        if editingStyle == .{
//
//            try! realm.write{
//                let item = (scheduleArray[indexPath.row])
//                realm.add(item)
//            }
//        }
        
        
    
    
    
    //  キーボードずらし
    func configureObserver() {
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        print("Notificationを発行")
    }
    
    // Notificationを削除
    func removeObserver() {
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: Notification?) {
        let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            let transform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
            self.view.transform = transform
        })
    }
    
    @objc func keyboardWillHide(notification: Notification?) {
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: {
            self.view.transform = CGAffineTransform.identity
        })
    }
}
