//
//  cLabel.swift
//  BmmCalendar
//
//  Created by Ama on 15/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit

enum VerticalAlignment {
    case top
    case middle
    case bottom
}
class cLabel: UILabel {

    var verticalAlignment: VerticalAlignment = .middle {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        
        var rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        
        switch verticalAlignment {
        case .top:
            rect.origin.y = bounds.origin.y
        case .bottom:
            rect.origin.y = bounds.origin.y + bounds.height - rect.height
        case .middle:
            fallthrough
        default:
            rect.origin.y = bounds.origin.y + (bounds.height - rect.height) * 0.5
        }
        
        return rect
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: textRect(forBounds: rect, limitedToNumberOfLines: numberOfLines))
    }

}
