//
//  PhotoSlideshow.swift
//  Marco
//
//  Created by Ky Nguyen on 6/27/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit

class marPhotoSlideshow: knView {

    internal var datasource = [String]()

    lazy var collectionView: UICollectionView = { [weak self] in

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.delegate = self
        cv.dataSource = self
        return cv

        }()

    internal let pageIndex: SnakePageControl = {

        let view = SnakePageControl()
        view.indicatorRadius = 2.5
        view.inactiveTint = UIColor.white.withAlphaComponent(0.4)
        view.indicatorPadding = 8
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private func registerCells() {
        collectionView.register(marSlideCell.self, forCellWithReuseIdentifier: "marSlideCell")
    }

    internal override func setupView() {
        registerCells()

        addSubviews(views: collectionView, pageIndex)
        collectionView.fill(toView: self)
        pageIndex.centerX(toView: collectionView)
        pageIndex.bottom(toView: collectionView, space: -16)

    }

    var timer: Timer?

    func updateDatasource(_ datasource: [String]) {
        self.datasource = datasource
        pageIndex.pageCount = datasource.count
        pageIndex.isHidden = datasource.count == 1
        collectionView.reloadData()
    }


    func startAnimation() {

        let duration: Double = 3
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: true, block: animate)
        } else {
            timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(animate), userInfo: nil, repeats: true)
        }

    }

    @objc private func animate(timer: Timer? = nil) {

        let isLastPage = pageIndex.currentPage == datasource.count - 1
        if isLastPage {
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
            pageIndex.progress = 0
        }
        else {
            collectionView.scrollToItem(at: IndexPath(item: pageIndex.currentPage + 1, section: 0), at: .left, animated: true)
            pageIndex.progress += 1
        }

    }
}




extension marPhotoSlideshow: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / scrollView.frame.size.width
        pageIndex.progress = index
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "marSlideCell", for: indexPath) as! marSlideCell
        cell.data = datasource[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}





class marSlideCell: knCollectionCell {

    var data: String? {
        didSet {

            imageView.downloadImage(from: data, placeholder: #imageLiteral(resourceName: "cover_placeholder"))
        }
    }

    let imageView: UIImageView = {

        let iv = UIImageView(image: UIImage(named: "cover_placeholder"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    override func setupView() {

        addSubviews(views: imageView)
        imageView.fill(toView: self)
    }
    
    
    
}





