//
//  PermissionEmptyView.swift
//  Chac
//
//  Created by 이원빈 on 2/5/26.
//

import SwiftUI

struct PermissionEmptyView: View {
    
    private enum Strings {
        static let noPermissionMessage = "앨범을 생성하려면\n사진 접근 권한이 필요해요."
        static let goToSetting = "설정으로 이동"
    }
    
    private enum Metric {
        static let topMargin = ScreenSize.height / 4
    }
    
    @EnvironmentObject private var permissionManager: DefaultPhotoLibraryPermissionManager
    
    var body: some View {
        VStack(spacing: 0) {
            Text(Strings.noPermissionMessage)
                .multilineTextAlignment(.center)
                .chacFont(.body)
                .foregroundStyle(ColorPalette.text_03)
                .padding(.top, Metric.topMargin)
            
            moveButton(
                title: Strings.goToSetting,
                titleColor: ColorPalette.text_btn_01,
                backgroundColor: ColorPalette.primary
            ) {
                permissionManager.openSettings()
            }
            .frame(width: 156)
            .padding(.top, 40)
            
            Spacer()
        }
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
    PermissionEmptyView()
        .environmentObject(DefaultPhotoLibraryPermissionManager())
}
