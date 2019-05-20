//
//  PJPetCreateBirthView.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/5/20.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJPetCreateBirthView: UIView {
    
    var yearSelected: (() -> Void)?
    var monthSelected: (() -> Void)?
    var daySelected: (() -> Void)?

    var currentYear = 1980
    var currentMonth = -1
    var currentDay = -1
    
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var monthLabel: UILabel!
    @IBOutlet private weak var dayLabel: UILabel!
    
    
    class func newInstance() -> PJPetCreateBirthView {
        return Bundle.main.loadNibNamed("PJPetCreateBirthView",
                                        owner: self,
                                        options: nil)?.first as! PJPetCreateBirthView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let yearTap = UITapGestureRecognizer(target: self, action: .year)
        yearLabel.addGestureRecognizer(yearTap)
        let monthTap = UITapGestureRecognizer(target: self, action: .month)
        monthLabel.addGestureRecognizer(monthTap)
        let dayTap = UITapGestureRecognizer(target: self, action: .day)
        dayLabel.addGestureRecognizer(dayTap)
    }
    
    func setYear(count: Int) {
        currentYear = 1980 + count
        yearLabel.text = "\(currentYear)"
        yearLabel.textColor = .black
    }
    
    func setMonth(count: Int) {
        currentMonth = count + 1
        monthLabel.text = "\(currentMonth)"
        monthLabel.textColor = .black
    }
    
    func setDay(count: Int) {
        currentDay = count + 1
        dayLabel.text = "\(currentDay)"
        dayLabel.textColor = .black
    }
    
    @objc
    fileprivate func year() {
        yearSelected?()
    }
    
    @objc
    fileprivate func month() {
        monthSelected?()
    }
    
    @objc
    fileprivate func day() {
        daySelected?()
    }
}

private extension Selector {
    static let year = #selector(PJPetCreateBirthView.year)
    static let month = #selector(PJPetCreateBirthView.month)
    static let day = #selector(PJPetCreateBirthView.day)
}
