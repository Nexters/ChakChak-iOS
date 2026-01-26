//
//  ClusterCell.swift
//  Chac
//
//  Created by 이원빈 on 1/13/26.
//

import SwiftUI


struct ClusterCell: View {
    
    private enum Strings {
        static let organizeButtonTitle = "사진 정리하기"
        static let saveButtonTitle = "그대로 저장"
    }
    
    private enum Metric {
        static let imageSize: CGFloat = 94
        static let downloadIconSize: CGFloat = 14
    }
    
    @EnvironmentObject private var photoLibraryStore: PhotoLibraryStore
    @State private var thumbnailImage: UIImage? = nil
    
    let viewModel: ClusterCellModel
    let onOrganizeTap: () -> Void
    let onSaveTap: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
                Image(uiImage: thumbnailImage ?? UIImage(named: "cluster_icon")!)
                .resizable()
                .scaledToFit()
                .frame(width: Metric.imageSize, height: Metric.imageSize)
            
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.title)
                    Text("\(viewModel.photoCount)장의 사진")
                }
                VStack {
                    Button(action: onOrganizeTap){
                        Text(Strings.organizeButtonTitle)
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
                            Text(Strings.saveButtonTitle)
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
    ClusterCell(viewModel: .stub(), onOrganizeTap: {}, onSaveTap: {})
}
