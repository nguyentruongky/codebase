//
//  MainViewController.swift
//  kLibrary
//
//  Created by Ky Nguyen on 1/26/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//


import UIKit

class MainViewController: UIViewController, knPageViewDelegate {

    fileprivate let contentImages = ["nature_pic_1.png",
        "nature_pic_2.png",
        "nature_pic_3.png",
        "nature_pic_4.png"];
    
    let contentText = ["Saigon", "Can Tho", "Ha Noi", "Da Nang"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pageController = knPageViewController()
        pageController.delegate = self
        pageController.setupController(contentImages.count)
        
        addChildViewController(pageController)
        self.view.addSubview(pageController.view)
    }
    
    func getPageItemAtIndex(_ index: Int) -> UIViewController {
        
        let pageItemController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ItemController") as! knPageItemController
        pageItemController.itemIndex = index
        pageItemController.imageName = contentImages[index]
        pageItemController.placeName = contentText[index]
        return pageItemController
    }
}

class knPageItemController: UIViewController {
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet var contentImageView: UIImageView!
    
    var itemIndex: Int = 0
    var imageName: String = "" {
        didSet {
            guard let imageView = contentImageView else { return }
            imageView.image = UIImage(named: imageName)
        }
    }
    
    var placeName : String = "" {
        didSet {
            guard let place = placeNameLabel else { return }
            place.text = placeName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentImageView!.image = UIImage(named: imageName)
        placeNameLabel!.text = placeName
    }
}

protocol knPageViewDelegate {
    func getPageItemAtIndex(_ index: Int) -> UIViewController
}

class knPageViewController:  UIViewController, UIPageViewControllerDataSource {
    
    var didShowPageControl = false
    
    var contentCount = 0
    
    var delegate: knPageViewDelegate?
    
    func setupController(_ numberOfContent: Int) {
        
        contentCount = numberOfContent
        
        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        
        if contentCount > 0 {
            let firstController = getItemController(0)!
            let startingViewControllers: NSArray = [firstController]
            pageController.setViewControllers(startingViewControllers as? [UIViewController], direction: .forward, animated: false, completion: nil)
        }
        
        addChildViewController(pageController)
        view.addSubview(pageController.view)
        
        if didShowPageControl == true {
            setupPageControl()
        }
    }
    
    fileprivate func setupPageControl() {
        
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.gray
        appearance.currentPageIndicatorTintColor = UIColor.white
        appearance.backgroundColor = UIColor.darkGray
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! knPageItemController
        guard itemController.itemIndex > 0 else { return nil }
        return getItemController(itemController.itemIndex - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! knPageItemController
        guard itemController.itemIndex + 1 < contentCount else { return nil }
        return getItemController(itemController.itemIndex + 1)
    }
    
    fileprivate func getItemController(_ itemIndex: Int) -> knPageItemController? {
        guard itemIndex < contentCount else { return nil }
        return delegate?.getPageItemAtIndex(itemIndex) as? knPageItemController
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        guard didShowPageControl == false else { return contentCount }
        return 0
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
}
