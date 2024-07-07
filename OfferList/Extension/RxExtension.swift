//
//  RxExtension.swift
//  OfferList
//
//  Created by Bowie Tso on 7/7/2024.
//
import Foundation
import Kingfisher
import RxCocoa
import RxSwift
import Moya

extension ObservableType where Element == String {
    
    func mapAPIObject<T: Codable>(element: T.Type, retry: Bool = true) -> Observable<T> {
        return self.flatMap { jsonStr -> Observable<T> in
            guard let data = jsonStr.data(using: .utf8) else { return .error(NSError())}
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                let responseModel = try jsonDecoder.decode(T.self, from: data)
                return .just(responseModel)
            } catch {
                print("MapObject: \(element)")
                print("Error: \(error)")
                return .error(error)
            }
        }
    }
    
    func autoHandlingGeneralAPIError<T:Codable>(_ retryTimes: Int, modelType: T.Type) -> Observable<String> {
        return self.flatMap { jsonString -> Observable<String> in
            if let responseModel  = (try? JSONDecoder().decode(T.self, from: jsonString.data(using: .utf8) ?? Data())) {
                print("can map to api response model")
            } else {
                print("this is API error")
                print(jsonString)
                return .just(jsonString)
            }
            
            return .just(jsonString)
        }.catch({ (error) -> Observable<String> in
            
            if let responseError = error as? MoyaError,
               let statusCode = responseError.response?.statusCode {
                
                switch statusCode {
                case 200..<300:
                    print("HTTP Status code success")
                case 400..<500:
                    print("HTTP Status code client error")
                case 500..<600:
                    print("HTTP Status code server error")
                default:
                    print("HTTP undefined error")
                }
            }
            return Observable.error(error)
        })
            .retry { (rxError: Observable<Error>) -> Observable<Int> in
            return rxError.enumerated().flatMap { (index, error) -> Observable<Int> in
                guard index < retryTimes else {
                    return Observable.error(error)
                }
                return Observable<Int>.timer(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            }
        }
    }
}

extension Reactive where Base: UIImageView {
    public var imageURL: Binder<String> {
        return Binder(base, binding: { (imageView, urlString) in
            guard !urlString.isEmpty else { return }
            do {
                let url = try urlString.asURL()
                imageView.kf.setImage(
                    with: url,
                    placeholder: UIImage(color: .white, size: imageView.size),
                    options: [.cacheOriginalImage], completionHandler:  { result in
                        switch result {
                        case .success(let value):
                            let image = value.image
                            imageView.image = image
                        case .failure(let error):
                            print("Job failed: \(error.localizedDescription)")
                        }
                    })
            } catch {
                print(error.localizedDescription)
                
            }
        })
    }
}

extension BehaviorRelay where Element == Bool {
    func toggle() {
        self.accept(!self.value)
    }
}
