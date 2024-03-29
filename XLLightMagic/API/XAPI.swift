//
//  XAPI.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/20.
//

import Moya
import HandyJSON
import MBProgressHUD

//MARK: loading插件，组合API请求，可在请求中自动补充loading
let LoadingPlugin = NetworkActivityPlugin { (type, target) in
//    guard let vc = topVC else { return }
    switch type {
    case .began:
//        MBProgressHUD.hide(for: vc.view, animated: false)
//        MBProgressHUD.showAdded(to: vc.view, animated: true)
        XHUD.x_hideHUD()
        XHUD.showActivityLoading()

    case .ended:
//        MBProgressHUD.hide(for: vc.view, animated: true)
        XHUD.x_hideHUD()

    }
}
//MARK: 超时中间件
let timeoutClosure = {(endpoint: Endpoint, closure: MoyaProvider<XApi>.RequestResultClosure) -> Void in
    
    if var urlRequest = try? endpoint.urlRequest() {
        urlRequest.timeoutInterval = 20
        closure(.success(urlRequest))
    } else {
        closure(.failure(MoyaError.requestMapping(endpoint.url)))
    }
}

//MARK: 无loading请求
let ApiProvider = MoyaProvider<XApi>(requestClosure: timeoutClosure)
//MARK: 有loading请求
let ApiLoadingProvider = MoyaProvider<XApi>(requestClosure: timeoutClosure, plugins: [LoadingPlugin])

//MARK: API定义
enum XApi {
    
    case chapter(chapter_id: Int)//章节内容
}

extension XApi: TargetType {
    
    var baseURL: URL { return URL(string: "https://jsonplaceholder.typicode.com/posts")! }
    
    var path: String {
        switch self {
        case .chapter: return ""
        }
    }
    
    var method: Moya.Method { return .get }
    var task: Task {
        var parmeters: [String : Any] = [:]
        switch self {
       
        case .chapter(let chapter_id):
            parmeters["chapter_id"] = chapter_id
            
//        default: break
        }
        
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
    
    var sampleData: Data { return "".data(using: String.Encoding.utf8)! }
    var headers: [String : String]? { return nil }
}

//MARK: 请求结果模型解析
extension Response {
    func mapModel<T: HandyJSON>(_ type: T.Type) throws -> T {
        let jsonString = String(data: data, encoding: .utf8)
        guard let model = JSONDeserializer<T>.deserializeFrom(json: jsonString) else {
            throw MoyaError.jsonMapping(self)
        }
        return model
    }
}

//MARK: 统一请求封装
extension MoyaProvider {
    @discardableResult
    public func request<T: HandyJSON>(_ target: Target,
                                    model: T.Type,
                                    completion: ((_ returnData: T?) -> Void)?) -> Cancellable? {
        
        return request(target, completion: { (result) in
            guard let completion = completion else { return }
            guard let returnData = try? result.value?.mapModel(ResponseData<T>.self) else {
                completion(nil)
                return
            }
            completion(returnData.data?.returnData)
        })
    }
}
