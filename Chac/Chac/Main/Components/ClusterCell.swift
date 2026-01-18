//
//  ClusterCell.swift
//  Chac
//
//  Created by 이원빈 on 1/13/26.
//

import SwiftUI

struct ClusterCell: View {
    
    private enum Metric {
        static let imageSize: CGFloat = 94
        static let downloadIconSize: CGFloat = 14
    }
    
    let onOrganizeTap: () -> Void
    let onSaveTap: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            Image("cluster_icon")
                .resizable()
                .scaledToFit()
                .frame(width: Metric.imageSize, height: Metric.imageSize)
            
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Jeju Trip")
                    Text("34장의 사진")
                }
                VStack {
                    Button(action: onOrganizeTap){
                        Text("사진 정리하기")
                            .foregroundStyle(Color.white)
                            .padding(.vertical, 7)
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(4)
                    }
                    
                    Button(action: onSaveTap) {
                        HStack {
                            Image("download_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: Metric.downloadIconSize, height: Metric.downloadIconSize)
                            Text("그대로 저장")
                                .foregroundStyle(Color.black)
                        }
                    }
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 22)
        }
        .padding(.horizontal, 20)
        .background(ColorPalette.gray)
        .cornerRadius(4)
    }
}

#Preview {
    ClusterCell(onOrganizeTap: {}, onSaveTap: {})
}
