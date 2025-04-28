

import GoogleSignIn

@MainActor
class GoogleSignInManager {
    static let shared = GoogleSignInManager()

    func signIn(completion: @escaping (GIDSignInResult?, Error?) -> Void) {
        // Get the root view controller from the app
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            return
        }

        // Set up Google Sign-In with the correct client ID and presenting view controller
//        GIDSignIn.sharedInstance.clientID = "36318724422-hbqlqt43bcs4qb81i3f872l7dh2hphvv.apps.googleusercontent.com"
        GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController // Provide the presenting view controller here
        ) { user, error in
            completion(user, error)
        }
    }
}
