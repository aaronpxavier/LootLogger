//
//  ItemStore.swift
//  LootLogger
//
//  Created by ladmin on 7/18/22.
//

import UIKit

class ItemStore {
    var allItems = [Item]();
    var filteredItems = [Item]();
    let itemArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("items.plist")
    }()
    
    
    init() {
        let notificationCenter = NotificationCenter.default
        
        do {
            let data = try Data(contentsOf: itemArchiveURL)
            let unarchiver = PropertyListDecoder()
            let items = try unarchiver.decode([Item].self, from: data)
            allItems = items
        } catch {
            print("Errora reading in saved items: \(error)")
        }
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didEnterBackgroundNotification, object: nil)
    }
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        allItems.append(newItem)
        return newItem
    }
    
    func removeItem(_ item: Item) {
        if let index = allItems.firstIndex(of: item) {
            allItems.remove(at: index)
        }
    }
    
    func removeItem(_ index: Int) {
        allItems.remove(at: index)
    }
    
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        let movedItem = allItems[fromIndex]
        
        allItems.remove(at: fromIndex)
        allItems.insert(movedItem, at: toIndex)
    }
    
    func search(filterBy searchText: String) {
        filteredItems = allItems.filter({(item: Item) -> Bool in
            return item.name.contains(searchText)
        })
    }
    
    @objc func saveChanges() -> Bool {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(allItems)
            try data.write(to: itemArchiveURL, options: .atomic)
            print("saved all of the items")
            return true
        } catch let encodingError {
            print("Error encoding allItems: \(encodingError)")
            return false
        }
    }
}
