//
//  ProcessingView.swift
//  Chac
//
//  Created by 이원빈 on 2/6/26.
//

import SwiftUI

struct ProcessingView: View {
    
    private enum Metric {
        static let circleSpacing: CGFloat = 4
        static let defaultSize: CGFloat = 4
        static let highlightedSize: CGFloat = 6
        static let timerInterval: TimeInterval = 0.3
    }
    
    @State private var highLightedIndex: Int = 0
    @State private var timer: Timer?
    
    var body: some View {
        HStack(spacing: Metric.circleSpacing) {
            makeCircle(index: 0)
            makeCircle(index: 1)
            makeCircle(index: 2)
        }
        .animation(.easeInOut, value: highLightedIndex)
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    @ViewBuilder
    private func makeCircle(index: Int) -> some View {
        Circle()
            .foregroundStyle(ColorPalette.sub_01)
            .frame(
                width: index == highLightedIndex ? Metric.highlightedSize : Metric.defaultSize,
                height: index == highLightedIndex ? Metric.highlightedSize : Metric.defaultSize
            )
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: Metric.timerInterval, repeats: true) { _ in
            highLightedIndex = (highLightedIndex + 1) % 3
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    ProcessingView()
}
