//
//  MainViewController.swift
//  MyPlaces
//
//  Created by Владислав Воробьев on 19.04.2022.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var places: Results<Place>!
    private var filtredPlaces: Results<Place>!
    private var ascendingSorting = true
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    private var isFiltering: Bool{
        return searchController.isActive && !searchBarIsEmpty
    }
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var reversedSortButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        places = realm.objects(Place.self)
        // Setup SearchController
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search"
    }

    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filtredPlaces.count
        }
        return places.isEmpty ? 0 : places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        var place = Place()
        if isFiltering{
            place = filtredPlaces[indexPath.row]
        } else {
            place = places[indexPath.row]
        }
        guard !places.isEmpty else {
            return cell
        }
        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.imageOfPlace.contentMode = .scaleAspectFill
        cell.imageOfPlace.image = UIImage(data: place.imageData!)
        cell.imageOfPlace?.layer.cornerRadius = cell.imageOfPlace.frame.height / 2
        cell.imageOfPlace?.clipsToBounds = true
        
        return cell
    }
    // MARK: - TabelViewDelagate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "showDetail"{
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let place:Place
            if isFiltering {
                place = filtredPlaces[indexPath.row]
            } else {
                place = places[indexPath.row]
            }
            let newPlaceVC = segue.destination as! NewPlaceVC
            newPlaceVC.currentPlace = place
            
        }
    }
    @IBAction func unwingSegue(_ segue: UIStoryboardSegue){
        guard let newPlaceVC =  segue.source as? NewPlaceVC else {return}
        newPlaceVC.savePlace()
        tableView.reloadData()
    }
    // MARK: TabelViewDelegate
    //    FOR ADD MANY ACTIONS
    //    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    //        let place = places[indexPath.row]
    //        let deliteAction = UIContextualAction(style: .destructive, title: "Delite") { _, _, _ in
    //            StorageManager.deliteObject(place)
    //            tableView.deleteRows(at: [indexPath], with: .automatic)
    //            tableView.reloadData()
    //        }
    //        return UISwipeActionsConfiguration(actions: [deliteAction])
    //    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let place = places[indexPath.row]
            StorageManager.deliteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func reversedSorting(_ sender: Any) {
        ascendingSorting.toggle()
        if ascendingSorting {
            reversedSortButton.image = UIImage(named: "AZ")
        } else {
            reversedSortButton.image = UIImage(named: "ZA")
        }
        sorting()
    }
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        sorting()
    }
    private func sorting(){
        if segmentedControl.selectedSegmentIndex == 0{
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        tableView.reloadData()
    }
}
extension MainViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    private func filterContentForSearchText(_ searchText: String){
        filtredPlaces = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText)
        tableView.reloadData()
    }
}
