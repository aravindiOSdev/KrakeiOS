//
//  KNetworkManager.swift
//  Pods
//
//  Created by Patrick on 28/07/16.
//
//

import Foundation
import Alamofire

@objc public enum SwiftKrakeAuthenticationProvider: Int{
    case facebook
    case twitter
    case google
    case linkedin
    case instagram
    case orchard
    case apple
}

@objc public class KrakeAuthenticationProvider: NSObject {
    public static let facebook = "facebook"
    public static let twitter = "twitter"
    public static let google = "google"
    public static let linkedin = "linkedin"
    public static let instagram = "instagram"
    public static let apple = "apple"
    @objc public static let orchard = "orchard"
}

public typealias KrakeAuthBlock = (_ success: Bool, _ withResponse: [AnyHashable : Any]?, _ error: Error?) -> Void
public let KNEKrakeResponse = "KrakeResponse"

public enum KResponseSerializer: Int {
    case json
    case data
}

public enum KRequestSerializer: Int {
    case json
    case http
}

public typealias KParamaters = [String: Any]

private extension KRequestSerializer {
    func encoding() -> ParameterEncoding {
        switch self {
        case .json:
            return JSONEncoding.default
        case .http:
            return URLEncoding.default
        }
    }

    func encoder() -> ParameterEncoder {
        switch self {
        case .json:
            return JSONParameterEncoder()
        case .http:
            return URLEncodedFormParameterEncoder(destination: .methodDependent)
        }
    }
}

public enum KMethod: Int {
    case get
    case post
    case put
    case delete
}

private extension KMethod {
    func afMethod() -> HTTPMethod {
        switch self {
        case .get:
            return HTTPMethod.get
        case .post:
            return HTTPMethod.post
        case .put:
            return HTTPMethod.put
        case .delete:
            return HTTPMethod.delete
        }
    }
}

open class KRequest {

    public var path: String = ""

    public var queryParameters = [URLQueryItem]()

    public var method: KMethod = .get
    public var parameters: KParamaters? = nil
    public var requestSerializer: KRequestSerializer? = nil
    public var headers =  [String: String]()

    public var responseSerializer: KResponseSerializer? = nil

    public var uploadProgress: ((Progress) -> Void)? = nil
    public var downloadProgress: ((Progress) -> Void)? = nil

    func genericParamters() -> Any? {
        return parameters
    }
}

public class KCodableRequest<Parameters: Encodable>: KRequest {
    var codableParameters: Parameters? = nil

    public init(_ codableParameters: Parameters? = nil) {
        self.codableParameters = codableParameters
        super.init()
    }

    override func genericParamters() -> Any? {
        return codableParameters
    }
}

extension KRequest {

    func asURL(_ baseUrl: URL) -> URL {

        var components = URLComponents(url: baseUrl.appendingPathComponent(path), resolvingAgainstBaseURL: true)
        components?.queryItems = queryParameters

        return try! (components?.asURL())!
    }

    func afHeaders() -> HTTPHeaders {

        return HTTPHeaders(headers.compactMap{ (key, value) -> HTTPHeader in
            return HTTPHeader(name: key, value: value)
        })
    }
}

public class KMultipartFormData {
    private let multiformData: MultipartFormData

    public func appendParameters(_ params: [String: String]) {

        for (key, value) in params {
            multiformData.append(value.data(using: String.Encoding.utf8)!, withName: key)
        }
    }

    public func appendPart(_ data: Data, withName name: String, fileName: String? = nil, mimeType: String? = nil) {
        multiformData.append(data,
                             withName: name,
                             fileName: fileName,
                             mimeType: mimeType)
    }

    fileprivate init(_ multiformData: MultipartFormData) {
        self.multiformData = multiformData
    }
}

private enum CallbackWrapperLevel {
    case standard //stadard level with krake error control
    case afterLogin //internal use login
    case none //no check, solo chiamata del block esterno
}


@objc
public class KDataTask: NSObject {
    internal let dataRequest: DataRequest
    public let request: KRequest

    init(request: KRequest, data: DataRequest) {
        self.dataRequest = data
        self.request = request
    }

    @objc public func cancel() {
        dataRequest.cancel()
    }

    public var isRunning: Bool {
        get {
            return dataRequest.isResumed
        }
    }

