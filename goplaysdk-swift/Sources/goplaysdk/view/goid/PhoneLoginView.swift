import SwiftUI

public struct PhoneLoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var phoneNumber = ""  // Store the phone number
    @State private var otp = ""  // Store the OTP
    @State private var otpButtonText = "Get OTP"  // Text for OTP button
    @State private var isOtpSent = false  // Track OTP sent status
    @State private var alertMessage = ""  // Alert message
    @State private var isLoading = false  // Loading state for API calls

    @StateObject private var phoneNumberValidator = PhoneValidator()  // Validator for phone number
    @StateObject private var otpValidator = OTPValidator()  // Validator for OTP

    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 20) {
                Text("Phone Login")
                    .font(.largeTitle)
                    .foregroundColor(.gray)

                // Phone Number GoTextField
                GoTextField<PhoneValidator>(text: $phoneNumber, placeholder: "Enter Phone Number", isPwd: false, validator: phoneNumberValidator, leftIconName: "phone.fill", isSystemIcon: true)
                    .keyboardType(.phonePad)
                    .padding(.horizontal, 16)
                
                // OTP GoTextField with Get OTP Button
                HStack {
                    GoTextField<OTPValidator>(text: $otp, placeholder: "Enter OTP", isPwd: false, validator: otpValidator, leftIconName: "lock.fill", isSystemIcon: true)
                        .keyboardType(.numberPad)
                        .padding(.horizontal, 16)
                    
                    Button(action: getOtp) {
                        Image(systemName: "paperplane.fill") // You can use any icon for the OTP button
                            .foregroundColor(.blue)
                            .padding()
                    }
                }

                // Submit Button to verify phone and OTP
                Button(action: submitPhoneLogin) {
                    Text("Verify and Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(isLoading ? Color.gray : Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                        .disabled(isLoading)
                }

                // Navigation to GoIdAuthenView
                NavigationLink(destination: GoIdAuthenView()) {
                    Text("Back to Login")
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                }

                // Login with Gmail Button
                Button(action: loginWithGmail) {
                    Text("Login with Gmail")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                }

                // Login with Apple Button
                Button(action: loginWithApple) {
                    Text("Login with Apple")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                }

                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
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
        guard !phoneNumber.isEmpty, !otp.isEmpty else {
            alertMessage = "Please enter both phone number and OTP."
            return
        }
        
        isLoading = true
        
        // Call API for phone number and OTP verification (dummy code, replace with actual API)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            alertMessage = "Phone number and OTP verified. Logging in..."
            // Continue with login process
        }
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
