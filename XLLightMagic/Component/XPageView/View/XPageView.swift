//
//  XPageView.swift
//  XLLightMagic
//
//  Created by admin on 2024/4/1.
//

import UIKit

public typealias PageViewDidSelectIndexBlock = (XPageView, Int) -> Void
public typealias AddChildViewControllerBlock = (Int, UIViewController) -> Void

@objc public protocol XPageViewDelegate: AnyObject {
    @objc optional func x_scrollViewDidScroll(_ scrollView: UIScrollView)
    @objc optional func x_scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    @objc optional func x_scrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
    @objc optional func x_scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    @objc optional func x_scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    @objc optional func x_scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
}

//MARK: XPageView相关的接口见此处
@objc protocol XPageViewHeaders: NSObjectProtocol {
    
    //MARK: 构造方法
    @objc init(frame: CGRect, currentViewController: UIViewController, viewControllers:[UIViewController], titles: [String], layout: XPageConfig, itemViewClass: XPageTitleItem.Type?)
    
    //MARK: 选中了第几个位置
    @objc var didSelectIndexBlock: PageViewDidSelectIndexBlock? { get }
    
    //MARK: 添加完子控制器回调
    @objc var addChildVcBlock: AddChildViewControllerBlock? { get }
    
    //MARK: 点击切换滚动过程动画
    @objc var isClickScrollAnimation: Bool { get }
    
    //MARK: pageView代理
    @objc weak var delegate: XPageViewDelegate? { get }
}

public class XPageView: UIView, XPageViewHeaders {
    //当前的控制器
    private weak var currentViewController: UIViewController?
    
    //控制器数组
    private var viewControllers: [UIViewController]
    
    //标题数组
    private var titles: [String]
    
    //设置默认布局，具体设置请查看XPageLayout类
    private var layout: XPageConfig
    
    //当前选中的位置
    private var x_currentIndex: Int = 0;
    
    //选中了第几个位置
    @objc public var didSelectIndexBlock: PageViewDidSelectIndexBlock?
    
    //添加完子控制器回调
    @objc public var addChildVcBlock: AddChildViewControllerBlock?
    
    // 点击切换滚动过程动画
    @objc public var isClickScrollAnimation = false {
        didSet {
            titleView.isClickScrollAnimation = isClickScrollAnimation
        }
    }
    
    //pageView的scrollView左右滑动监听
    @objc public weak var delegate: XPageViewDelegate?
    
    /** 获取所有的itemViews
    @available(*, deprecated, message: "use init_xxx_itemViewClass: instand of it")
    @objc public func customLayoutItems(handle: (([XPageTitleItem], XPageView) -> Void)?) {
        handle?(titleView.allItemViews(), self)
    }
     */
    
    var itemViewClass: XPageTitleItem.Type?
    
    /** 如果XPageView 与 XPageLayout结合使用 需要将它设置为true */
    var isSimpeMix = false {
         didSet {
             scrollView.isSimpeMix = isSimpeMix
         }
     }
    
    @objc public var gestureRecognizerEnabledHandle: ((Bool) -> Void)?
    
    private lazy var titleView: XPageTitleView = {
        let titleView = XPageTitleView(frame: CGRect(x: 0, y: 0, width: width, height: layout.sliderHeight), titles: titles, layout: layout, itemViewClass: itemViewClass)
        titleView.backgroundColor = layout.titleViewBgColor
        return titleView
    }()
    
    private lazy var scrollView: XPageScrollView = {
        let scrollView = XPageScrollView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        scrollView.contentSize = CGSize(width: width * CGFloat(self.titles.count), height: 0)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.bounces = layout.isShowBounces
        scrollView.isScrollEnabled = layout.isScrollEnabled
        scrollView.showsHorizontalScrollIndicator = layout.showsHorizontalScrollIndicator
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.gestureRecognizerEnabledHandle = {[weak self] in
            self?.gestureRecognizerEnabledHandle?($0)
        }
        return scrollView
    }()
    
    @objc convenience public init(frame: CGRect, currentViewController: UIViewController, viewControllers:[UIViewController], titles: [String], layout: XPageConfig) {
        self.init(frame: frame, currentViewController: currentViewController, viewControllers: viewControllers, titles: titles, layout: layout, itemViewClass: nil)
    }
    
