
import SwiftUI

struct CircularProgressView: View {
    let progressColors: [UIColor] = [.systemRed, .systemRed, .systemOrange, .systemYellow, .systemGreen]
    var progress: Decimal
    var color: Color
    
    init(progress: Decimal) {
        self.progress = progress
        self.color = Color(progressColors.intermediate(percentage: progress.doubleValue))
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 7)
                .foregroundColor(Color.gray)
                .opacity(0.25)
            Circle()
                .trim(from: 0, to: min(progress, 1.0).doubleValue)
                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270))
            if progress == 1.0 {
                Image(systemName: "checkmark")
                    .foregroundColor(Color.primary)
            } else {
                Text("\(progress * 100)%")
                    .font(.footnote)
                    .foregroundColor(Color.primary)
            }
        }
    }
}
