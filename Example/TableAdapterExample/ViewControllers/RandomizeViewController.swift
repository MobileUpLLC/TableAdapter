//
//  RandomizeViewController.swift
//  TableAdapterExample
//
//  Created by Nikolai Timonin on 19.05.2020.
//  Copyright © 2020 MobileUp LLC. All rights reserved.
//

import UIKit
import TableAdapter

class RandomizeViewController: UIViewController {

    // MARK: Private properties

    private let tableView = UITableView()

    private lazy var adapter = TableAdapter<Int, Int>(tableView: tableView)

    private var items: [Int] {

        let rightBound = Int.random(in: 1..<6)

        return (0..<rightBound).map { _ in Int.random(in: 0..<6) }
    }

    private var sections: [Section<Int, Int>] {

        let rightBound = Int.random(in: 2..<6)

        let result = (0..<rightBound).map { idx in

            return Section<Int, Int>(
                id: idx,
                items: items,
                header: .default(title: "Section \(idx + 1)"),
                footer: .default(title: "Section \(idx + 1)")
            )
        }

        return result.shuffled()
    }

    private var baseSections: [Section<Int, Int>] {

        let fistSection = Section<Int, Int>(
            id: 0,
            items: [1, 2, 3],
            header: .default(title: "Section 1"),
            footer: .default(title: "Section 1")
        )

        let secondSection = Section<Int, Int>(
            id: 1,
            items:  [4, 5, 6],
            header: .default(title: "Section 2"),
            footer: .default(title: "Section 2")
        )

        return [fistSection, secondSection]
    }

    // MARK: Public properties

    // MARK: Override methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupToolbar()

        adapter.update(with: baseSections, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.frame = view.bounds
    }

    // MARK: Private methods

    private func setupTableView() {

        view.addSubview(tableView)

        tableView.register(
            AnyObjectCell.self,
            forCellReuseIdentifier: adapter.defaultCellIdentifier
        )
    }

    private func setupToolbar() {

        let shuffle = UIBarButtonItem(
            title: "Shuffle",
            style: .plain,
            target: self,
            action: #selector(suffleItems)
        )

        let reset = UIBarButtonItem(
            title: "Reset",
            style: .plain,
            target: self,
            action: #selector(resetItems)
        )

        let randomize = UIBarButtonItem(
            title: "Randomize",
            style: .plain,
            target: self,
            action: #selector(randomizeItems)
        )

        let spacer = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: self,
            action: nil
        )

        toolbarItems = [shuffle, spacer, randomize, spacer, reset]

        navigationController?.setToolbarHidden(false, animated: false)
    }

    @objc private func randomizeItems() {

        adapter.update(with: sections)
    }

    @objc private func resetItems() {

        adapter.update(with: baseSections)
    }

    @objc private func suffleItems() {

        var newSections = adapter.sections.shuffled()

        for i in 0..<newSections.count {

            newSections[i].items.shuffle()
        }

        adapter.update(with: newSections)
    }
}
