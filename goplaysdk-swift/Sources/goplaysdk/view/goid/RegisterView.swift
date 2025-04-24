//
//  RegisterView.swift
//  goplaysdk
//
//  Created by Ngô Đồng on 24/4/25.
//

import SwiftUI

public struct RegisterView: View {
    public var body: some View {
        HStack {
            Spacer()
            Text("RegisterView")
//                .font(.title)
                .font(.system(size: 32)) // 👈 Set specific font size
                .bold()
                
            Spacer()
        }
        .padding()
        .background(AppTheme.Colors.primary)
        .foregroundColor(.white)
    }
    
    public init() {}
}
