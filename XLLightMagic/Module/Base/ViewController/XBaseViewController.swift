//
//  XBaseViewCOntroller.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/20.
//


import UIKit
import SnapKit
import Reusable
import Kingfisher

class XBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.themeBackground
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigationBar()
    }
    
    func configUI() {}
    
    func configNavigationBar() {
        guard let navi = navigationController else { return }
        
        if navi.visibleViewController == self {
            navi.barStyle(.clear)
            navi.disablePopGesture = true
            navi.setNavigationBarHidden(true, animated: true)
            if navi.viewControllers.count > 1 {
                navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back_white"),
                                                                   target: self,
                                                                   action: #selector(pressBack))
            }
        }
    }
    
    @objc func pressBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension XBaseViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