    public var response: HTTPURLResponse? {
        get {
            return dataRequest.response
        }
    }
}

@objc public class KNetworkManager: NSObject {

    private let authenticated: Bool
    private let checkHeaderResponse: Bool
    private let sessionManager: Session
    private let requestSerializer: KRequestSerializer
    private let responseSerializer: KResponseSerializer
    public let baseURL: URL

    public init(baseURL: URL,
                auth: Bool,
                checkHeaderResponse: Bool = false,
                requestSerializer: KRequestSerializer = .json,
                responseSerializer: KResponseSerializer = .json) {
        
        self.sessionManager = Session(configuration: URLConfigurationCookies.shared.configuration,
                                 interceptor: RequestHeaderAdapter(auth: auth))
        
        self.baseURL = baseURL
        self.authenticated = auth
        self.checkHeaderResponse = checkHeaderResponse
        self.requestSerializer = requestSerializer
        self.responseSerializer = responseSerializer
        super.init()
    }
    
    @objc public static func defaultManager(_ auth: Bool = false,
                                             checkHeaderResponse: Bool = false) -> KNetworkManager {
        return KNetworkManager.default(auth, checkHeaderResponse, .json, .json)
    }
    
    public static func `default`(_ auth: Bool = false,
                                            _ checkHeaderResponse: Bool = false,
                                            _ requestSerializer: KRequestSerializer = .json,
                                            _ responseSerializer: KResponseSerializer = .json) -> KNetworkManager
    {
        let manager = KNetworkManager(baseURL: KInfoPlist.KrakePlist.path,
                                      auth: auth,
                                      checkHeaderResponse: checkHeaderResponse,
                                      requestSerializer: requestSerializer,
                                      responseSerializer: responseSerializer)
        return manager
    }
    
    //MARK: - Metodi di autenticazione

    public func krakeLogin(providerName: String,
                           params: KParamaters,
                           completion: @escaping KrakeAuthBlock )
    {

        var extras = KParamaters()
        extras["UUID"] = KConstants.uuid
        params.forEach { (key: String, value: Any) in
            extras[key] = value
        }

        let request = KRequest()
        request.parameters = extras
        switch providerName {
        case KrakeAuthenticationProvider.orchard:
            request.path = KAPIConstants.userExtensions + "/SignInSsl"
            request.queryParameters.append(URLQueryItem(name:"Lang",value: KLocalization.Core.language))
            request.method = .post
        default:
            request.path = KAPIConstants.externalTokenLogon
            request.queryParameters.append(URLQueryItem(name: KParametersKeys.language, value: KLocalization.Core.language))
            request.queryParameters.append(URLQueryItem(name: KParametersKeys.Login.provider, value: providerName))
            request.method = .post
        }

        let success: (KDataTask, Any?) -> Void =
           {
               (task, object) in
            
               self.loginCompletion(task, object: object, completion: completion)
           }
           let failure: (KDataTask?, Error) -> Void =
           {
               (task, error) in
               self.loginCompletion(task, error: error, completion: completion)
           }


        _ = self.request(request,
                callbackWrapperLevel: .none,
                     successCallback: success,
                     failureCallback: failure)
    }

    @objc public func krakeRegisterUser(_ params: KParamaters,
                                        completion: @escaping KrakeAuthBlock) {
        let request = KRequest()
        request.path = KAPIConstants.userExtensions + "/RegisterSsl"
        request.queryParameters.append(URLQueryItem(name: "UUID", value: KConstants.uuid))
        request.queryParameters.append(URLQueryItem(name: "Lang", value: KLocalization.Core.language))
        request.method = .post
        request.parameters = params

        _ = self.request(request,
                         callbackWrapperLevel: .none,
                         successCallback: { (task, object) in
                            self.loginCompletion(task, object: object, completion: completion)
        }, failureCallback: { (task, error) in
            self.loginCompletion(task, error: error, completion: completion)
        })
    }
    
