import SwiftUI
/**
 sample1
 GoButton(
 color:AppTheme.Colors.secondary,
 action: {
 print("Button tapped!")
 }
 ) {
 HStack {
 Image(systemName: "arrow.right.circle.fill")
 .resizable()
 .scaledToFit()
 .frame(width: 20, height: 20)
 
 Text("Login with Google")
 .font(.headline)
 }
 }
 
 sample1
 GoButton(
 text: "Login with Google",
 iconName: "arrow.right.circle.fill",
 action: {
 print("Button tapped!")
 }
 )
 */
import SwiftUI

public struct GoButton<Content: View>: View {
    let color: Color
    let borderColor: Color?
    let width: CGFloat?
    //    let fontSize: CGFloat
    //    let textColor: Color
    let action: (() -> Void)?
    let content: () -> Content
    
    private var paddingHorizontal: CGFloat = 16
    
    public init(
        color: Color = AppTheme.Colors.primary,
        borderColor: Color? = nil,
        //        textColor: Color = .white,
        //        fontSize: CGFloat = 19,
        width: CGFloat? = nil,
        action: (() -> Void)? = nil,
        content: @escaping () -> Content
    ) {
        self.color = color
        //        self.textColor = textColor
        //        self.fontSize = fontSize
        self.width = width
        self.action = action
        self.content = content
        self.borderColor = borderColor
    }
    
    public var body: some View {
        Button(action: {
            action?()
        }) {
            content()
                .padding()
                .frame(
                    maxWidth: width ?? min(
                        UIScreen.main.bounds.width - 2 * paddingHorizontal,
                        300
                    )
                )
            //                .foregroundColor(textColor)
                .background(color)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(borderColor ?? Color.clear, lineWidth: borderColor != nil ? 1 : 0)
                )
        }
        .contentShape(Rectangle())
    }
}

// MARK: - Convenience initializer for text + icon fallback using AnyView

public extension GoButton where Content == AnyView {
    init(
        text: String,
        color: Color = AppTheme.Colors.primary,
        borderColor: Color? = nil,
        textColor: Color = .white,
        iconSysColor: Color = .white,
        fontSize: CGFloat = 19,
        width: CGFloat? = nil,
        iconName: String? = nil,
        isSystemIcon: Bool = true,
        iconSize:CGFloat = 19,
        iconPadding: EdgeInsets = EdgeInsets(),
        action: (() -> Void)? = nil
    ) {
        self.init(color: color, borderColor: borderColor,width: width, action: action) {
            AnyView(
                HStack {
                    if isSystemIcon {
                        if let iconName = iconName {
                            Image(systemName: iconName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: iconSize, height: iconSize)
                                .foregroundColor(iconSysColor)
                                .clipped()
                                .padding(iconPadding)
                        }
                    } else {
                        if let icon = iconName,
                           let image = UIImage(named: icon, in: Bundle.module, compatibleWith: nil) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: iconSize, height: iconSize)
                                .clipped()
                                .padding(iconPadding)
                        }
                    }
                    
                    if(!text.isEmpty){
                        Text(text)
                            .font(Font.copyWith(size: fontSize))
                            .foregroundColor(textColor)
                    }
                }
            )
        }
    }
}
