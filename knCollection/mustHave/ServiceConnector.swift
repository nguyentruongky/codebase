//
//  ServiceConnector.swift
//  WorkshopFixir
//
//  Created by Ky Nguyen on 12/28/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import Foundation
import Alamofire

struct knServiceConnector {
    
    static fileprivate var connector = AlamofireConnector()
    
    private static func getHeader() -> [String: String]? {
        
        guard let token = ogeSetting.token else { return nil }
        return ["Authorization": token]
    }
    
    private static func getUrl(from api: String) -> URL? {
        
        let apiUrl = api.contains("http") ? api : ogeSetting.baseUrl + api
        return URL(string: apiUrl)
    }
    
    
    static func get(_ api: String,
                    params: [String: Any]? = nil,
                    success: @escaping (_ result: AnyObject) -> Void,
                    fail: ((_ error: knError) -> Void)? = nil) {
        
        let header = getHeader()
        get(api, params: params, header: header, success: success, fail: fail)
    }
    
    
    static func get(_ api: String,
                    params: [String: Any]? = nil,
                    header: [String: String]?,
                    success: @escaping (_ result: AnyObject) -> Void,
                    fail: ((_ error: knError) -> Void)? = nil) {
        
        let apiUrl = getUrl(from: api)
        connector.request(withApi: apiUrl,
                          method: .get,
                          params: params,
                          header: header,
                          success: success,
                          fail: fail)
    }
    
    static func put(_ api: String,
                    params: [String: Any]? = nil,
                    success: @escaping (_ result: AnyObject) -> Void,
                    fail: ((_ error: knError) -> Void)? = nil) {
        
        let header = getHeader()
        put(api, params: params, header: header, success: success, fail: fail)
    }
    
    
    static func put(_ api: String,
                    params: [String: Any]? = nil,
                    header: [String: String]?,
                    success: @escaping (_ result: AnyObject) -> Void,
                    fail: ((_ error: knError) -> Void)? = nil) {
        
        let apiUrl = getUrl(from: api)
        connector.request(withApi: apiUrl, method: .put, params: params,
                          header: header, success: success, fail: fail)
    }
    
    static func post(_ api: String,
                     params: [String: Any]? = nil,
                     success: @escaping (_ result: AnyObject) -> Void,
                     fail: ((_ error: knError) -> Void)? = nil) {
        
        let header = getHeader()
        post(api, params: params, header: header, success: success, fail: fail)
    }
    
    
    static func post(_ api: String,
                     params: [String: Any]? = nil,
                     header: [String: String]?,
                     success: @escaping (_ result: AnyObject) -> Void,
                     fail: ((_ error: knError) -> Void)? = nil) {
        
        let apiUrl = getUrl(from: api)
        connector.request(withApi: apiUrl, method: .post, params: params,
                          header: header, success: success, fail: fail)
    }
    
    static func delete(_ api: String,
                       params: [String: Any]? = nil,
                       success: @escaping (_ result: AnyObject) -> Void,
                       fail: ((_ error: knError) -> Void)? = nil) {
        
        let header = getHeader()
        delete(api, params: params, header: header, success: success, fail: fail)
    }
    
    
    static func delete(_ api: String,
                       params: [String: Any]? = nil,
                       header: [String: String]?,
                       success: @escaping (_ result: AnyObject) -> Void,
                       fail: ((_ error: knError) -> Void)? = nil) {
        
        let apiUrl = getUrl(from: api)
        connector.request(withApi: apiUrl, method: .delete, params: params,
                          header: header, success: success, fail: fail)
    }
}


struct knAlamofireConnector {
    
    func request(withApi api: URL?,
                 method: HTTPMethod,
                 params: [String: Any]? = nil,
                 header: [String: String]? = nil,
                 success: @escaping (_ result: AnyObject) -> Void,
                 fail: ((_ error: knError) -> Void)?) {
        
        guard let api = api else { return }
        let encoding: ParameterEncoding = method == .post ? JSONEncoding.default : URLEncoding.httpBody
        
        Alamofire.request(api, method: method, parameters: params, encoding: encoding, headers: header)
            .responseJSON { (response) in
                
                print("Alamofire:: Request:: \(String(describing: response.request?.url))")
                
                if self.isPhysicalFailure(response: response) {
                    print(response)
                    fail?(knError(code: .timeOut, message: response.result.error!.localizedDescription))
                    print("Alamofire:: Error:: \(response.result.error!.localizedDescription)")
                    return
                }
                
                if let error = self.isLogicalFailure(response: response.result.value as AnyObject) {
                    print("Alamofire:: Error: \(String(describing: error.message))")
                    fail?(error)
                    return
                }
                
                success(response.result.value! as AnyObject)
        }
    }
    
    private func isPhysicalFailure(response: DataResponse<Any>) -> Bool {
        return response.result.error != nil
    }
    
    private func isLogicalFailure(response: AnyObject) -> knError? {
        
        let error = JSONParser.getBool(forKey: "error", inObject: response)
        if error == true {
            let message = JSONParser.getString(forKey: "msg", inObject: response)
            return knError(code: .notSure, message: message)
        }
        return nil
    }
    
}

