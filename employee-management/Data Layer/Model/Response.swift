//
//  Response.swift
//  employee-management
//
//  Created by Tatiana López Tchalián on 8/2/22.
//

import Foundation

struct Response: Codable {
    
    var status: Int
    var msg: String
    var empleados: [Employee]?
    var empleado: Employee?
}
