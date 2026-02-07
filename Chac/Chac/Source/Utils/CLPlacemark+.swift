//
//  CLPlacemark+.swift
//  Chac
//
//  Created by 가은 on 2/3/26.
//

import CoreLocation

extension CLPlacemark {
    
    /// 중복 없이 주소 조합
    var formattedAddress: String {
        let candidates = [administrativeArea, locality, subLocality, thoroughfare]
        
        var components: [String] = []
        for candidate in candidates {
            guard let component = candidate, !component.isEmpty else { continue }
            if !components.contains(component) {
                components.append(component)
            }
        }
        
        return components.joined(separator: " ")
    }
}