    fileprivate func loginCompletion(_ task: KDataTask?,
                                     object: Any? = nil,
                                     error: Error? = nil,
                                     completion: KrakeAuthBlock) {
        if let error = error{
            parseAndCheckKrakeError(error)
            KLoginManager.shared.userLogout()
            completion(false, nil, error)
        }else{
            let response = KrakeResponse(object: object)
            if (response?.success ?? false){
                if let task = task {
                           checkHeaderResponse(task)
                           let error: Error? = !(response?.message ?? "").isEmpty ? NSError(domain: KInfoPlist.appName, code: 0, userInfo: [NSLocalizedDescriptionKey : response!.message!]) : nil
                           completion(true, response?.data, error)
                       }
                       else {
                           completion(false, nil, nil)
                       }
            }else{
                if KLoginManager.shared.isKrakeLogged {
                    KLoginManager.shared.userLogout()   
                }
                completion(false, nil, NSError(domain: "Login", code: (response?.errorCode ?? 0), userInfo: [NSLocalizedDescriptionKey : (response?.message ?? KLocalization.Error.genericError)]))
            }
        }
        invalidateSessionCancelingTasks(true)
    }
    
    //MARK: - Krake lost password request
    
    public func requestKrakeLostPassword(_ queryString: String,
                                               params: KParamaters,
                                               completion: @escaping KrakeAuthBlock) {
        let request = KRequest()
        request.method = .post
        request.parameters = params
        request.path = KAPIConstants.userExtensions + "/" + queryString
        request.queryParameters.append(URLQueryItem(name: "Lang", value: KLocalization.Core.language))

        _ = self.request(request,
                         callbackWrapperLevel: .none,
                         successCallback: { (task, object) in
                            if let responseObject = object as? [String : AnyObject] , let response = KrakeResponse(object: responseObject as AnyObject) , response.success == false{
                                completion(false, nil,
                                           NSError(domain: "Request lost password",
                                                   code: response.errorCode,
                                                   userInfo: [NSLocalizedDescriptionKey : response.message ?? ""]))
                            }
                            else {
                                completion(true, nil, nil)
                            }
                            self.invalidateSessionCancelingTasks(true)
        },
                         failureCallback: { (task, error) in
                            completion(false, nil, error as Error?)
                                       self.invalidateSessionCancelingTasks(true)
        })
    }

    //MARK: - aggiornare il profilo utente

    @objc public func updateUserProfile(_ params: KParamaters,
                                        completion: @escaping KrakeAuthBlock){

        _ = request(KAPIConstants.userStartupConfig,
                    method: .post,
                    parameters: params,
                    successCallback: { (task, object) in
                        if let responseObject = object , let response = KrakeResponse(object: responseObject) {
                            if response.success == true {
                                completion(true, response.data, nil)
                            }
                            else {
                                completion(false, nil, NSError(domain: "User update profile",
                                                               code: response.errorCode,
                                                               userInfo: [NSLocalizedDescriptionKey : response.message ?? ""]))
                            }
                        }
                        else {
                            completion(false, nil, NSError(domain: "User update profile",
                                                           code: KErrorCode.genericError,
                                                           userInfo: [NSLocalizedDescriptionKey : KLocalization.Error.genericError]))
                        }
        }) { (task, error) in
            completion(false, nil, error)
        }
    }


    //MARK: - Krake additional registration infos

    @objc public func policiesRegistration(_ completion: @escaping (_ success: Bool,
        _ withResponse: AnyObject?,
        _ error: Error?) -> Void){

        let request = KRequest()
        request.path = KAPIConstants.userExtensions + "/GetCleanRegistrationPoliciesSsl"
        request.method = .get
        request.queryParameters = [URLQueryItem(name: "Lang", value: KLocalization.Core.language)]

        _ = self.request(request,
                         callbackWrapperLevel: .none,
                         successCallback: { (task, object) in
                                         if let responseObject = object as? [String : AnyObject],
                                             let policies = responseObject["Policies"] {
                                             completion(true, policies, nil)
                                         }else{
                                            completion(false, nil, NSError(domain: "Registration", code: KErrorCode.genericError, userInfo: [NSLocalizedDescriptionKey : KLocalization.Error.genericError]))
                                         }
                                         self.invalidateSessionCancelingTasks(true)
                         },
                         failureCallback: { (task, error) in
                             completion(false, nil, error)
                             self.invalidateSessionCancelingTasks(true)
                         })
    }

    //MARK: - Generic Requests

