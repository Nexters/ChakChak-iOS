//
//  LocationClusteringService.swift
//  Chac
//
//  Created by 가은 on 1/24/26.
//

import Photos

/// 위치 정보를 기반으로 사진을 그룹화
final class LocationClusteringService: ClusteringStrategy {
    var minClusterSize: Int
    
    /// 동일한 클러스터로 묶을 수 있는 최대 거리(미터 단위)
    private let epsilon: Double
    
    /// 클러스터를 형성하기 위해 이웃해야 하는 최소 지점의 수
    private let minPoints: Int
    
    /// - Parameters:
    ///   - minClusterSize: 유효한 그룹으로 인정될 최소 사진 수 (기본 20개)
    ///   - epsilon: 동일 클러스터로 간주할 최대 거리 (단위: 미터, 기본 100m)
    ///   - minPoints: 클러스터를 형성하기 위한 최소 이웃 수 (기본 1개)
    init(minClusterSize: Int = 20, epsilon: Double = 100.0, minPoints: Int = 1) {
        self.minClusterSize = minClusterSize
        self.epsilon = epsilon
        self.minPoints = minPoints
    }
    
    func cluster(assets: [PHAsset]) async -> [[PHAsset]] {
        // 위치 정보가 있는 사진만 필터링
        let assetsWithLocation = assets.filter { $0.location != nil }
        guard !assetsWithLocation.isEmpty else { return [] }
        
        var visited = Set<String>()
        var clusters: [[PHAsset]] = []
        
        for asset in assetsWithLocation {
            // 이미 방문한 사진은 건너뜁니다.
            if visited.contains(asset.localIdentifier) { continue }
            visited.insert(asset.localIdentifier)
            
            let neighbors = findNeighbors(target: asset, in: assetsWithLocation)
            
            // 주변에 이웃이 부족하면 노이즈로 간주
            if neighbors.count < minPoints { continue }
            
            // 이웃이 충분한 경우,
            // 새로운 클러스터를 생성하고 주변으로 확장
            var newCluster: [PHAsset] = [asset]
            expandCluster(
                newCluster: &newCluster,
                neighbors: neighbors,
                allAssets: assetsWithLocation,
                visited: &visited
            )
            
            // 최종 생성된 그룹이 최소 크기 조건을 만족하는지 확인
            if newCluster.count >= minClusterSize {
                clusters.append(newCluster)
            }
        }
        
        return clusters
    }
    
    /// 특정 사진의 반경(epsilon) 내에 있는 이웃 사진들을 찾습니다.
    /// - Parameters:
    ///   - target: 반경 계산의 중심이 되는 기준 사진
    ///   - allAssets: 위치 정보를 가진 전체 사진 배열 (비교 대상)
    /// - Returns: 기준 사진으로부터 설정된 거리(m) 이내에 있는 이웃 사진들의 배열
    private func findNeighbors(target: PHAsset, in allAssets: [PHAsset]) -> [PHAsset] {
        guard let targetLocation = target.location else { return [] }
        
        return allAssets.filter { other in
            // 1. 위치 정보가 있고, 2. 자기 자신이 아닌 사진만 필터링
            guard let otherLocation = other.location,
                  target.localIdentifier != other.localIdentifier else { return false }
            
            // 두 지점 사이의 실제 거리(m) 계산
            let distanceInMeters = targetLocation.distance(from: otherLocation)
            
            // 설정된 반경(epsilon) 이내인지 확인
            return distanceInMeters <= epsilon
        }
    }
    
    /// 발견된 이웃들을 순차적으로 방문하며 클러스터의 범위를 확장합니다.
    /// - Parameters:
    ///   - newCluster: 현재 생성 중인 사진 그룹
    ///   - neighbors: 시작점의 반경(epsilon) 내에서 발견된 1차 이웃들
    ///   - allAssets: 위치 정보가 있는 전체 사진 목록
    ///   - visited: 이미 방문 처리된 사진의 고유 ID 집합
    private func expandCluster(
        newCluster: inout [PHAsset],
        neighbors: [PHAsset],
        allAssets: [PHAsset],
        visited: inout Set<String>
    ) {
        var queue = neighbors
        var index = 0
        
        while index < queue.count {
            let neighbor = queue[index]
            index += 1
            
            // 이미 방문했다면 패스
            if visited.contains(neighbor.localIdentifier) { continue }
            visited.insert(neighbor.localIdentifier)
            
            // 현재 이웃을 클러스터에 추가
            newCluster.append(neighbor)
            
            // 현재 이웃의 주변(100m)에도 사진이 충분히 모여있는지 확인
            let nextNeighbors = findNeighbors(target: neighbor, in: allAssets)
            
            // 핵심 지점(Core Point)이라면 대기열에 추가
            if nextNeighbors.count >= minPoints {
                for next in nextNeighbors {
                    if !visited.contains(next.localIdentifier) {
                        queue.append(next)
                    }
                }
            }
        }
    }
}

