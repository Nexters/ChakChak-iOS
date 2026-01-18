//
//  PhotoDetailView.swift
//  Chac
//
//  Created by 가은 on 1/16/26.
//

import SwiftUI

struct PhotoDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(.gray)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            
            VStack {
                Spacer()
                
                Image("")
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .aspectRatio(0.8, contentMode: .fit)
                    .background(.gray)
                
                Spacer()
            }
        }
        
    }
}

#Preview {
    PhotoDetailView()
}
