//
//  TableViewCell.swift
//  timeschedule2
//
//  Created by masahiro tono on 2021/03/07.
//

import UIKit
import RealmSwift

class TableViewCell: UITableViewCell,UITextFieldDelegate{
    @IBOutlet var titleTextField: UITextField!
 
    var date: Schedule!
    
    let realm = try! Realm()
    var dic: [String:String] = [:]
    var scheduleArray: Results<Schedule>!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleTextField.delegate = self
        scheduleArray = realm.objects(Schedule.self)
        let schedule: Schedule? = read()
        titleTextField.text = schedule?.day
        

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("タップされました")
        // Configure the view for the selected state
    }

    func read() -> Schedule? {
        return realm.objects(Schedule.self).first
    }
    
    func textFieldShouldReturn(_ titleTextField: UITextField) -> Bool {
        //        self.titleTextField.text = ""
        titleTextField.resignFirstResponder()
        
        try! realm.write {
            date.day = titleTextField.text!
            realm.add(date)
        }
        return true
    }
    
    func  textFieldShouldReturn(choice:IndexPath){
        
        self.titleTextField.text = String((choice .row) + 1)
        date = scheduleArray[choice.row]
        try! realm.write{
            date.day = titleTextField.text!
            realm.add(date)
        }
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
        //        self.table.reloadData()
    }
}
