//
//  ViewController.swift
//  OfferList
//
//  Created by Bowie Tso on 7/7/2024.
//

import UIKit
import RxSwift
import RxCocoa

class OfferListViewController: UIViewController {
    
    let viewModel = OfferListViewControllerViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var sortByExpiryDateView: UIView!
    @IBOutlet weak var sortByExpiryDateSwitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(resource: R.nib.offerListTableViewCell),
                           forCellReuseIdentifier: R.reuseIdentifier.offerListTableViewCell.identifier)
        
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        setNavigationBar(.titleWithoutBarButtonItems(title: "Offer Detail"))
        setupBinding()
        // Do any additional setup after loading the view.
    }
    
    func setupBinding(){

        Driver.combineLatest(
            viewModel.output.offersVmDriver,
            viewModel.output.isSortByExpiryDateDriver).drive(with: self, onNext: { this, _ in
            this.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    @IBAction func didSortByExpiryDateSwitchTapped(_ sender: Any) {
        viewModel.isSortByExpiryDate.toggle()
    }
    
    @objc func refreshTableView(sender:AnyObject)
    {
        viewModel.loadData()
        tableView.refreshControl?.endRefreshing()
    }
}

extension OfferListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.offersViewModelRelay.value.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let offer = viewModel.isSortByExpiryDate.value ?  viewModel.sortedOffersViewModelRelay.value[indexPath.row].offerData.value :
        viewModel.offersViewModelRelay.value[indexPath.row].offerData.value
        let vc = R.storyboard.main.offerDetailViewController()!
        vc.viewModel.setupVm(offer: offer)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cellIdentifier = OfferListTableViewCell.cellIdentifier
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? OfferListTableViewCell else {
                fatalError("The dequeued cell is not an instance of OfferListTableViewCell.")
            }
        cell.setup(vm: viewModel.isSortByExpiryDate.value ? viewModel.sortedOffersViewModelRelay.value[indexPath.row] : viewModel.offersViewModelRelay.value[indexPath.row])
            return cell
    }
    
}
