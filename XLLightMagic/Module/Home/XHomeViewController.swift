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
    
    //设置默认布局，具体设置请查看LTLayout类
    
    
    lazy var settingView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: UIDevice.xd_safeDistanceTop(), width: view.width, height: SettingBarHeight))
           view.backgroundColor = UIColor.themeBackground
           view.addSubview(self.button)
           return view
       }()

       lazy var button: UIButton = {
           let button = UIButton()
           button.frame = CGRectMake(0, 0, SettingBarHeight, SettingBarHeight)
           button.setImage(UIImage(named: "icon_home_setting"), for: .normal)
           button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
           return button
       }()
    
    private lazy var titleView: XPageTitleView = {
        let layout = XPageLayout()
        layout.bottomLineColors = UIColor.gradientColors
        layout.titleViewBgColor = UIColor.themeBackground
        let titleView = XPageTitleView(frame: CGRect(x: 0, y:UIDevice.xd_safeDistanceTop()+SettingBarHeight , width: view.width, height: layout.sliderHeight), titles: ["测试","哈哈哈哈哈哈","asdasd","asdasd","asdasd"], layout: layout, itemViewClass: nil)
        return titleView
    }()
    
    private lazy var titles: [String] = {
        return ["此处标题View支持", "自定义", "查看", "LTPageView具体使用"]
    }()
    
    private lazy var viewControllers: [UIViewController] = {
        var vcs = [UIViewController]()
        for _ in titles {
            vcs.append(TestVC())
        }
        return vcs
    }()
    
    private lazy var layout: XPageLayout = {
        let layout = XPageLayout()
        layout.bottomLineColors = UIColor.gradientColors
        layout.titleViewBgColor = UIColor.themeBackground
        layout.bottomLineCornerRadius = 2.0
        layout.isColorAnimation = true
        layout.lrMargin = 20
        layout.sliderWidth = 40
        
        return layout
    }()
    
    private func managerReact() -> CGRect {
        let Y: CGFloat = UIDevice.xd_safeDistanceTop()+46
        let H: CGFloat = view.height - Y - UIDevice.xp_safeDistanceBottom()
        return CGRect(x: 0, y: Y, width: view.bounds.width, height: H)
    }
    
    private lazy var simpleManager: XPageLayoutManager = {
        let simpleManager = XPageLayoutManager(frame: managerReact(), viewControllers: viewControllers, titles: titles, currentViewController: self, layout: layout/*, itemViewClass: LTCustomTitleItemView.self*/)
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
            let headerView = strongSelf.testLabel()
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

extension XHomeViewController: LTSimpleScrollViewDelegate {
    
    //MARK: 滚动代理方法
    func glt_scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print("offset -> ", scrollView.contentOffset.y)
    }
    
    //MARK: 控制器刷新事件代理方法
    func glt_refreshScrollView(_ scrollView: UIScrollView, _ index: Int) {
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
    private func testLabel() -> UILabel {
        let headerView = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 180))
        headerView.backgroundColor = UIColor.red
        headerView.text = "点击响应事件"
        headerView.textColor = UIColor.white
        headerView.textAlignment = .center
        headerView.isUserInteractionEnabled = true
        headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(_:))))
        return headerView
    }
}
