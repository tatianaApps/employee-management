//
//  Network Manager.swift
//  employee-management
//
//  Created by Tatiana López Tchalián on 6/2/22.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    static var baseUrl = "http://localhost/gestion_empleados/public/api/"
     
    //Endpoints
    var registerUrl = NetworkManager.baseUrl + "users/registerUser/"
    var loginUrl = NetworkManager.baseUrl + "login/"
    var recoverPasswordUrl = NetworkManager.baseUrl + "users/recoverPassword/"
    var listEmployeeUrl = NetworkManager.baseUrl + "users/listEmployee/"
    var detailEmployeeUrl = NetworkManager.baseUrl + "users/detailEmployee/"
    var seeProfileUrl = NetworkManager.baseUrl + "users/seeProfile/"
    
    func login(params: [String: Any]?,completion: @escaping (Response?) -> Void) {
        guard let url = URL(string: loginUrl) else {
            completion(nil)
            return
        }
        
        var urlRequest = URLRequest(url: url, timeoutInterval: 10)
        
        if let params = params {
            guard let paramsData = try? JSONSerialization.data(withJSONObject: params, options: []) else {
                completion(nil)
                return
            }
            
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = paramsData
        }
        
        let headers = [
            "Content-type": "application/json",
            "Accept":       "application/json"
        ]
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.httpAdditionalHeaders = headers
        
        let urlSession = URLSession(configuration: sessionConfiguration)
        
        let networkTask = urlSession.dataTask(with: urlRequest) {
            data, response, error in

            guard error == nil else {
                completion(nil)
                return
            }

            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: data)
                DispatchQueue.main.asyncAfter(deadline: .now() + 4){
                    completion(response)}
            } catch {
                completion(nil)
            }
        }
        networkTask.resume()
    }
    
    func recoverPassword(params: [String: Any]?, completion: @escaping (Response?) -> Void) {
        guard let url = URL(string: recoverPasswordUrl) else {
            completion(nil)
            return
        }

        var urlRequest = URLRequest(url: url, timeoutInterval: 10)
        
        if let params = params {
            guard let paramsData = try? JSONSerialization.data(withJSONObject: params, options: []) else {
                completion(nil)
                return
            }
            
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = paramsData
        }
        
        let headers = [
            "Content-type": "application/json",
            "Accept":       "application/json"
        ]
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.httpAdditionalHeaders = headers
        
        let urlSession = URLSession(configuration: sessionConfiguration)
        
        let networkTask = urlSession.dataTask(with: urlRequest) {
            data, response, error in

            guard error == nil else {
                completion(nil)
                return
            }

            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: data)
                DispatchQueue.main.asyncAfter(deadline: .now() + 4){
                    completion(response)}
            } catch {
                completion(nil)
            }
        }
        networkTask.resume()
    }
    
    func listEmployee(params: [String: Any]?, completion: @escaping (Response?) -> Void) {
        guard let url = URL(string: listEmployeeUrl) else {
            completion(nil)
            return
        }

        let urlRequest = URLRequest(url: url)
        let networkTask = URLSession.shared.dataTask(with: urlRequest) {
            data, response, error in

            guard error == nil else {
                completion(nil)
                return
            }

            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: data)
                DispatchQueue.main.asyncAfter(deadline: .now() + 4){
                    completion(response)}
            } catch {
                completion(nil)
            }
        }
        networkTask.resume()
    }
    
    func detailEmployee(params: [String: Any]?, completion: @escaping (Response?) -> Void) {
        guard let url = URL(string: detailEmployeeUrl) else {
            completion(nil)
            return
        }

        var urlRequest = URLRequest(url: url, timeoutInterval: 10)
        
        if let params = params {
            guard let paramsData = try? JSONSerialization.data(withJSONObject: params, options: []) else {
                completion(nil)
                return
            }
            
            urlRequest.httpMethod = "GET"
            urlRequest.httpBody = paramsData
        }
        
        let headers = [
            "Content-type": "application/json",
            "Accept":       "application/json"
        ]
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.httpAdditionalHeaders = headers
        
        let urlSession = URLSession(configuration: sessionConfiguration)
        
        let networkTask = urlSession.dataTask(with: urlRequest) {
            data, response, error in

            guard error == nil else {
                completion(nil)
                return
            }

            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: data)
                DispatchQueue.main.asyncAfter(deadline: .now() + 4){
                    completion(response)}
            } catch {
                completion(nil)
            }
        }
        networkTask.resume()
    }
    
    func registerEmployee(params: [String: Any]?, completion: @escaping (Response?) -> Void) {
        guard let url = URL(string: registerUrl) else {
            completion(nil)
            return
        }

        var urlRequest = URLRequest(url: url, timeoutInterval: 10)
        
        if let params = params {
            guard let paramsData = try? JSONSerialization.data(withJSONObject: params, options: []) else {
                completion(nil)
                return
            }
            
            urlRequest.httpMethod = "PUT"
            urlRequest.httpBody = paramsData
        }
        
        let headers = [
            "Content-type": "application/json",
            "Accept":       "application/json"
        ]
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.httpAdditionalHeaders = headers
        
        let urlSession = URLSession(configuration: sessionConfiguration)
        
        let networkTask = urlSession.dataTask(with: urlRequest) {
            data, response, error in

            let httpResponse = response as! HTTPURLResponse
            print("HTTP Status Code: \(httpResponse.statusCode)")
            
            guard error == nil else {
                completion(nil)
                return
            }

            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: data)
                DispatchQueue.main.asyncAfter(deadline: .now() + 4){ //Con esto, hago que tarde más al cargar
                    completion(response)}
            } catch {
                completion(nil)
            }
        }

        networkTask.resume()
    }
    
    func seeProfile(params: [String: Any]?, completion: @escaping (Response?) -> Void) {
        guard let url = URL(string: seeProfileUrl) else {
            completion(nil)
            return
        }

        let urlRequest = URLRequest(url: url)
        let networkTask = URLSession.shared.dataTask(with: urlRequest) {
            data, response, error in

            guard error == nil else {
                completion(nil)
                return
            }

            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: data)
                DispatchQueue.main.asyncAfter(deadline: .now() + 4){
                    completion(response)}
            } catch {
                completion(nil)
            }
        }
        networkTask.resume()
    }
}
