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
                    let maxTasks = 3  // 동시에 실행할 최대 작업 수
                    
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
    func fetchLocationName(from location: CLLocation) async -> String {
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            
            guard let placemark = placemarks.first else { return "어느 멋진 날의 추억" }
            
            let adminArea = placemark.administrativeArea
            let locality = placemark.locality
            let subLocality = placemark.subLocality
            let thoroughfare = placemark.thoroughfare
            
            var addressComponents: [String] = []
            let candidates = [adminArea, locality, subLocality, thoroughfare]
            
            for candidate in candidates {
                guard let component = candidate, !component.isEmpty else { continue }
                
                if !addressComponents.contains(component) {
                    addressComponents.append(component)
                }
            }
            
            return addressComponents.joined(separator: " ")
        } catch {
            print("역지오코딩 에러: \(error.localizedDescription)")
            return "알 수 없는 장소"
        }
    }
    
}
