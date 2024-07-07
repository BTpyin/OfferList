//
//  OfferListTableViewCell.swift
//  OfferList
//
//  Created by Bowie Tso on 7/7/2024.
//

import UIKit
import SwifterSwift
import RxSwift
import RxCocoa

class OfferListTableViewCell: UITableViewCell {

    static let cellIdentifier = "OfferListTableViewCell"
    
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var stickerImageView: UIImageView!
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var bagdesStackView: UIStackView!
    
    @IBOutlet weak var badge1View: UIView!
    @IBOutlet weak var badge1Label: UILabel!
    @IBOutlet weak var badge2View: UIView!
    @IBOutlet weak var badge2Label: UILabel!
    
    @IBOutlet weak var offerNameLabel: UILabel!
    
    @IBOutlet weak var favouriteView: UIView!
    @IBOutlet weak var isFavouriteImageView: UIImageView!
    
    var viewModel = OfferListTableViewCellViewModel()
    
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        
        isFavouriteImageView.dropShadow(color: .black, opacity: 0.1, offSet: .zero, radius: 2)
        cellContentView.roundCorners(.allCorners, radius: 20)
        cellContentView.dropShadow(color: .black, opacity: 0.2, offSet: .zero, radius: 3)
        badge1View.roundCorners([ .bottomRight], radius: 12)
        badge2View.roundCorners([ .bottomRight], radius: 12)
    }

    func setup(vm: OfferListTableViewCellViewModel) {
       viewModel = vm
        setupBinding()
    }
    
    func setupBinding(){
        
        viewModel.offerNameDriver
            .drive(offerNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.offerImageUrlDriver
            .drive(offerImageView.rx.imageURL)
            .disposed(by: disposeBag)
        
        viewModel.stickerImageUrlDriver
            .drive(stickerImageView.rx.imageURL)
            .disposed(by: disposeBag)
        
        viewModel.badge1Driver
            .drive(badge1Label.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.badge2Driver
            .drive(badge2Label.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isBadge1HiddenDriver
            .drive(badge1View.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.isBadge2HiddenDriver
            .drive(badge2View.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.isStickerHiddenDriver
            .drive(stickerImageView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
