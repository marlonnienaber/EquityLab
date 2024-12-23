import SwiftUI

struct CurrencyInputView<Content: View>: View {
    @Binding var value: Decimal
    @ViewBuilder var customContent: () -> Content
    
    var body: some View {
        HStack {
            customContent()
            Spacer()
            CurrencyInputField(value: $value)
                .padding(6)
        }
    }
}
