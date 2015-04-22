# LKLocation
方便、易用的定位功能
请在真机测试

===
单例对象

```
LKLocationManager.sharedInstance
```

===
方法

```
    获得位置坐标
    func getLocationCoordinate(locaiontBlock: (locationCorrrdinate: CLLocationCoordinate2D) -> Void) { startLocate() }
    
    获得坐标和地址
    func getLocationCoordinate(locaiontBlock: (locationCorrrdinate: CLLocationCoordinate2D) -> Void, addressBlock: (addressName: String) -> Void) { startLocate() }
    
    获得地址
    func getAddress(addressBlock: (addressName: String) -> Void) { startLocate() }
    
    获得城市
    func getCity(cityBlock: (cityName: String) -> Void) { startLocate() }
```
