//
//  XPageTitleView.swift
//  XLLightMagic
//
//  Created by admin on 2024/4/1.
//

import UIKit

typealias scrollIndexHandle = () -> Int
public typealias XCreateViewControllerHandle = (Int) -> Void
public typealias XDidSelectTitleViewHandle = (Int) -> Void
public typealias XItemViewClassHandle = () -> XPageTitleItem

@objc public class XPageTitleView:UIView{
    
    //传递进来的scrollView
    var mainScrollView: UIScrollView?

    //标题数组
    private var titles: [String]
    
    //设置默认布局，具体设置请查看XPageConfig类
    private var layout: XPageConfig
    
    //存储文本宽度数组
    private lazy var x_textWidths: [CGFloat] = []
    
    //存储线的宽度数组
    private lazy var x_lineWidths: [CGFloat] = []
    
    //存储所有的button
    private lazy var x_buttons: [XPageTitleItem] = []
    
    //当前的位置
    private lazy var x_currentIndex: Int = 0
    
    //标记是否是点击
    private lazy var isClick: Bool = false
    
    //起始偏移量
    private lazy var x_startOffsetX: CGFloat = 0.0
    
    //是否有点击动画
    private lazy var x_isClickScrollAnimation = false
    
    //是否有点击动画 其他类使用
    final lazy var isClickScrollAnimation = false
    
    //是否是第一次加载
    private lazy var isFirstLoad: Bool = true
    
    //选中某个位置的回调
    var scrollIndexHandle: scrollIndexHandle?
    
    //创建子控制器的回调
    var x_createViewControllerHandle: XCreateViewControllerHandle?
    
    //选中标题view回调
    var x_didSelectTitleViewHandle: XDidSelectTitleViewHandle?
    
    //设置pageView的代理
    weak var delegate: XPageViewDelegate?
    
    //返回所有的数组
    func allItemViews() -> [XPageTitleItem] {
        return x_buttons
    }
    
    var itemViewClass: XPageTitleItem.Type?
    
    private lazy var x_titleColor = (layout.titleColor ?? NORMAL_BASE_COLOR).getRGB()
    
    private lazy var x_selectTitleColor = (layout.titleSelectColor ?? SELECT_BASE_COLOR).getRGB()
    
    
    private lazy var sliderScrollView: UIScrollView = {
        let sliderScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        sliderScrollView.showsHorizontalScrollIndicator = false
        sliderScrollView.bounces = false
        if #available(iOS 11.0, *) {
            sliderScrollView.contentInsetAdjustmentBehavior = .never
        }
        return sliderScrollView
    }()
    
    private lazy var pageBottomLineView: UIView = {
        let pageBottomLineView = UIView(frame: CGRect(x: 0, y: bounds.height - layout.pageBottomLineHeight, width: bounds.width, height: layout.pageBottomLineHeight))
        pageBottomLineView.backgroundColor = layout.pageBottomLineColor
        return pageBottomLineView
    }()
    
    private lazy var sliderLineView: GradientView = {
        let sliderLineView = GradientView(frame: CGRect(x: layout.lrMargin, y: bounds.height - layout.bottomLineHeight - layout.pageBottomLineHeight, width: 0, height: layout.bottomLineHeight))
        if(layout.bottomLineColors.count > 1){
            //渐变色
            sliderLineView.setGradient(colors: layout.bottomLineColors)
        }else{
            //单一色
            let color = layout.bottomLineColors.first
            sliderLineView.backgroundColor = color
        }
        sliderLineView.isHidden = layout.isHiddenSlider
        return sliderLineView
    }()
    
    
    
    @objc  init(frame: CGRect, titles: [String], layout: XPageConfig, itemViewClass: XPageTitleItem.Type? = nil) {
        self.titles = titles
        self.layout = layout
        self.itemViewClass = itemViewClass
        super.init(frame: frame)
        backgroundColor = layout.titleViewBgColor
        setupSubViews()
    }
    
    /* 滚动到某个位置 */
    @objc public func scrollToIndex(index: Int)  {
        var index = index
        x_setupScrollToIndex(&index)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        addSubview(sliderScrollView)
        addSubview(pageBottomLineView)
        setupButtonsLayout()
        sliderScrollView.addSubview(sliderLineView)
    }
}

//布局计算
extension XPageTitleView{
    
