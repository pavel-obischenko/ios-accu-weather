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
    typealias LocationHandler = (LocationService?) -> Void
    
    public private(set) var locationManager: CLLocationManager
    public private(set) var currentLocation: CLLocation?
    
    public var permissionStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    private var updatePermissionHandler: LocationHandler?
    private var updateLocationHandler: LocationHandler?
    
    override init() {
        locationManager = CLLocationManager()
        
        super.init()
        
        locationManager.delegate = self
    }
    
    init(locationManager manager: CLLocationManager) {
        locationManager = manager
        
        super.init()
        
        locationManager.delegate = self
    }
    
    @discardableResult
    func start(desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest) -> LocationService {
        DispatchQueue.main.async {
            self.locationManager.desiredAccuracy = desiredAccuracy
            self.locationManager.startUpdatingLocation()
        }
        
        return self
    }
    
    @discardableResult
    func stop() -> LocationService {
        locationManager.stopUpdatingLocation()
        
        return self
    }
    
    @discardableResult
    func updateOnce(desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest) -> LocationService {
        DispatchQueue.main.async {
            self.locationManager.desiredAccuracy = desiredAccuracy
            self.locationManager.requestLocation()
        }
        
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
    
    @discardableResult
    func requestPermission(desiredStatus: CLAuthorizationStatus = .authorizedWhenInUse) -> LocationService {
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() {
                if !self.isPermissionsGranted() && self.permissionStatus == .notDetermined {
                    self.requestLocationPermission(desiredStatus: desiredStatus)
                }
            } else {
                weak var weakSelf = self
                self.updatePermissionHandler?(weakSelf)
            }
        }
        
        return self
    }
    
    deinit {
        debugPrint("LocationManager: deinit")
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
            weak var weakSelf = self
            self.updatePermissionHandler?(weakSelf)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            let oldLocation = self.currentLocation
            self.currentLocation = locations.last
            
            guard let old = oldLocation, let current = self.currentLocation, current.coordinate == old.coordinate else {
                weak var weakSelf = self
                self.updateLocationHandler?(weakSelf)
                
                return
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error)
    }
}

extension CLLocationCoordinate2D: Equatable {}

public func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return (lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude)
}
