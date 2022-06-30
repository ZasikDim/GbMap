//
//  LaunchController.swift
//  GBMap
//
//  Created by Dmitry Zasenko on 28.06.22.
//

import UIKit

class LaunchController: UIViewController {
    
    @IBOutlet weak var router: LaunchRouter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router.toAuth()
    }
}

final class LaunchRouter: BaseRouter {
    func toAuth() {
        perform(segue: "toAuth")
    }
}