    private func setupButtonsLayout() {
        
        guard titles.count != 0 else { return }
        
        //是否自定义了item的宽
        let _isLayoutWidth = layout.layoutItemWidths.count > 0
        
        // 将所有的宽度计算出来放入数组
        for text in titles {
            if layout.isAverage {
                let textAverageW = (width - layout.lrMargin * 2.0 - layout.titleMargin * CGFloat(titles.count - 1)) / CGFloat(titles.count)
                if !_isLayoutWidth {
                    x_textWidths.append(textAverageW)
                }
                x_lineWidths.append(textAverageW)
                continue
            }
            if text.count == 0 {
                if !_isLayoutWidth {
                    x_textWidths.append(60)
                }
                x_lineWidths.append(60)
                continue
            }
            let textW = text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 8), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : layout.titleFont ?? UIFont.systemFont(ofSize: 16)], context: nil).size.width
            if !_isLayoutWidth {
                x_textWidths.append(textW)
            }
            x_lineWidths.append(textW)
        }
        
        if _isLayoutWidth {
            x_textWidths = layout.layoutItemWidths
        }
        
        // 按钮布局
        var upX: CGFloat = layout.lrMargin
        let subH = height - layout.bottomLineHeight
        for index in 0..<titles.count {
            let subW = x_textWidths[index]
            let buttonReact = CGRect(x: upX, y: 0, width: subW, height: subH)
            let button = subButton(frame: buttonReact, flag: index, title: titles[index], parentView: sliderScrollView)
            let color = (index == 0 ? layout.titleSelectColor : layout.titleColor)
            button.setTitleColor(color, for: .normal)
            upX = button.frame.origin.x + subW + layout.titleMargin
            x_buttons.append(button)
            button.x_index = index
            button.x_isSelected = index == 0
            button.x_layoutSubviews?()
        }
        
        let firstButton = x_buttons[0]
        let firstLineWidth = x_lineWidths[0]
        let firstTextWidth = x_textWidths[0]
        
        if layout.isNeedScale {
            firstButton.transform = CGAffineTransform(scaleX: layout.scale , y: layout.scale)
        }
        
        // lineView的宽度为第一个的宽度
        if layout.sliderWidth == x_sliderDefaultWidth {
            if layout.isAverage {
                sliderLineView.width = firstLineWidth
                sliderLineView.left = (firstTextWidth - firstLineWidth) * 0.5 + layout.lrMargin
            }else {
                sliderLineView.width = firstButton.width
                sliderLineView.left = firstButton.left
            }
        }else {
            sliderLineView.width = layout.sliderWidth
            sliderLineView.left = ((firstTextWidth + layout.lrMargin * 2) - layout.sliderWidth) * 0.5
        }
        
        if layout.bottomLineCornerRadius != 0.0 {
            sliderLineView.layer.cornerRadius = layout.bottomLineCornerRadius
            sliderLineView.layer.masksToBounds = true
            sliderLineView.clipsToBounds = true
        }
        
        if layout.isAverage {
            sliderScrollView.contentSize = CGSize(width: width, height: 0)
            return
        }
        
        // 计算sliderScrollView的contentSize
        let sliderContenSizeW = upX - layout.titleMargin + layout.lrMargin
        
        if sliderContenSizeW < width {
            sliderScrollView.width = sliderContenSizeW
        }
        
        //最后多加了一个 layout.titleMargin， 这里要减去
        sliderScrollView.contentSize = CGSize(width: sliderContenSizeW, height: 0)
        
    }
    @objc private func titleSelectIndex(_ btn: UIButton)  {
        
        setupTitleSelectIndex(btn.tag)
        
    }
    
    private func setupTitleSelectIndex(_ btnSelectIndex: Int) {

        guard let scrollView = mainScrollView else { return }
        if x_currentIndex == btnSelectIndex || scrollView.isDragging || scrollView.isDecelerating {
            return
        }
        let totalW = bounds.width
        isClick = true
        x_isClickScrollAnimation = true
        scrollView.setContentOffset(CGPoint(x: totalW * CGFloat(btnSelectIndex), y: 0), animated: isClickScrollAnimation)
        if isClickScrollAnimation {
            return
        }
        let nextButton = x_buttons[btnSelectIndex]
        if layout.sliderWidth == x_sliderDefaultWidth {
            if layout.isAverage {
                let adjustX = (nextButton.frame.size.width - x_lineWidths[btnSelectIndex]) * 0.5
                sliderLineView.frame.origin.x = nextButton.frame.origin.x + adjustX
                sliderLineView.frame.size.width = x_lineWidths[btnSelectIndex]
            }else {
                sliderLineView.frame.origin.x = nextButton.frame.origin.x
                sliderLineView.frame.size.width = nextButton.frame.width
            }
        }else {
            setupSliderLineViewWidth(currentButton: nextButton)
        }
        x_currentIndex = btnSelectIndex
    }
    
 
    
    @objc public func reloadLayout(titles: [String]) {
        guard titles.count == self.titles.count else { return }
        guard titles.count != 0 else { return }
        self.titles = titles
        x_textWidths.removeAll()
        
        //是否自定义了item的宽
        let _isLayoutWidth = layout.layoutItemWidths.count > 0
        
        // 将所有的宽度计算出来放入数组
        for text in titles {
            if layout.isAverage {
                let textAverageW = (width - layout.lrMargin * 2.0 - layout.titleMargin * CGFloat(titles.count - 1)) / CGFloat(titles.count)
                if !_isLayoutWidth {
                    x_textWidths.append(textAverageW)
                }
                x_lineWidths.append(textAverageW)
                continue
            }
            if text.count == 0 {
                if !_isLayoutWidth {
                    x_textWidths.append(60)
                }
                x_lineWidths.append(60)
                continue
            }
            let textW = text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 8), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : layout.titleFont ?? UIFont.systemFont(ofSize: 16)], context: nil).size.width
            if !_isLayoutWidth {
                x_textWidths.append(ceil(textW))
            }
            x_lineWidths.append(ceil(textW))
        }
        
        if _isLayoutWidth {
            x_textWidths = layout.layoutItemWidths
        }
        
        // 按钮布局
        var upX: CGFloat = layout.lrMargin
        let subH = height - layout.bottomLineHeight
        for index in 0..<titles.count {
            let subW = x_textWidths[index]
            let buttonReact = CGRect(x: upX, y: 0, width: subW, height: subH)
            let button = x_buttons[index]
            button.transform = .identity
            button.frame = buttonReact
            button.setTitle(titles[index], for: .normal)
            upX = button.frame.origin.x + subW + layout.titleMargin
            button.x_layoutSubviews?()
        }
        
        if layout.isAverage {
            sliderScrollView.contentSize = CGSize(width: width, height: 0)
            return
        }
        
        let firstButton = x_buttons[x_currentIndex]
        let firstLineWidth = x_lineWidths[x_currentIndex]
        let firstTextWidth = x_textWidths[x_currentIndex]
        
        if layout.isNeedScale {
            firstButton.transform = CGAffineTransform(scaleX: layout.scale , y: layout.scale)
        }
        
        // lineView的宽度为第一个的宽度
        if layout.sliderWidth == x_sliderDefaultWidth {
            if layout.isAverage {
                sliderLineView.width = firstLineWidth
                sliderLineView.left = (firstTextWidth - firstLineWidth) * 0.5 + layout.lrMargin
            }else {
                sliderLineView.width = firstButton.width
                sliderLineView.left = firstButton.left
            }
        }else {
            sliderLineView.width = layout.sliderWidth
            sliderLineView.left = ((firstTextWidth + layout.lrMargin * 2) - layout.sliderWidth) * 0.5
        }
        
        if layout.bottomLineCornerRadius != 0.0 {
            sliderLineView.layer.cornerRadius = layout.bottomLineCornerRadius
            sliderLineView.layer.masksToBounds = true
            sliderLineView.clipsToBounds = true
        }
        
        if layout.isAverage {
            sliderScrollView.contentSize = CGSize(width: width, height: 0)
            return
        }
        
        // 计算sliderScrollView的contentSize
        let sliderContenSizeW = upX - layout.titleMargin + layout.lrMargin
        
        if sliderContenSizeW < width {
            sliderScrollView.width = sliderContenSizeW
        }
        
        //最后多加了一个 layout.titleMargin， 这里要减去
        sliderScrollView.contentSize = CGSize(width: sliderContenSizeW, height: 0)
    }
    
    
}

