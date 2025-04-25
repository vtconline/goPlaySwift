import SwiftUI

public struct PhoneLoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    
    @State private var phoneNumber = ""  // Store the phone number
    @State private var otp = ""  // Store the OTP
    @State private var otpButtonText = "Get OTP"  // Text for OTP button
    @State private var isOtpSent = false  // Track OTP sent status
    @State private var alertMessage = ""  // Alert message
    @State private var isLoading = false  // Loading state for API calls
    
    @StateObject private var phoneNumberValidator = PhoneValidator()  // Validator for phone number
    @StateObject private var otpValidator = OTPValidator()  // Validator for OTP
    
    @State private var checkPhoneDone = true
    
    public init() {}
    var spaceOriented: CGFloat {
        // Dynamically set space based on the device orientation
        return DeviceOrientation.shared.isLandscape ? 10 : 20
    }
    
    
    public var body: some View {
        
        VStack(alignment: .center, spacing: spaceOriented) {
            HStack {
                GoBackButton(text:"Quay lại")
                Spacer()
                
                Text("Phone Login")
                    .font(DeviceOrientation.shared.isLandscape ? .title : .largeTitle )
                    .foregroundColor(.gray)
//                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
                GoBackButton(text:"Quay lại").hidden()
            }
            
            
            // Phone Number GoTextField
            GoTextField<PhoneValidator>(text: $phoneNumber, placeholder: "Nhập số điện thoại", isPwd: false, validator: phoneNumberValidator, leftIconName: "images/ic_phone", isSystemIcon: false)
                .keyboardType(.phonePad)
                .padding(.horizontal, 16)
            
            
            
            
            // OTP GoTextField with Get OTP Button
            if(checkPhoneDone){
                HStack {
                    GoTextField<OTPValidator>(text: $otp, placeholder: "Enter OTP", isPwd: false, validator: otpValidator, leftIconName: "images/ic_lock_focused",
                                              isSystemIcon: false)
                    .keyboardType(.numberPad)
                    .padding(.trailing, 16)
                    
                    Button(action: getOtp) {
                        Image(systemName: "paperplane.fill") // You can use any icon for the OTP button
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
                .frame(width: min(UIScreen.main.bounds.width - 32, 300))
            }
            
            // Submit Button to verify phone and OTP
            GoButton(text: "ĐĂNG NHẬP SĐT", action: submitPhoneLogin)
            
            HStack(alignment: .center) {
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                
                Text("hoặc")
                    .foregroundColor(.gray)
                    .padding(.horizontal, 8)
                
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 0)
            .padding(.horizontal, 32)
            
            
            // Navigation to GoIdAuthenView
            if(DeviceOrientation.shared.isLandscape == false){
                GoNavigationLink(
                    text: "ĐĂNG NHẬP GOID",
                    destination: GoIdAuthenView(),
                    assetImageName: "images/logo_goplay",
                    
                    imageSize: CGSize(width: 28, height: 28),
                    font: .system(size: 16, weight: .semibold),
                    textColor: .white,
                    backgroundColor: AppTheme.Colors.secondary
                )
            }
            
            
            // Login with Gmail Button
            ResponsiveView(portraitView: socialViewPortraid(), landscapeView: socialViewLandscape())
            
            Spacer()
        }
        .padding()
        .navigationBarHidden(true) // hide navigaotr bar at top (backbtn,..etc)
        .observeOrientation() // Apply the modifier to detect orientation changes
        
    }
    
    func socialViewPortraid() -> some View {
        VStack {
            GoButton(
                text: "Login with Google",
                color: .white,
                borderColor: .black,
                textColor: .black,
                
                iconName: "images/google_icon",
                isSystemIcon: false,
                iconSize: 24,
                action: loginWithGmail
            )
            
            GoButton(
                text: "Login with Apple",
                color: AppTheme.Colors.apple,
                textColor: .white,
                iconSysColor: .white,
                iconName: "apple.logo",
                iconPadding: EdgeInsets(top: 0, leading: 0, bottom: 6, trailing: 0),
                action: loginWithGmail
            )
            
            
            GoButton(
                color: .white,
                borderColor: .black,
                width: 60,
                action: loginGuest
                
            ){
                ZStack {
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                    
                    VStack {
                        Spacer()
                        Text("Login nhanh")
                            .font(.caption)
                            .foregroundColor(.black)
                        //                            .bold()
                            .shadow(radius: 1)
                            .padding(.top, 22)
                    }
                    .frame(width: 40,height: 24)
                }
                
            }
            
        }
    }
    
    func socialViewLandscape() -> some View {
        HStack {
            Spacer()
            GoNavigationLink(
                text: "",
                destination: GoIdAuthenView(),
                assetImageName: "images/logo_goplay",
                width: 60,
                imageSize: CGSize(width: 24, height: 24),
                font: .system(size: 16, weight: .semibold),
                textColor: .white,
                backgroundColor: AppTheme.Colors.secondary
            )
            GoButton(
                text: "",
                color: .white,
                borderColor: .black,
                textColor: .black,
                width: 60,
                iconName: "images/google_icon",
                isSystemIcon: false,
                iconSize: 24,
                action: loginWithGmail
            )
            
            GoButton(
                text: "",
                color: AppTheme.Colors.apple,
                textColor: .white,
                iconSysColor: .white,
                width: 60,
                iconName: "apple.logo",
                iconPadding: EdgeInsets(top: 0, leading: 0, bottom: 6, trailing: 0),
                action: loginWithGmail
            )
            GoButton(
                color: .white,
                borderColor: .black,
                width: 60,
                action: loginGuest
                
            ){
                ZStack {
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                    
                    VStack {
                        Spacer()
                        Text("Guest")
                            .font(.caption)
                            .foregroundColor(.black)
                        //                            .bold()
                            .shadow(radius: 1)
                            .padding(.top, 22)
                    }
                    .frame(width: 40,height: 24)
                }
                
            }
            Spacer()
        }
        
    }
    
    // Function to call the API to get OTP
    private func getOtp() {
        guard !phoneNumber.isEmpty else {
            alertMessage = "Phone number is required."
            return
        }
        
        isLoading = true
        otpButtonText = "Sending..."
        
        // Call API for OTP (dummy code, replace with actual API)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            isOtpSent = true
            otpButtonText = "OTP Sent!"
            alertMessage = "OTP has been sent to your phone number."
        }
    }
    
    // Function to submit phone number and OTP for verification
    private func submitPhoneLogin() {
        //        guard !phoneNumber.isEmpty, !otp.isEmpty else {
        //            alertMessage = "Please enter both phone number and OTP."
        //            return
        //        }
        
        LoadingDialog.instance.show();
        isLoading = true
        
        // Call API for phone number and OTP verification (dummy code, replace with actual API)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            alertMessage = "Phone number and OTP verified. Logging in..."
            // Continue with login process
            LoadingDialog.instance.hide();
        }
    }
    private func loginGuest() {
        // Trigger Gmail login logic here
        alertMessage = "loginGuest triggered."
    }
    // Function for Gmail login (dummy)
    private func loginWithGmail() {
        // Trigger Gmail login logic here
        alertMessage = "Login with Gmail triggered."
    }
    
    // Function for Apple login (dummy)
    private func loginWithApple() {
        // Trigger Apple login logic here
        alertMessage = "Login with Apple triggered."
    }
}
