public struct CheckAuthenOtp: Codable {
    var userCount: Int = 0
    var loginType: Int = LoginType.phone.rawValue
    var code: Int = 0
    var message: String = ""
    var data: [CheckAuthenUserInfo] = []
    var isSuccessed: Bool = true
    var haveError: Bool = false
    var redirectUrl: String? = nil
    var tokenExpired: Bool = false
    var nextStep: Int = 0

    enum CodingKeys: String, CodingKey {
        case userCount
        case loginType
        case code
        case message
        case data
        case isSuccessed = "IsSuccessed"
        case haveError = "HaveError"
        case redirectUrl
        case tokenExpired = "token_expired"
        case nextStep
    }
}

public struct CheckAuthenUserInfo: Codable {
    var accountID: Int = 0
    var accountName: String = ""
    var fullName: String? = nil
    var gender: Int = 0
    var accountType: Int = AccountType.unknown.rawValue
    var confirmCode: Int = ConfirmCode.unknown.rawValue
    var mobile: String = ""
    var email: String = ""

    enum CodingKeys: String, CodingKey {
        case accountID = "AccountID"
        case accountName = "AccountName"
        case fullName = "Fullname"
        case gender = "Gender"
        case accountType = "Status"
        case confirmCode = "ConfirmCode"
        case mobile = "Mobile"
        case email = "Email"
    }
}
