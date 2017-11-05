//
//  GalleryView.swift
//  Marco
//
//  Created by Ky Nguyen on 8/24/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit

class marPhotoGalleryController: knController {
    
    weak var addPhotoController: marAddListingAddPhotosController?
    
    var maximumSelection = 5
    
    var datasource = [UIImage]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    lazy var collectionView: UICollectionView = { [weak self] in
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        return cv
        
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        registerCells()
        setupView()
        fetchData()
    }
    
    let addButton = knUIMaker.makeButton(title: "Add", titleColor: .black)
    
    func handleAdd() {
        
    }
    
    override func setupView() {
        
        addBackButton(tintColor: marColor.mar_74)
        navigationController?.changeTitleFont(marFont.font(name: .openSans_Light, size: 17), color: marColor.mar_18_21_24)
        navigationItem.title = "Camera Rolls"
        let addBarButton = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = addBarButton
        
        view.addSubview(collectionView)
        collectionView.fill(toView: view)
    }
    
    func registerCells() {
        collectionView.register(marPhotoCell.self, forCellWithReuseIdentifier: "marPhotoCell")
    }

    var selectedIndexes = [Int]() {
        didSet {
            addButton.isHidden = selectedIndexes.count == 0
            addButton.setTitle("ADD \(selectedIndexes.count)", for: .normal)
        }
    }
}


extension marPhotoGalleryController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "marPhotoCell", for: indexPath) as! marPhotoCell
        cell.data = datasource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? marPhotoCell else { return }
        if cell.isChecked == false && selectedIndexes.count == maximumSelection { return }
        
        cell.isChecked = !cell.isChecked
        if cell.isChecked == true {
            selectedIndexes.append(indexPath.row)
        }
        else {
            if let index = selectedIndexes.index(of: indexPath.row) {
                selectedIndexes.remove(at: index)
            }
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = screenWidth / 4 - 1
        return CGSize(width: width, height: width)
    }
}


class marPhotoCell: knCollectionCell {
    
    var isChecked: Bool = false {
        didSet {
            imageView.createBorder(isChecked ? 2 : 0, color: marColor.mar_182_152_90_gold)
            checkIcon.isHidden = !isChecked
        }
    }
    
    var data: UIImage? { didSet { imageView.image = data } }
    
    let checkIcon = knUIMaker.makeImageView(image: UIImage(named: "check"))
    let imageView = knUIMaker.makeImageView()
    
    override func setupView() {
        addSubviews(views: imageView, checkIcon)
        imageView.fill(toView: self)
        
        checkIcon.square(edge: 15)
        checkIcon.topRight(toView: self, top: 7, right: -7)
    }
}









