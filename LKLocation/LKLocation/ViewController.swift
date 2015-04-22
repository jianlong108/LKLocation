//
//  ViewController.swift
//  LKLocation
//
//  Created by liukun on 15/4/21.
//  Copyright (c) 2015年 liukun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // 获取地址
    @IBAction func getAddress(sender: UIButton) {
        LKLocationManager.sharedInstance.getAddress({ (addressName) -> Void in
            self.cityInfo.text = addressName
        })
    }
    
    // 获取城市
    @IBAction func getCity(sender: UIButton) {
        LKLocationManager.sharedInstance.getCity({ (cityName) -> Void in
            self.cityInfo.text = cityName
        })
    }
    
    // 获取坐标
    @IBAction func getCoordinate(sender: UIButton) {
        LKLocationManager.sharedInstance.getLocationCoordinate ({ (locationCorrrdinate) -> Void in
            self.cityInfo.text = "\(locationCorrrdinate.latitude)" + " + " + "\(locationCorrrdinate.longitude)"
        })
    }
    
    @IBOutlet weak var cityInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

