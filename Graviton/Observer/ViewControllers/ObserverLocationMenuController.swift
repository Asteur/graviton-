//
//  ObserverLocationMenuController.swift
//  Graviton
//
//  Created by Sihao Lu on 8/3/17.
//  Copyright © 2017 Ben Lu. All rights reserved.
//

import UIKit

fileprivate let cityCellId = "cityCell"

class ObserverLocationMenuController: MenuController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController:  nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        return searchController
    }()

    lazy var cities: [City] = CityManager.fetchCities()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu_icon_target"), style: .plain, target: self, action: #selector(requestUsingLocationService))
        self.navigationItem.titleView = searchController.searchBar
        self.definesPresentationContext = true
    }

    func requestUsingLocationService() {
        CityManager.default.currentlyLocatedCity = nil
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        cell.backgroundColor = UIColor.clear
        if let currentCity = CityManager.default.currentlyLocatedCity, city == currentCity {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let city = cities[indexPath.row]
        let cell = MenuLocationCell(style: .subtitle, reuseIdentifier: cityCellId)
        cell.textLabel?.text = city.name
        let detail: String
        if city.iso3 == "USA" {
            detail = "\(city.country), \(city.provinceAbbreviation!)"
        } else {
            detail = city.country
        }
        cell.detailTextLabel?.text = detail
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .checkmark
        CityManager.default.currentlyLocatedCity = city
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    // MARK: - Search controller delegate

    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        cities = CityManager.fetchCities(withNameContaining: searchString)
        tableView.reloadData()
    }

}
