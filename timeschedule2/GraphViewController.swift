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
    var allArray: Results<Sum>!
    var todoList = [String]()
    var assignment :Sum!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonDraw.setTitleColor(UIColor.blue, for: .normal)
        buttonDraw.addTarget(self, action: #selector(self.touchUpButtonDraw), for: .touchUpInside)
        self.view.addSubview(buttonDraw)
        self.view.addSubview(chartView)
        allArray = realm.objects(Sum.self)
        print(allArray!)
        
        changeScreen()
        table.register(UINib(nibName: "CustomTableViewCell", bundle:   nil),forCellReuseIdentifier:"CustomTableViewCell")
        table.dataSource = self
        table.delegate = self
        
        print("User Realm User file location: \(realm.configuration.fileURL!.path)")
        //        drawChart()
        // Do any additional setup after loading the view.
 
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: {(UIViewControllerTransitionCoordinatorContext) in
                self.changeScreen()}
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
        // チェック状態を反転してリロードする
//        allArray[indexPath.row] = !allArray[indexPath.row]
                table.reloadData()
        let cell = tableView.cellForRow(at:indexPath)
        // チェックマークを入れる
        cell?.accessoryType = .checkmark
        
        // セルを選択した時の背景の変化を遅くする
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        
        // チェックマークを外す
        cell?.accessoryType = .none
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
        if let index = index {
            print(index)
            let time = objs[index].all
        } else {
            print("値が代入されていません")
        }
        return allArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell",for: indexPath as IndexPath)
        let objs: Results<Schedule> = realm.objects(Schedule.self)
        let time = objs[index!].all
        if let index = index {
            print(index)
        } else {
            print("値が代入されていません")
        }
        cell.textLabel?.text = time[indexPath.row].title
        
//        if allArray[indexPath.row] {
//                    cell.accessoryType = .checkmark
//                } else {
//                    cell.accessoryType = .none
//                }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let objs: Results<Schedule> = realm.objects(Schedule.self)
            let schedule = objs[self.index!]
            let time3 = Sum()
            //            time3.title = TextField.text
            let time = schedule.all
            let obj = time[indexPath.row]
            // アイテム削除処理
            
            try! realm.write(){
                //              timeArray.remove(at: indexPath.row)
                let item = (allArray[indexPath.row])
                realm.delete(item)
            }
        }
        // TableViewを再読み込み.
        self.table.reloadData()
    }
    
    @IBAction func addBarButtonTapped(_ sender: UIBarButtonItem) {
        let objs: Results<Schedule> = realm.objects(Schedule.self)
        var textField = UITextField()
        let alert = UIAlertController(title: "新しいアイテム追加", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "リストに追加", style: .default) {(action) in
            
            let schedule = objs[self.index!]
            let time = schedule.all
            let sum = Sum()
            sum.title = textField.text!
            try! self.realm.write {
                self.realm.add(sum)
                time.append(sum)
            }
//            self.allArray.append(time)
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
    }
    
    @IBAction func PlayBarButtonTapped(_ sender: UIBarButtonItem) {
        drawChart()
    }
    
    @objc func touchUpButtonDraw(){
        drawChart()
        
        print("グラフ表示ボタンが押された!")
    }
    /**
     グラフを表示
     */
    private func drawChart(){
        //        let rate = Double(textRate.text!)
        //        chartView.drawChart(rate: rate!)
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
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */
