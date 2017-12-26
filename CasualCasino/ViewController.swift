//
//  ViewController.swift
//  CasualCasino
//
//  Created by Johnny Curran on 10/13/17.
//  Copyright © 2017 Johnny Curran. All rights reserved.
//

import UIKit

class BlackjackViewController: UIViewController {
    
    // MARK: 

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var card = CardStackView()
        view.addSubview(card)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

