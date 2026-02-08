//
//  PhotoSaveView.swift
//  Chac
//
//  Created by 가은 on 1/15/26.
//

import SwiftUI

struct PhotoSaveView: View {
    
    private enum Strings {
        static let completeSave = "저장 완료"
        static let moveToPhotoList = "메인으로"
        static let photoCountFormat = "총 %d장의 사진이 포함된 앨범을 \n갤러리에 저장했어요!"
    }
    
    private enum Metric {
        static let topMargin = ScreenSize.height / 9.75
    }
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var permissionManager: DefaultPhotoLibraryPermissionManager
    
    @Binding var savedCount: Int
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button {
                    dismiss()
                    coordinator.popToRoot()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(ColorPalette.text_01)
                }
            }
            .padding(.vertical, 14)
            
            Image("save_complete_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 117)
                .padding(.top, Metric.topMargin)
            
            Text(Strings.completeSave)
                .chacFont(.headline_02)
                .foregroundStyle(ColorPalette.text_01)
                .padding(.top, 26)
            
            Text(String(format: Strings.photoCountFormat, savedCount))
                .multilineTextAlignment(.center)
                .chacFont(.body)
                .foregroundStyle(ColorPalette.text_03)
                .padding(.top, 10)
            
            Spacer()
            Spacer()
            
            moveButton(
                title: Strings.moveToPhotoList,
                titleColor: ColorPalette.text_btn_01,
                backgroundColor: ColorPalette.primary
            ) {
                dismiss()
                coordinator.popToRoot()
            }
        }
        .padding(.horizontal, 20)
        .background(ColorPalette.background)
    }
    
    @ViewBuilder
    private func moveButton(title: String, titleColor: Color, backgroundColor: Color, action: @escaping () -> Void) -> some View { // TODO: 공통 컴포넌트로 분리
        Button(action: action) {
            Text(title)
                .chacFont(.btn)
                .foregroundStyle(titleColor)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(RoundedRectangle(cornerRadius: 12).fill(backgroundColor))
        }
    }
}

#Preview {
    PhotoSaveView(savedCount: .constant(5))
}
