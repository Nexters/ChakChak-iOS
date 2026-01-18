//
//  MainView.swift
//  Chac
//
//  Created by 이원빈 on 1/13/26.
//


import SwiftUI

struct MainView: View {
    
    private enum Strings {
        static let allPhotos = "모든 사진"
        static let createAlbum = "앨범 생성"
    }
    
    private enum Metric {
        static let cornerRadius: CGFloat = 4
        static let horizontalPadding: CGFloat = 20
        static let createAlbumIconSize: CGFloat = 16
    }
    
    @EnvironmentObject private var coordinator: NavigationCoordinator

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("로고/서비스 네임")
                Spacer()
                Button {
                    // TODO: 설정 화면으로 이동
                } label: {
                    Image("setting_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
            }
            .frame(height: 52)
            .padding(.horizontal, Metric.horizontalPadding)

            HStack {
                Text(Strings.allPhotos)
                Spacer()
                Text("99,990") // TODO: 실제 데이터 갯수 주입
            }
            .padding(.horizontal, Metric.horizontalPadding)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(ColorPalette.gray)
            .cornerRadius(Metric.cornerRadius)
            .padding(.top, 12)
            .padding(.horizontal, Metric.horizontalPadding)
            
            HStack {
                Image("create_album_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: Metric.createAlbumIconSize, height: Metric.createAlbumIconSize)
                Text(Strings.createAlbum)
                Spacer()
            }
            .padding(.top, 28)
            .padding(.horizontal, Metric.horizontalPadding)
            
            ScrollView {
                VStack {
                    ForEach(0..<3) { _ in
                        ClusterCell(
                            onOrganizeTap: { coordinator.push(.next) },
                            onSaveTap: { } // TODO: 그대로 저장 액션 수행
                        )
                    }
                    
                    LoadingView()
                }
                .padding(.horizontal, Metric.horizontalPadding)
            }
            .padding(.top, 15)
        }
    }
}

#Preview {
    NavigationStack{
        MainView()
            .environmentObject(NavigationCoordinator())
    }
}
