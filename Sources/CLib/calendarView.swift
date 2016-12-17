//
//  calendarView.swift
//  BmmCalendar
//
//  Created by Ama on 09/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//

import UIKit


public class calendarView: UIControl {

    // MARK: - public api
    public var selectedDate: (Date, String)?
    
    public var weekdayHeaderTextColor: UIColor? = {
        return UIColor(colorLiteralRed: 0.4,
                       green: 0.4,
                       blue: 0.4,
                       alpha: 0.5)
    }()
    
    public var weekdayHeaderWeekendTextColor: UIColor? = {
        return UIColor(colorLiteralRed: 0.99,
                       green: 0.62,
                       blue: 0.86,
                       alpha: 0.5)
    }()
    
    public var selectedIndicatorColor: UIColor? = {
        return UIColor(colorLiteralRed: 0.99,
                       green: 0.62,
                       blue: 0.86,
                       alpha: 0.5)
    }()
    
    public var todayIndicatorColor: UIColor? = {
        return UIColor(colorLiteralRed: 0.93,
                       green: 0.93,
                       blue: 0.93,
                       alpha: 1)
    }()
    
    
    public var indicatorRadius: CGFloat = 17
    public var boldPrimaryComponentText: Bool = true
    
    public var singleRowMode: Bool = false {
        didSet {
            updateCurrentVisibleRow()
        }
    }
    
    // MARK: - private api
    fileprivate var weekday:[String]?
    fileprivate var visibleYear: Int?
    fileprivate var visibleMonth: Int?
    fileprivate var currentVisibleRow: Int?
    
