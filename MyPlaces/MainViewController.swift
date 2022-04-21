//
//  MainViewController.swift
//  MyPlaces
//
//  Created by Владислав Воробьев on 19.04.2022.
//

import UIKit

class MainViewController: UITableViewController {
    let restaurantNames = ["Паштет", "Eat & Go", "Рваный бургер", "Burger King", "Macdonalds", "Своя компания"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let imageView = cell.viewWithTag(1) as? UIImageView
        let textLabel = cell.viewWithTag(2) as? UILabel
        imageView?.image = UIImage(named: restaurantNames[indexPath.row])
        imageView?.layer.cornerRadius = cell.frame.size.height / 2
        imageView?.clipsToBounds = true
        textLabel?.text = restaurantNames[indexPath.row]
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
