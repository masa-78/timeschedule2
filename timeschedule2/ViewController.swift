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
    
    var selected: Int!
    
    @IBOutlet var table: UITableView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:  #selector(addBarButtonTapped(_:)))
        
        self.navigationItem.rightBarButtonItems = [addBarButtonItem]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
                title:  "Day",
                style:  .plain,
                target: nil,
                action: nil
            )
       
        scheduleArray = realm.objects(Schedule.self)
        print(scheduleArray!)
        
        navigationItem.title = "Day"
        
        table.register (UINib(nibName: "TableViewCell", bundle: nil),forCellReuseIdentifier: "TableViewCell")
        
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
            let graphView = segue.destination as! GraphViewController
                graphView.index = selected
        }
    }
    //    画面遷移　segue
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
        
        try! realm.write() {
            realm.add(time2)
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            // アイテム削除処理
            
            try! realm.write{
                let item = (scheduleArray[indexPath.row])
                realm.delete(item)
            }
        }
        
        // TableViewを再読み込み.
        self.table.reloadData()
    }
    
    func taptransition(_ sender: Any) {
        performSegue(withIdentifier: "toNextViewController", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = indexPath.row
        performSegue(withIdentifier: "toNextViewController", sender: nil)
    }
    
    //  キーボードずらし
    func configureObserver() {
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        print("Notificationを発行")
    }
    
    @objc
    func onTapBackButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
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
