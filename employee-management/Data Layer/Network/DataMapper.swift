//
//  DataMapper.swift
//  employee-management
//
//  Created by Tatiana López Tchalián on 14/2/22.
//

import Foundation
import UIKit

final class DataMapper {
    
    static let shared = DataMapper()
    private init() {}
    
    //Endpoints
    var loginUrl = "login"
    var recoverPasswordUrl = "users/recoverPassword"
    var listEmployeeUrl = "users/listEmployee"
    var detailEmployeeUrl = "users/detailEmployee"
    var registerUrl = "users/registerUser"
    var seeProfileUrl = "users/seeProfile"
    var editProfileurl = "users/editProfile"
    
    func login(params: [String: Any]?,completion: @escaping (Response?) -> Void) {
        Connection().connect(httpMethod: "POST", to: loginUrl, params: params) {
            data in
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: data)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    completion(response)
                }
            } catch {
                print("Error al decodificar")
                completion(nil)
            }
        }
    }
    
    func recoverPassword(params: [String: Any]?,completion: @escaping (Response?) -> Void) {
        Connection().connect(httpMethod: "POST", to: recoverPasswordUrl, params: params) {
            data in
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: data)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    completion(response)
                }
            } catch {
                print("Error al decodificar")
                completion(nil)
            }
        }
    }
    
    func listEmployee(params: [String: Any]?, completion: @escaping (Response?) -> Void) {
        Connection().connect(httpMethod: "POST", to: listEmployeeUrl, params: params) {
            data in

            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: data)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    completion(response)
                }
            } catch {
                print("Error al decodificar")
                completion(nil)
            }
        }
    }
    
    func detailEmployee(params: [String: Any]?, completion: @escaping (Response?) -> Void) {
        Connection().connect(httpMethod: "POST", to: detailEmployeeUrl, params: params) {
            data in

            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: data)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    completion(response)
                }
            } catch {
                print("Error al decodificar")
                completion(nil)
            }
        }
    }

    func registerEmployee(params: [String: Any]?, completion: @escaping (Response?) -> Void) {
        Connection().connect(httpMethod: "PUT", to: registerUrl, params: params) {
            data in

            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: data)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    completion(response)
                }
            } catch {
                print("Error al decodificar")
                completion(nil)
            }
        }
    }
    
    func seeProfile(params: [String: Any]?, completion: @escaping (Response?) -> Void) {
        Connection().connect(httpMethod: "POST", to: seeProfileUrl, params: params) {
            data in

            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: data)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    completion(response)
                }
            } catch {
                print("Error al decodificar")
                completion(nil)
            }
        }
    }
}
