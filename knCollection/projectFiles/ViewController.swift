//
//  ViewController.swift
//  knCollection
//
//  Created by Ky Nguyen on 10/12/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        testControl()
    }
    
    func testControl() {
        let tagView = knTagView()
        view.addSubview(tagView)
        tagView.fill(toView: view)
    }

}

