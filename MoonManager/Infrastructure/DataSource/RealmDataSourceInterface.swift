//
//  DatabaseService.swift
//  MoonManager
//
//  Created by cschoi on 12/29/23.
//

import Foundation
import RealmSwift

public protocol RealmDataSourceInterface {
    func create<Element>(_ element: Element) where Element: Object
    func retrieve<Element, Key>(key: Key) -> Element? where Element: Object
    func retrieve<Element>(query: String) -> [Element] where Element: Object
    func retrieve<Element>(isIncluded: (Element) -> Bool) -> [Element] where Element: Object
    func update<Element>(_ element: Element) where Element: Object
    func update<Element, Key>(key: Key, update: (Element?) -> Void) where Element: Object
    func delete<Element>(_ element: Element) where Element: Object
    func delete<Element>(isIncluded: (Element) -> Bool) where Element: Object
    func deleteAll<Element>(_ type: Element.Type) where Element: Object
}
