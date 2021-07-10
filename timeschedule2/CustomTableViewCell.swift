//
//  CustomTableViewCell.swift
//  timeschedule2
//
//  Created by masahiro tono on 2021/03/07.
//

import UIKit

class CustomTableViewCell: UITableViewCell, UITextViewDelegate, UITextFieldDelegate{
    var saveData:UserDefaults = UserDefaults.standard
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func viewDidLoad() {
//        titleTextField.delegate = self
//        ContentTextView.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
}
