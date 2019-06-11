//
//  PJInfoViewController.swift
//  PIGPEN
//
//  Created by PJHubs on 2019/6/10.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let bgImg = UIImageView(frame: CGRect(x: 0, y: 0, width: view.pj_width, height: view.pj_height))
        bgImg.image = UIImage(named: "friend")
        view.addSubview(bgImg)
        // Do any additional setup after loading the view.
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
