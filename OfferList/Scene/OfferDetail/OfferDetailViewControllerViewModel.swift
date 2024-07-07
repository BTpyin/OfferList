//
//  OfferDetailViewControllerViewModel.swift
//  OfferList
//
//  Created by Bowie Tso on 7/7/2024.
//

import Foundation
import RxSwift
import RxCocoa


protocol OfferDetailViewControllerViewModelInputProtocol: InputProtocol {
    
}

protocol OfferDetailViewControllerViewModelOutputProtocol: OutputProtocol {

    var offerImageUrlDriver: Driver<String> { get }
    var offerNameDriver: Driver<String> { get }
    var descriptionDriver: Driver<String> { get }
    var dateDriver: Driver<String> { get }
    var tncDriver: Driver<String> { get }
    
}

protocol OfferDetailViewControllerViewModelProtocol: ViewModelType
where input == OfferDetailViewControllerViewModelInputProtocol,
      output == OfferDetailViewControllerViewModelOutputProtocol {
    var input: OfferDetailViewControllerViewModelInputProtocol { get }
    var output: OfferDetailViewControllerViewModelOutputProtocol { get }
    
}

class OfferDetailViewControllerViewModel: OfferDetailViewControllerViewModelProtocol {
    
    var base: OfferDetailViewControllerViewModel {return self}
    var input: OfferDetailViewControllerViewModelInputProtocol { return self }
    var output: OfferDetailViewControllerViewModelOutputProtocol { return self }
    
    private let offerData = BehaviorRelay<Offer?>(value: nil)
    
    var disposeBag = DisposeBag()
    
    init() {
        setupBinding()
    }
    
    func setupVm(offer: Offer?) {
        offerData.accept(offer)
    }
    
    func setupBinding() {
        
    }
    
}

extension OfferDetailViewControllerViewModel: OfferDetailViewControllerViewModelInputProtocol {
    
}

extension OfferDetailViewControllerViewModel: OfferDetailViewControllerViewModelOutputProtocol {

    var offerNameDriver: Driver<String> {
        base.offerData.map{
            $0?.offerName ?? ""
        }.asDriver(onErrorJustReturn: "")
    }
    
    var offerImageUrlDriver: Driver<String> {
        base.offerData.map{
            $0?.offerAppImageURL ?? ""
        }.asDriver(onErrorJustReturn: "")
    }
    
    var descriptionDriver: Driver<String> {
        base.offerData.map{
            $0?.description ?? ""
        }.asDriver(onErrorJustReturn: "")
    }
    
    var tncDriver: Driver<String> {
        base.offerData.map{
            $0?.tnc ?? ""
        }.asDriver(onErrorJustReturn: "")
    }
    
    var dateDriver: Driver<String> {
        base.offerData.map { (offer) in
            let inputDateFormatter = DateFormatter()
            inputDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
            if let date = inputDateFormatter.date(from: (offer?.endDate ?? "")) {
                let formattedDateString = outputDateFormatter.string(from: date)
                return formattedDateString
            } else {
                return ""
            }
        }.asDriver(onErrorJustReturn: "")
    }
}

