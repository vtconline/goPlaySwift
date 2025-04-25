import SwiftUI
import Combine

struct GoTextField<Validator: TextFieldValidator>: View {
    @Binding var text: String
    @ObservedObject var validator: Validator // 👈 Use validator binding
    @State private var isPasswordVisible = false
    @Binding var keyBoardFocused: Bool
    var placeholder: String = ""
    var leftIconName: String? = nil
    var isSystemIcon: Bool = true
    var isPwd: Bool = false
    var widthBtn: CGFloat = 300
    private var paddingHorizontal: CGFloat = 16
    private var scaleFactor: CGFloat {
        return 1
        //        return UIScreen.main.scale
    }
    
    public init(text: Binding<String>, placeholder: String = "user name", isPwd: Bool = false, validator: Validator, widthBtn: CGFloat = 300,leftIconName: String? = nil, isSystemIcon: Bool = true, keyBoardFocused: Binding<Bool> = .constant(false)) {
        self._text = text // ✅ Bindings use underscore!
        self.placeholder = placeholder
        self.leftIconName = leftIconName
        self.isSystemIcon = isSystemIcon
        self.validator = validator
        self.isPwd = isPwd
        self.widthBtn = widthBtn
        self._keyBoardFocused = keyBoardFocused // 🟢 Bind the passed in `keyBoardFocused` state
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                // Optional Left Icon (from assets in the main bundle)
                if(isSystemIcon){
                    if let icon = leftIconName{
                        Image(systemName: icon).resizable()
                            .scaledToFit()
                            .frame(width: 48 * scaleFactor, height: 48 * scaleFactor)
                            .clipped()
                    }
                }
                else{
                    if let icon = leftIconName, let image = UIImage(named: icon,in: Bundle.module, compatibleWith: nil) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48 * scaleFactor, height: 48 * scaleFactor)
                            .clipped() // Trims any overflowing content
                        //                        .foregroundColor(.gray)
                        //                        .padding(.leading, 12)
                    }
                }
                
                //                TextField(placeholder, text: $text)
                //                    .padding(.trailing, 12) // only right side
                //                    .padding(.vertical, 12)
                //                    .font(.system(size: 16))
                
                if isPwd && !isPasswordVisible {
                    SecureField(placeholder, text: $text)
                        .font(.system(size: 16))
                        .padding(.vertical, 12)
                        .padding(.trailing, 12)
                        .autocorrectionDisabled(true)
                        .keyboardType(.asciiCapable)
                        .background(UIViewRepresentableFocus(keyBoardFocused: $keyBoardFocused))
                } else {
                    TextField(placeholder, text: $text)
                        .font(.system(size: 16))
                        .padding(.vertical, 12)
                        .padding(.trailing, 12)
                        .autocorrectionDisabled(true)
                        .keyboardType(.asciiCapable)
                        .background(UIViewRepresentableFocus(keyBoardFocused: $keyBoardFocused))
                }
                
                // Right Eye Icon
                if(isPwd){
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 12)
                }
                
            }
//            .frame(width: min(UIScreen.main.bounds.width - 2*paddingHorizontal, widthBtn))
            .frame(maxWidth: widthBtn == nil ? .infinity : widthBtn)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.1), lineWidth: 2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay( // Add border matching the clip shape
                RoundedRectangle(cornerRadius: 12)
                    .stroke(validator.isValid ? Color.gray.opacity(0.1) : Color.red, lineWidth: 2)
            )
            // Optional: Show validation error
            if !validator.isValid {
                Text(validator.errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        // Validate text input on change
        .onChange(of: text) { _ in
            if(!validator.isValid) {
                validator.validate(text: text)
            }
        }
        
    }
    
    
}

// Custom view to manage focus
struct UIViewRepresentableFocus: UIViewRepresentable {
    @Binding var keyBoardFocused: Bool
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if keyBoardFocused {
            uiView.becomeFirstResponder()
        } else {
            uiView.resignFirstResponder()
        }
    }
}
