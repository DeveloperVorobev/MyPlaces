//
//  MainViewController.swift
//  MyPlaces
//
//  Created by Владислав Воробьев on 19.04.2022.
//

import UIKit

class MainViewController: UITableViewController {
    let places = Place.getPlaces()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        cell.nameLabel.text = places[indexPath.row].name
        cell.imageOfPlace.image = UIImage(named: places[indexPath.row].image)
        cell.imageOfPlace?.layer.cornerRadius = cell.imageOfPlace.frame.height / 2
        cell.imageOfPlace?.clipsToBounds = true
        cell.locationLabel.text = places[indexPath.row].location
        cell.typeLabel.text = places[indexPath.row].type
        return cell
    }
    // MARK: - TabelViewDelagate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
