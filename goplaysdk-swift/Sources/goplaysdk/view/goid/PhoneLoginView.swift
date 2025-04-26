import SwiftUI

public struct PhoneLoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var navigationManager = NavigationManager()
    
    @State private var phoneNumber = ""  // Store the phone number
    @State private var otp = ""  // Store the OTP
    @State private var otpButtonText = "Get OTP"  // Text for OTP button
    @State private var isOtpSent = false  // Track OTP sent status
    @State private var alertMessage = ""  // Alert message
    @State private var isLoading = false  // Loading state for API calls
    
    @StateObject private var phoneNumberValidator = PhoneValidator()  // Validator for phone number
    @StateObject private var otpValidator = OTPValidator()  // Validator for OTP
    
    @State private var checkPhoneDone = false
    
    
    public init() {}
    var spaceOriented: CGFloat {
        // Dynamically set space based on the device orientation
        return DeviceOrientation.shared.isLandscape ? 10 : 10
    }
    
    
    public var body: some View {
        
        VStack(alignment: .center, spacing: spaceOriented) {
            
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
            
            
            
            
            
            // Login with Gmail Button
            ResponsiveView(portraitView: socialViewPortraid(), landscapeView: socialViewLandscape())
            
            
            Spacer()
        }
        .padding()
        .observeOrientation() // Apply the modifier to detect orientation changes
        .navigateToDestination(navigationManager: navigationManager)  // Using the extension method
        .resetNavigationWhenInActive(navigationManager: navigationManager, scenePhase: scenePhase)
        //        .navigationBarHidden(true) // hide navigaotr bar at top
        .navigationTitle("Đăng nhập với SĐT")
        //                .navigationBarBackButtonHidden(false) // Show back button (default)
        
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Quay lại") // ← Custom back button text
                    }
                }
            }
        }
        
        
    }
    
    func socialViewPortraid() -> some View {
        VStack(spacing: spaceOriented) {
            GoNavigationLink(
                text: "ĐĂNG NHẬP GOID",
                destination: GoIdAuthenView(),
                assetImageName: "images/logo_goplay",
                
                imageSize: CGSize(width: 28, height: 28),
                font: .system(size: 16, weight: .semibold),
                textColor: .white,
                backgroundColor: AppTheme.Colors.secondary
            )
            GoButton(
                text: "Login with Google",
                color: .white,
                borderColor: .gray.opacity(0.75),
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
                text: "Login nhanh",
                color: .white,
                borderColor:.gray,
                textColor: .black,
                iconSysColor: .black,
                
                iconName: "person",
                action: loginGuest
            )
            
            
        }
        .padding(.vertical,0)
        .padding(.horizontal,0)
        
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
                guard !phoneNumber.isEmpty else {
                    alertMessage = "Vui lòng nhập SĐT"
                    AlertDialog.instance.show(message: alertMessage)
                    return
                }
        let validation = phoneNumberValidator.validate(text: phoneNumber);
        if(validation.isValid == false){
            return
        }
        LoadingDialog.instance.show();
        isLoading = true
        
        // Call API for phone number and OTP verification (dummy code, replace with actual API)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            isLoading = false
//            alertMessage = "Phone number and OTP verified. Logging in..."
//            // Continue with login process
//            LoadingDialog.instance.hide();
//        }
        // This would be a sample data payload to send in the POST request
        let bodyData: [String: Any] = [
            "otpname": phoneNumber,
            "loginType": LoginType.phone.rawValue
        ]

        // Now, you can call the `post` method on ApiService
        Task {
            await ApiService.shared.post(path: GoApi.oauthCheckAuthenOtp, body: bodyData) { result in
                        DispatchQueue.main.async {
                         
                            LoadingDialog.instance.hide();
                        }
                
                switch result {
                case .success(let data):
                    // Handle successful response

                    // Parse the response if necessary
                    if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []),
                       let responseDict = jsonResponse as? [String: Any] {
//                        print("submitPhoneLogin Response: \(responseDict)")
                        checkPhoneNumberResponse(response: responseDict)
                    }
                    
                case .failure(let error):
                    // Handle failure response
                    print("Error: \(error.localizedDescription)")
                }
            }
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
    
    
    func checkPhoneNumberResponse(response: [String: Any]) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
            let apiResponse =  try JSONDecoder().decode(CheckAuthenOtp.self, from: jsonData)
            

//            print("apiResponse isSuccessed: \(apiResponse.isSuccessed)")

            var message = "Lỗi sđt"
            var haveError = true

            if apiResponse.isSuccessed {
                
                let listUser = apiResponse.data

                if !listUser.isEmpty {
                    haveError = false

                    if listUser.count == 1 {
                        let userInfo = listUser[0]
                        print("userInfo.accountType = \(userInfo.accountType)")

                        if userInfo.accountType == AccountType.goId.rawValue {
                            var msg = "SĐT \(userInfo.mobile) khai báo cho tài khoản \(userInfo.accountName). Hãy đăng nhập bằng tài khoản và mật khẩu goID!"
                            if userInfo.confirmCode == ConfirmCode.emailActive.rawValue || userInfo.confirmCode == ConfirmCode.emailAndPhoneActive.rawValue {
                                msg = "SĐT \(userInfo.mobile) đã kích hoạt cho tài khoản \(userInfo.accountName). Hãy đăng nhập bằng mật khẩu goID!"
                            }
                            AlertDialog.instance.show(message: msg, onOk: {
                                print("User navigateToGoIDView confirmed")
                                navigationManager.navigate(to: NavigationDestination.goIdAuthenView)
                            })//,navigatorView:GoIdAuthenView()

                            /*DialogManager.showPositiveDialog(
                                context: mContext,
                                title: "Thông báo",
                                message: msg
                            ) { dialog in
                                dialog.dismiss(animated: true)
                                self.showLoginType(.phone)
                            }*/

                        } else {
//                            self.otpView.isHidden = false
//                            self.btnLoginPhone.isHidden = true
                        }
                    } else {
                        let msg = "Bạn có \(apiResponse.userCount) tài khoản kích hoạt bằng SĐT \(listUser.first?.mobile ?? ""). Hãy đăng nhập bằng tài khoản và mật khẩu goID!"
                  
                        AlertDialog.instance.show(message: msg)

//                        DialogManager.showPositiveDialog(
//                            context: mContext,
//                            title: "Thông báo",
//                            message: msg
//                        ) { dialog in
//                            dialog.dismiss(animated: true)
//                        }
                    }
                } else {
                    // Chưa có tài khoản nào gắn với số điện thoại
//                    self.otpView.isHidden = false
                }
            } else {
                message = apiResponse.message
            }

            if haveError {
                AlertDialog.instance.show(message: message)
//                DialogManager.showPositiveDialog(
//                    context: mContext,
//                    title: NSLocalizedString("title_login_err", comment: ""),
//                    message: message
//                ) { dialog in
//                    dialog.dismiss(animated: true)
//                }
            }

        } catch {
            print("Parsing or network error: \(error.localizedDescription)")
        }
    }
}
