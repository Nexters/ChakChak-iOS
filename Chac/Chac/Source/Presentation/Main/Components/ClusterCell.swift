//
//  ClusterCell.swift
//  Chac
//
//  Created by 이원빈 on 1/13/26.
//

import SwiftUI
import CoreLocation

struct ClusterCell: View {
    
    private enum Metric {
        static let imageSize: CGFloat = 72
    }
    
    @EnvironmentObject private var photoLibraryStore: PhotoLibraryStore
    @State private var thumbnailImage: UIImage? = nil
    
    let viewModel: ClusterCellModel
    let backgroundColor: Color
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 16) {
            Image(uiImage: thumbnailImage ?? UIImage(named: "cluster_icon")!)
                .resizable()
                .scaledToFill()
                .frame(width: Metric.imageSize, height: Metric.imageSize)
                .cornerRadius(10)
                .clipped()
                .overlay(alignment: .bottomTrailing) {
                    Text("+\(viewModel.photoCount)")
                        .chacFont(.sub_number)
                        .foregroundStyle(ColorPalette.text_btn_01)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 8)
                        .background(ColorPalette.black_70)
                        .cornerRadius(1000)
                        .padding([.bottom, .trailing], 4)
                }
            VStack(alignment: .leading, spacing: 6) {
                Text(viewModel.title)
                    .chacFont(.headline_02)
                    .foregroundStyle(ColorPalette.text_01)
                    .multilineTextAlignment(.leading)
                Text("\(DateFormatter.yyyyMMdd.string(from: viewModel.thumbnailPHAsset.creationDate ?? Date()))")
                    .chacFont(.date_text)
                    .foregroundStyle(ColorPalette.white_80)
                Spacer()
            }
            .padding(.vertical, 2)
            
            Spacer()
            
            Image("arrow_up_right_icon")
                .padding(.trailing, 2)
        }
        .padding(14)
        .background(backgroundColor)
        .cornerRadius(16)
        .task {
            do {
                thumbnailImage = try await photoLibraryStore.requestThumbnail(
                    for: viewModel.thumbnailPHAsset,
                    targetSize: .init(width: Metric.imageSize, height: Metric.imageSize)
                )
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ClusterCell(viewModel: .stub(), backgroundColor: ColorPalette.primary)
}
