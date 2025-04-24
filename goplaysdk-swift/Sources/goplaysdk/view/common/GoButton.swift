//
//  GoButton.swift
//  goplaysdk
//
//  Created by Ngô Đồng on 24/4/25.
//
import SwiftUI

public struct GoButton: View {
    let text: String
    let color: Color
    let width: CGFloat?
    let iconName: String?
    let isSystemIcon: Bool
    let action: (() -> Void)?
    
    private var paddingHorizontal: CGFloat = 16
    
    private var scaleFactor: CGFloat {
        return 1
        //        return UIScreen.main.scale
    }

    public init(
        text: String,
        color: Color = AppTheme.Colors.primary,
        width: CGFloat? = nil,
        iconName: String? = nil,
        isSystemIcon: Bool = true,
        action: (() -> Void)? = nil
    ) {
        self.text = text
        self.color = color
        self.width = width
        self.iconName = iconName
        self.isSystemIcon = isSystemIcon
        self.action = action
    }

    public var body: some View {
        Button(action: {
            action?()
        }) {
            HStack {
                if let iconName = iconName {
                    (isSystemIcon ? Image(systemName: iconName) : Image(iconName))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }

                Text(text)
                    .font(.headline)
            }
            .padding()
            .frame(maxWidth: width ?? min(UIScreen.main.bounds.width - 2*paddingHorizontal, 300))
            .foregroundColor(.white)
            .background(color)
            .cornerRadius(10)
        }
    }
}

