//
//  calendarBar.swift
//  AMACalendar
//
//  Created by Ama on 09/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit

enum barCommand: Int {
    case noCommand
    case previous
    case next
}
class calendarBar: UIControl {

    fileprivate(set) var command: barCommand?
    
    fileprivate(set) var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.alpha = 0.5
        return label
    }()
    
    fileprivate var previousBtn: UIButton = {
        let pBtn = UIButton(type: .custom)
        pBtn.translatesAutoresizingMaskIntoConstraints = false
        
        pBtn.setImage(calendarBundle.previousImage(), for: .normal)
        
        pBtn.tintColor = UIColor(colorLiteralRed: 0.99,
                                 green: 0.62,
                                 blue: 0.86,
                                 alpha: 1)
        
        return pBtn
    }()
    
    fileprivate var nextBtn: UIButton = {
        let nBtn = UIButton(type: .custom)
        nBtn.translatesAutoresizingMaskIntoConstraints = false
        
        nBtn.setImage(calendarBundle.nextImage(), for: .normal)
        
        nBtn.tintColor = UIColor(colorLiteralRed: 0.99,
                                 green: 0.62,
                                 blue: 0.86,
                                 alpha: 1)
        return nBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        UI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension calendarBar {
    fileprivate func UI() {
        
        /// previous
        addSubview(previousBtn)
        /// textLabel
        addSubview(textLabel)
        /// next
        addSubview(nextBtn)
        
        previousBtn
            .addTarget(self,
                       action: #selector(didTapPBtn),
                       for: .touchUpInside)
        nextBtn
            .addTarget(self,
                       action: #selector(didTapNBtn),
                       for: .touchUpInside)
        
        // VFL
        let views: [String: Any] = ["previousBtn": previousBtn,
                                    "textLabel": textLabel,
                                    "nextBtn": nextBtn]
        
        var cons = NSLayoutConstraint
            .constraints(withVisualFormat: "H:|[previousBtn(50)]-20-[textLabel]-20-[nextBtn(50)]|",
                         options: .alignAllCenterY,
                         metrics: nil,
                         views: views)
        
        cons += NSLayoutConstraint
            .constraints(withVisualFormat: "V:|[previousBtn]|",
                         options: [],
                         metrics: nil,
                         views: views)
        
        cons += NSLayoutConstraint
            .constraints(withVisualFormat: "V:|[nextBtn]|",
                         options: [],
                         metrics: nil,
                         views: views)
        
        cons += [NSLayoutConstraint.init(item: textLabel,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: 0)]
        addConstraints(cons)
    }
}

// MARK: - Action
extension calendarBar {
    @objc fileprivate func didTapPBtn() {
        command = .previous
        sendActions(for: .valueChanged)
    }
    
    @objc fileprivate func didTapNBtn() {
        command = .next
        sendActions(for: .valueChanged)
    }
}
