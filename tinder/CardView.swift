//
//  CardView.swift
//  tinder
//
//

import UIKit

class CardView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        layer.shadowColor = UIColor.black.cgColor
        
        layer.shadowOpacity = 0.4
        
        layer.shadowOffset = CGSize.zero
        
        layer.shadowRadius = CGFloat(12)
        
    }
    
    override func layoutSubviews() {
        
        layer.cornerRadius = CGFloat(6)
        
    }
    

}
