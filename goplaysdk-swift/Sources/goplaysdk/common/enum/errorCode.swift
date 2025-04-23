//
//  errorCode.swift
//  goplaysdk
//
//  Created by Ngô Đồng on 17/4/25.
//

enum GoPlayError: Error {
    case outOfPaper
    case noToner
    case onFire
}

//example
//do {
//    .....
//    throw GoPlayError.noToner
//    print(printerResponse)
//} catch GoPlayError.onFire {
//    print("I'll just put this over here, with the rest of the fire.")
//} catch let printerError as GoPlayError {
//    print("Printer error: \(printerError).")
//} catch {
//    print(error)
//}
