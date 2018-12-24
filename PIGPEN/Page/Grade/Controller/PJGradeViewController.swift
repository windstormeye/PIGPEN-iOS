//
//  PJGradeViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2018/12/24.
//  Copyright © 2018 PJHubs. All rights reserved.
//

import UIKit

class PJGradeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let vc1 = PJGradeYesterdayViewController()
        let vc2 = PJGradeWeekViewController()
        
        vc1.view.x = 0
        vc2.view.x = 50
        
        view.addSubview(vc1.view)
        view.addSubview(vc2.view)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
