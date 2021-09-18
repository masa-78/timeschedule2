//
//  GraphViewController.swift
//  timeschedule2
//
//  Created by masahiro tono on 2021/03/07.
//

import UIKit
import RealmSwift

class GraphViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    let realm = try! Realm()
 
    @IBOutlet var buttonDraw:UIButton! = UIButton()
    @IBOutlet var chartView: ChartView! = ChartView()
    @IBOutlet var table: UITableView!
    
    var outputValue : String?
    var resultHandler: ((String) -> Void)?
    var index: Int?
    var checkmarkArray: [[Bool]] = [[]]
    var doneCounterArray: [[Bool]] = [[]]
    
    var doneCounter: Int = 0
    
    var toDoCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.view.addSubview(chartView)
 
        changeScreen()
        table.register(UINib(nibName: "CustomTableViewCell", bundle:   nil),forCellReuseIdentifier:"CustomTableViewCell")
        table.dataSource = self
        table.delegate = self
        
        print("User Realm User file location: \(realm.configuration.fileURL!.path)")
        
        // Do any additional setup after loading the view.

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: {(UIViewControllerTransitionCoordinatorContext) in
                self.changeScreen()
                
            }
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("GraphViewController Will Appear")
        self.configureObserver()
        self.table.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("GraphViewController Will Disappear")
        self.removeObserver()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let cell = tableView.cellForRow(at:indexPath)
        
        var checkMarkNow: [Bool] = checkmarkArray[index!]
        var donecounterNow: [Bool] = doneCounterArray[index!]
        print(checkMarkNow)
        print(donecounterNow)
        checkMarkNow[indexPath.row] = changeBool(value: checkMarkNow[indexPath.row])
//        donecounterNow[indexPath.row] = changeBool(value: donecounterNow[indexPath.row])
        checkmarkArray[index!] = checkMarkNow
        
        UserDefaults.standard.set(checkmarkArray, forKey: "checkmarkarray")
        
        if(cell?.accessoryType == UITableViewCell.AccessoryType.none){
            cell?.accessoryType = .checkmark
           doneCounter += 1
            
        }else{
            cell?.accessoryType = .none
            doneCounter -= 1
        }
   
        // セルを選択した時の背景の変化を遅くする
        tableView.deselectRow(at: indexPath, animated: true)
      
        // チェック状態を反転してリロードする
                table.reloadData()
    }
   
    func changeBool(value: Bool) -> Bool {
          if value == true {
              return false
          } else {
              return true
          }
    }

    private func changeScreen(){
        let screenSize: CGRect = UIScreen.main.bounds
        let widthValue = screenSize.width
        let heightValue = screenSize.height
        
        var drawWidth = widthValue * 0.7
        if (widthValue > heightValue){
            drawWidth = heightValue * 0.8
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        let objs: Results<Schedule> = realm.objects(Schedule.self)
        let time = objs[index!].all
        
        return time.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell",for: indexPath as IndexPath)
        let objs: Results<Schedule> = realm.objects(Schedule.self)
        let time = objs[index!].all
        
            if time.isEmpty == false {
                cell.textLabel?.text = time[indexPath.row].title
                
                checkmarkArray = UserDefaults.standard.array(forKey: "checkmarkarray") as! [[Bool]]
                
                let checkMarkNow: [Bool] = checkmarkArray[index!]
                
                if checkMarkNow[indexPath.row] == true {
                    cell.accessoryType = .checkmark
                } else {
                    
                }
            }
        return cell
    }
  
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let objs: Results<Schedule> = realm.objects(Schedule.self)
            let schedule = objs[self.index!]
            
            let time = schedule.all
            let obj = time[indexPath.row]

        }
        // TableViewを再読み込み.
        self.table.reloadData()
    }
    
    @IBAction func playBarButtonTapped(_ sender: UIBarButtonItem) {
        drawChart()
    }
    @IBAction func addBarButtonTapped(_ sender: UIBarButtonItem) {
        let objs: Results<Schedule> = realm.objects(Schedule.self)
        let time = objs[index!].all
        var textField = UITextField()
        let alert = UIAlertController(title: "新しいアイテム追加", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "リストに追加", style: .default) {(action) in
            
//            let schedule = objs[self.index!]
//            let time = schedule.all
            let sum = Sum()
            sum.title = textField.text!
            try! self.realm.write {
                self.realm.add(sum)
                time.append(sum)
                print("sum",sum)
            }
            self.table.reloadData()
        }
        alert.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "新しいアイテム"
            textField =  alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        print("+ボタンが押された")
        checkmarkArray = UserDefaults.standard.array(forKey: "checkmarkarray") as! [[Bool]]
        checkmarkArray[index!].append(false)
        UserDefaults.standard.set(checkmarkArray, forKey: "checkmarkarray")
        print("今見たいところです！",checkmarkArray)
    }

    /**
     グラフを表示
     */
    private func drawChart(){
        let objs: Results<Schedule> = realm.objects(Schedule.self)
        let time = objs[index!].all
        toDoCounter = time.count
        print("todocount",toDoCounter)
        print("done",doneCounter)
        let rate = (Double(doneCounter) / Double(toDoCounter) * 100)
        print(doneCounter / toDoCounter)
        chartView.drawChart(rate: rate)
        print("rate",rate)
    }
    //    キーボードずらし
    func configureObserver() {
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        UIView.animate(withDuration: duration!, animations: { () in
            
            self.view.transform = CGAffineTransform.identity
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let objs: Results<Schedule> = realm.objects(Schedule.self)
        let Total = objs[index!].all
        if let index = index {
            print(index)
        }else {
            print("値が代入されていません")
        }
        return true
    }
}
//extension Array {
//    subscript (safe index: Index) -> Element? {
//        //indexが配列内なら要素を返し、配列外ならnilを返す（三項演算子）
//        return indices.contains(index) ? self[index] : nil
//    }
//}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */
