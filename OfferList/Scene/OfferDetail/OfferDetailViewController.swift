//
//  OfferDetailViewController.swift
//  OfferList
//
//  Created by Bowie Tso on 7/7/2024.
//

import UIKit
import RxSwift
import RxCocoa

class OfferDetailViewController: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentStackView: UIStackView!
    
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var offerNameLabel: UILabel!
    
    @IBOutlet weak var offerDescriptionLabel: UILabel!
    @IBOutlet weak var expiryDateLabel: UILabel!
    @IBOutlet weak var tncLabel: UILabel!
    
    let viewModel = OfferDetailViewControllerViewModel()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar(.backWithTitle(title: "Offer Detail"))
        setupBinding()
        // Do any additional setup after loading the view.
    }
    
    func setupBinding() {
        viewModel.offerNameDriver
            .drive(offerNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.offerImageUrlDriver
            .drive(offerImageView.rx.imageURL)
            .disposed(by: disposeBag)
        
        viewModel.descriptionDriver
            .drive(offerDescriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        viewModel.tncDriver
            .drive(tncLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.dateDriver
            .drive(expiryDateLabel.rx.text)
            .disposed(by: disposeBag)
        
    }

}
