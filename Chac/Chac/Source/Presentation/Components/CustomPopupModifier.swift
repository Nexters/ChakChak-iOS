//
//  CustomPopupModifier.swift
//  Chac
//
//  Created by 가은 on 2/4/26.
//

import SwiftUI

struct CustomPopupModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let explaination: String
    let okAction: () -> Void

    func body(content: Content) -> some View {
        ZStack {
            content // 기존 메인 뷰

            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                VStack {
                    Image("exclamation_icon")
                    Text(title)
                        .padding(.top, 16)
                    Text(explaination)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 10)
                    
                    HStack(spacing: 8) {
                        Button {
                            isPresented = false
                        } label: {
                            Text("취소")
                                .frame(height: 54)
                                .frame(maxWidth: .infinity)
                                .background()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        Button {
                            okAction()
                            isPresented = false
                        } label: {
                            Text("확인")
                                .frame(height: 54)
                                .frame(maxWidth: .infinity)
                                .background()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                    }
                    .padding(.top, 20)
                }
                .padding(20)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(24)
            }
        }
        .animation(.easeIn(duration: 0.25), value: isPresented)
    }
}

extension View {
    func customPopup(
        isPresented: Binding<Bool>,
        title: String,
        explaination: String,
        action: @escaping () -> Void
    ) -> some View {
        self.modifier(CustomPopupModifier(isPresented: isPresented, title: title, explaination: explaination, okAction: action))
    }
}

#Preview {
    EmptyView()
        .customPopup(isPresented: .constant(true), title: "페이지 나가기", explaination: "선택된 내용은 저장되지 않습니다.\n페이지를 나가겠어요?") {
            
        }
}
