//
//  ViewModelType.swift
//  OfferList
//
//  Created by Bowie Tso on 7/7/2024.
//

import Foundation
import RxSwift

protocol InputProtocol{
    
}

protocol OutputProtocol{
    
}

protocol ViewModelType {
    
    associatedtype input
    associatedtype output

    var disposeBag: DisposeBag { get }
    
    func setupBinding()
}
