//
//  LocationDataManager.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 4/4/24.
//

import Foundation
import CoreLocation

class LocationDataManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            
            authorizationStatus = .authorizedWhenInUse
            locationManager.requestLocation()
            break
        case .restricted:
            
            authorizationStatus = .restricted
            break
        case .denied:
            
            authorizationStatus = .denied
            break
        case .notDetermined:
            
            authorizationStatus = .notDetermined
            locationManager.requestWhenInUseAuthorization()
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Insert code to handle location updates
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
    
    let statesDictionary: [String: String] = [
        "AL": "Alabama",
        "AK": "Alaska",
        "AZ": "Arizona",
        "AR": "Arkansas",
        "CA": "California",
        "CO": "Colorado",
        "CT": "Connecticut",
        "DE": "Delaware",
        "FL": "Florida",
        "GA": "Georgia",
        "HI": "Hawaii",
        "ID": "Idaho",
        "IL": "Illinois",
        "IN": "Indiana",
        "IA": "Iowa",
        "KS": "Kansas",
        "KY": "Kentucky",
        "LA": "Louisiana",
        "ME": "Maine",
        "MD": "Maryland",
        "MA": "Massachusetts",
        "MI": "Michigan",
        "MN": "Minnesota",
        "MS": "Mississippi",
        "MO": "Missouri",
        "MT": "Montana",
        "NE": "Nebraska",
        "NV": "Nevada",
        "NH": "New Hampshire",
        "NJ": "New Jersey",
        "NM": "New Mexico",
        "NY": "New York",
        "NC": "North Carolina",
        "ND": "North Dakota",
        "OH": "Ohio",
        "OK": "Oklahoma",
        "OR": "Oregon",
        "PA": "Pennsylvania",
        "RI": "Rhode Island",
        "SC": "South Carolina",
        "SD": "South Dakota",
        "TN": "Tennessee",
        "TX": "Texas",
        "UT": "Utah",
        "VT": "Vermont",
        "VA": "Virginia",
        "WA": "Washington",
        "WV": "West Virginia",
        "WI": "Wisconsin",
        "WY": "Wyoming"
    ]
    
    let slugDictionary: [String: String] = [
        "AL": "ALA",
        "AK": "ASK",
        "AZ": "ARI",
        "AR": "ARK",
        "CA": "CAL",
        "CO": "COL",
        "CT": "CNT",
        "DE": "DEL",
        "FL": "FLA",
        "GA": "GEO",
        "HI": "HAW",
        "ID": "IDA",
        "IL": "ILL",
        "IN": "INI",
        "IA": "IOW",
        "KS": "KAN",
        "KY": "KTY",
        "LA": "LOU",
        "ME": "MAI",
        "MD": "MRY",
        "MA": "MAS",
        "MI": "MIC",
        "MN": "MIN",
        "MS": "MSI",
        "MO": "MSO",
        "MT": "MNT",
        "NE": "NEB",
        "NV": "NEV",
        "NH": "NWH",
        "NJ": "NWJ",
        "NM": "NWM",
        "NY": "NWY",
        "NC": "NCA",
        "ND": "NDA",
        "OH": "OHI",
        "OK": "OKL",
        "OR": "ORE",
        "PA": "PEN",
        "RI": "RHO",
        "SC": "SCA",
        "SD": "SDA",
        "TN": "TEN",
        "TX": "TEX",
        "UT": "UTA",
        "VT": "VER",
        "VA": "MRY",
        "WA": "WAS",
        "WV": "WVA",
        "WI": "WIS",
        "WY": "WYO"
    ]
}

extension CLLocation {
    
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}

extension CLPlacemark {
    /// street name, eg. Infinite Loop
    var streetName: String? { thoroughfare }
    /// // eg. 1
    var streetNumber: String? { subThoroughfare }
    /// city, eg. Cupertino
    var city: String? { locality }
    /// neighborhood, common name, eg. Mission District
    var neighborhood: String? { subLocality }
    /// state, eg. CA
    var state: String { administrativeArea! }
    /// county, eg. Santa Clara
    var county: String? { subAdministrativeArea }
    /// zip code, eg. 95014
    var zipCode: String? { postalCode }
    
}
