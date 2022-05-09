//
//  LaunchVC.swift
//  Kudu
//
//  Created by Admin on 05/05/22.
//

import UIKit

class LaunchVC:BaseVC
{
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testLabel.text = "Hello".localiz()
    }
    
}
