//
//  LocationManager.swift
//  iBeacon
//
//  Created by 山河絵利奈 on 2024/08/23.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location = CLLocation()
    @Published var beacons: [CLBeacon] = []
    var locationManager: CLLocationManager!
    var beaconRegion:CLBeaconRegion!

    override init() {
        super.init()
        
        locationManager = CLLocationManager()
       
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.distanceFilter = 2
        
        let status = locationManager.authorizationStatus
        if(status == .notDetermined) {
            requestPermission()
       }
        locationManager.startUpdatingLocation()
        self.startMonitoring()
    }
    
    func requestPermission() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func startMonitoring() {
        let uuid: NSUUID! = NSUUID(uuidString: "41462998-6CEB-4511-9D46-1F7E27AA6572")
        let identifierStr: String = "BeaconId"
        beaconRegion = CLBeaconRegion(uuid: uuid as UUID, identifier: identifierStr)
        beaconRegion.notifyEntryStateOnDisplay = false
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true
        locationManager.startMonitoring(for: beaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        locationManager.requestState(for: self.beaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for inRegion: CLRegion) {

            switch (state) {
            case .inside:
                self.locationManager.startRangingBeacons(satisfying: self.beaconRegion.beaconIdentityConstraint)
                break
            case .outside:
                break
            case .unknown:
                break

            }
        }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.locationManager.startRangingBeacons(satisfying: self.beaconRegion.beaconIdentityConstraint)
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        self.locationManager.startRangingBeacons(satisfying: self.beaconRegion.beaconIdentityConstraint)
    }

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion){
        self.beacons = beacons
    }

    func locationManager(_ manager: CLLocationManager,
                           didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last!
    }

}