    public func request(_ path: String,
                                method: KMethod,
                                parameters: KParamaters? = nil,
                                query: [URLQueryItem] = [],
        successCallback: ((KDataTask, Any?) -> Void)?,
        failureCallback: ((KDataTask, Error) -> Void)?) -> KDataTask {

        let request = KRequest()
        request.path = path
        request.method = method
        request.parameters = parameters
        request.queryParameters = query
        return self.request(request, successCallback: successCallback, failureCallback: failureCallback)
    }

    public func request(_ request: KRequest,
                 successCallback: ((KDataTask, Any?) -> Void)?,
                 failureCallback: ((KDataTask, Error) -> Void)?) -> KDataTask {

        return self.request(request,
                            callbackWrapperLevel: .standard,
                            successCallback: successCallback,
                            failureCallback: failureCallback)
    }

    public func request<Parameters: Encodable>(codable request: KCodableRequest<Parameters>,
                 successCallback: ((KDataTask, Any?) -> Void)?,
                 failureCallback: ((KDataTask, Error) -> Void)?) -> KDataTask {

        let dataRequestBuilder = {(manager: KNetworkManager) -> DataRequest in
            let dataRequest = manager.sessionManager.request(request.asURL(manager.baseURL),
                                                     method: request.method.afMethod(),
                                                     parameters: request.codableParameters,
                                                     encoder: (request.requestSerializer ?? manager.requestSerializer).encoder(),
                                                     headers: request.afHeaders(),
                                                     interceptor: nil)
                .validate()

            if let dp = request.downloadProgress {
                dataRequest.downloadProgress(closure: dp)
            }

            if let up = request.uploadProgress {
                dataRequest.uploadProgress(closure: up)
            }
            return dataRequest
        }

        return self.wrapAndExecute(request: request,
                                   dataRequestBuilder: dataRequestBuilder,
                                   successCallback: successCallback,
                                   failureCallback: failureCallback)
    }

    public func upload(_ path: String,
                           constructingBodyWith block: ((KMultipartFormData) -> Void)?,
                           progress uploadProgress: ((Progress) -> Void)? = nil,
                           successCallback: ((KDataTask, Any?) -> Void)? = nil,
                           failureCallback: ((KDataTask?, Error) -> Void)? = nil) -> KDataTask?{
        let uploadRequest = KRequest()
        uploadRequest.method = .post
        uploadRequest.path = path

        let dataRequestBuilder = {(manager: KNetworkManager) -> DataRequest in

            let dataRequest = manager.sessionManager.upload(multipartFormData: { (multiFormData) in
                block?(KMultipartFormData(multiFormData))
            }, to:  manager.baseURL.appendingPathComponent(path))
                .validate()

            if let up = uploadProgress {
                dataRequest.uploadProgress(closure: up)
            }
            return dataRequest
        }
        return self.wrapAndExecute(request: uploadRequest,
            dataRequestBuilder: dataRequestBuilder,
                                   successCallback: successCallback,
                                   failureCallback: failureCallback)

    }


    //MARK: - Internal methods generic request
    private func request(_ request: KRequest,
                         callbackWrapperLevel: CallbackWrapperLevel,
                 successCallback: ((KDataTask, Any?) -> Void)?,
                 failureCallback: ((KDataTask, Error) -> Void)?) -> KDataTask {

        let dataRequestBuilder = {(manager: KNetworkManager) -> DataRequest in
            let dataRequest = manager.sessionManager.request(request.asURL(manager.baseURL),
                                                            method: request.method.afMethod(),
                                                            parameters: request.parameters,
                                                            encoding: (request.requestSerializer ?? manager.requestSerializer).encoding(),
                                                            headers: request.afHeaders(),
                                                            interceptor: nil)
                       .validate()

                   if let dp = request.downloadProgress {
                       dataRequest.downloadProgress(closure: dp)
                   }

                   if let up = request.uploadProgress {
                       dataRequest.uploadProgress(closure: up)
                   }
            return dataRequest
        }


        return self.wrapAndExecute(callbackWrapperLevel: callbackWrapperLevel,
                                   request: request,
                                   dataRequestBuilder: dataRequestBuilder,
                                   successCallback: successCallback,
                                   failureCallback: failureCallback)
    }

