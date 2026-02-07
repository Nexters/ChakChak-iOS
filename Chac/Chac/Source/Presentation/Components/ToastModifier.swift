//
//  ToastModifier.swift
//  Chac
//
//  Created by 가은 on 2/5/26.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let duration: Double = 2.0

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                VStack {
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Image("toast_icon")
                            .padding(.vertical, 12)
                        Text(message)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .background(Color.black.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.bottom, 30)
                    .padding(.horizontal, 30)
                }
                .transition(.opacity)
                .task {
                    try? await Task.sleep(for: .seconds(duration))
                    withAnimation {
                        isPresented = false
                    }
                }
            }
        }
        .animation(.easeInOut, value: isPresented)
    }
}

extension View {
    func toast(isPresented: Binding<Bool>, message: String) -> some View {
        self.modifier(ToastModifier(isPresented: isPresented, message: message))
    }
}

#Preview {
    EmptyView()
        .toast(isPresented: .constant(true), message: "앨범이 갤러리에 저장되었습니다.")
}
