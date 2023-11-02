//
//  ViewController.swift
//  DI Part 5 - Moving between ViewControllers
//
//  Created by Red Wang on 2023/11/1.
//

import UIKit

enum PresentType {
    case present
    case push
}

class ViewController: UIViewController {
    
    var pageColor: Color = .red
    var presentType: PresentType?
    
    // MARK: - Subview
    private let nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        nextButton.setTitleColor(.black, for: .normal)
        nextButton.backgroundColor = .systemGray2
        return nextButton
    }()
    private let presentButton: UIButton = {
        let presentButton = UIButton()
        presentButton.setTitle("Present", for: .normal)
        presentButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        presentButton.setTitleColor(.black, for: .normal)
        presentButton.backgroundColor = .systemGray2
        return presentButton
    }()
   
    // MARK: - View Load
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBar()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = pageColor.backgroundColor
        setUpButtons()
        setUpLayouts()
        setUpButtonActions()
    }
    private func setUpNavigationBar() {
        guard let presentType = presentType else { return }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(leaveButtonTapped))
        navigationItem.leftBarButtonItem =  UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(leaveButtonTapped))
        
        if presentType == .push {
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationItem.rightBarButtonItem?.isHidden = true
        } else if presentType == .present {
            navigationItem.leftBarButtonItem?.isEnabled = false
            navigationItem.leftBarButtonItem?.isHidden = true
        }
    }
    private func setUpButtons() {
        if pageColor == Color.allCases.last {
            nextButton.isHidden = true
            nextButton.isEnabled = false
            presentButton.isHidden = true
            presentButton.isEnabled = false
        }
    }
    private func setUpLayouts() {
        view.addSubview(nextButton)
        view.addSubview(presentButton)
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        presentButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            nextButton.widthAnchor.constraint(equalToConstant: 60),
            nextButton.heightAnchor.constraint(equalToConstant: 40),
            
            presentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            presentButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            presentButton.widthAnchor.constraint(equalToConstant: 80),
            presentButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    private func setUpButtonActions() {
        nextButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        presentButton.addTarget(self, action: #selector(presentPage), for: .touchUpInside)
    }
    
    // MARK: - Methods
    @objc private func nextPage() {
        let nextVC = ViewController()
        nextVC.presentType = .push
        
        if let pageIndex = Color.allCases.firstIndex(of: pageColor) {
            nextVC.pageColor = Color.allCases[pageIndex + 1]
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
    }
    @objc private func presentPage() {
        let presentVC = ViewController()
        presentVC.presentType = .present
        let nav = NavigationController(rootViewController: presentVC)
        
        if let pageIndex = Color.allCases.firstIndex(of: pageColor) {
            presentVC.pageColor = Color.allCases[pageIndex + 1]
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    @objc func leaveButtonTapped() {
        if pageColor == Color.allCases.last {
            backToRoot()
        } else if pageColor == Color.green {
            backToOrange()
        } else if self.presentType == .present {
            dismiss(animated: true, completion: nil)
        } else {
            backToPrevious()
        }
    }
    
}

// MARK: - ViewController Leave Methods
extension ViewController {
   
    func backToPrevious() {
        if let navigateVC = self.navigationController {
            navigateVC.popViewController(animated: false)
        }
    }
    
    func backToRoot() {
        if let windowRootVC = NavigationController.shared {
            if let initialVC = NavigationController.shared!.viewControllers.first {
                windowRootVC.popToViewController(initialVC, animated: true)
                windowRootVC.dismiss(animated: false)
            }
        }
    }
    
    func backToOrange() {

        if self.presentType == .present {
            /// The NavigationVC that presented Green VC
            let previousNavVC = self.navigationController?.presentingViewController as? UINavigationController
            
            // 1. Dismiss Green VC
            self.navigationController?.dismiss(animated: false) { [previousNavVC] in
                // 2. Leave PreviousVC of GreenVC
                if let previousVC = previousNavVC?.viewControllers.last as? ViewController {
                    previousVC.leaveButtonTapped()
                }
            }
            
        } else {
          
            if let navigationController = self.navigationController {
                // 1. Pop GreenVC
                navigationController.popViewController(animated: false)
                // 2. Leave PreviousVC of GreenVC
                if let previousVC = navigationController.viewControllers.last as? ViewController {
                    previousVC.leaveButtonTapped()
                }
      
            }
            
        }

    }
    
}
