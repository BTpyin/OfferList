//
//  OfferListTableViewCellViewModel.swift
//  OfferList
//
//  Created by Bowie Tso on 7/7/2024.
//

import Foundation
import SwifterSwift
import RxSwift
import RxCocoa

protocol OfferListTableViewCellViewModelInputProtocol: InputProtocol {
//    var didContentTappedSignal: Signal<Void> { get }
}

protocol OfferListTableViewCellViewModelOutputProtocol: OutputProtocol {
    
    var badge1Driver: Driver<String> { get }
    var badge2Driver: Driver<String> { get }
    var isBadge1HiddenDriver: Driver<Bool> { get }
    var isBadge2HiddenDriver: Driver<Bool> { get }
    var offerImageUrlDriver: Driver<String> { get }
    var stickerImageUrlDriver: Driver<String> { get }
    var isStickerHiddenDriver: Driver<Bool> { get }
    var offerNameDriver: Driver<String> { get }
}


protocol OfferListTableViewCellViewModelProtocol: ViewModelType
where input == OfferListTableViewCellViewModelInputProtocol,
      output == OfferListTableViewCellViewModelOutputProtocol {
    var input: OfferListTableViewCellViewModelInputProtocol { get }
    var output: OfferListTableViewCellViewModelOutputProtocol { get }
    
}
class OfferListTableViewCellViewModel: OfferListTableViewCellViewModelProtocol{
    
    var base: OfferListTableViewCellViewModel {return self}
    var input: OfferListTableViewCellViewModelInputProtocol { return self }
    var output: OfferListTableViewCellViewModelOutputProtocol { return self }
    
    
    let offerData = BehaviorRelay<Offer?>(value: nil)
//    private let isExtraInfoViewHidden = BehaviorRelay(value: true)
    let didContentTapped = PublishRelay<Void>()
    
    
    var disposeBag = DisposeBag()
    
    init() {
        setupBinding()
    }
    
    func setupVm(offer: Offer) {
        offerData.accept(offer)
    }
    
    func setupBinding() {
        base.didContentTapped.bind(with: self, onNext: { this,_ in
//            this.isExtraInfoViewHidden.toggle()
        }).disposed(by: disposeBag)
    
    }
    
}

extension OfferListTableViewCellViewModel: OfferListTableViewCellViewModelInputProtocol {
    
//    var didContentTappedSignal: Signal<Void> {
//        base.didContentTapped.asSignal()
//    }
    
}

extension OfferListTableViewCellViewModel: OfferListTableViewCellViewModelOutputProtocol {

    var badge1Driver: Driver<String>  {
        base.offerData.map{
            $0?.badge1 ?? ""
        }.asDriver(onErrorJustReturn: "")
    }
    
    var badge2Driver: Driver<String>  {
        base.offerData.map{
            $0?.badge2 ?? ""
        }.asDriver(onErrorJustReturn: "")
    }
    
    var isBadge1HiddenDriver: Driver<Bool>  {
        base.offerData.map{
            return ($0?.badge1.isNilOrEmpty ?? true)
        }.asDriver(onErrorJustReturn: true)
    }
    
    var isBadge2HiddenDriver: Driver<Bool>  {
        base.offerData.map{
            return ($0?.badge2.isNilOrEmpty ?? true)
        }.asDriver(onErrorJustReturn: true)
    }
    
    
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
    
    var stickerImageUrlDriver: Driver<String> {
        base.offerData.map{
            $0?.sticker ?? ""
        }.asDriver(onErrorJustReturn: "")
    }
    
    var isStickerHiddenDriver: Driver<Bool>  {
        base.offerData.map{
            return ($0?.sticker.isNilOrEmpty ?? true)
        }.asDriver(onErrorJustReturn: true)
    }
    
}
