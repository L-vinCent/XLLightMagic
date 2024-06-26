//
//  Global.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/20.
//

import Foundation
import UIKit
import Kingfisher
import SnapKit
import MJRefresh

//MARK: 应用默认颜色
extension UIColor {
    
    //主题背景黑
    class var themeBackground: UIColor {
        return UIColor.hex(hexString:"#000000")
    }

    class var mainBlueColor:UIColor{
        return UIColor.hex(hexString:"#3742FA")
    }
    
    class var fontWhiteColor:UIColor{
        return UIColor.hex(hexString:"#FFFFFF")
    }
    
    //灰
    class var fontGray300: UIColor {
        return UIColor.hex(hexString:"#D4D4D4")
    }
    
    class var fontGray600: UIColor {
        return UIColor.hex(hexString:"#999999")
    }
    
    class var fontGray900: UIColor {
        return UIColor.hex(hexString:"#666666")
    }
    
    //背景灰
    class var BGNormalGray01: UIColor {
        return UIColor.hex(hexString:"#F6F6F6")
    }
    
    
    class var accentColor: UIColor{
        return UIColor.hex(hexString:"#FA9E2C")
    }
    
    class var cellColor: UIColor{
        return UIColor.hex(hexString:"#CDCDCD")
    }
    
    class var normalTextColor: UIColor{
        return UIColor.hex(hexString:"#FFFFFF")
    }
    
    class var descTextColor: UIColor{
        return UIColor.hex(hexString:"#999999")
    }
    
    class var selectColor: UIColor{
        return UIColor.hex(hexString:"#1296db")
    }
    
    //渐变色组
    class var gradientColors: [UIColor]{
        return [UIColor.hex(hexString: "FF4D4D"),UIColor.hex(hexString: "FFAF40"),UIColor.hex(hexString: "32FF7E"),UIColor.hex(hexString: "37BFFA"),UIColor.hex(hexString: "3E5DFF")]
    }
    
}

extension UIFont{
    //常规字体
    class var regularFont:UIFont{
        return Self.PingFangRegular(size: 15)
    }
    
    static func PingFangRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    static func PingFangBold(size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func PingFangSemiBold(size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Semibold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func PingFangMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
}

extension String {
    static let searchHistoryKey = "searchHistoryKey"
    static let sexTypeKey = "sexTypeKey"
}

extension NSNotification.Name {
    static let USexTypeDidChange = NSNotification.Name("USexTypeDidChange")
}

let XScreenWidth = UIScreen.main.bounds.width
let XScreenHeight = UIScreen.main.bounds.height



//MARK: print
func xLog<T>(_ message: T, file: String = #file, function: String = #function, lineNumber: Int = #line) {
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("[\(fileName):funciton:\(function):line:\(lineNumber)]- \(message)")
    #endif
}

//MARK: Kingfisher
extension Kingfisher where Base: ImageView {
    @discardableResult
    public func setImage(urlString: String?, placeholder: Placeholder? = UIImage(named: "normal_placeholder_h")) -> RetrieveImageTask {
        return setImage(with: URL(string: urlString ?? ""),
                        placeholder: placeholder,
                        options:[.transition(.fade(0.5))])
    }
}

extension Kingfisher where Base: UIButton {
    @discardableResult
    public func setImage(urlString: String?, for state: UIControl.State, placeholder: UIImage? = UIImage(named: "normal_placeholder_h")) -> RetrieveImageTask {
        return setImage(with: URL(string: urlString ?? ""),
                        for: state,
                        placeholder: placeholder,
                        options: [.transition(.fade(0.5))])
        
    }
}

//MARK: SnapKit
extension ConstraintView {
    var xsnp: ConstraintBasicAttributesDSL {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        } else {
            return self.snp
        }
    }
}

extension UICollectionView {
    func reloadData(animation: Bool = true) {
        if animation {
            reloadData()
        } else {
            UIView .performWithoutAnimation {
                reloadData()
            }
        }
    }
}

extension UIApplication {
    class func changeOrientationTo(landscapeRight: Bool) {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        if landscapeRight == true {
            delegate.orientation = .landscapeRight
            UIApplication.shared.supportedInterfaceOrientations(for: delegate.window)
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        } else {
            delegate.orientation = .portrait
            UIApplication.shared.supportedInterfaceOrientations(for: delegate.window)
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }
}
