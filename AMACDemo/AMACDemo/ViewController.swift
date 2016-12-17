//
//  ViewController.swift
//  AMACDemo
//
//  Created by Ama.Qiu on 17/12/2016.
//  Copyright © 2016 Ama.Qiu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendar = calendarView(frame: CGRect(x: 10, y: 50, width: UIScreen.main.bounds.width - 20, height: 280))
        calendar.addTarget(self, action: #selector(calendarChange), for: .valueChanged)
        view.addSubview(calendar)
    }

    @objc fileprivate func calendarChange(view: calendarView) {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        print(formatter.string(from: (view.selectedDate?.0)!), view.selectedDate!.1)
    }


}

