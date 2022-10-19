//
//  AllGroupsController.swift
//  VKontakte
//
//  Created by Елена Русских on 20.06.2022.
//

import UIKit
import SDWebImage

class AllGroupsController: UITableViewController, UISearchBarDelegate {
    
    let apiManager = APIManager()
    let session = Session.shared


    var groups = [Group]()
    var filteredGroups = [Group]()

    var currentGroup = Group()

   lazy var searchController: UISearchController = {
     let  search = UISearchController(searchResultsController: nil)
       search.searchResultsUpdater = self

       search.obscuresBackgroundDuringPresentation = false
       search.searchBar.placeholder = "Search group"
       search.searchBar.sizeToFit()
       search.searchBar.searchBarStyle = .prominent
       search.searchBar.delegate = self

        return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isUserInteractionEnabled = true

        navigationItem.searchController = searchController
        
        apiManager.getGroupsAll(token: session.token){ [weak self] items  in

            self?.groups = items

            self?.tableView.reloadData()

        }

    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredGroups.count
        }
        return groups.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! AllGroupsCell

        if isFiltering(){
            self.currentGroup = filteredGroups[indexPath.row]
            let url = URL(string: filteredGroups[indexPath.row].photoGroup)
            cell.GroupImage.sd_setImage(with: url)
        } else {
            self.currentGroup = groups[indexPath.row]
            let url = URL(string: groups[indexPath.row].photoGroup)
            cell.GroupImage.sd_setImage(with: url)
        }
        
        cell.GroupName.text = self.currentGroup.name
      
        return cell
    }




    func filterGroupsForSearchText (searchText: String){
        
      guard searchText != "" else{return}
      let search = searchText.lowercased()
        
        apiManager.getUserGroupsSearch(token: session.token, text: search ){ [weak self] items  in
        
                   self?.filteredGroups = items
        
                   self?.tableView.reloadData()
        
               }
        
        tableView.reloadData()
    }


    func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }


    func searchBar(_ searchBar: UISearchBar) {

        filterGroupsForSearchText(searchText: searchBar.text!)
    }


    func isFiltering() -> Bool{
        return searchController.isActive && !isSearchBarEmpty()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering(){
            self.currentGroup = filteredGroups[indexPath.row]
        } else{
            self.currentGroup = groups[indexPath.row]
        }
    }
}



extension AllGroupsController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterGroupsForSearchText(searchText: searchBar.text!)
    }
}
