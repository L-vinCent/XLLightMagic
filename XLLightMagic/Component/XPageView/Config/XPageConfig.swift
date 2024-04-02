//
//  XLayout.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/29.
//

import UIKit

let NORMAL_BASE_COLOR: UIColor = UIColor(r: 153, g:153, b: 153)
let SELECT_BASE_COLOR: UIColor = UIColor(r: 255, g: 255, b: 255)
let x_sliderDefaultWidth: CGFloat = 40.0001 //加小数点，因为如果外部正好设置为40的高度，内部会认为还是自动适配宽度

public class XPageConfig: NSObject {
    
    /**
     自定义每一个item的宽，如果有值内部将不再计算每一个item的宽
     isNeedScale如果不设置为false，将来取每一个itemView的时候frame由于缩放效果会导致frame改变
     isNeedScale如果为true可以从 layout.layoutItemWidths 取值这样不会影响内部布局
     */
    @objc public lazy var layoutItemWidths: [CGFloat] = [CGFloat]()
    
    /** pageView背景颜色 **/
    @objc public var titleViewBgColor: UIColor? = UIColor.black
    
    /** mainTableView 背景颜色 **/
    @objc public var mainTableViewBgColor: UIColor? = UIColor.black
    
    /** 标题颜色，请使用RGB赋值 **/
    @objc public var titleColor: UIColor? = NORMAL_BASE_COLOR
    
    /** 标题选中颜色，请使用RGB赋值 **/
    @objc public lazy var titleSelectColor: UIColor? = SELECT_BASE_COLOR
    
    /** 标题字号 **/
    @objc public lazy var titleFont: UIFont? = UIFont.systemFont(ofSize: 15)
    
    /** 滑块底部线的颜色 - UIColor.blue,传多个颜色就是渐变色 **/
    @objc public lazy var bottomLineColors: [UIColor] = [UIColor.red]
    
    /** pageView底部线的颜色 **/
    @objc public lazy var pageBottomLineColor: UIColor? = UIColor.clear
    
    /** 整个滑块的高，pageTitleView的高 **/
    @objc public lazy var sliderHeight: CGFloat = 44.0
    
    /** 单个滑块的宽度, 一旦设置，将不再自动计算宽度，而是固定为你传递的值 **/
    @objc public lazy var sliderWidth: CGFloat = x_sliderDefaultWidth
    
    /**
     * 如果刚开始的布局不希望从最左边开始， 只想平均分配在整个宽度中，设置它为true
     * 注意：此时最左边 lrMargin 以及 titleMargin 仍然有效，如果不需要可以手动设置为0
     **/
    @objc public lazy var isAverage: Bool = false
    
    /** 滑块底部线的高 **/
    @objc public lazy var bottomLineHeight: CGFloat = 4.0
    
    /** 滑块底部线圆角 **/
    @objc public lazy var bottomLineCornerRadius: CGFloat = 2.0
    
    /** 是否隐藏滑块、底部线**/
    @objc public lazy var isHiddenSlider: Bool = false
    
    /** 标题之间的间隔（标题距离下一个标题的间隔）**/
    @objc public lazy var titleMargin: CGFloat = 30.0
    
    /** 距离最左边和最右边的距离 **/
    @objc public lazy var lrMargin: CGFloat = 15.0
    
    /** 滑动过程中是否放大标题 **/
    @objc public lazy var isNeedScale: Bool = true
    
    /** 放大标题的倍率 **/
    @objc public lazy var scale: CGFloat = 1.2
    
    /** 是否开启颜色渐变 **/
    @objc public lazy var isColorAnimation: Bool = true
    
    /** 是否隐藏底部线 **/
    @objc public lazy var isHiddenPageBottomLine: Bool = false
    
    /** pageView底部线的高度 **/
    @objc public lazy var pageBottomLineHeight: CGFloat = 0.5
    
    /** pageView的内容ScrollView是否开启左右弹性效果 **/
    @objc public lazy var isShowBounces: Bool = false
    
    /** pageView的内容ScrollView是否开启左右滚动 **/
    @objc public lazy var isScrollEnabled: Bool = true
    
    /** pageView的内容ScrollView是否显示HorizontalScrollIndicator **/
    @objc public lazy var showsHorizontalScrollIndicator: Bool = true
    
    /** 是否悬停 默认为true开启悬停 此属性仅对XPageLayoutManager有效 关闭时记得修改viewControll的frame**/
    @objc public lazy var isHovered: Bool = true
    
    /** 内部使用 - 外界不需要调用 **/
    internal lazy var isSinglePageView: Bool = false
}
