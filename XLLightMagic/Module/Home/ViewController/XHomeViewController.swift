//
//  XHomeViewController.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/29.
//

import Foundation
import UIKit

//设置栏高度
let SettingBarHeight = 46.0

class XHomeViewController:XBaseViewController{
    
    //设置默认布局，具体设置请查看XPageConfig类
    lazy var settingView: XHomeTopView = {
        let view = XHomeTopView()
        return view
    }()
    
    lazy var bannerView: XHomeBannerView = {
        let view = XHomeBannerView()
        return view
    }()
    
    private lazy var titles: [String] = {
        return ["证件照", "拼图"]
    }()
    
    private lazy var viewControllers: [UIViewController] = {
        return [XHomePuzzleListViewController(),XHomePuzzleListViewController()]
    }()
    
    private lazy var layout: XPageConfig = {
        let layout = XPageConfig()
        layout.bottomLineColors = [UIColor.mainBlueColor]
        layout.titleViewBgColor = UIColor.themeBackground
        layout.bottomLineCornerRadius = 2.0
        layout.isColorAnimation = true
        layout.lrMargin = 20
        layout.sliderWidth = 40
        layout.titleFont = UIFont.PingFangSemiBold(size: 15)
        layout.scale = 1.2
        layout.titleMargin = 35
        return layout
    }()
    
    private func managerReact() -> CGRect {
        let Y: CGFloat = UIDevice.xd_safeDistanceTop()
        let H: CGFloat = view.height - Y - UIDevice.xp_safeDistanceBottom()
        return CGRect(x: 0, y: Y, width: view.bounds.width, height: H)
    }
    
    private lazy var simpleManager: XPageLayoutManager = {
        let simpleManager = XPageLayoutManager(frame: managerReact(), viewControllers: viewControllers, titles: titles, currentViewController: self, layout: layout)
        /* 设置代理 监听滚动 */
        simpleManager.delegate = self
        return simpleManager
    }()
    
    override func configUI() {
        view.addSubview(self.settingView)
        view.addSubview(self.simpleManager)
        simpleManagerConfig()
    }
    
    
    
}

extension XHomeViewController{
    
    @objc func buttonTapped() {
        print("Button tapped!")
        // 在这里添加按钮点击事件的处理代码
    }

}

extension XHomeViewController {
    
    //MARK: 具体使用请参考以下
    private func simpleManagerConfig() {
        
        //MARK: headerView设置
        simpleManager.configHeaderView {[weak self] in
            guard let strongSelf = self else { return nil }
            let headerView = strongSelf.headView()
            return headerView
        }
        
        //MARK: pageView点击事件
        simpleManager.didSelectIndexHandle { (index) in
            print("点击了 \(index) 😆")
        }
        
    }
    
    @objc private func tapLabel(_ gesture: UITapGestureRecognizer)  {
        print("tapLabel☄")
    }
}

extension XHomeViewController: XSimpleScrollViewDelegate {
    
    //MARK: 滚动代理方法
    func x_scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print("offset -> ", scrollView.contentOffset.y)
    }
    
    //MARK: 控制器刷新事件代理方法
    func x_refreshScrollView(_ scrollView: UIScrollView, _ index: Int) {
        //注意这里循环引用问题。
//        scrollView.mj_header = MJRefreshNormalHeader {[weak scrollView] in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//                print("对应控制器的刷新自己玩吧，这里就不做处理了🙂-----\(index)")
//                scrollView?.mj_header.endRefreshing()
//            })
//        }
    }
}

extension XHomeViewController {
    
    private func headView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 236))
        view.addSubview(self.settingView)
        view.addSubview(self.bannerView)
        
        settingView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(46)
        }
        
        bannerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(settingView.snp_bottom)
            make.height.equalTo(188)
        }
        
        return view
    }
    
    
   
    
}
