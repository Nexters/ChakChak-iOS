//
//  DefaultGeocodingService.swift
//  Chac
//
//  Created by 가은 on 2/3/26.
//

import CoreLocation

final class DefaultGeocodingService: GeocodingService {
    private let geocoder = CLGeocoder()
    private var isFirstRequest = true
    private var cache: [String: String] = [:]
    
    /// 위치에 해당하는 주소를 반환합니다
    func fetchLocationName(from location: CLLocation) async -> String {
        return await fetchWithRetry(from: location, retryCount: 0)
    }
    
    // MARK: - Private
    private func fetchWithRetry(from location: CLLocation, retryCount: Int) async -> String {
        // 캐시 확인
        let key = cacheKey(for: location)
        if let cached = cache[key] { return cached }
        
        // 첫 번째는 바로 실행, 이후부터 1초 딜레이
        if isFirstRequest {
            isFirstRequest = false
        } else {
            try? await Task.sleep(for: .seconds(1))
        }
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            
            guard let placemark = placemarks.first else {
                return PhotoLocationError.foundNoResult.location
            }
            
            let result = placemark.formattedAddress
            
            if result.isEmpty {
                return PhotoLocationError.foundNoResult.location
            }
            
            cache[key] = result
            return result
        } catch {
            if let clError = error as? CLError {
                return await handleCLError(clError, location: location, retryCount: retryCount)
            }
            return PhotoLocationError.network.location
        }
    }
    
    private func handleCLError(_ error: CLError, location: CLLocation, retryCount: Int) async -> String {
        switch error.code {
        case .network:
            if retryCount < 2 {
                return await fetchWithRetry(from: location, retryCount: retryCount + 1)
            }
            return PhotoLocationError.network.location
        case .geocodeFoundNoResult:
            return PhotoLocationError.foundNoResult.location
        default:
            return PhotoLocationError.network.location
        }
    }
    
    /// 위치 정보를 기반으로 고유한 캐시 키 문자열 생성
    /// - Parameter location: 캐싱 기준이 되는 CLLocation 객체
    /// - Returns: "위도_경도" 형식의 문자열 (각 좌표는 소수점 3자리까지 포함)
    private func cacheKey(for location: CLLocation) -> String {
        return String(format: "%.3f_%.3f",
                      location.coordinate.latitude,
                      location.coordinate.longitude)
    }
}
