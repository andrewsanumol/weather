//
//  SearchTableViewController.swift
//  weather
//
//  Created by codinghands on 01/10/19.
//  Copyright © 2019 codinghands. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol cityselection{
    func selectcityfunction(object:String)
}
class SearchTableViewController: UITableViewController,UISearchResultsUpdating {
    
    let tableData = ["Bangalore","Kochi","Mumbai","New Delhi","Hyderabad","Pune","Lucknow"]
    var filteredTableData = [String]()
    var searchController: UISearchController!
    var delegatevar: cityselection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredTableData.count
        }else{
            return tableData.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "citycell", for: indexPath)
        
        if isFiltering() {
            cell.textLabel?.text = filteredTableData[indexPath.row]
            return cell
        }
        else {
            cell.textLabel?.text = tableData[indexPath.row]
            print(tableData[indexPath.row])
            return cell
        }
    }
    func configureSearchController(){
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        // Place the search bar view to the tableview headerview.
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (tableData as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [String]
        
        self.tableView.reloadData()
    }
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFiltering() {
            delegatevar?.selectcityfunction(object: filteredTableData[indexPath.row])
            //params = ["q":filteredTableData[indexPath.row], "appid": APP_ID]
            searchController.dismiss(animated: true, completion: {
                self.dismiss(animated: true)
            })
        }
        else {
            delegatevar?.selectcityfunction(object: tableData[indexPath.row])
            
            // params = ["q":tableData[indexPath.row], "appid": APP_ID]
            //delegatevar?.selectcityfunction(name: tableData[indexPath.row])
            dismiss(animated: true)
        }
    }
}
