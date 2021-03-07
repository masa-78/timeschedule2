//
//  time.swift
//  timeschedule2
//
//  Created by masahiro tono on 2021/03/07.
//

import Foundation
import RealmSwift


class Date: Object{
    @objc dynamic var day = ""//日にち（1画面）
    var time = List<Time>()
}

class Time: Object {
    //3画面
//    @objc dynamic var name = ""
    @objc dynamic var title = ""//時間

    
}
