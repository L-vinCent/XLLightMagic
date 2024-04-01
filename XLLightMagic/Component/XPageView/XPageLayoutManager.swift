//
//  XPageLayoutManager.swift
//  XLLightMagic
//
//  Created by admin on 2024/4/1.
//

import UIKit

@objc public protocol XSimpleScrollViewDelegate: AnyObject {
    @objc optional func x_scrollViewDidScroll(_ scrollView: UIScrollView)
    @objc optional func x_scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    @objc optional func x_scrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
    @objc optional func x_scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    @objc optional func x_scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    @objc optional func x_scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    //刷新tableView的代理方法
    @objc optional func x_refreshScrollView(_ scrollView: UIScrollView, _ index: Int);
}

public class XPageLayoutManager: UIView {
    
    /* headerView配置 */
    @objc public func configHeaderView(_ handle: (() -> UIView?)?) {
        guard let headerView = handle?() else { return }
        setupHeaderView(headerView: headerView)
    }
    
    /* 动态改变header的高度 */
    @objc public var x_headerHeight: CGFloat = 0.0 {
        didSet {
            kHeaderHeight = CGFloat(Int(x_headerHeight))
            if layout.isHovered == false {
                hoverY = 0.0
                kHeaderHeight += self.layout.sliderHeight
                titleView.frame.origin.y = kHeaderHeight - layout.sliderHeight
            }
            headerView?.frame.size.height = kHeaderHeight
            tableView.tableHeaderView = headerView
        }
    }
    
    public typealias XSimpleDidSelectIndexHandle = (Int) -> Void
    @objc public var sampleDidSelectIndexHandle: XSimpleDidSelectIndexHandle?
    @objc public func didSelectIndexHandle(_ handle: XSimpleDidSelectIndexHandle?) {
        sampleDidSelectIndexHandle = handle
    }
    
    public typealias XSimpleRefreshTableViewHandle = (UIScrollView, Int) -> Void
    @objc public var simpleRefreshTableViewHandle: XSimpleRefreshTableViewHandle?
    @objc public func refreshTableViewHandle(_ handle: XSimpleRefreshTableViewHandle?) {
        simpleRefreshTableViewHandle = handle
    }
    
    /* 代码设置滚动到第几个位置 */
    @objc public func scrollToIndex(index: Int)  {
        titleView.scrollToIndex(index: index)
    }
    
    /* 点击切换滚动过程动画  */
    @objc public var isClickScrollAnimation = false {
        didSet {
            titleView.isClickScrollAnimation = isClickScrollAnimation
        }
    }
    
    //设置悬停位置Y值
    @objc public var hoverY: CGFloat = 0
    
    /* XSimple的scrollView上下滑动监听 */
    @objc public weak var delegate: XSimpleScrollViewDelegate?
    
    /** 如果XPageView 与 XSimple结合使用 需要将它设置为true */
    @objc public var isSimpeMix = false {
        didSet {
            pageView.isSimpeMix = isSimpeMix
            tableView.isSimpeMix = isSimpeMix
        }
    }
    
    private var contentTableView: UIScrollView?
    private var kHeaderHeight: CGFloat = 0.0
    private var headerView: UIView?
    private var viewControllers: [UIViewController]
    private var titles: [String]
    private var layout: XPageConfig
    private weak var currentViewController: UIViewController?
    private var pageView: XPageView!
    private var currentSelectIndex: Int = 0
    private var titleView: XPageTitleView!
    private var itemViewClass: XPageTitleItem.Type?
    
    private lazy var tableView: XTableView = {
        let tableView = XTableView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height), style:.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        registerCell(tableView, UITableViewCell.self)
        
