import SwiftUI

struct BalanceView: View {
    var body: some View {
        VStack(spacing: 8) {
            // Assets section with rounded top corners
            HStack {
                Image(systemName: "plus.circle")
                Text("Assets")
                Spacer()
            }
            .foregroundColor(Color("AssetsUnselected"))
            .padding()
            .frame(maxWidth: .infinity)
//            .overlay(
//                UnevenRoundedRectangle(cornerRadii: .init(topLeading: 16,
//                                                          bottomLeading: 0,
//                                                          bottomTrailing: 0,
//                                                          topTrailing: 16),
//                                       style: .continuous)
//                .stroke(.green, lineWidth: 1)
//            )
            
            // Liabilities section with no rounded corners
            HStack {
                Image(systemName: "minus.circle")
                Text("Liabilities")
                Spacer()
            }
            .foregroundColor(Color("LiabilitiesUnselected"))
            .padding()
            .frame(maxWidth: .infinity)
//            .overlay(
//                Rectangle()
//                    .stroke(.red, lineWidth: 1)
//            )
            
            // Equity section with rounded bottom corners
            HStack {
                Image(systemName: "equal.square")
                Text("Equity")
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
//            .overlay(
//                UnevenRoundedRectangle(cornerRadii: .init(topLeading: 0,
//                                                          bottomLeading: 16,
//                                                          bottomTrailing: 16,
//                                                          topTrailing: 0),
//                                       style: .continuous)
//                .stroke(.primary, lineWidth: 1)
//            )
        }
        .padding()
    }
}

struct RoundedCornerShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    BalanceView()
}
