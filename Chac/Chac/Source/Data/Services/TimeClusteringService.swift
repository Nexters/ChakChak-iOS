//
//  TimeClusteringService.swift
//  Chac
//
//  Created by 가은 on 1/24/26.
//

import Photos

/// 시간 간격을 기반으로 사진을 그룹화
final class TimeClusteringService: ClusteringStrategy {
    var minClusterSize: Int
    private let interval: TimeInterval
    
    /// - Parameters:
    ///   - minClusterSize: 유효한 클러스터가 되기 위한 최소 개수 (기본 20개)
    ///   - interval: 인접한 시간 간에 허용되는 최대 시간 간격(초 단위), 기본값은 10,800초(3시간)
    init(minClusterSize: Int = 20, interval: TimeInterval = 10800) {
        self.minClusterSize = minClusterSize
        self.interval = interval
    }
    
    func cluster(assets: [PHAsset]) async -> [[PHAsset]] {
        guard !assets.isEmpty else { return [] }
        
        var clusters: [[PHAsset]] = []
        var currentCluster: [PHAsset] = [assets[0]]
        
        for i in 1..<assets.count {
            let previousAsset = assets[i-1]
            let currentAsset = assets[i]
            
            guard let curAssetDate = currentAsset.creationDate,
                  let prevAssetDate = previousAsset.creationDate else { break }
            
            // 시간 차이가 임계값(3시간) 이내인지 확인
            if curAssetDate.timeIntervalSince(prevAssetDate) <= interval {
                currentCluster.append(currentAsset)
            } else {
                // 임계값을 초과하면, 클러스터가 최소 크기(20개)를 만족할 때만 추가
                if currentCluster.count >= minClusterSize {
                    clusters.append(currentCluster)
                }
                
                // 새로운 그룹 시작
                currentCluster = [currentAsset]
            }
        }
        
        // 루프 종료 후 마지막 그룹 처리
        if currentCluster.count >= minClusterSize {
            clusters.append(currentCluster)
        }
        
        return clusters
    }
}