    fileprivate var calendarbar: calendarBar = {
        let bar = calendarBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    fileprivate var weekHeaderView: UIStackView = {
       let hView = UIStackView()
        hView.translatesAutoresizingMaskIntoConstraints = false
        hView.axis = .horizontal
        hView.distribution = .fillEqually
        hView.alignment = .center
        return hView
    }()
    
    fileprivate var contentWrapper: UIView = {
        let wView = UIView()
        wView.translatesAutoresizingMaskIntoConstraints = false
        return wView
    }()
    
    fileprivate var contentView: UIStackView = {
        let cView = UIStackView()
        cView.translatesAutoresizingMaskIntoConstraints = false
        cView.axis = .vertical
        cView.distribution = .fillEqually
        cView.alignment = .fill
        cView.spacing = 8
        return cView
    }()
    
    /// 选择 指示器
    fileprivate var selectedIndicatorView: indicatorView = {
        let sView = indicatorView()
        sView.translatesAutoresizingMaskIntoConstraints = false
        sView.isHidden = true
        return sView
    }()
    
    /// 今天 指示器
    fileprivate var todayIndicatorView: indicatorView = {
       let tView = indicatorView()
        tView.translatesAutoresizingMaskIntoConstraints = false
        tView.isHidden = true
        return tView
    }()
    
    fileprivate var componentViews = [componentView]()
    fileprivate var barTitle: String? {
        get {
            return "\(visibleYear!). \(visibleMonth!)"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        UI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        UI()
    }
}

// MARK: - UI
extension calendarView {
    fileprivate func UI() {
        clipsToBounds = true
        
        var comps = utils.date(fromDate: Date(timeIntervalSinceNow: 0))
        visibleYear = comps.year
        visibleMonth = comps.month
        
        calendarbar.textLabel.text = barTitle
        calendarbar.addTarget(self, action: #selector(barBtnDidTap(sender:)), for: .valueChanged)
        
        addSubview(calendarbar)
        addSubview(weekHeaderView)
        addSubview(contentWrapper)
        contentWrapper.addSubview(contentView)
        
        // calendarbar weekHeaderView VFL
        let views: [String: Any] = ["calendarbar": calendarbar,
                                    "weekHeaderView": weekHeaderView,
                                    "contentWrapper": contentWrapper]
        
        var cons = NSLayoutConstraint
            .constraints(withVisualFormat: "V:|[calendarbar(40)][weekHeaderView]-(5)-[contentWrapper]",
                         options: [], metrics: nil, views: views)
        
        cons += NSLayoutConstraint
            .constraints(withVisualFormat: "H:|[calendarbar]|",
                         options: [], metrics: nil, views: views)
        
        cons += NSLayoutConstraint
            .constraints(withVisualFormat: "H:|[weekHeaderView]|",
                         options: [], metrics: nil, views: views)
        
        cons += NSLayoutConstraint
            .constraints(withVisualFormat: "H:|[contentWrapper]|",
                         options: [], metrics: nil, views: views)
        
        cons += [NSLayoutConstraint
            .init(item: weekHeaderView,
                  attribute: .centerX,
                  relatedBy: .equal,
                  toItem: self,
                  attribute: .centerX,
                  multiplier: 1.0,
                  constant: 0)]
        
        cons += [NSLayoutConstraint
            .init(item: contentWrapper,
                  attribute: .centerX,
                  relatedBy: .equal,
                  toItem: self, attribute: .centerX,
                  multiplier: 1.0,
                  constant: 0)]
        
        addConstraints(cons)
        
        var subCons = NSLayoutConstraint
            .constraints(withVisualFormat: "H:|[contentView]|",
                         options: [],
                         metrics: nil,
                         views: ["contentView": contentView])
        
        subCons += NSLayoutConstraint
            .constraints(withVisualFormat: "V:|[contentView]|",
                         options: [],
                         metrics: nil,
                         views: ["contentView": contentView])
        
        contentWrapper.addConstraints(subCons)
        
        makeUIElements()
        
        let leSG = UISwipeGestureRecognizer(target: self,
                                            action: #selector(didSwipe))
        leSG.direction = .left
        
        let riSG = UISwipeGestureRecognizer(target: self,
                                            action: #selector(didSwipe))
        riSG.direction = .right
        
        addGestureRecognizer(riSG)
        addGestureRecognizer(leSG)
    }
    
    // MARK: - calendar elements
    fileprivate func makeUIElements() {
        
        contentWrapper.insertSubview(todayIndicatorView, belowSubview: contentView)
        contentWrapper.insertSubview(selectedIndicatorView, belowSubview: contentView)
        
        for _ in 1...7 {
            weekHeaderView.addArrangedSubview(UILabel())
        }
        
        var currentColumn = 0
        var currentRowView: UIStackView?
        
        let makeRow: () -> () = {
            currentRowView = UIStackView()
            currentRowView?.axis = .horizontal
            currentRowView?.distribution = .fillEqually
            currentRowView?.alignment = .fill
        }
        
        let submitRowIfNecessary: () -> () = {
            if currentColumn >= 7 && currentRowView != nil {
                self.contentView.addArrangedSubview(currentRowView!)
                currentColumn = 0
                makeRow()
            }
        }
        
        let submitCell: (_ cellView: UIView) -> () = { [weak self] cellView in
            currentRowView?.addArrangedSubview(cellView)
            self?.componentViews.append(cellView as! componentView)
            currentColumn += 1
            submitRowIfNecessary()
        }
        
        makeRow()
        
        for _ in 0..<42 {
            let compv = componentView()
            compv.addTarget(self, action: #selector(componentDidTap(sender:)), for: .touchUpInside)
            submitCell(compv)
        }
    }
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        reloadView(animated: false)
    }
}

//MARK: - private
extension calendarView {
    fileprivate func componentViewForDateComponents(comps: DateComponents) -> componentView? {
        for obj in componentViews {
            let cps = obj.representedObj as? DateComponents
            if (cps?.day == comps.day) &&
                (cps?.month == comps.month) &&
                (cps?.year == comps.year) {
                return obj
            }
        }
        return nil
    }
    
    fileprivate func configureIndicatorViews() {
        selectedIndicatorView.color = selectedIndicatorColor
        todayIndicatorView.color = todayIndicatorColor
    }
    
    fileprivate func configureWeekdayHeaderView() {
        let isValidWeekday: Bool = (weekday != nil) && weekday?.count == 7
        
        for idx in 0..<weekHeaderView.arrangedSubviews.count {
            let wkLabel = weekHeaderView.arrangedSubviews[idx] as? UILabel
            wkLabel?.textAlignment = .center
            wkLabel?.font = UIFont.systemFont(ofSize: 12)
            wkLabel?.textColor = (idx == 0 || idx == 6) ?
                    weekdayHeaderWeekendTextColor :
                    weekdayHeaderTextColor

            if isValidWeekday {
                wkLabel?.text = weekday?[idx]
            } else {
                wkLabel?.text = utils.stringOfWeekday(weekday: idx + 1)
            }
        }
    }
    
    fileprivate func configureComponentView(view: componentView, day: Int, month: Int, year: Int) {
        var comps = DateComponents()
        comps.day = day
        comps.month = month
        comps.year = year
        
        let chineseComps = utils.date(convertToCComps: month, day: day, year: year)
        
        
        if utils.isDateToday(components: comps) {
            if todayIndicatorView.isHidden {
                todayIndicatorView.isHidden = false
                todayIndicatorView.transform = CGAffineTransform(scaleX: 0, y: 0)
                
                UIView.animate(withDuration: 0.3, animations: { 
                    self.todayIndicatorView.transform = CGAffineTransform.identity
                })
            }
            
            todayIndicatorView.attachingView = view
            addConstraintToCenterIndicatorView(view: todayIndicatorView,
                                               toView: view)
        }
        
        if chineseComps.day == 1 {
            if view.mIndicatorView.isHidden {
                view.mIndicatorView.isHidden = false
                
                view.mIndicatorView.transform = CGAffineTransform(scaleX: 0, y: 0)
                
                UIView.animate(withDuration: 0.3, animations: {
                    view.mIndicatorView.transform = CGAffineTransform.identity
                })
            }
        } else {
            view.mIndicatorView.isHidden = true
        }
        
        view.representedObj = comps
        if selectedIndicatorView.attachingView == view {
            view.isSelected = true
        } else {
            view.isSelected = false
        }
        
        view.textLabel.alpha = (visibleMonth == month) ? 1.0 : 0.5
        view.chineseTextLabel.alpha = (visibleMonth == month) ? 1.0 : 0.5
        
        view.textLabel.font = UIFont.systemFont(ofSize: 15)
        view.chineseTextLabel.font = UIFont.systemFont(ofSize: 8)
        
        view.textLabel.text = String(day)
        view.chineseTextLabel.text =
            (chineseComps.day == 1) ?
                utils.date(convertToCMonthStr: chineseComps.month!) :
                utils.date(convertToCDayStr: chineseComps.day!)
    }
    
    fileprivate func configureContentView() {
        var pointer = 0
        let totalDay = utils.day(inMonth: visibleMonth!, inYear: visibleYear!)!
        let paddingDay = utils.firstWeekday(inMonth: visibleMonth!, inYear: visibleYear!)!
        
        let paddingYear = (visibleMonth! == 1) ? (visibleYear! - 1) : visibleYear!
        let paddingMonth = (visibleMonth! == 1) ? 12 : (visibleMonth! - 1)
        let totalDayInLastMonth = utils.day(inMonth: paddingMonth, inYear: paddingYear)!
        
        for  i in (0..<paddingDay - 1).reversed() {
            configureComponentView(view: componentViews[pointer],
                                   day: totalDayInLastMonth - i,
                                   month: paddingMonth,
                                   year: paddingYear)
            pointer += 1
        }
        
        for i in 0..<totalDay {
            configureComponentView(view: componentViews[pointer],
                                   day: i + 1,
                                   month: visibleMonth!,
                                   year: visibleYear!)
            pointer += 1
        }
        
        let reserveYear = (visibleMonth! == 12) ? (visibleYear! + 1) : visibleYear!
        let reserveMonth = (visibleMonth! == 12) ? 1 : (visibleMonth! + 1)
        
        for i in 0..<componentViews.count - pointer {
            configureComponentView(view: componentViews[pointer],
                                   day: i + 1,
                                   month: reserveMonth,
                                   year: reserveYear)
            pointer += 1
        }
    }
    
    fileprivate func addConstraintToCenterIndicatorView(view: UIView, toView: UIView) {
        for obj in contentWrapper.constraints {
            if (obj.firstItem as! UIView) == view {
                contentWrapper.removeConstraint(obj)
            }
        }
        
        // VFL
        let views: [String: Any] = ["view": view]
        
        var cons = NSLayoutConstraint
            .constraints(withVisualFormat: "H:[view(w)]",
                         options: [],
                         metrics: ["w": indicatorRadius * 2],
                         views: views)
        
        cons += NSLayoutConstraint
            .constraints(withVisualFormat: "V:[view(h)]",
                         options: [],
                         metrics: ["h": indicatorRadius * 2],
                         views: views)
        
        view.addConstraints(cons)
        
        var subCons = [NSLayoutConstraint
            .init(item: view,
                  attribute: .centerX,
                  relatedBy: .equal,
                  toItem: toView,
                  attribute: .centerX,
                  multiplier: 1.0,
                  constant: 0)]
        
        subCons += [NSLayoutConstraint
            .init(item: view,
                  attribute: .centerY,
                  relatedBy: .equal,
                  toItem: toView,
                  attribute: .centerY,
                  multiplier: 1.0,
                  constant: 0)]
        
        contentWrapper.addConstraints(subCons)
    }
    
    fileprivate func updateCurrentVisibleRow() {
        for idx in 0..<contentView.arrangedSubviews.count {
            let obj = contentView.arrangedSubviews[idx]
            if singleRowMode {
                obj.isHidden = currentVisibleRow != idx
                obj.alpha = obj.isHidden ? 0 : 1
            } else {
                obj.isHidden = false
                obj.alpha = 1
            }
        }
        
        guard let tAttachingView = todayIndicatorView.attachingView else {
            return
        }
        
        todayIndicatorView.alpha = (tAttachingView.superview?.isHidden)! ? 0 : 1
        
        guard let sAttachingView = todayIndicatorView.attachingView else {
            return
        }
        
        selectedIndicatorView.alpha = (sAttachingView.superview?.isHidden)! ? 0 : 1

    }
}

//MARK: - public
extension calendarView {
    func jump(toMonth  month:Int, year: Int) {
        var direction = false
        if visibleYear! == year {
            direction = month > visibleMonth!
        } else {
            direction = year > visibleYear!
        }
        
        visibleMonth = month
        visibleYear = year
        selectedDate = nil
        
        todayIndicatorView.isHidden = true
        todayIndicatorView.attachingView = nil
        selectedIndicatorView.attachingView = nil
        
        UIView.transition(with: calendarbar.textLabel,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.calendarbar.textLabel.text = self.barTitle
        }, completion: nil)
        
        let snapshotView = contentWrapper.snapshotView(afterScreenUpdates: false)
        snapshotView?.frame = contentWrapper.frame
        addSubview(snapshotView!)
        
        configureContentView()
        
        contentView.transform =
            CGAffineTransform(translationX: contentView.frame.width / 3 * (direction ? 1 : -1),
                              y: 0)
        contentView.alpha = 0
        
        UIView.animate(withDuration: 0.6,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: .curveLinear,
                       animations: {
                        snapshotView?.transform =
                            CGAffineTransform(translationX: self.contentView.frame.width / 2 * (direction ? -1: 1), y: 0)
                        snapshotView?.alpha = 0
                        self.selectedIndicatorView.transform = CGAffineTransform(scaleX: 0, y: 0)
                        self.contentView.transform = CGAffineTransform.identity
                        self.contentView.alpha = 1
        }, completion: { _ in
            snapshotView?.removeFromSuperview()
            if self.selectedDate == nil {
                self.selectedIndicatorView.isHidden = true
            }
        })
    }
    
    func jumpPrevious() {
        if singleRowMode {
            if currentVisibleRow! > 0 {
                currentVisibleRow! -= 1
                UIView.transition(with: contentWrapper,
                                  duration: 0.4,
                                  options: .transitionFlipFromBottom,
                                  animations: nil,
                                  completion: nil)
                updateCurrentVisibleRow()
                return
            } else {
                currentVisibleRow = 5
            }
        }
        
        var pMonth = 0, pYear = 0
        if visibleMonth! <= 1 {
            pMonth = 12
            pYear = visibleYear! - 1
        } else {
            pMonth = visibleMonth! - 1
            pYear = visibleYear!
        }
        
        jump(toMonth: pMonth, year: pYear)
        
        if singleRowMode {
            updateCurrentVisibleRow()
        }
    }
    
    func jumpNext() {
        if singleRowMode {
            if currentVisibleRow! < 5 {
                currentVisibleRow! += 1
                UIView.transition(with: contentWrapper,
                                  duration: 0.4,
                                  options: .transitionFlipFromTop,
                                  animations: nil,
                                  completion: nil)
            } else {
                currentVisibleRow! = 0
            }
        }
        
        var nMonth = 0, nYear = 0
        if visibleMonth! >= 12 {
            nMonth = 1
            nYear = visibleYear! + 1
        } else {
            nMonth = visibleMonth! + 1
            nYear = visibleYear!
        }
        
        jump(toMonth: nMonth, year: nYear)
        
        if singleRowMode {
            updateCurrentVisibleRow()
        }
    }
    
    func reloadView(animated: Bool) {
        configureIndicatorViews()
        configureWeekdayHeaderView()
        configureContentView()
        
        if animated {
            UIView.transition(with: self,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
}

//MARK: - action
extension calendarView {
    @objc fileprivate func barBtnDidTap(sender: calendarBar) {
        guard let command = sender.command else {
            return
        }
        switch command {
            
        case .previous:
            jumpPrevious()
            
        case .next:
            jumpNext()
            
        default:
            break
        }
    }
    
    @objc fileprivate func componentDidTap(sender: componentView) {
        let comp = sender.representedObj as! DateComponents
        
        if comp.year! != visibleYear! || comp.month! != visibleMonth! {
            jump(toMonth: comp.month!, year: comp.year!)
            return
        }
        
        if selectedIndicatorView.isHidden {
            selectedIndicatorView.isHidden = false
            selectedIndicatorView.transform = CGAffineTransform(scaleX: 0, y: 0)
            selectedIndicatorView.attachingView = sender
            addConstraintToCenterIndicatorView(view: selectedIndicatorView,
                                               toView: sender)
            
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0,
                           options: .curveLinear,
                           animations: {
                            
                            self.selectedIndicatorView.transform = CGAffineTransform.identity
                            sender.isSelected = true
                            
            }, completion: nil)
            
        } else {
            addConstraintToCenterIndicatorView(view: selectedIndicatorView, toView: sender)
            
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveLinear,
                           animations: {
                            
                            self.contentWrapper.layoutIfNeeded()
                            (self.selectedIndicatorView.attachingView as? componentView)?.isSelected = false
                            sender.isSelected = true
                            
            }, completion: nil)
            
            selectedIndicatorView.attachingView = sender
        }
        
        selectedDate = (utils.date(components: comp)!, utils.date(forChineseComps: comp))
        sendActions(for: .valueChanged)
    }
    
    @objc fileprivate func didSwipe(sGes: UISwipeGestureRecognizer) {
        if sGes.direction == .left {
            jumpNext()
        } else {
            jumpPrevious()
        }
    }
}