    @objc required public init(frame: CGRect, currentViewController: UIViewController, viewControllers:[UIViewController], titles: [String], layout: XPageConfig, itemViewClass: XPageTitleItem.Type? = nil) {
        self.currentViewController = currentViewController
        self.viewControllers = viewControllers
        self.titles = titles
        self.layout = layout
        self.itemViewClass = itemViewClass
        guard viewControllers.count == titles.count else {
            fatalError("控制器数量和标题数量不一致")
        }
        super.init(frame: frame)
        
        self.addSubview(self.scrollView)
        
        guard !layout.isSinglePageView else { return }
        
        addSubview(self.titleView)
        
        x_createViewController(0)
        
        _makeupPageView(self.titleView)
    }
    
    /* 滚动到某个位置 */
    @objc public func scrollToIndex(index: Int)  {
        titleView.scrollToIndex(index: index)
    }
    
    @objc public func reloadLayout(titles: [String]) {
        titleView.reloadLayout(titles: titles)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension XPageView {
    
    final func _makeupPageView(_ titleView: XPageTitleView) {
        
        //设置滑动view的代理为XPageTitleView
//        self.delegate = titleView
        self.delegate = titleView
        
        //将当前的scrollView传递给titleView
        titleView.mainScrollView = scrollView
        
        //当titleView的选中位置传递给scrollView
        titleView.scrollIndexHandle = {[weak self] in
            guard let `self` = self else { return 0 }
            return self.currentIndex()
        }
        
        //通过pageView创建自子控制器
        titleView.x_createViewControllerHandle = {[weak self] index in
            self?.x_createViewController(index)
        }
        
        //选中某个位置的回调
        titleView.x_didSelectTitleViewHandle = {[weak self] index in
            guard let `self` = self else { return }
            self.didSelectIndexBlock?(self, index)
        }
    }
    
    final func makeupPageView(_ pageView:XPageView, _ titleView: XPageTitleView) {
        //设置滑动view的代理为XPageTitleView
        pageView.delegate = titleView
        titleView.mainScrollView = pageView.scrollView
        titleView.scrollIndexHandle = {[weak pageView] in
            return pageView?.currentIndex() ?? 0
        }
        titleView.x_createViewControllerHandle = {[weak pageView] index in
            pageView?.x_createViewController(index)
        }
        titleView.x_didSelectTitleViewHandle = {[weak pageView] index in
            pageView?.didSelectIndexBlock?((pageView)!, index)
        }
    }
}

extension XPageView {
    
    //仅内部调用创建控制器
    final func x_createViewController(_ index: Int)  {
        
        //如果当前控制器不存在直接return
        guard let currentViewController = currentViewController else { return }
        
        let viewController = viewControllers[index]
        
        //判断是否包含当前控制器，如果包含无需要再次创建
        guard !currentViewController.children.contains(viewController) else { return }
        
        //设置viewController的frame
        let X = scrollView.width * CGFloat(index)
        let Y = layout.isSinglePageView ? 0 : layout.sliderHeight
        let W = scrollView.width
        let H = scrollView.height
        viewController.view.frame = CGRect(x: X, y: Y, width: W, height: H)
        
        //将控制器的view添加到scrollView上
        scrollView.addSubview(viewController.view)
        
        //将控制器作为当前控制器的子控制器
        currentViewController.addChild(viewController)
                
        //抛出回调给外界
        addChildVcBlock?(index, viewController)
        
        guard let x_scrollView = viewController.x_scrollView else { return }
        
        if #available(iOS 11.0, *) {
            x_scrollView.contentInsetAdjustmentBehavior = .never
        }else {
            viewController.automaticallyAdjustsScrollViewInsets = false
        }
        //修正外部scrollView的高
        x_scrollView.height = x_scrollView.height - Y
    }
    
    //获取当前位置
    private func currentIndex() -> Int {
        if scrollView.bounds.width == 0 || scrollView.bounds.height == 0 {
            return 0
        }
        let index = Int((scrollView.contentOffset.x + scrollView.bounds.width * 0.5) / scrollView.bounds.width)
        return max(0, index)
    }
}

//MARK: 提供给外界监听的方法
extension XPageView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.x_scrollViewDidScroll?(scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.x_scrollViewWillBeginDragging?(scrollView)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?.x_scrollViewWillBeginDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.x_scrollViewDidEndDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.x_scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.x_scrollViewDidEndScrollingAnimation?(scrollView)
    }
}
