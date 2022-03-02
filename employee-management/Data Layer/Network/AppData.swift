//
//  AppData.swift
//  employee-management
//
//  Created by Tatiana López Tchalián on 14/2/22.
//

import Foundation

class AppData {
    
    static let shared = AppData()
    var api_token: String = ""
    var employees: [Employee]=[]
    
    enum Error: Int {
        case badData = 0
        case correct = 1
        case userDontExist = 20
        case wrongPassword = 21
        case unauthorized = 22
        case dontFindUserToken = 24
        case incorrectToken = 25
    }
}