//pageView 滑动的代理方法
extension XPageTitleView {
    
    public func x_scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDidScrollOffsetX(scrollView.contentOffset.x)
    }
    
    public func x_scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.x_scrollViewWillBeginDragging?(scrollView)
        x_startOffsetX = scrollView.contentOffset.x
    }
    
    public func x_scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.x_scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    public func x_scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if x_isClickScrollAnimation {
            let index = currentIndex()
            x_createViewControllerHandle?(index)
            setupSlierScrollToCenter(offsetX: scrollView.contentOffset.x, index: index)
            setupIsClickScrollAnimation(index: index)
            x_didSelectTitleViewHandle?(index)
        }
    }
}


extension XPageTitleView: XPageViewDelegate {
    
    private func scrollViewDidScrollOffsetX(_ offsetX: CGFloat)  {
        
        _ = setupLineViewX(offsetX: offsetX)
        
        let index = currentIndex()
        
        if x_currentIndex != index {
            
            //如果开启滚动动画
            if isClickScrollAnimation {
                //如果不是点击事件继续在这个地方设置偏移
                if !x_isClickScrollAnimation {
                    setupSlierScrollToCenter(offsetX: offsetX, index: index)
                }
            }else {
                //设置滚动的位置
                setupSlierScrollToCenter(offsetX: offsetX, index: index)
            }
            
            let upButton = x_buttons[x_currentIndex]
            let currentButton = x_buttons[index]
            
            // 如果是点击的话
            if isClick {
                if layout.isNeedScale {
                    UIView.animate(withDuration: 0.2, animations: {
                        currentButton.transform = CGAffineTransform(scaleX: self.layout.scale , y: self.layout.scale)
                        upButton.transform = CGAffineTransform(scaleX: 1.0 , y: 1.0 )
                    })
                }
                
                setupButtonStatusAnimation(upButton: upButton, currentButton: currentButton)
                
            }
            
            if layout.isColorAnimation == false {
                setupButtonStatusAnimation(upButton: upButton, currentButton: currentButton)
            }
            
            //如果开启滚动动画
            if isClickScrollAnimation {
                //如果不是点击事件继续在这个地方设置偏移
                if !x_isClickScrollAnimation {
                    x_createViewControllerHandle?(index)
                    x_didSelectTitleViewHandle?(index)
                    upButton.x_isSelected = false
                    currentButton.x_isSelected = true
                }
            }else {
                //默认的设置
                x_createViewControllerHandle?(index)
                x_didSelectTitleViewHandle?(index)
                upButton.x_isSelected = false
                currentButton.x_isSelected = true
            }
            x_currentIndex = index
        }
        isClick = false
        
    }
    
