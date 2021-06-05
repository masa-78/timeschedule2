//
//  NyuryokuViewController.swift
//  timeschedule2
//
//  Created by masahiro tono on 2021/03/07.
//

import UIKit
import RealmSwift


class NyuryokuViewController: UIViewController, UITextFieldDelegate , UITableViewDataSource,  UITableViewDelegate{
    
    @IBOutlet var table: UITableView!
    @IBOutlet var bar: UINavigationBar!
    
    var hourArray:Results<Hour>!
    
    var addBarButtonItem: UIBarButtonItem!
    
    var addButtonPressed = UIBarButtonItem?.self

    var outputValue : String?
    
    var resultHandler: ((String) -> Void)?
    
    var index: Int?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hourArray = realm.objects(Hour.self)
        print(hourArray!)
   
        table.register(UINib(nibName: "CustomTableViewCell", bundle:   nil),forCellReuseIdentifier:"CustomTableViewCell")
        table.dataSource = self
        table.delegate = self
        print("Nyuryoku")

        addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItems = [addBarButtonItem]
        
        bar.bottomAnchor.constraint(equalTo: table.topAnchor).isActive = true
        bar.topAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
//        UINavigationBar.topAnchor.constraint(equalTo:UITableView.topAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("NyuryokuViewController Will Appear")
        self.table.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("NyuryokuViewController Will Disappear")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let objs: Results<Schedule> = realm.objects(Schedule.self)
        let time = objs[index!].time
        return hourArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell",for: indexPath)
        let objs: Results<Schedule> = realm.objects(Schedule.self)
        let time = objs[index!].time
//        let time = hourArray[indexPath.row]
        cell.textLabel?.text = time[indexPath.row].title
        //cell.accessoryType = time.done ? .checkmark : .none
        print("aaa")
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 300
    //    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let objs: Results<Schedule> = realm.objects(Schedule.self)
            let schedule = objs[self.index!]
            let time3 = Hour()
//            time3.title = TextField.text
            let time = schedule.time
            let obj = time[indexPath.row]
            // アイテム削除処理
            
            try! realm.write(){
//                timeArray.remove(at: indexPath.row)
                let item = (hourArray[indexPath.row])
                realm.delete(time3)
             
            }
        }
        // TableViewを再読み込み.
        self.table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    
//    @objc func addBarButtonTapped(_ sender: UIBarButtonItem) {
//
//        let textField = UITextField()
//        _ = UIAlertController(title: "新しいアイテム追加", message: "", preferredStyle: .alert)
//        _ = UIAlertAction(title: "リストに追加", style: .default) {(action) in
//
//            let time = Time()
//            time.title = textField.text!
//            try! self.realm.write {
//                self.realm.add(time)
//            }
//            //            self.timeArray.append(time)
//            self.table.reloadData()
//
//            alert.addTextField {
//                (alertTextField) in
//                alertTextField.placeholder = "新しいアイテム"
//                textField = alertTextField
//            }
//            alert.addAction(action)
//            present(alert, animated: true, completion: nil)
//        }
    
//        print("【+】ボタンが押された!")
//       }
    
    @IBAction func addBarButtonTapped(_ sender: Any) {

        let objs: Results<Schedule> = realm.objects(Schedule.self)
        var textField = UITextField()
        let alert = UIAlertController(title: "新しいアイテム追加", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "リストに追加", style: .default) {(action) in

            let schedule = objs[self.index!]
            let time = schedule.time
            let hour = Hour()
            hour.title = textField.text!
            try! self.realm.write {
                self.realm.add(hour)
                time.append(hour)
            }
            //            self.timeArray.append(time)
            self.table.reloadData()
        }
        alert.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "新しいアイテム"
            textField =  alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
  
}

/*
 // MARK: - Navigation
 
 
 */
