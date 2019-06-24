//
//  HttpClient.swift
//
//  Created by Oliver Paray on 5/3/18.
//

import Foundation
import MessageUI

public typealias Header = [String:String]
public typealias SuccessBlock = (_ response:URLResponse?,_ data:Data?) -> Void
public typealias FailureBlock = (_ status:URLResponse?,_ error:Error?,_ message:String?) -> Void
public typealias ExecutionBlock = (success:SuccessBlock,failure:FailureBlock)

public enum Method:String{
    case Delete,Get,Post,Put
}

public class HttpClient: NSObject,MFMailComposeViewControllerDelegate{
    
    //MARK: - Properties

    public static let sharedInstance = HttpClient()

    fileprivate var serverReachability: Reachability?

    //MARK: - Initializers

    //MARK: - Class Methods

    //MARK: - Public Methods

    public func execute(async concurrent:Bool = true,
                        serviceUrl url:URL,
                        webMethod method:Method,
                        requestHeader header:Header? = nil,
                        requestBody body:Data? = nil,
                        dispatchQueue queue:DispatchQueue = DispatchQueue.global(qos: .utility),
                        executionHandler handler:ExecutionBlock)
    {
        var dataRequest = URLRequest(url: url)
        dataRequest.httpMethod = method.rawValue
        if let headerData = header{
            for (key,value) in headerData{
                dataRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
        if let bodyData = body{
            dataRequest.httpBody = bodyData
        }
        if concurrent {
            queue.async {
                self.requestExecution(request: dataRequest, handler: handler)
            }
        } else {
            queue.sync {
                self.requestExecution(request: dataRequest, handler: handler)
            }
        }
    }

    public func execute(async concurrent:Bool = true,
                        serviceUrl url:String,
                        webMethod method:Method,
                        requestHeader header:Header? = nil,
                        requestBody body:String? = nil,
                        dispatchQueue queue:DispatchQueue = DispatchQueue.global(qos: .utility),
                        executionHandler handler:ExecutionBlock)
    {
        var data:Data? = nil
        guard let url = URL(string: url) else {
            handler.failure(nil, nil,"Bad URL...")
            return
        }
        if let bodyData = body{
            guard let encoded = bodyData.data(using: .utf8) else {
                handler.failure(nil, nil,"Bad String...")
                return
            }
            data = encoded
        }
        execute(async: concurrent,serviceUrl: url, webMethod: method, requestHeader: header, requestBody: data, dispatchQueue: queue, executionHandler: handler)
    }

    public func execute(async concurrent:Bool = true,
                        serviceUrl url:String,
                        webMethod method:Method,
                        requestHeader header:Header? = nil,
                        requestBody body:JSON?,
                        dispatchQueue queue:DispatchQueue = DispatchQueue.global(qos: .utility),
                        executionHandler handler:ExecutionBlock)
    {
        var data:Data? = nil
        guard let url = URL(string: url) else {
            handler.failure(nil, nil,"Bad URL...")
            return
        }
        if let bodyData = body{
            do{
                data = try JSONSerialization.data(withJSONObject: bodyData, options: .prettyPrinted)
            } catch {
                handler.failure(nil, nil,"Bad JSON...")
                return
            }
        }
        execute(async: concurrent,serviceUrl: url, webMethod: method, requestHeader: header, requestBody: data, dispatchQueue: queue, executionHandler: handler)
    }

    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: false, completion: nil)
    }

    public func testReachability(server: String = "https://api.humble-scholar.com/api/sample"){
        print("Testing reachability...")

        guard let url = NSURL(string: server),
            let host = url.host,
            let reachability = Reachability(hostname: host) else {
            print("Could not instantiate network reachability")
            return
        }

        reachability.whenReachable = { reachable in
            print("Using network device \(reachable.connection.description)")
            self.testDownload(server: server,
                              completion: { (failure, message) in
                                let subject = "HumbleScholar Status:\((failure ? "Fail!!!":"Pass!"))"
                                self.sendEmail(recipients: ["oliver@usa-ues.com","mark@usa-ues.com","nian@usa-ues.com","tyler@usa.ues.com"], subject: subject, body: message)
            })
        }

        reachability.whenUnreachable = { unreachable in
            self.sendEmail(recipients: ["oliver@usa-ues.com","mark@usa-ues.com","nian@usa-ues.com","tyler@usa.ues.com"],
                           subject: "HumbleScholar Status: Unreachable!!!",
                           body: "Using network device \(unreachable.connection.description)")
        }

        self.serverReachability = reachability

        do {
            try self.serverReachability!.startNotifier()
        } catch {
            print("Unable to start network reachability tests:\n\(error.localizedDescription)")
        }

    }

    public func testDownload(server: String = "https://api.humble-scholar.com/api/sample",completion: ((_ failure: Bool,_ result: String) -> Void)?){
        print("Testing download...")

        let fileNames = ["student","vocabulary","modules"]
        let serviceUrl = server

        for file in fileNames{
            let urlSpec = String(format: "%@/%@", serviceUrl, file)

            print("Testing for \(urlSpec)")

            HttpClient.sharedInstance.execute(async: true,
                                              serviceUrl: urlSpec,
                                              webMethod: .Get,
                                              executionHandler:
                (success:{
                    (response,data) in
                    if let httpResponse = response as? HTTPURLResponse, let httpData = data, let completionBlock = completion{
                        if httpResponse.statusCode != 200{
                            completionBlock(true,String(format: "Status Code %d when accessing %@", httpResponse.statusCode, urlSpec))
                        }
                        if let jsonString = String(data: httpData, encoding: String.Encoding.utf8){
                            completionBlock(false,String(format: "Accessing %@\nJSON Decoded: %@", urlSpec, jsonString))
                        } else {
                            completionBlock(true,String(format: "Invalid JSON when accessing: %@", urlSpec))
                        }
                    } else {
                    }
                },failure:{
                    (response,error,message) in
                    if let errorMessage = message, let completionBlock = completion{
                        completionBlock(true,String(format: "Error when accessing %@\nMessage: %@", urlSpec, errorMessage))
                    }
                })
            )

        }
    }

    //MARK: - Private Methods
    
    fileprivate func requestExecution(request: URLRequest, handler:ExecutionBlock){
        let task = URLSession.shared.dataTask(with: request) { (responseData, responseStatus, responseError) in
            if let errorOccurred = responseError{
                handler.failure(responseStatus,errorOccurred,errorOccurred.localizedDescription)
                return
            }
            guard let returnedData = responseData else {
                handler.failure(responseStatus,nil,"No Data...")
                return
            }
            handler.success(responseStatus,returnedData)
        }
        task.resume()
    }

    fileprivate func sendEmail(recipients: [String],subject: String,body: String,isHtml: Bool=false){
        if MFMailComposeViewController.canSendMail(){
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setToRecipients(recipients)
            mailComposer.setSubject(subject)
            mailComposer.setMessageBody(body, isHTML: isHtml)

            guard let window = UIApplication.shared.keyWindow, let activeViewController = window.activeViewController() else{
                return
            }

            activeViewController.present(mailComposer, animated: false, completion: nil)
        } else {
            return
        }
    }
}
