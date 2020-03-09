//
//  Location.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 09.03.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject {
    typealias LocationHandler = (LocationService?)->()
    
    public private(set) var locationManager: CLLocationManager
    public private(set) var currentLocation: CLLocation?
    
    public var permissionStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    private var updatePermissionHandler: LocationHandler?
    private var updateLocationHandler: LocationHandler?
    
    private weak var weakSelf: LocationService?
    
    init(locationManager manager: CLLocationManager) {
        locationManager = manager
        
        super.init()
        
        locationManager.delegate = self
        weakSelf = self
    }
    
    @discardableResult
    func start(desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest) -> LocationService {
        locationManager.desiredAccuracy = desiredAccuracy
        locationManager.startUpdatingLocation()
        
        return self
    }
    
    @discardableResult
    func stop() -> LocationService {
        locationManager.stopUpdatingLocation()
        
        return self
    }
    
    @discardableResult
    func updateOnce(desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest) -> LocationService {
        locationManager.desiredAccuracy = desiredAccuracy
        locationManager.requestLocation()
        
        return self
    }
    
    @discardableResult
    func onUpdate(handler: LocationHandler?) -> LocationService {
        updateLocationHandler = handler
        
        return self
    }
    
    @discardableResult
    func onPermissionChanged(handler: LocationHandler?) -> LocationService {
        updatePermissionHandler = handler
        
        return self
    }
    
    func isPermissionsGranted() -> Bool {
        return CLLocationManager.locationServicesEnabled() && (permissionStatus == .authorizedAlways || permissionStatus == .authorizedWhenInUse)
    }
    
    func requestPermission(desiredStatus: CLAuthorizationStatus) -> LocationService {
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() {
                if !self.isPermissionsGranted() && self.permissionStatus == .notDetermined {
                    self.requestLocationPermission(desiredStatus: desiredStatus)
                }
            } else {
                self.updatePermissionHandler?(self.weakSelf)
            }
        }
        
        return self
    }
    
    deinit {
        debugPrint("deinit")
    }
}

private extension LocationService {
    func requestLocationPermission(desiredStatus: CLAuthorizationStatus) {
        switch desiredStatus {
        case .authorizedAlways:
            locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            locationManager.requestWhenInUseAuthorization()
        default: break
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status != .notDetermined else { return }
        
        DispatchQueue.main.async {
            self.updatePermissionHandler?(self.weakSelf)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            let oldLocation = self.currentLocation
            self.currentLocation = locations.last
            
            guard let old = oldLocation, let current = self.currentLocation, current.coordinate == old.coordinate else {
                self.updateLocationHandler?(self.weakSelf)
                return
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error)
    }
}

extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return (lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude)
}