    private func wrapAndExecute(
        callbackWrapperLevel: CallbackWrapperLevel = .standard,
        request: KRequest,
        dataRequestBuilder: @escaping ((KNetworkManager) -> DataRequest),
        successCallback: ((KDataTask, Any?) -> Void)?,
        failureCallback: ((KDataTask, Error) -> Void)?) -> KDataTask {

        let dataTask = KDataTask(request: request, data: dataRequestBuilder(self))

        let failureWrapper : ((KDataTask, Error) -> Void)?
        let successWrapper : ((KDataTask, Any?) -> Void)?

        switch callbackWrapperLevel {
        case .standard:
            failureWrapper  = { (task, error) in
                       self.parseAndCheckKrakeError(error)
                       failureCallback?(task, error)
                       self.invalidateSessionCancelingTasks(true)
                   }

            successWrapper = { (task, object) in
                                    self.checkHeaderResponse(task)
                                    if let responseObject = object as? [String : AnyObject] , let kSuccess = responseObject["Success"] as? NSNumber ?? responseObject["success"] as? NSNumber , kSuccess == 0{
                                        self.checkKrakeResponse(KrakeResponse(object: responseObject), parameters: request.genericParamters(), checkSuccess: { (manager) in
                                            _ = manager.wrapAndExecute(callbackWrapperLevel: .afterLogin,
                                                                   request: request,
                                                                   dataRequestBuilder: dataRequestBuilder,
                                                                   successCallback: successCallback,
                                                                   failureCallback: failureCallback)
                                        }, checkFailure: { (error: Error) in
                                            failureCallback?(task, error)
                                            self.invalidateSessionCancelingTasks(true)
                                        })
                                    }
                                    else{
                                        successCallback?(task, object)
                                        self.invalidateSessionCancelingTasks(true)
                                    }
            }

        case .afterLogin:
            failureWrapper = { (task, error) in
                failureCallback?(task, error)
                self.invalidateSessionCancelingTasks(true)
            }

            successWrapper = { (task, object) in
                successCallback?(task, object)
                self.invalidateSessionCancelingTasks(true)
            }
        default:
            failureWrapper = failureCallback
            successWrapper = successCallback
        }
        
        switch responseSerializer {
        case .json:
            dataTask.dataRequest.responseJSON { response in
                switch response.result {
                case let .success(json):
                    successWrapper?(dataTask,json)
                case let .failure(error):
                    failureWrapper?(dataTask,error)
                    print(error)
                }
            }
        case .data:
            dataTask.dataRequest.response { response in
                switch response.result {
                case let .success(data):
                    successWrapper?(dataTask,data)
                case let .failure(error):
                    failureWrapper?(dataTask,error)
                    print(error)
                }
            }
        }
        return dataTask
    }

    private func invalidateSessionCancelingTasks(_ cancelTask: Bool) {
        //TODO: alamo fire verificare se ha senso chiamato così tanto spesso
        if (cancelTask) {
            sessionManager.session.invalidateAndCancel()
        } else {
            sessionManager.session.finishTasksAndInvalidate()
        }
    }

    //MARK: - Metodi privati
    
    fileprivate func checkKrakeResponse(_ responseObject: KrakeResponse?,
                                        parameters: Any? = nil,
                                        checkSuccess: ((KNetworkManager) -> Void)? = nil,
                                        checkFailure: ((Error) -> Void)? = nil){
        if let response = responseObject{
            switch response.resolutionAction{
            case KResolutionAction.userHaveToLogin:
                if !authenticated && KLoginManager.shared.isKrakeLogged {
                    let manager = KNetworkManager.default(true)
                    checkSuccess?(manager)
                }else{
                    //USER HAVE TO LOGGED IN
                    KLoginManager.shared.userLogout()
                    if KLoginManager.shared.delegate?.shouldDisplayLoginControllerAfterFailure(with: responseObject, parameter: parameters) ?? true
                    {
                        KLoginManager.shared.presentLogin(completion: { (loginSuccess, serviceRegistrated, roles, error) in
                            if loginSuccess{
                                let manager = KNetworkManager.default(true)
                                checkSuccess?(manager)
                            }else{
                                let error = NSError(domain: KInfoPlist.appName, code: response.errorCode, userInfo: [NSLocalizedDescriptionKey : response.message as Any])
                                checkFailure?(error)
                            }
                        })
                    }
                }
            case KResolutionAction.userHaveToAcceptPolicy:
                //USER HAVE TO ACCEPT POLICIES
                if let data = response.data as? [String : AnyObject]{
                    OGLCoreDataMapper.sharedInstance().importAndSave(inCoreData: data, parameters: parameters as? [AnyHashable: Any], loadDataTask: nil)
                }
                checkKrakeError(response, checkFailure: checkFailure)
            default:
                checkKrakeError(response, checkFailure: checkFailure)
            }
        }
        else {
            checkKrakeError(nil, checkFailure: checkFailure)
        }
    }
    
