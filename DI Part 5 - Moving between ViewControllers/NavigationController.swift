//
//  NavigationController.swift
//  DI Part 5 - Moving between ViewControllers
//
//  Created by Red Wang on 2023/11/2.
//

import UIKit

class NavigationController: UINavigationController {
    
    static var shared: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navBarAppearance = UINavigationBarAppearance()
        self.navigationBar.standardAppearance = navBarAppearance
        self.navigationBar.scrollEdgeAppearance = navBarAppearance
        self.modalPresentationStyle = .fullScreen
    }
}