        return tableView
    }()
    
    /// 外部调用，统一布局
    /// - Parameters:
    ///   - frame: 视图Frame
    ///   - viewControllers: 控制器数组，和标题一一对应
    ///   - titles: 标题数组，和控制器一一对应
    ///   - currentViewController: 当前控制器
    ///   - layout: 布局模型 XPageConfig
    ///   - titleView: 自定义的标题栏
    ///   - itemViewClass: 自定义滑块
    @objc public init(frame: CGRect, viewControllers: [UIViewController], titles: [String], currentViewController:UIViewController, layout: XPageConfig, titleView: XPageTitleView? = nil, itemViewClass: XPageTitleItem.Type? = nil) {
        UIScrollView.initializeOnce()
        self.viewControllers = viewControllers
        self.titles = titles
        self.currentViewController = currentViewController
        self.layout = layout
        self.itemViewClass = itemViewClass
        super.init(frame: frame)
        layout.isSinglePageView = true
        self.titleView = setupTitleView()
        self.titleView.delegate = self
        pageView = createPageViewConfig(currentViewController: currentViewController, layout: layout, titleView: titleView, itemViewClass: itemViewClass)
        createSubViews()
    }
    
    @objc public convenience init(frame: CGRect, viewControllers: [UIViewController], titles: [String], currentViewController:UIViewController, layout: XPageConfig) {
        self.init(frame: frame, viewControllers: viewControllers, titles: titles, currentViewController: currentViewController, layout: layout, titleView: nil)
    }
    
    @objc public func reloadLayout(titles: [String]) {
        titleView.reloadLayout(titles: titles)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocConfig()
    }
}

extension XPageLayoutManager {
    private func setupTitleView() -> XPageTitleView {
        let titleView = XPageTitleView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: layout.sliderHeight), titles: titles, layout: layout, itemViewClass: itemViewClass)
        return titleView
    }
}

extension XPageLayoutManager {
    
    private func createPageViewConfig(currentViewController:UIViewController, layout: XPageConfig, titleView: XPageTitleView?, itemViewClass: XPageTitleItem.Type?) -> XPageView {
        let pageView = XPageView(frame: self.bounds, currentViewController: currentViewController, viewControllers: viewControllers, titles: titles, layout:layout, itemViewClass: itemViewClass)
        if titles.count != 0 {
            pageView.x_createViewController(0)
        }
        pageView.gestureRecognizerEnabledHandle = {[weak self] isEnabled in
            self?.tableView.isEnabled = isEnabled
        }
        return pageView
    }
}

extension XPageLayoutManager: XPageViewDelegate {
    
    public func x_scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        tableView.isScrollEnabled = false
    }
    
    public func x_scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        tableView.isScrollEnabled = true
    }
    
}

extension XPageLayoutManager {
    
    private func createSubViews() {
        backgroundColor = UIColor.white
        addSubview(tableView)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        setupRefreshData()
        pageViewDidSelectConfig()
        guard let viewController = viewControllers.first else { return }
        viewController.beginAppearanceTransition(true, animated: true)
        contentScrollViewScrollConfig(viewController)
        pageView.makeupPageView(pageView, titleView)
    }
    
    private func contentScrollViewScrollConfig(_ viewController: UIViewController) {
        if self.contentTableView == nil {
            self.contentTableView = viewController.x_scrollView
        }
        viewController.x_scrollView?.scrollHandle = {[weak self] scrollView in
            guard let `self` = self else { return }
            self.contentTableView = scrollView
            if self.tableView.contentOffset.y  < self.kHeaderHeight - self.hoverY {
                scrollView.contentOffset = CGPoint(x: 0, y: 0)
                scrollView.showsVerticalScrollIndicator = false
            }else{
                scrollView.showsVerticalScrollIndicator = true
            }
        }
    }
    
}

extension XPageLayoutManager {
    private func setupRefreshData()  {
        DispatchQueue.main.after(0.001) {
            UIView.animate(withDuration: 0.34, animations: {
                self.tableView.contentInset = .zero
            })
            self.simpleRefreshTableViewHandle?(self.tableView, self.currentSelectIndex)
            self.delegate?.x_refreshScrollView?(self.tableView, self.currentSelectIndex)
        }
        
    }
}

extension XPageLayoutManager {
    private func pageViewDidSelectConfig()  {
        pageView.didSelectIndexBlock = {[weak self] in
            guard let `self` = self else { return }
            self.currentSelectIndex = $1
            self.setupRefreshData()
            self.sampleDidSelectIndexHandle?($1)
        }
        pageView.addChildVcBlock = {[weak self] in
            guard let `self` = self else { return }
            self.contentScrollViewScrollConfig($1)
        }
    }
}

