//
//  ItemsViewController.swift
//  LootLogger
//
//  Created by ladmin on 7/18/22.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    static private let tableViewCellReuseId = "ItemCell"

    var itemStore: ItemStore? = nil
    let backgroundLayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 65
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore?.allItems.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemsViewController.tableViewCellReuseId, for: indexPath) as! ItemCell
        let item = itemStore?.allItems[indexPath.row]
        cell.nameLabel.text = item?.name
        cell.serialNumberLabel.text = item?.serialNumber
        cell.valueLabel.text = String(item?.valueInDollars ?? 0)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let item = itemStore?.allItems[indexPath.row] {
            itemStore?.removeItem(item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        itemStore?.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
        print(itemStore?.allItems ?? [])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showItem":
            if let row = tableView.indexPathForSelectedRow?.row {
                let item = itemStore?.allItems[row]
                
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        guard let newItem = itemStore?.createItem() else { return }
        if let index = itemStore?.allItems.firstIndex(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        if isEditing {
            sender.setTitle("Edit", for:.normal)
            setEditing(false, animated: true)
        } else {
            sender.setTitle("Done", for: .normal)
            setEditing(true, animated: true)
        }
    }
    
  
}
