//
//  DefaultPhotoClusterService.swift
//  Chac
//
//  Created by 이원빈 on 1/24/26.
//

import Photos

final class DefaultPhotoClusterService: PhotoClusterService {
    private let timeService: StreamingStrategy
    private let locationService: ClusteringStrategy
    private let geocoder = CLGeocoder()
    
    private var isFirstRequest = true
    private var locationCache: [String: String] = [:]
    
    init(
        timeService: StreamingStrategy = TimeClusteringService(),
        locationService: ClusteringStrategy = LocationClusteringService()
    ) {
        self.timeService = timeService
        self.locationService = locationService
    }
    
    /// 두 가지 전략을 순차적으로 적용하여 최종 클러스터를 생성합니다
    func clusterPhotos(_ photos: [PHAsset]) -> AsyncStream<PhotoCluster> {
        AsyncStream { continuation in
            Task {
                // 시간으로 그룹화
                let timeGroups = timeService.cluster(assets: photos)
                
                // 병렬 처리를 위한 TaskGroup
                await withTaskGroup(of: Void.self) { group in
                    var activeTasks = 0
                    let maxTasks = 1  // 동시에 실행할 최대 작업 수
                    
                    for await timeGroup in timeGroups {
                        // 실행 중인 작업이 너무 많으면 하나가 끝날 때까지 대기
                        if activeTasks >= maxTasks {
                            await group.next()
                            activeTasks -= 1
                        }
                        
                        activeTasks += 1
                        
                        // 각 시간 그룹마다 새로운 자식 Task 추가
                        group.addTask {
                            // 공간 기반 2차 그룹화
                            let locationGroups = self.locationService.cluster(assets: timeGroup)
                            
                            for locGroup in locationGroups {
                                guard let location = locGroup.first?.location else { continue }
                                
                                // 위치 이름 가져오기
                                let title = await self.fetchLocationName(from: location)
                                
                                let newCluster = PhotoCluster(id: UUID(), title: title, phAssets: locGroup)
                                
                                // 클러스터 완성될 때마다 스트림 방출
                                continuation.yield(newCluster)
                            }
                            
                        }
                    }
                }
                // 병렬 작업 끝나면 스트림 종료
                continuation.finish()
            }
        }
    }
    
    /// location에 해당하는 주소를 추출합니다.
    func fetchLocationName(from location: CLLocation, retryCount: Int = 0) async -> String {
        // 캐시 확인
        let key = cacheKey(for: location)
        if let cached = locationCache[key] { return cached }
        
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
            
            locationCache[key] = result
            
            return result
        } catch let error as CLError {
            switch error.code {
            case .network:
                // 네트워크 에러는 retry
                if retryCount < 2 {
                    return await fetchLocationName(from: location, retryCount: retryCount + 1)
                }
                return PhotoLocationError.network.location
            case .geocodeFoundNoResult:
                return PhotoLocationError.foundNoResult.location
            default:
                return PhotoLocationError.network.location
            }
        } catch {
            return PhotoLocationError.network.location
        }
    }
    
    /// 위치를 캐시 키로 변환
    private func cacheKey(for location: CLLocation) -> String {
        return String(format: "%.3f_%.3f",
                      location.coordinate.latitude,
                      location.coordinate.longitude)
    }
}