    //MARK: 让title的ScrollView滚动到中心点位置
    private func setupSlierScrollToCenter(offsetX: CGFloat, index: Int)  {
        let currentButton = x_buttons[index]
        let btnCenterX = currentButton.center.x
        var scrollX = btnCenterX - sliderScrollView.bounds.width * 0.5
        if scrollX < 0 {
            scrollX = 0
        }
        if scrollX > sliderScrollView.contentSize.width - sliderScrollView.bounds.width {
            scrollX = sliderScrollView.contentSize.width - sliderScrollView.bounds.width
        }
        sliderScrollView.setContentOffset(CGPoint(x: scrollX, y: 0), animated: true)
    }
    
    private func setupButtonStatusAnimation(upButton: UIButton, currentButton: UIButton)  {
        upButton.setTitleColor(layout.titleColor, for: .normal)
        currentButton.setTitleColor(layout.titleSelectColor, for: .normal)
    }
    
    private func currentIndex() -> Int {
        return scrollIndexHandle?() ?? 0
    }
    
    
    
    private func setupIsClickScrollAnimation(index: Int) {
        if !isClickScrollAnimation {
            return
        }
        for button in x_buttons {
            if button.tag == index {
                if layout.isNeedScale {
                    button.transform = CGAffineTransform(scaleX: layout.scale , y: layout.scale)
                }
                button.setTitleColor(self.layout.titleSelectColor, for: .normal)
                button.x_isSelected = true
            }else {
                if layout.isNeedScale {
                    button.transform = CGAffineTransform(scaleX: 1.0 , y: 1.0)
                }
                button.setTitleColor(self.layout.titleColor, for: .normal)
                button.x_isSelected = false
            }
        }
        x_isClickScrollAnimation = false
    }
}



//MARK: 处理刚进入滚动到第几个位置
extension XPageTitleView {
    
