//
//  RatingControll.swift
//  MyPlaces
//
//  Created by Владислав Воробьев on 06.05.2022.
//

import UIKit

@IBDesignable class RatingControll: UIStackView {
    private var ratingButtons = [UIButton]()
    var rating = 0
    @IBInspectable var starSige:CGSize = CGSize(width: 44, height: 44){
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount:Int = 5{
        didSet{
            setupButtons()
        }
    }
    
   // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }

    // MARK: - Button Action
    
    @objc func ratingButtonTaped(button:UIButton){
        guard let index = ratingButtons.firstIndex(of: button) else {return}
        
        // calculate rating of
    }
    
    // MARK: - Private Methots
    
    private func setupButtons(){
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
        // load button image
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        for _ in 1...starCount{
            // Create button
            let button = UIButton()
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            
            // Add conatrains
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSige.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSige.width).isActive = true
            
            // Setup the button action
            button.addTarget(self, action: #selector(ratingButtonTaped(button:)), for: .touchUpInside)
            
            // Add the buttom to stack
            addArrangedSubview(button)
            ratingButtons.append(button)
        }
    }
}
