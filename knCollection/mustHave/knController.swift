//
//  knController.swift
//  Ogenii
//
//  Created by Ky Nguyen on 3/17/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit
class knController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    func setupView() { }
    func fetchData() { }
    deinit {
        print("Deinit \(NSStringFromClass(type(of: self)))")
        removeKeyboardNotificationListeners()
    }
}



class knCollectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        registerCells()
    }
    
    init() { super.init(collectionViewLayout: UICollectionViewFlowLayout()) }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    
    func registerCells() { }
    func setupView() { }
    func fetchData() { }
    
    deinit { print("Deinit \(NSStringFromClass(type(of: self)))") }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return 0 }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { return UICollectionViewCell() }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { return 0 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { return UIScreen.main.bounds.size }
}



class knTableController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        automaticallyAdjustsScrollViewInsets = false
        registerCells()
    }
    
    func setupView() { }
    func registerCells() { }
    func fetchData() { }
    deinit {
        print("Deinit \(NSStringFromClass(type(of: self)))")
        removeKeyboardNotificationListeners()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 0 }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { return UITableViewCell() }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 100 }
}



class knCustomTableController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        automaticallyAdjustsScrollViewInsets = false
        registerCells()
    }
    
    lazy var tableView: UITableView = { [weak self] in
        
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.separatorStyle = .none
        tb.showsVerticalScrollIndicator = false
        tb.dataSource = self
        tb.delegate = self
        return tb
        
        }()
    
    func setupView() { }
    func registerCells() { }
    func fetchData() { }
    
    deinit {
        print("Deinit \(NSStringFromClass(type(of: self)))")
        removeKeyboardNotificationListeners()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 0 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { return UITableViewCell() }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 100 }
}



extension UINavigationController {
    
    func setBarHiddenWhenScrolling(inScrollView scrollView: UIScrollView) {
        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if actualPosition.y > 0 {
            setNavigationBarHidden(false, animated: true)
            return
        }
        setNavigationBarHidden(scrollView.contentOffset.y > 24, animated: true)
    }
    
    func changeTitleFont(_ font: UIFont, color: UIColor = .white) {
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: color,
                                             NSAttributedStringKey.font: font]
    }
    
    func removeBottomSeparator(color: UIColor = .white, titleColor: UIColor = .black) {
        navigationBar.setBackgroundImage(UIImage.imageFromColor(colour: color), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = titleColor
    }
    
    func fillNavigationBar(withColors colors: [CGColor],
                           startPoint: CGPoint = CGPoint(x: 0, y: 0),
                           endPoint: CGPoint = CGPoint(x: 1, y: 1)) {
        
        let gradientLayer = CAGradientLayer()
        var updatedFrame = navigationBar.bounds
        updatedFrame.size.height += 20
        gradientLayer.frame = updatedFrame
        gradientLayer.colors = colors
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        let image = gradientLayer.renderImage()
        navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
    }
}

extension CALayer {
    func renderImage() -> UIImage? {
        UIGraphicsBeginImageContext(bounds.size)
        render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
