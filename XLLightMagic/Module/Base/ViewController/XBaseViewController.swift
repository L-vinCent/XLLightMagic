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

typealias DidNavClickClosure = () -> Void

class XBaseViewController: UIViewController {

    var didNavClickHandle:DidNavClickClosure?
    //是否隐藏导航栏
    var navBarHidden:Bool = true{
        didSet{
            guard let navi = navigationController else { return }
            navi.setNavigationBarHidden(navBarHidden, animated: false)

        }
    }
    
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

//自定义导航栏
extension XBaseViewController {
    
    //添加自定义view
    func addCustomNavView(title:String?) -> UIView{
        
        lazy var navHead:UIView = {
            let view = UIView(frame: CGRect.init(x: 0, y: UIDevice.xd_safeDistanceTop(), width:XScreenWidth, height: UIDevice.xp_navigationBarHeight()))
            let btn = UIButton(frame: CGRect.init(x: 15, y: 0, width: 24, height: 24))
            btn.extendEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            btn.addTarget(self, action: #selector(navTapped), for: .touchUpInside)
            btn.setImage(UIImage(named: "nav_back_white"), for: .normal)
            btn.centerY = view.height/2
            
            view.addSubview(btn)
            
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: view.height))
            titleLabel.textColor = UIColor.fontWhiteColor
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.PingFangMedium(size: 18)
            titleLabel.text = title
            titleLabel.centerX = view.centerX
            view.addSubview(titleLabel)
            
            return view
        }()
        self.navBarHidden = true
        view.addSubview(navHead)
        return navHead
    }
    
    @objc func navTapped() {
        print("Button tapped!")
        self.didNavClickHandle?()
    }

    
}
