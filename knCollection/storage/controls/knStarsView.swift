//
//  RateView.swift
//  Ogenii
//
//  Created by Ky Nguyen on 4/10/17.
//  Copyright © 2017 Ogenii. All rights reserved.
//

import UIKit

final class knStarsView: knView {
    
    var ratePoint: Int = 0 {
        didSet {
            for i in 0 ..< ratePoint {
                stars[i].image = #imageLiteral(resourceName: "star_on")
            }
        }
    }
    
    private let stars: [UIImageView] = {
       
        var icons = [UIImageView]()
        
        for i in 0 ..< 5 {
        
            let starImageView: UIImageView = {
                
                let imageName = "star_off"
                let iv = UIImageView(image: UIImage(named: imageName))
                iv.translatesAutoresizingMaskIntoConstraints = false
                iv.contentMode = .scaleAspectFit
                
                iv.clipsToBounds = true
                return iv
            }()
            
            starImageView.size(CGSize(width: 12, height: 11))
            icons.append(starImageView)
        }
        
        return icons
    }()
    
    override func setupView() {
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        for star in stars {
            containerView.addSubview(star)
            star.vertical(toView: containerView)
        }
        
        containerView.addConstraints(withFormat: "H:|[v0]-4-[v1]-4-[v2]-4-[v3]-4-[v4]|",
                                     views: stars[0], stars[1], stars[2], stars[3], stars[4])
        
        
        addSubview(containerView)
        containerView.fill(toView: self)
    }
}
