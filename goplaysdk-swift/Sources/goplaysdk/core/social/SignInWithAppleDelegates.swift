//


class SignInWithAppleDelegates: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    static let shared = SignInWithAppleDelegates()
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // Get the key window properly (without UIKit UIApplication.shared)
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            fatalError("No UIWindowScene available")
        }
        guard let window = scene.windows.first(where: { $0.isKeyWindow }) else {
            fatalError("No keyWindow found")
        }
        return window
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email

            print("✅ Successfully signed in with Apple!")
            print("User ID: \(userIdentifier)")
            print("Email: \(email ?? "No Email")")
            print("Full Name: \(fullName?.givenName ?? "") \(fullName?.familyName ?? "")")
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("❌ Sign in with Apple failed: \(error.localizedDescription)")
    }
}
