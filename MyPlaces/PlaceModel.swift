//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Владислав Воробьев on 21.04.2022.
//

import Foundation
struct Place{
    var name: String
    var location: String
    var type: String
    var image: String
    
    static let restaurantNames = ["Паштет", "Eat & Go", "Рваный бургер", "Burger King", "Macdonalds", "Своя компания"]
    static func getPlaces () -> [Place]{
        var places = [Place]()
        
        for place in restaurantNames {
            places.append(Place(name: place, location: "Екатеринбург", type: "Ресторан", image: place))
        }
        return places
    }
}