extension XPageLayoutManager: UITableViewDelegate {
    
    /*
     * 0 到 kHeaderHeight - hoverY 之间，滑动的是底部tableView，并且此时要将内容scrollView的contentoffset设置为0
     * 当 大于 kHeaderHeight - hoverY 的时候， 滑动的是内容ScrollView，此时将底部tableView的contentoffset y固定为kHeaderHeight - hoverY
     */
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.x_scrollViewDidScroll?(scrollView)
        guard scrollView == tableView, let contentTableView = contentTableView else { return }
        let offsetY = scrollView.contentOffset.y
        if contentTableView.contentOffset.y > 0 || offsetY > kHeaderHeight - hoverY {
            tableView.contentOffset = CGPoint(x: 0.0, y: kHeaderHeight - hoverY)
        }
        //滑动期间将其他的内容scrollView contentOffset设置为0
        if scrollView.contentOffset.y < kHeaderHeight - hoverY {
            for viewController in viewControllers {
                guard viewController.x_scrollView != scrollView else { continue }
                viewController.x_scrollView?.contentOffset = .zero
            }
        }
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

extension XPageLayoutManager: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellWithTableView(tableView)
        cell.selectionStyle = .none
        if layout.isHovered {
            pageView.addSubview(titleView)
        }
        cell.contentView.addSubview(pageView)
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height
    }
}

extension XPageLayoutManager {
    private func deallocConfig() {
        for viewController in viewControllers {
            viewController.x_scrollView?.delegate = nil
        }
    }
}

//MARK: HeaderView设置
extension XPageLayoutManager {
    
    private func setupHeaderView(headerView: UIView) {
        //获取headerView的高度
        kHeaderHeight = CGFloat(Int(headerView.bounds.height))
        //判断是否悬停 默认为true开启悬停，如果不开启悬停则需要把hoverY的值设置为0，并重新设置kHeaderHeight，因为布局结构改变（正常情况下titleView是在pageView上，pageView在cell上，如果悬停则titleView放到了headerView上）
        if layout.isHovered == false {
            hoverY = 0.0
            kHeaderHeight += self.layout.sliderHeight
        }
        headerView.frame.size.height = kHeaderHeight
        if self.layout.isHovered == false {
            //此处需要延时一下才有效
            DispatchQueue.main.after(0.0001) {
                //设置titleView的y值
                self.titleView.frame.origin.y = self.kHeaderHeight - self.layout.sliderHeight
                headerView.addSubview(self.titleView)
            }
        }
        self.headerView = headerView
        tableView.tableHeaderView = headerView
    }
    
}

extension XPageLayoutManager{
    
    private func configIdentifier(_ identifier: inout String) -> String {
        var index = identifier.firstIndex(of: ".")
        guard index != nil else { return identifier }
        index = identifier.index(index!, offsetBy: 1)
        identifier = String(identifier[index! ..< identifier.endIndex])
        return identifier
    }
    
    func registerCell(_ tableView: UITableView, _ cellCls: AnyClass) {
        var identifier = NSStringFromClass(cellCls)
        identifier = configIdentifier(&identifier)
        tableView.register(cellCls, forCellReuseIdentifier: identifier)
    }
    
    public func cellWithTableView<T: UITableViewCell>(_ tableView: UITableView) -> T {
        var identifier = NSStringFromClass(T.self)
        identifier = configIdentifier(&identifier)
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        return cell as! T
    }
    
    public func tableViewConfig(_ delegate: UITableViewDelegate, _ dataSource: UITableViewDataSource, _ style: UITableView.Style?) -> UITableView  {
        let tableView = UITableView(frame:  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: style ?? .plain)
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        return tableView
    }
    
    public func tableViewConfig(_ frame: CGRect ,_ delegate: UITableViewDelegate, _ dataSource: UITableViewDataSource, _ style: UITableView.Style?) -> UITableView  {
        let tableView = UITableView(frame: frame, style: style ?? .plain)
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        return tableView
    }
    
}
