//
//  Connection.swift
//  employee-management
//
//  Created by Tatiana López Tchalián on 14/2/22.
//

import Foundation
import UIKit

final class Connection {
        
    let baseUrl = "http://localhost/gestion_empleados/public/api/"

    func connect(httpMethod: String, to endpoint: String, params: [String: Any]? ,completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: baseUrl+endpoint) else {
            completion(nil)
            return
        }
        
        var urlRequest = URLRequest(url: url, timeoutInterval: 10)
        
        
        if let params = params {
            guard let paramsData = try? JSONSerialization.data(withJSONObject: params, options: []) else {
                completion(nil)
                return
            }
            
            urlRequest.httpMethod = httpMethod
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
            
            let httpResponse = response as! HTTPURLResponse
            print("HTTP Status Code: \(httpResponse.statusCode )")
            
            completion(data)
        }
        
        networkTask.resume()
    }
}
