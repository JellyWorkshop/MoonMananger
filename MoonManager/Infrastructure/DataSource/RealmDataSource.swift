//
//  RealmDataSource.swift
//  MoonManager
//
//  Created by cschoi on 1/8/24.
//

import Foundation
import RealmSwift

public class RealmDataSource: RealmDataSourceInterface {
    private var realm: Realm
    
    public init() {
        let config = Realm.Configuration(schemaVersion: 2)
        Realm.Configuration.defaultConfiguration = config
        realm = try! Realm(configuration: config)
    }
    
    public func create<Element>(_ element: Element) where Element: Object {
        try! realm.write {
            realm.add(element)
        }
    }
    
    public func retrieveAll<Element>() -> [Element] where Element: Object {
        realm.objects(Element.self).map { $0 }
    }
    
    public func retrieve<Element, Key>(key: Key) -> Element? where Element: Object {
        realm.object(ofType: Element.self, forPrimaryKey: key)
    }
    
    public func retrieve<Element>(query: String) -> [Element] where Element: Object {        
        realm.objects(Element.self).filter(query).map { $0 }
    }
    
    public func retrieve<Element>(isIncluded: (Element) -> Bool) -> [Element] where Element: Object {
        return realm.objects(Element.self).filter(isIncluded).map { $0 }
    }
    
    public func update<Element>(_ element: Element) where Element: Object {
        try! realm.write {
            realm.add(element, update: .modified)
        }
    }
    
    public func update<Element, Key>(key: Key, update: (Element?) -> Void) where Element: Object {
        let object = realm.object(ofType: Element.self, forPrimaryKey: key)
        try! realm.write {
            update(object)
        }
    }
    
    public func delete<Element>(_ element: Element) where Element: Object {
        try! realm.write {
            realm.delete(element)
        }
    }
    
    public func delete<Element>(isIncluded: (Element) -> Bool) where Element: Object {
        try! realm.write {
            let objects = realm.objects(Element.self).filter(isIncluded)
            realm.delete(objects)
        }
    }
    
    public func deleteAll<Element>(_ type: Element.Type) where Element: Object {
        try! realm.write {
            let objects = realm.objects(type)
            realm.delete(objects)
        }
    }
}
