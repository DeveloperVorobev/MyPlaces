//
//  StackForMainVC.swift
//  MyPlaces
//
//  Created by Владислав Воробьев on 07.05.2022.
//

import UIKit

class StackForMainVC: UIStackView {
    private var ratingImages = [UIImageView]()
    var ratingCount = 5
    var rating = 0 {
        didSet {
            setupImages()
        }
    }
    var countOfStars = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImages()
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupImages()
    }
    private func setupImages(){
        for image in ratingImages {
            removeArrangedSubview(image)
            image.removeFromSuperview()
        }
        ratingImages.removeAll()
        for numberOfStar in 1...ratingCount{
            let readyStar = UIImageView()
            if numberOfStar <= rating  {
                readyStar.image = UIImage(named: "filledStar")
            } else {
                readyStar.image = UIImage(named: "emptyStar")
            }
            addArrangedSubview(readyStar)
            ratingImages.append(readyStar)
        }
        
       
}
}
