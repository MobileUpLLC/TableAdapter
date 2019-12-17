//
//  SearchViewController.swift
//  TableAdapterExample
//
//  Created by Nikolai Timonin on 06.12.2019.
//  Copyright © 2019 MobileUp LLC. All rights reserved.
//

import UIKit
import TableAdapter

class SearchViewController: UIViewController {
    
    // MARK: Private properties
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let tableView = UITableView()
    
    private lazy var adapter = TableAdapter(tableView: tableView)
    
    private lazy var seas: [String] = seasRaw.components(separatedBy: CharacterSet.newlines)
    
    // MARK: Override methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchController()
        
        adapter.update(with: seas, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    // MARK: Private methods
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.register(AnyObjectCell.self, forCellReuseIdentifier: adapter.defaultCellIdentifier)
        
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        
        tableView.tableFooterView = UIView()
    }
    
    private func setupSearchController() {
        
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        
        navigationItem.searchController = searchController
    }
}

// MARK: UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let filter = searchController.searchBar.text, filter.isEmpty == false else {
            
            return adapter.update(with: seas, animated: true)
        }
        
        let filteredWords = seas.filter { $0.lowercased().contains(filter.lowercased()) }
        
        adapter.update(with: filteredWords, animated: true)
    }
}

// MARK: Seas Raw Data

let seasRaw = """
Adriatic Sea
Aegean Sea
Aland Sea
Aki-nada
Alboran Sea
Amakusa-nada
Amundsen Sea
Andaman Sea
Arabian Sea
Arafura Sea
Aral Sea
Arctic Ocean
Atlantic Ocean
Baie d'Hudson
Bakor Sea
Balearic Sea
Bali Sea
Baltic Sea
Banda Sea
Barents Sea
Bay of Bengal
Beaufort Sea
Bellingshausen Sea
Bering Sea
Bingo-nada
Bay of Biscay
Bismarck Sea
Black Sea
Bohol Sea
Bulkhead Rip
Camotes Sea
Cape Rip
Caribbean Sea
Caspian Sea
Celebes Sea
Celtic Sea
Ceram Sea
Chosŏndong-hae
Chukchi Sea
Clement Rapids
Coral Sea
Daryā-ye Khazar
Daryā-ye Khezer
Daryā-ye Māzandarān
Daryā-ye ‘Ommān
Davis Sea
Dent Rapids
Dicks Rip
Dumont d'Urville, Mer
East China Sea
East Siberian Sea
Eastern Chops
Eastern Mediterranean
English Channel
Flores Sea
Galloway Rapids
Genkai-nada
Greene Point Rapids
Greenland Sea
Cuanabara Bay
Gulf of Guinea
Gulf of Mexico
Halmahera Sea
Harima-nada
Hibiki-nada
Hiuchi-nada
Hyŏnji-hae
Hyūga-nada
Indian River
Indian Ocean
Inland Sea
Ionian Sea
Irish Sea
Itsuki-nada
Iyo-nada
Java Sea
Jiuzhou Yang
Kalupag Sea
Kara Sea
Kashima-nada
Khalkidhikón Pélagos
Kong Håkon VII Hav
Koro Sea
Kosmonavtov, more
Kumano-nada
Labrador Sea
Laccadive Sea
Landmeen
Laptev Sea
Laut Lepar
Lazareva, more
Leading Tickles
Ligurian Sea
Lincoln Sea
Long Rip
Luzon Sea
Maotou Yang
Mawson Sea
McKinley Sea
Mediterranean Sea
Meiyu Yang
Mer d' Emeraude
Mer de Lincoln
Mer du Labrador
Mindanao Sea
Mizushima-nada
Molucca Sea
Moore Rip
Myrtóön Pélagos
Nakwakto Rapids
NORTH SEA
Northwest Rip
Northwest Straits
Norwegian Sea
Outer Bald Rip
P'eng-hu Wan
Pacific Ocean
Pechorskoye More
Persian Gulf
Philippine Sea
Pollock Rip
Prince Gustaf Adolf Sea
Putuo Yang
Qizhou Yang
Queen Victoria Sea
Quoddy River
Red Sea
Riser-Larsena, more
Ross Sea
Saaristomeri
Salish Sea
Samar Sea
Sargasso Sea
Savu Sea
Scotch Corner
Scotia Sea
Sea of Azov
Sea of Crete
Sea of Japan
Sea of Marmara
Sea of Okhotsk
Sea of the Hebrides
Shag Harbour Rip
Shantarskoye More
Short Rip
Sibuyan Sea
Sodruzhestva, more
Solomon Sea
Somova, more
Soutch China Sea
South Pacific Ocean
Sulu Sea
Suō-nada
Tail of the Rip
Tasman Sea
Thálassa Cheimarras
Thale Phuket
The Hospital
The Overfalls
The Rip
The Swirlers
The Tittle
Thimble Tickles
Thrakikón Pelagós
Timor Sea
Tosa-wan
Tyrrhenian Sea
Uwa-kai
Virsko More
Visayan Sea
Wandel Hav
Weddell Sea
Western Mediterranean
Whirlpool Rapids
White Sea
Wilsons Rip
Yellow Sea
"""
