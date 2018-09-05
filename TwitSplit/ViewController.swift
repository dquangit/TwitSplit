//
//  ViewController.swift
//  TwitSplit
//
//  Created by thuydunq on 9/1/18.
//  Copyright © 2018 dquang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let messageViewController = storyboard.instantiateViewController(withIdentifier: "MessageViewController")
        present(messageViewController, animated: false, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

