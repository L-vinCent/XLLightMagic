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
        return UIColor.hex(hexString:"#1E1E1E")
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
    
}

extension UIFont{
    //常规大小字体
    class var normalFont:UIFont{
        return UIFont.systemFont(ofSize: 14)
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
