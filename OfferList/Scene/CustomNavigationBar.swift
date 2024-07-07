//
//  CustomNavigationBar.swift
//  OfferList
//
//  Created by Bowie Tso on 7/7/2024.
//
import UIKit
import SwifterSwift

enum OfferListNavigationBarStyle {
    case titleWithoutBarButtonItems(title: String)
    case backWithTitle(title: String)
    case none
}

class OfferListBarButtonItem: UIBarButtonItem  {
    fileprivate var parameter: Any?
}

extension UIViewController {
    func setNavigationBar(_ style: OfferListNavigationBarStyle = .none) {
        if let navigationController = navigationController {
            navigationController.navigationBar.isTranslucent = true
            navigationController.navigationBar.tintColor = UIColor(red: 80, green: 144, blue: 254)

            navigationController.isNavigationBarHidden = false
            navigationController.navigationBar.barTintColor = UIColor(red: 80, green: 144, blue: 254)
            navigationController.navigationBar.isTranslucent = false

            navigationController.navigationBar.layerShadowColor = .black
            navigationController.navigationBar.layerShadowOffset = CGSize(width: 0, height: 0.5)
            navigationController.navigationBar.layerShadowOpacity = 0.2
            navigationController.navigationBar.layer.masksToBounds = false
            navigationController.navigationBar.setColors(background: UIColor(red: 80, green: 144, blue: 254)!, text: .white)
            
            let backBarButton = OfferListBarButtonItem(image: R.image.back()!,
                                                       style: .plain,
                                                       target: self,
                                                       action: #selector(backPressedHandling(_:)))
            backBarButton.tintColor = .white
            
            switch style {
            case .titleWithoutBarButtonItems(let title):
                navigationItem.leftBarButtonItems = []
                navigationItem.rightBarButtonItems = []
                setNavigationBar(title: title)
            case .backWithTitle(let title):
                navigationItem.leftBarButtonItems = [backBarButton]
                navigationItem.rightBarButtonItems = []
                setNavigationBar(title: title)
            default:
                self.hideNavigationBar()
                return
            }
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
            navigationController.interactivePopGestureRecognizer?.delegate = nil
        }
    }
    
    func setNavigationBar(title: String) {
        navigationItem.title = title
    }
    
    func hideNavigationBar(animated: Bool = true) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func showNavigationBar(animated: Bool = false) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: - Actions
    @objc private func backPressedHandling(_ sender: OfferListBarButtonItem) {
        if let action = sender.parameter as? (() -> Void) {
            action()
        } else {
            navigationController?.popViewController()
        }
    }
}

extension UINavigationController {
    func popToRootViewController(animated: Bool, completion: @escaping () -> Void) {
        popToRootViewController(animated: animated)

        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
}
