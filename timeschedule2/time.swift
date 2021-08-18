//
//  time.swift
//  timeschedule2
//
//  Created by masahiro tono on 2021/03/07.
//

import Foundation
import RealmSwift


class Schedule: Object{
    @objc dynamic var day = ""//日にち（1画面）
    
    var all = List<Sum>()
//    var time = List<Hour>()
}

class Sum: Object{
    @objc dynamic var total = ""//2画面
    @objc dynamic var title = ""//初期の値
}

//class Hour: Object {
//    3画面
//    @objc dynamic var title = ""//時間
//}
