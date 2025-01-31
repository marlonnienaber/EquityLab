import SwiftUI

struct Collapsible<Content: View>: View {
    @State private var isExpanded: Bool = false
    let labelText: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack {
            if isExpanded {
                header
                    .padding(.top, 5)
                Divider()
                    .padding(.vertical, 7)
                corpus
                    .padding(.bottom, 7)
            } else {
                header
                    .padding(.vertical, 5)
            }
        }
    }
    
    private var header: some View {
        Button {
            isExpanded.toggle()
        } label: {
            HStack {
                Text(labelText)
                    .font(.footnote)
                Spacer()
                Image(systemName: "chevron.right")
                    .rotationEffect(.degrees(isExpanded ? 90 : 0))
            }
            .frame(height: 20)
        }
        .buttonStyle(.plain)
    }
    
    private var corpus: some View {
        content()
    }
}
