//
//  ViewController.swift
//  TableAdapterExample
//
//  Created by Nikolai Timonin on 28.11.2019.
//  Copyright © 2019 MobileUp LLC. All rights reserved.
//

import UIKit
import TableAdapter

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let table = UITableView()
        
        let adapter = TableAdapter(tableView: table)
        adapter.dataSource = self
    }
}

extension ViewController: TableAdapterDataSource {
    
    func objectsForTableAdapter(_ adapter: TableAdapter) -> [Any] {
        
        return []
    }
}
