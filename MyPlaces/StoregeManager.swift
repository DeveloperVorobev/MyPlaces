//
//  StoregeManager.swift
//  MyPlaces
//
//  Created by Владислав Воробьев on 27.04.2022.
//

import Foundation
import RealmSwift
let realm = try! Realm()
class StorageManager {
    static func saveObject(_ place: Place){
        try! realm.write{
            realm.add(place)
        }
    }
    static func deliteObject (_ place: Place){
        try! realm.write{
            realm.delete(place)
        }
    }
}
