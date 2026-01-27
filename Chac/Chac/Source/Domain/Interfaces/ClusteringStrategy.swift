//
//  ClusteringStrategy.swift
//  Chac
//
//  Created by 가은 on 1/24/26.
//

import Photos

protocol ClusteringStrategy {
    /// 클러스터로 인정되기 위한 최소 사진 개수
    var minClusterSize: Int { get }
    
    /// 주어진 사진 배열을 특정 전략에 따라 그룹화합니다.
    /// - Parameter assets: 클러스터링 대상 사진 배열
    /// - Returns: 그룹화된 사진들의 2차원 배열
    func cluster(assets: [PHAsset]) async -> [[PHAsset]]
}
