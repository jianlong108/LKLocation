//
//  CCLocationManager.swift
//  Location
//
//  Created by liukun on 15/4/21.
//  Copyright (c) 2015年 liukun. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

let LKPreviousLongitude =   "CCPreviousLongitude"
let LKPreviousLatitude  =   "CCLastLatitude"
let LKPreviousCity      =   "CCLastCity"
let LKPreviousAddress   =   "CCLastAddress"

class LKLocationManager: NSObject, CLLocationManagerDelegate {
    /// MARK: - 单例
    private static let instance = LKLocationManager()
    class var sharedInstance: LKLocationManager {
        return instance
    }
    
    /// MARK: - 获取坐标、详细位置、城市接口
    /**
    获得位置坐标
    
    :param: locaiontBlock   返回的坐标结果
    */
    func getLocationCoordinate(locaiontBlock: (locationCorrrdinate: CLLocationCoordinate2D) -> Void) {
        self.locationBlock = locaiontBlock
        startLocate()
    }
    
    /**
    获得坐标和地址
    
    :param: locaiontBlock   返回的坐标结果
    :param: addressBlock    返回的位置结果
    */
    func getLocationCoordinate(locaiontBlock: (locationCorrrdinate: CLLocationCoordinate2D) -> Void, addressBlock: (addressName: String) -> Void) {
        self.locationBlock = locaiontBlock
        self.addressBlock = addressBlock
        startLocate()
    }
    
    /**
    获得地址
    
    :param: addressBlock    返回的位置结果
    */
    func getAddress(addressBlock: (addressName: String) -> Void) {
        self.addressBlock = addressBlock
        startLocate()
    }
    
    /**
    获得城市
    
    :param: cityBlock       返回的城市结果
    */
    func getCity(cityBlock: (cityName: String) -> Void) {
        self.cityBlock = cityBlock
        startLocate()
    }
    
    /// MARK: - 成员变量
    private var manager: CLLocationManager?
    
    var previousCoordinate: CLLocationCoordinate2D!
    var previousCity: String?
    var previousAddress: String?
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    private var locationBlock: ((locationCorrrdinate: CLLocationCoordinate2D) -> Void)?
    private var cityBlock: ((cityName: String) -> Void)?
    private var addressBlock: ((addressName: String) -> Void)?
    private var errorBlock: ((error: NSError) -> Void)?
    
    /// MARK: - 初始化
    override init() {
        super.init()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let latitude: CLLocationDegrees = CLLocationDegrees(defaults.floatForKey(LKPreviousLatitude))
        let longitude: CLLocationDegrees = CLLocationDegrees(defaults.floatForKey(LKPreviousLongitude))
        self.latitude = latitude
        self.longitude = longitude
        self.previousCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
        self.previousCity = defaults.objectForKey(LKPreviousCity) as? String
        self.previousAddress = defaults.objectForKey(LKPreviousAddress) as? String
    }
}

extension LKLocationManager {
    /// MARK: - CLLocationManagerDelegate
    /**
    位置更新调用的代理方法
    :param: manager     调用者
    :param: newLocation 新的位置
    :param: oldLocation 以前的位置
    */
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(newLocation, completionHandler: { (placemarks, error) -> Void in
            if placemarks.count > 0 {
                let placemark = placemarks.first as! CLPlacemark
                
                self.previousCity = "\(placemark.administrativeArea)" + "\(placemark.locality)"
                defaults.setObject(self.previousCity, forKey: LKPreviousCity)
                
                self.previousAddress = "\(placemark.country)" + "\(placemark.administrativeArea)" + "\(placemark.locality)" + "\(placemark.subLocality)" + "\(placemark.thoroughfare)" + "\(placemark.subThoroughfare)"
                defaults.setObject(self.previousAddress, forKey: LKPreviousAddress)
            }
            
            if let _cityBlock = self.cityBlock {
                if let _previousCity = self.previousCity {
                    _cityBlock(cityName: _previousCity)
                    self.cityBlock = nil
                }
            }
            
            if let _addressBlock = self.addressBlock {
                if let _previousCity = self.previousAddress {
                    _addressBlock(addressName: _previousCity)
                    self.addressBlock = nil
                }
            }
        })

        
        self.previousCoordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)
        if let _locationBlock = self.locationBlock {
            if let _previousCoordinate = self.previousCoordinate {
                _locationBlock(locationCorrrdinate: _previousCoordinate)
                self.locationBlock = nil
            }
        }
        
        defaults.setObject(newLocation.coordinate.latitude, forKey: LKPreviousLatitude)
        defaults.setObject(newLocation.coordinate.longitude, forKey: LKPreviousLongitude)
        
        manager.stopUpdatingLocation()
    }
    
    /**
    初始化定位管理器
    */
    private func startLocate() {
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.Denied {
            manager = CLLocationManager()
            manager?.delegate = self
            manager?.desiredAccuracy = kCLLocationAccuracyBest
            manager?.requestAlwaysAuthorization()
            manager?.requestWhenInUseAuthorization()
            manager?.distanceFilter = 1000
            manager?.startUpdatingLocation()
        } else {
            let alvertView = UIAlertView(title: "提示", message: "需要开启定位服务,请到设置->隐私,打开定位服", delegate: nil, cancelButtonTitle: "确定")
            alvertView.show()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        self.manager = nil
    }
}
