//
//  indicatorView.swift
//  AMACalendar
//
//  Created by Ama on 09/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit

class indicatorView: UIView {

    var attachingView: UIView?
    var color: UIColor? {
        willSet {
            ellipseLayer?.fillColor = newValue?.cgColor
        }
    }
    
    fileprivate var ellipseLayer: CAShapeLayer?
    

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        ellipseLayer = CAShapeLayer()
        ellipseLayer?.fillColor = color?.cgColor
        layer.addSublayer(ellipseLayer!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ellipseLayer?.frame = bounds
        ellipseLayer?.path = CGPath(ellipseIn: bounds, transform: nil)
    }
}
