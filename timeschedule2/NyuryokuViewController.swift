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
    
    var timeArray:Results<Time>!
    
    var addButtonPressed = UIBarButtonItem?.self

    var outputValue : String?
    
    var resultHandler: ((String) -> Void)?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeArray = realm.objects(Time.self)
        print(timeArray!)
   
        table.register(UINib(nibName: "CustomTableViewCell", bundle:   nil),forCellReuseIdentifier:"CustomTableViewCell")
        table.dataSource = self
        table.delegate = self
        print("Nyuryoku")

        
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
        return timeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell",for: indexPath)
        let time = timeArray[indexPath.row]
        cell.textLabel?.text = time.title
        //cell.accessoryType = time.done ? .checkmark : .none
        print("aaa")
        print (time)
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 300
    //
    //    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            // アイテム削除処理
            
            try! realm.write {
                //                timeArray.remove(at: indexPath.row)
                let item = (timeArray[indexPath.row])
                realm.delete(item)
            }
        }
        // TableViewを再読み込み.
        self.table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "新しいアイテム追加", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "リストに追加", style: .default) {(action) in
            
            let time = Time()
            time.title = textField.text!
            try! self.realm.write {
                self.realm.add(time)
            }
            //            self.timeArray.append(time)
            self.table.reloadData()
        }
        alert.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "新しいアイテム"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
  
}

/*
 // MARK: - Navigation
 
 
 */
