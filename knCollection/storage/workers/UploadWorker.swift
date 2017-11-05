//
//  Uploader.swift
//  Fixir
//
//  Created by Ky Nguyen on 3/31/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import Foundation

enum knFileType: String {
 
    case image, audio
}

struct knUploadWorker: knWorker {
    
    var api: String
    var params: [String: Any]?
    var uploadData: Data
    var fileKeyPath: String
    var fileName: String
    var fileType: String
    var token: String?
    
    var success: ((AnyObject) -> Void)?
    var fail: ((Error) -> Void)?
    
    init(api: String,
         token: String? = nil,
         params: [String: Any]? = nil,
         uploadData: Data,
         fileKeyPath: String = "file",
         fileName: String = "defaultName",
         fileType: String = "image",
         success: ((AnyObject) -> Void)? = nil,
         fail: ((Error) -> Void)? = nil) {
        
        self.api = api
        self.token = token
        self.params = params
        self.uploadData = uploadData
        self.fileKeyPath = fileKeyPath
        self.fileName = fileName
        self.fileType = fileType
        self.success = success
        self.fail = fail
    }
    
    func execute() {
        
        guard let request = makeRequest() else { return }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                print("Upload fail with error: \(error!)")
                
                self.fail?(error!)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as AnyObject
                print(json)
                self.success?(json)
                
            } catch let err { print(err) }
        }
    
        task.resume()
    }

    private func makeRequest() -> URLRequest? {
        
        guard let apiUrl = URL(string: api) else { return nil }
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBodyWithParameters(parameters: params,
                                                    filePathKey: fileKeyPath,
                                                    fileData: uploadData,
                                                    fileName: fileName,
                                                    mimeType: fileType == "image" ? "image/jpg" : "audio/x-mpeg-3",
                                                    boundary: boundary)
        
        return request
    }
    
    
    private func createBodyWithParameters(parameters: [String: Any]?,
                                         filePathKey: String?,
                                         fileData: Data,
                                         fileName: String,
                                         mimeType: String,
                                         boundary: String) -> Data {
        
        var body = Data()
        
        if let params = parameters {
            for (key, value) in params {
                
                body.append(string: "--\(boundary)\r\n")
                body.append(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append(string: "\(value)\r\n")
            }
        }
        
        body.append(string: "--\(boundary)\r\n")
        body.append(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(fileName)\"\r\n")
        body.append(string: "Content-Type: \(mimeType)\r\n\r\n")
        body.append(fileData)
        body.append(string: "\r\n")
        body.append(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
}

extension Data {
    
    mutating func append(string: String) {
        guard let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true) else { return }
        append(data)
    }
}