    private func x_setupScrollToIndex(_ index:inout Int) {
        if index >= titles.count {
            print("超过最大数量限制, 请正确设置值, 默认这里取第一个")
            index = 0
        }
        
        if isClickScrollAnimation {
            
            let nextButton = x_buttons[index]
            
            if layout.sliderWidth == x_sliderDefaultWidth {
                
                if layout.isAverage {
                    let adjustX = (nextButton.frame.size.width - x_lineWidths[index]) * 0.5
                    sliderLineView.frame.origin.x = nextButton.frame.origin.x + adjustX
                    sliderLineView.frame.size.width = x_lineWidths[index]
                }else {
                    sliderLineView.frame.origin.x = nextButton.frame.origin.x
                    sliderLineView.frame.size.width = nextButton.frame.width
                }
                
            }else {
                if isFirstLoad {
                    setupSliderLineViewWidth(currentButton: x_buttons[index])
                    isFirstLoad = false
                }
            }
        }
        
        setupTitleSelectIndex(index)
    }
    
}



extension XPageTitleView {
    
    //MARK: 设置线的移动
    private func setupLineViewX(offsetX: CGFloat) -> Bool {
        if isClick {
            return false
        }
        //目的是改变它的值，让制滑动第一个和最后一个的时候（-0.5），导致数组下标越界
        var offsetX = offsetX
        let scrollW = bounds.width
        let scrollContenSizeW: CGFloat = bounds.width * CGFloat(titles.count)
        // 目的是滑动到最后一个的时候 不让其再往后滑动
        if offsetX + scrollW >= scrollContenSizeW {
            if layout.sliderWidth == x_sliderDefaultWidth {
                let adjustX = (x_textWidths.last! - x_lineWidths.last!) * 0.5
                sliderLineView.frame.origin.x = layout.lrMargin + adjustX
            }else {
                setupSliderLineViewWidth(currentButton: x_buttons.last!)
            }
            offsetX = scrollContenSizeW - scrollW - 0.5
        }
        // 目的是滑动到第一个的时候 不让其再往前滑动
        if offsetX <= 0 {
            if layout.sliderWidth == x_sliderDefaultWidth {
                let adjustX = (x_textWidths[0] - x_lineWidths[0]) * 0.5
                sliderLineView.frame.origin.x = layout.lrMargin + adjustX
            }else {
                sliderLineView.frame.origin.x = ((x_textWidths[0] + layout.lrMargin * 2) - layout.sliderWidth) * 0.5
            }
            offsetX = 0.5
        }
        var nextIndex = Int(offsetX / scrollW)
        var sourceIndex = Int(offsetX / scrollW)
        //向下取整 目的是减去整数位，只保留小数部分
        var progress = (offsetX / scrollW) - floor(offsetX / scrollW)
        if offsetX > x_startOffsetX { // 向左滑动
            //向左滑动 下个位置比源位置下标 多1
            nextIndex = nextIndex + 1
        }else { // 向右滑动
            //向右滑动 由于源向下取整的缘故 必须补1 nextIndex则恰巧是原始位置
            sourceIndex = sourceIndex + 1
            progress = 1 - progress
        }
        let nextButton = x_buttons[nextIndex]
        let currentButton = x_buttons[sourceIndex]
        if layout.isColorAnimation {
        
            let colorDelta = (x_selectTitleColor.0 - x_titleColor.0, x_selectTitleColor.1 - x_titleColor.1, x_selectTitleColor.2 - x_titleColor.2)
            let nextColor = UIColor(r: UInt32(x_titleColor.0 + colorDelta.0 * progress), g: UInt32(x_titleColor.1 + colorDelta.1 * progress), b: UInt32(x_titleColor.2 + colorDelta.2 * progress))
            let currentColor = UIColor(r: UInt32(x_selectTitleColor.0 - colorDelta.0 * progress), g: UInt32(x_selectTitleColor.1 - colorDelta.1 * progress), b: UInt32(x_selectTitleColor.2 - colorDelta.2 * progress))
            currentButton.setTitleColor(currentColor, for: .normal)
            nextButton.setTitleColor(nextColor, for: .normal)
        }
        if layout.isNeedScale {
            let scaleDelta = (layout.scale - 1.0) * progress
            currentButton.transform = CGAffineTransform(scaleX: layout.scale - scaleDelta, y: layout.scale - scaleDelta)
            nextButton.transform = CGAffineTransform(scaleX: 1.0 + scaleDelta, y: 1.0 + scaleDelta)
        }
        // 判断是否是自定义Slider的宽度（这里指没有自定义）
        if layout.sliderWidth == x_sliderDefaultWidth {
            
            if layout.isAverage {
                /*
                 * 原理：（按钮的宽度 - 线的宽度）/ 2 = 线的X便宜量
                 * 如果是不是平均分配 按钮的宽度 = 线的宽度
                 */
                // 计算宽度的该变量
                let moveW = x_lineWidths[nextIndex] - x_lineWidths[sourceIndex]
                
                // （按钮的宽度 - 线的宽度）/ 2
                let nextButtonAdjustX = (nextButton.frame.size.width - x_lineWidths[nextIndex]) * 0.5
                
                // （按钮的宽度 - 线的宽度）/ 2
                let currentButtonAdjustX = (currentButton.frame.size.width - x_lineWidths[sourceIndex]) * 0.5
                
                // x的该变量
                let moveX = (nextButton.frame.origin.x + nextButtonAdjustX) - (currentButton.frame.origin.x + currentButtonAdjustX)
                
                self.sliderLineView.frame.size.width = x_lineWidths[sourceIndex] + moveW * progress
                
                self.sliderLineView.frame.origin.x = currentButton.frame.origin.x + moveX * progress + currentButtonAdjustX
                
            }else {
                // 计算宽度的该变量
                let moveW = nextButton.frame.width - currentButton.frame.width
                
                // 计算X的该变量
                let moveX = nextButton.frame.origin.x - currentButton.frame.origin.x
                
                self.sliderLineView.frame.size.width = currentButton.frame.width + moveW * progress
                self.sliderLineView.frame.origin.x = currentButton.frame.origin.x + moveX * progress - 0.25
            }
            
        }else {
            
            
            /*
             * 原理：按钮的最左边X（因为有lrMargin，这里必须减掉） 以及 按钮的相对右边X（注意不是最右边，因为每个按钮的X都有一个lrMargin， 所以相对右边则有两个才能保证按钮的位置，这个和titleMargin无关）
             */
            let maxNextLeft = nextButton.frame.origin.x - layout.lrMargin
            let maxNextRight = maxNextLeft + layout.lrMargin * 2.0 + nextButton.frame.size.width
            let originNextX = (maxNextRight - maxNextLeft - layout.sliderWidth) * 0.5 + maxNextLeft
            
            let maxLeft = currentButton.frame.origin.x - layout.lrMargin
            let maxRight = maxLeft + layout.lrMargin * 2.0 + currentButton.frame.size.width
            let originX = (maxRight - maxLeft - layout.sliderWidth) * 0.5 + maxLeft
            
            let moveX = originNextX - originX
            
            self.sliderLineView.frame.origin.x = originX + moveX * progress
            
            sliderLineView.frame.size.width = layout.sliderWidth
        }
        
        return false
    }
    
