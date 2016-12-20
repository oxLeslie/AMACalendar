//
//  componentsView.swift
//  AMACalendar
//
//  Created by Ama on 09/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit

class componentView: UIControl {
    
    var textLabel: cLabel = {
       let label = cLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.verticalAlignment = .bottom
        return label
    }()
    
    var chineseTextLabel: cLabel = {
        let label = cLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.verticalAlignment = .top
        return label
    }()
    
    /// 初一 指示器
    var mIndicatorView: indicatorView = {
        let mView = indicatorView()
        mView.translatesAutoresizingMaskIntoConstraints = false
        mView.color = UIColor.red.withAlphaComponent(0.7)
        mView.isHidden = true
        return mView
    }()
    
    var representedObj: Any?

    override init(frame: CGRect) {
        super.init(frame: frame)
        UI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension componentView {
    fileprivate func UI() {
        addSubview(mIndicatorView)
        addSubview(textLabel)
        addSubview(chineseTextLabel)

        
        // VFL
        let views: [String: Any] = ["textLabel": textLabel,
                                    "mIndicatorView": mIndicatorView,
                                    "chineseTextLabel": chineseTextLabel]

        var cons = NSLayoutConstraint
            .constraints(withVisualFormat: "H:[mIndicatorView(15)]",
                         options: [],
                         metrics: nil,
                         views: views)
        
        cons += NSLayoutConstraint
            .constraints(withVisualFormat: "V:[mIndicatorView(2)]-(-5)-|",
                         options: [],
                         metrics: nil,
                         views: views)
        
        cons += [NSLayoutConstraint
            .init(item: mIndicatorView,
                  attribute: .centerX,
                  relatedBy: .equal,
                  toItem: self,
                  attribute: .centerX,
                  multiplier: 1.0,
                  constant: 0)]
        
        
        cons += NSLayoutConstraint
            .constraints(withVisualFormat: "H:|[textLabel]|",
                         options: [],
                         metrics: nil,
                         views: views)
        
        cons += NSLayoutConstraint
            .constraints(withVisualFormat: "H:|[chineseTextLabel]|",
                         options: [],
                         metrics: nil,
                         views: views)

        cons += NSLayoutConstraint
            .constraints(withVisualFormat: "V:|[textLabel][chineseTextLabel]|",
                         options: [],
                         metrics: nil,
                         views: views)

        addConstraints(cons)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        addGestureRecognizer(tapGesture)
    }
}

extension componentView {
    @objc fileprivate func tap() {
        sendActions(for: .touchUpInside)
    }
}
