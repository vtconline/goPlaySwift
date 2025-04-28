
import SwiftUI
//0394253555
public struct SocialLoginGroupView: View {
    private var haveGoIdLogin: Bool = false
    public init(haveGoIdLogin: Bool ) {
        self.haveGoIdLogin = haveGoIdLogin
    }
    var spaceOriented: CGFloat {
        // Dynamically set space based on the device orientation
        return DeviceOrientation.shared.isLandscape ? 10 : 10
    }
    
    
    public var body: some View {
        ResponsiveView(portraitView: socialViewPortraid(), landscapeView: socialViewLandscape())
    }
    
    
    func socialViewPortraid() -> some View {
        VStack(spacing: spaceOriented) {
            if haveGoIdLogin {
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
                action: loginWithApple
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
            if haveGoIdLogin {
                GoNavigationLink(
                    text: "",
                    destination: GoIdAuthenView(),
                    assetImageName: "images/logo_goplay",
                    width: 60,
                    imageSize: CGSize(width: 18, height: 18),
                    font: .system(size: 16, weight: .semibold),
                    textColor: .white,
                    backgroundColor: AppTheme.Colors.secondary
                )
            }
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
                action: loginWithApple
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
    private func loginGuest() {
        LoadingDialog.instance.show();
       
        // This would be a sample data payload to send in the POST request
        let bodyData: [String: Any] = [
            "email": GoPlayUUID.shared.userUUID,
        ]

        // Now, you can call the `post` method on ApiService
        Task {
            await ApiService.shared.post(path: GoApi.oauthGuest, body: bodyData) { result in
                        DispatchQueue.main.async {
                         
                            LoadingDialog.instance.hide();
                        }
                
                switch result {
                case .success(let data):
                    // Handle successful response

                    // Parse the response if necessary
                    if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []),
                       let responseDict = jsonResponse as? [String: Any] {
                        print("loginGuest Response: \(responseDict)")
                        onLoginResponse(response: responseDict)
                    }
                    
                case .failure(let error):
                    // Handle failure response
//                    print("Error: \(error.localizedDescription)")
                    AlertDialog.instance.show(message: error.localizedDescription)
                }
            }
        }
    }
    
    // Function for Gmail login (dummy)
    private func loginWithGmail() {
        GoogleSignInManager.shared.signIn { user, error in
                                if let error = error {
                                    print("Sign-in error: \(error.localizedDescription)")
                                } else if let user = user {
//                                    userName = user.profile.name
                                    print("Sign-in user.profile.name: \(user.user.profile?.name ?? "EMPTY")")
                                }
                            }
    }
    
    // Function for Apple login (dummy)
    private func loginWithApple() {
        // Trigger Apple login logic here
       
    }
    
    
    func onLoginResponse(response: [String: Any]) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
            let apiResponse =  try JSONDecoder().decode(GoPlayApiResponse<TokenData>.self, from: jsonData)
            
            var message = "Lỗi đăng nhập"
            

            if apiResponse.isSuccess() {
                
                print("onLoginResponse onRequestSuccess userName: \(apiResponse.data?.accessToken ?? "")")
                if(apiResponse.data != nil){
                    let tokenData : TokenData = apiResponse.data!
                    if let session = GoPlaySession.deserialize(data: tokenData) {
                        KeychainHelper.save(key: GoConstants.goPlaySession, data: session)
                        AuthManager.shared.postEventLogin(sesion: session)
                    }else{
                        AlertDialog.instance.show(message:"Không đọc được Token")
                    }
                }
                
                

            } else {
                message = apiResponse.message
                AlertDialog.instance.show(message:apiResponse.message)
            }

            

        } catch {
            AlertDialog.instance.show(message:error.localizedDescription)
        }
    }
}