    // currentButton将要滚动到的按钮
    private func setupSliderLineViewWidth(currentButton: UIButton)  {
        let maxLeft = currentButton.frame.origin.x - layout.lrMargin
        let maxRight = maxLeft + layout.lrMargin * 2 + currentButton.frame.size.width
        let originX = (maxRight - maxLeft - layout.sliderWidth) * 0.5  + maxLeft
        sliderLineView.frame.origin.x = originX
        sliderLineView.frame.size.width = layout.sliderWidth
    }
    
}
extension XPageTitleView {
    
    @discardableResult
    private func subButton(frame: CGRect, flag: Int, title: String?, parentView: UIView) -> XPageTitleItem {
        if self.itemViewClass == nil {
            let button = XPageButton.init(type: .custom)
            button.frame = frame
            button.tag = flag
            button.setTitle(title, for: .normal)
            button.addTarget(self, action: #selector(titleSelectIndex(_:)), for: .touchUpInside)
            button.titleLabel?.font = layout.titleFont
            parentView.addSubview(button)
            return button
        }else {
            let button = itemViewClass!.init(type: .custom)
            button.frame = frame
            button.tag = flag
            button.setTitle(title, for: .normal)
            button.addTarget(self, action: #selector(titleSelectIndex(_:)), for: .touchUpInside)
            button.titleLabel?.font = layout.titleFont
            parentView.addSubview(button)
            return button
        }
    }
}

class XPageButton: UIButton, XPageTitleItem {
    var x_index: Int = 0
}


private class GradientView: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    func setGradient(colors: [UIColor]) {
        guard let gradientLayer = layer as? CAGradientLayer else { return }
        
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
    }
}
