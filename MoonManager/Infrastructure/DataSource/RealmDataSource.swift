//
//  RealmDataSource.swift
//  MoonManager
//
//  Created by cschoi on 1/8/24.
//

import Foundation
import RealmSwift

class RealmDataSource: RealmDataSourceInterface {
    var realm: Realm!
    
    init() {
        //realm = try! Realm()
    }
    
    func create<Element>(_ element: Element) where Element: Object {
        try! realm.write {
            realm.add(element)
        }
    }
    
    func retrieve<Element, Key>(key: Key) -> Element? where Element: Object {
        realm.object(ofType: Element.self, forPrimaryKey: key)
    }
    
    func retrieve<Element>(query: String) -> [Element] where Element: Object {
        realm.objects(Element.self).filter(query).map { $0 }
    }
    
    func retrieve<Element>(isIncluded: (Element) -> Bool) -> [Element] where Element: Object {
        return realm.objects(Element.self).filter(isIncluded).map { $0 }
    }
    
    func update<Element>(_ element: Element) where Element: Object {
        try! realm.write {
            realm.add(element, update: .modified)
        }
    }
    
    func update<Element, Key>(key: Key, update: (Element?) -> Void) where Element: Object {
        let object = realm.object(ofType: Element.self, forPrimaryKey: key)
        try! realm.write {
            update(object)
        }
    }
    
    func delete<Element>(_ element: Element) where Element: Object {
        try! realm.write {
            realm.delete(element)
        }
    }
    
    func delete<Element>(isIncluded: (Element) -> Bool) where Element: Object {
        try! realm.write {
            let objects = realm.objects(Element.self).filter(isIncluded)
            realm.delete(objects)
        }
    }
    
    func deleteAll<Element>(_ type: Element.Type) where Element: Object {
        try! realm.write {
            let objects = realm.objects(type)
            realm.delete(objects)
        }
    }
}
