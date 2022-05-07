//
//  CustomTableViewCell.swift
//  MyPlaces
//
//  Created by Владислав Воробьев on 21.04.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var imageOfPlace: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet var stackView: StackForMainVC!
    
}