    fileprivate func checkKrakeError(_ responseObject: KrakeResponse?, checkFailure: ((Error) -> Void)? = nil){
        if let response = responseObject{
            switch response.errorCode {
            case KErrorCode.userNotHavePermission:
                Date.networkTimeSync()
            default:
                break
            }
            let error = NSError(domain: KInfoPlist.appName,
                                code: response.errorCode,
                                userInfo: [NSLocalizedDescriptionKey : response.message ?? "", KNEKrakeResponse: response])
            checkFailure?(error)
        }
        else {
            let error = NSError(domain: KInfoPlist.appName, code: KErrorCode.genericError, userInfo: [NSLocalizedDescriptionKey : KLocalization.Error.genericError])
            checkFailure?(error)
        }
    }
    
    fileprivate func parseAndCheckKrakeError(_ errore: Error){
        let error = errore as NSError
        if let data = error.userInfo["com.alamofire.serialization.response.error.data"] as? Data,
            let dic = (try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves)) as? [String : AnyObject]{
            checkKrakeResponse(KrakeResponse(object: dic as AnyObject))
        }
    }


    fileprivate func checkHeaderResponse(_ task : KDataTask){
        if checkHeaderResponse  && task.request.method != .get {
            if let response = task.dataRequest.response,
                   let headers = response.allHeaderFields as? [String : String]{
                   let array = HTTPCookie.cookies(withResponseHeaderFields: headers, for: baseURL)
                   URLConfigurationCookies.shared.parse(cookies: array)
               }
           }
       }
}

extension KNetworkManager  {

    private func createRequest(path: String,
                               method: KMethod,
                               queryItems: [URLQueryItem],
                               parameters: KParamaters?) -> KRequest {
        let request = KRequest()
        request.path = path
        request.method = method
        request.queryParameters = queryItems
        request.parameters = parameters
        return request
    }

    //MARK: - Metodi sovrascritti per gestire gli errori di krake e l'invalidateSessionManager
    @available(*, deprecated, renamed: "request(_:method:parameters:query:successCallback:failureCallback:)")
    public func get(_ URLString: String,
                          parameters: KParamaters?,
                          progress downloadProgress: ((Progress) -> Void)?,
                          success: ((KDataTask, Any?) -> Void)?,
                          failure: ((KDataTask, Error) -> Void)?) -> KDataTask{

        let request = createRequest(path: URLString,
                      method: .get,
                      queryItems: [],
                      parameters: parameters)
        request.downloadProgress = downloadProgress

        return self.request(request,
        successCallback: success,
        failureCallback:  failure)
    }

    @available(*, deprecated, renamed: "request(_:method:parameters:query:successCallback:failureCallback:)")
    public func put(_ URLString: String,
                                   parameters: KParamaters?,
                                   success: ((KDataTask, Any?) -> Void)?,
                                   failure: ((KDataTask, Error) -> Void)?) -> KDataTask {
        let request = createRequest(path: URLString,
                             method: .put,
                             queryItems: [],
                             parameters: parameters)
        return self.request(request,
                            successCallback: success,
                            failureCallback:  failure)
    }

    @available(*, deprecated, renamed: "request(_:method:parameters:query:successCallback:failureCallback:)")
    public func post(_ URLString: String,
                           parameters: KParamaters?,
                           progress uploadProgress: ((Progress) -> Void)?,
                           success: ((KDataTask, Any?) -> Void)?,
                           failure: ((KDataTask, Error) -> Void)?) -> KDataTask {
        let request = createRequest(path: URLString,
        method: .post,
        queryItems: [],
        parameters: parameters)
        request.uploadProgress = uploadProgress

        return self.request(request,
                            successCallback:  success,
                            failureCallback: failure)
    }
}
