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

protocol StreamingStrategy {
    /// 클러스터로 인정되기 위한 최소 사진 개수
    var minClusterSize: Int { get }
    
    /// 입력된 사진 배열을 클러스터링하여 스트림으로 반환합니다.
    /// - Parameter assets: 클러스터링할 원본 `PHAsset` 배열
    /// - Returns: 완성된 클러스터(`[PHAsset]`)를 하나씩 방출하는 `AsyncStream`
    func cluster(assets: [PHAsset]) -> AsyncStream<[PHAsset]>
}

