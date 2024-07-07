//
//  OfferListViewControllerViewModel.swift
//  OfferList
//
//  Created by Bowie Tso on 7/7/2024.
//

import Foundation
import Foundation
import RxSwift
import RxCocoa


protocol OfferListViewControllerViewModelInputProtocol: InputProtocol {
    var didSortByExpiryDateSwitchTappedSignal: Signal<Void> { get }
}

protocol OfferListViewControllerViewModelOutputProtocol: OutputProtocol {
    var offersVmDriver: Driver<[OfferListTableViewCellViewModel]> { get }
    var isSortByExpiryDateDriver: Driver<Bool> { get }
}

protocol OfferListViewControllerViewModelProtocol: ViewModelType
where input == OfferListViewControllerViewModelInputProtocol,
      output == OfferListViewControllerViewModelOutputProtocol {
    var input: OfferListViewControllerViewModelInputProtocol { get }
    var output: OfferListViewControllerViewModelOutputProtocol { get }
    
}

class OfferListViewControllerViewModel: OfferListViewControllerViewModelProtocol {
    
    
    var base: OfferListViewControllerViewModel {return self}
    var input: OfferListViewControllerViewModelInputProtocol { return self }
    var output: OfferListViewControllerViewModelOutputProtocol { return self }
    
    var disposeBag = DisposeBag()
    let offersViewModelRelay = BehaviorRelay<[OfferListTableViewCellViewModel]>(value: [])
    let sortedOffersViewModelRelay = BehaviorRelay<[OfferListTableViewCellViewModel]>(value: [])
    let didSortByExpiryDateSwitchTapped = PublishRelay<Void>()
    let isSortByExpiryDate = BehaviorRelay<Bool>(value: false)
    
    let isLoading = BehaviorRelay<Bool>(value: true)
    
    init() {
        loadData()
        setupBinding()
    }
    
    func loadData() {
        callApiForAlbumList()
            .disposed(by: disposeBag)
    }
    
    func setupBinding() {
        isSortByExpiryDate.subscribe(with: self, onNext: { (this, isOn) in
            if isOn {
                
            }
        }).disposed(by: disposeBag)
    }
    
    func callApiForAlbumList() -> Disposable {
        return NetworkManager.requestAPI(target: .offerList, type: OfferList?.self)
            .mapAPIObject(element: OfferList?.self)
            .subscribe(with: self, onNext: { (this, offers) in
                
                let offerViewModels: [OfferListTableViewCellViewModel] = offers?.map { offer in
                    let vm = OfferListTableViewCellViewModel()
                    vm.setupVm(offer: offer)
                    return vm
                } ?? []
                
                this.offersViewModelRelay.accept(offerViewModels)
                
                let inputDateFormatter = DateFormatter()
                inputDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let sortedOfferViewModels: [OfferListTableViewCellViewModel] = offers?
                    .sorted { (offer1, offer2) in
                        let date1 = inputDateFormatter.date(from: offer1.endDate ?? "") ?? Date()
                        let date2 = inputDateFormatter.date(from: offer2.endDate ?? "") ?? Date()
                        return date1 < date2
                    }
                    .map { offer in
                        let vm = OfferListTableViewCellViewModel()
                        vm.setupVm(offer: offer)
                        return vm
                    } ?? []
                
                this.sortedOffersViewModelRelay.accept(sortedOfferViewModels)
                
                
            }, onError: { (this, error) in
                print("callApiForAlbumList: \(error)")
                this.isLoading.accept(false)
            })
    }
    
}

extension OfferListViewControllerViewModel: OfferListViewControllerViewModelInputProtocol {
    
    var didSortByExpiryDateSwitchTappedSignal: Signal<Void> {
        base.didSortByExpiryDateSwitchTapped.asSignal()
    }
    
}

extension OfferListViewControllerViewModel: OfferListViewControllerViewModelOutputProtocol {
    var offersVmDriver: Driver<[OfferListTableViewCellViewModel]> {
        base.offersViewModelRelay
            .asDriver()
    }
    
    var isLoadingDriver: Driver<Bool> {
        base.isLoading
            .asDriver()
    }
    
    var isSortByExpiryDateDriver: Driver<Bool> {
        base.isSortByExpiryDate
            .asDriver()
    }
    
}
