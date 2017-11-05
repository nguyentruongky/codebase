//
//  MarcoManagerNew.swift
//  Marco
//
//  Created by Ky Nguyen on 7/28/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit



class knTabController: knController {
    
    var pages = [UIViewController]()
    var buttons = [UIButton]()
    var selectedIndex = 0
    
    lazy var tabBar: knTabBarView = {
        let view = knTabBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.homeButton.addTarget(self, action: #selector(showHome))
        view.messageButton.addTarget(self, action: #selector(showMessages))
        view.favouriteButton.addTarget(self, action: #selector(showFavourite))
        view.profileButton.addTarget(self, action: #selector(showProfile))
        return view
    }()

    func showHome() {
        changePage(to: 0)
    }

    func showMessages() {
        changePage(to: 1)
    }

    func showFavourite() {
        changePage(to: 1)
    }

    func showProfile() {
        changePage(to: 3)
    }
    
    func changePage(to index: Int) {
        
        if marSetting.didLogin == false && index != 0 {
            showLogin()
            return
        }
        
        isFavouriteBarHidden = true
        markAllNotificationRead()
        
        removePage(pages[selectedIndex])
        buttons[selectedIndex].tintColor = marColor.mar_141
        buttons[2].tintColor = marColor.mar_141

        addPage(pages[index])
        buttons[index].tintColor = marColor.mar_182_152_90_gold

        setProfileSelected(selected: index == 3)

        selectedIndex = index
    }
    
    let home = UINavigationController(rootViewController: UIViewController())
    let message = UINavigationController(rootViewController: UIViewController())
    let favourite = UINavigationController(rootViewController: UIViewController())
    let profile = UINavigationController(rootViewController: UIViewController())
    let containerView = knUIMaker.makeView()
    var containerHeight: NSLayoutConstraint? // update when tab bar hidden or shown
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func setupView() {

        pages = [home, message, favourite, profile]
        buttons = [tabBar.homeButton, tabBar.messageButton, tabBar.favouriteButton, tabBar.profileButton]
        
        view.addSubviews(views: containerView, tabBar, overlayButton, favouriteBar)
        
        containerView.horizontal(toView: view)
        containerView.top(toView: view)
        containerHeight = containerView.height(screenHeight - 49)
        
        tabBar.horizontal(toView: view)
        tabBar.bottom(toView: view)
        tabBar.height(49)
        
        addPage(home)
    }
    
    private func addPage(_ page: UIViewController) {
        containerView.addSubview(page.view)
        page.view.frame = containerView.bounds
        addChildViewController(page)
        page.didMove(toParentViewController: self)
    }
    
    private func removePage(_ page: UIViewController) {
        page.willMove(toParentViewController: nil)
        page.view.removeFromSuperview()
        page.removeFromParentViewController()
    }

}

class knTabBarView: knView {
    
    let homeButton = knUIMaker.makeButton()
    let messageButton = knUIMaker.makeButton()
    let favouriteButton = knUIMaker.makeButton()
    let profileButton = knUIMaker.makeButton()
    
    override func setupView() {
        addSubviews(views: homeButton, messageButton, favouriteButton, profileButton)
        
        addConstraints(withFormat: "H:|[v0][v1][v2][v3]|", views: homeButton, messageButton, favouriteButton, profileButton)
        homeButton.vertical(toView: self)
        messageButton.vertical(toView: homeButton)
        favouriteButton.vertical(toView: homeButton)
        profileButton.vertical(toView: homeButton)
        
        homeButton.width(screenWidth / 4)
        messageButton.width(toView: homeButton)
        favouriteButton.width(toView: homeButton)
        profileButton.width(toView: homeButton)
        
        let separator = knUIMaker.makeLine()
        addSubviews(views: separator)
        separator.horizontal(toView: self)
        separator.top(toView: self)
        
        backgroundColor = .white
    }
}
















