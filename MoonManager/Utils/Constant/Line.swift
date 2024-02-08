//
//  Line.swift
//  MoonManager
//
//  Created by YEON HWANGBO on 2/6/24.
//

import SwiftUI

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

struct DashedLine: View {
    var lineWidth: CGFloat
    var dash: [CGFloat]
    var height: CGFloat
    
    init(
        lineWidth: CGFloat = 1,
        dash: [CGFloat] = [5],
        height: CGFloat = 1
    ) {
        self.lineWidth = lineWidth
        self.dash = dash
        self.height = height
    }
    
    var body: some View {
        VStack {
            Line()
                .stroke(style: StrokeStyle(lineWidth: lineWidth, dash: dash))
                .frame(height: height)
        }
    }
}
