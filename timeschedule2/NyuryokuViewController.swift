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
        self.navigationItem.rightBarButtonItem = addBarButtonItem
        
        
        if let bar = bar {
            bar.bottomAnchor.constraint(equalTo: table.topAnchor).isActive = true
            print(bar)
        } else {
            print("値が代入されていません")
        }
       
        if let bar = bar {
            bar.topAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            print(bar)
        } else {
            print("値が代入されていません")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("NyuryokuViewController Will Appear")
        print(index)
        self.table.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("NyuryokuViewController Will Disappear")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//    func setuoNavigation() {
//        let Nabutton1: UIBarButtonItem = UIBarButtonItem.init(
//            style: UIBarButtonItem.Style.plain,
//            target: self,
//            action: #selector(Nabutton1Proc))
//        
//        self.navigationItem.rightBarButtonItems = [Nabutton1]
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let objs: Results<Schedule> = realm.objects(Schedule.self)
        
        if let index = index {
            print(index)
            let time = objs[index].time
        } else {
            print("値が代入されていません")
        }
        
        return hourArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell",for: indexPath)
        let objs: Results<Schedule> = realm.objects(Schedule.self)
        let time = objs[index!].time
        if let index = index {
            print(index)
        } else {
            print("値が代入されていません")
        }
        cell.textLabel?.text = time[indexPath.row].title
        return cell
    }
    
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
                //              timeArray.remove(at: indexPath.row)
                let item = (hourArray[indexPath.row])
                realm.delete(item)
            }
        }
        // TableViewを再読み込み.
        self.table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func addBarButtonTapped(_ sender: UIBarButtonItem) {
        
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
