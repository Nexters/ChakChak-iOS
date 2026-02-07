//
//  ClusterCell.swift
//  Chac
//
//  Created by 이원빈 on 1/13/26.
//

import SwiftUI
import CoreLocation

struct ClusterCell: View {
    
    private enum Strings {
        static let organizeButtonTitle = "정리하기"
    }
    
    private enum Metric {
        static let imageSize: CGFloat = 90
        static let downloadIconSize: CGFloat = 14
    }
    
    @EnvironmentObject private var photoLibraryStore: PhotoLibraryStore
    @State private var thumbnailImage: UIImage? = nil
    
    let viewModel: ClusterCellModel
    let backgroundColor: Color
    let onOrganizeTap: () -> Void
    let onSaveTap: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            Image(uiImage: thumbnailImage ?? UIImage(named: "cluster_icon")!)
                .resizable()
                .scaledToFill()
                .frame(width: Metric.imageSize, height: Metric.imageSize)
                .cornerRadius(12)
                .clipped()
                .overlay(alignment: .bottomTrailing) {
                    Text("+\(viewModel.photoCount)")
                        .chacFont(.sub_number)
                        .foregroundStyle(ColorPalette.text_btn_01)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(ColorPalette.black_70)
                        .cornerRadius(1000)
                        .padding(.trailing, 6)
                        .padding(.bottom, 6)
                }
            
            VStack(alignment: .leading) {
                Text(viewModel.title)
                    .chacFont(.content_title)
                    .foregroundStyle(ColorPalette.text_01)
                Spacer()
                HStack {
                    Button(action: onSaveTap) {
                        Circle()
                            .foregroundStyle(Color.white.opacity(0.4))
                            .frame(width: 40, height: 40)
                            .overlay {
                                Image("download_icon")
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: Metric.downloadIconSize, height: Metric.downloadIconSize)
                                    .foregroundStyle(ColorPalette.text_btn_01)
                            }
                    }
                    Button(action: onOrganizeTap) {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(Color.white.opacity(0.8))
                            .frame(height: 40)
                            .frame(maxWidth: .infinity)
                            .overlay {
                                HStack(spacing: 8) {
                                    Text(Strings.organizeButtonTitle)
                                        .chacFont(.sub_btn)
                                        .foregroundStyle(ColorPalette.text_btn_02)
                                    Image("vector_icon")
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 4.5, height: 9)
                                        .foregroundStyle(ColorPalette.text_btn_02)
                                }
                            }
                    }
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 22)
        }
        .frame(height: 130)
        .padding(.horizontal, 20)
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
    ClusterCell(viewModel: .stub(), backgroundColor: ColorPalette.primary, onOrganizeTap: {}, onSaveTap: {})
}
