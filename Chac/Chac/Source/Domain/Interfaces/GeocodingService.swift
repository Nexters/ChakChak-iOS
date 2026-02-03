//
//  GeocodingService.swift
//  Chac
//
//  Created by 가은 on 2/3/26.
//

import CoreLocation

protocol GeocodingService {
    func fetchLocationName(from location: CLLocation) async -> String
}
