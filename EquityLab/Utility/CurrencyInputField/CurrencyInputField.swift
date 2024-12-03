
import UIKit
import SwiftUI

struct CurrencyInputField: View {
    @Binding var value: Decimal
    @State private var isSelected = false

    var body: some View {
        CurrencyUITextFieldRepresentable(value: $value, isSelected: $isSelected)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(isSelected ? Color.primary : Color.gray.opacity(0.3), lineWidth: 2))
            .frame(width: 165, height: 35)
    }
}

struct CurrencyUITextFieldRepresentable: UIViewRepresentable {
    @Binding var value: Decimal
    @Binding var isSelected: Bool
    
    func makeUIView(context: Context) -> CurrencyUITextField {
        let currencyUITextField = CurrencyUITextField()
        currencyUITextField.currencyDelegate = context.coordinator
        currencyUITextField.delegate = context.coordinator
        currencyUITextField.setText(using: value)
        return currencyUITextField
    }
    
    func updateUIView(_ uiView: CurrencyUITextField, context: Context) {
        if uiView.text?.containedDecimal != value {
            uiView.setText(using: value)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, CurrencyUITextFieldDelegate, UITextFieldDelegate {
        var parent: CurrencyUITextFieldRepresentable
        
        init(parent: CurrencyUITextFieldRepresentable) {
            self.parent = parent
        }
        
        func currencyUITextField(_ textField: CurrencyUITextField, didChangeValue value: Decimal) {
            DispatchQueue.main.async {
                self.parent.value = value
            }
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let currencyUITextField = textField as? CurrencyUITextField else { return true }
            let currentText = currencyUITextField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            let digits = newText.containedDigits
            return digits.count <= 12
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async { [weak self] in
                self?.parent.isSelected = true
            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            DispatchQueue.main.async { [weak self] in
                self?.parent.isSelected = false
            }
        }
    }
}

class CurrencyUITextField: UITextField {
    private let formatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    weak var currencyDelegate: CurrencyUITextFieldDelegate?
    
    init() {
        super.init(frame: .zero)
        tintColor = .clear
        font = .systemFont(ofSize: 14, weight: .regular)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        addTarget(self, action: #selector(handleEditing), for: .editingChanged)
        keyboardType = .numberPad
        textAlignment = .right
        sendActions(for: .editingChanged)
    }
    
    /// Disable text selection actions
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    /// Prevent cursor movement
    override var selectedTextRange: UITextRange? {
        get {
            return textRange(from: endOfDocument, to: endOfDocument)
        }
        set {}
    }

    /// is called whenever the text of the UITextField changes
    @objc private func handleEditing() {
        text = getCurrencyString(from: text)
        let value: Decimal
        if let unwrappedText = text {
            value = unwrappedText.containedDecimal / 100
        } else {
            value = 0
        }
        currencyDelegate?.currencyUITextField(self, didChangeValue: value)
    }
    
    /// deletes last digit whenever delete is pressed
    override func deleteBackward() {
        if let unwrappedText = text {
            text = unwrappedText.containedDigits.dropLast().string
        } else {
            text = ""
        }
        sendActions(for: .editingChanged)
    }
    
    /// formats the text parameter (designed for text property of UITextField) to a localized string representing  a currency amount
    private func getCurrencyString(from text: String?) -> String {
        let text = text ?? ""
        let decimal = text.containedDecimal / 100
        return formatter.string(for: decimal) ?? ""
    }
    
    /// formats the value parameter (designed for value property of CurrencyUITextFieldRepresentable) to a localized string representing  a currency amount
    func setText(using value: Decimal) {
        let textValue = formatter.string(from: value.nsDecimalNumberValue) ?? ""
        text = textValue
    }
    
    /// adds horizontal padding
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20, dy: 0)
    }
    
    /// adds horizontal padding
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20, dy: 0)
    }
}

protocol CurrencyUITextFieldDelegate: AnyObject {
    func currencyUITextField(_ textField: CurrencyUITextField, didChangeValue value: Decimal)
}

extension String {
    /// returns only the contained digits in the string while preserving their sequence
    var containedDigits: String { filter(\.isWholeNumber) }
    
    /// converts the integer string number returned by containedDigits into a Decimal
    var containedDecimal: Decimal { Decimal(string: containedDigits) ?? 0 }
}

extension LosslessStringConvertible {
    /// convenience property returning the String representation for types which can be converted to String with the init String(from: type)
    var string: String { .init(self) }
}
