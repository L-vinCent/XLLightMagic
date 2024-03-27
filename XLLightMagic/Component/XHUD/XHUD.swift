//
//  XHUD.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/27.
//

import UIKit
import MBProgressHUD

enum XHUDLoadingProgressStyle: Int {
    // 开扇型加载进度
    case determinate
    // 横条加载进度
    case determinateHorizontalBar
    // 环形加载进度
    case annularDeterminate
}

class XHUD: MBProgressHUD {
    
    
    
    class func showText(_ text: String, view: UIView? = nil) {
        showPlainText(text, hideAfterDelay: 1.0, view: view)
    }
    
    class func showPlainText(_ text: String, view: UIView? = nil) {
        showPlainText(text, hideAfterDelay: 1.0, view: view)
    }
    
    class func showPlainText(_ text: String, hideAfterDelay time: TimeInterval, view: UIView? = nil) {
        guard let window = UIDevice.keyWindow() else {return}
        let hudView = view ?? window
        let hud = MBProgressHUD.showAdded(to: hudView, animated: true)
        hud.mode = .text
        
        hud.label.text = text
        hud.label.textColor = .white
        
        hud.bezelView.style = .solidColor
        hud.bezelView.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: time)
    }
    
    class func showIcon(_ icon: UIImage, message: String, hideAfterDelay time: TimeInterval, view: UIView? = nil) {
        guard let window = UIDevice.keyWindow() else {return}
        let hudView = view ?? window
        let hud = MBProgressHUD.showAdded(to: hudView, animated: true)
        hud.label.text = message
        hud.customView = UIImageView(image: icon)
        hud.mode = .customView
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: time)
    }
    
    class func showIcon(_ icon: UIImage, message: String, view: UIView? = nil) {
        showIcon(icon, message: message, hideAfterDelay: 1.0, view: view)
    }
    
    class func showCustomView(_ customView: UIView? = nil, message: String? = nil, hideAfterDelay time: TimeInterval, toView view: UIView? = nil) {
        assert(customView != nil,"自定义视图不能为空")
        guard let window = UIDevice.keyWindow() else {return}

        let hudView = view ?? window
        let hud = MBProgressHUD.showAdded(to: hudView, animated: true)
        
        if let message = message {
            hud.label.text = message
        }
        
        hud.customView = customView
        hud.mode = .customView
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: time)
    }
    
    class func showCustomView(_ customView: UIView?, hideAfterDelay time: TimeInterval, toView view: UIView? = nil) {
        showCustomView(customView, message: nil, hideAfterDelay: time, toView: view)
    }
    
    class func showCustomView(_ customView: UIView?, hideAfterDelay time: TimeInterval) {
        showCustomView(customView, hideAfterDelay: time, toView: nil)
    }
    
    class func showMessage(_ message: String?, hideAfterDelay time: TimeInterval, toView view: UIView?, customView: (() -> UIView)?) {
        
        showCustomView(customView?(), message: message, hideAfterDelay: time, toView: view)
    }
    
    class func showHideAfterDelay(_ time: TimeInterval, customView: (() -> UIView)?) {
        showCustomView(customView?(), hideAfterDelay: time)
    }
    
    class func showActivityLoading(_ message: String? = nil, toView view: UIView? = nil) -> MBProgressHUD {
        
        guard let window = UIDevice.keyWindow() else {return MBProgressHUD()}
        let hudView = view ?? window
        
        let hud = MBProgressHUD.showAdded(to: hudView, animated: true)
        
        hud.mode = .indeterminate
        if let message = message {
            hud.label.text = message
        }
        
        hud.removeFromSuperViewOnHide = true
        
        return hud
    }
    
    class func showActivityLoading(toView view: UIView? = nil) -> MBProgressHUD {
        return showActivityLoading(nil, toView: view)
    }
    
    class func showActivityLoading() -> MBProgressHUD {
        return showActivityLoading(nil, toView: nil)
    }
    
    class func showAnnularLoading(_ message: String? = nil, toView view: UIView? = nil) -> MBProgressHUD {
        return showLoadingStyle(.annularDeterminate, message: message, toView: view)
    }
    
    class func showAnnularLoading() -> MBProgressHUD {
        return showAnnularLoading(nil, toView: nil)
    }
    
    class func showDeterminateLoading(_ message: String? = nil, toView view: UIView? = nil) -> MBProgressHUD {
        return showLoadingStyle(.determinate, message: message, toView: view)
    }
    
    class func showDeterminateLoading() -> MBProgressHUD {
        return showDeterminateLoading(nil, toView: nil)
    }
    
    
      class func showLoadingStyle(_ style: XHUDLoadingProgressStyle, message: String? = nil, toView view: UIView? = nil) -> MBProgressHUD {

          guard let window = UIDevice.keyWindow() else {return MBProgressHUD()}
          let hudView = view ?? window
          
          let hud = MBProgressHUD.showAdded(to: hudView, animated: true)
          
          switch style {
          case .determinate:
              hud.mode = .determinate
          case .determinateHorizontalBar:
              hud.mode = .determinateHorizontalBar
          case .annularDeterminate:
              hud.mode = .annularDeterminate
          }
          
          if let message = message {
              hud.label.text = message
          }
          
          hud.removeFromSuperViewOnHide = true
          return hud
      }
      
      class func showLoadingStyle(_ style: XHUDLoadingProgressStyle, toView view: UIView? = nil) -> MBProgressHUD {
          return showLoadingStyle(style, message: nil, toView: view)
      }
      
      class func showLoadingStyle(_ style: XHUDLoadingProgressStyle) -> MBProgressHUD {
          return showLoadingStyle(style, toView: nil)
      }
      
      class func showError(_ error: String? = nil, hideAfterDelay time: TimeInterval, toView view: UIView? = nil) {
          show(error, animationType: .error, hideAfterDelay: time, view: view)
      }
      
      class func showError(_ error: String? = nil, toView view: UIView? = nil) {
          showError(error, hideAfterDelay: 1.0, toView: view)
      }
      
      class func showError(_ error: String? = nil) {
          showError(error, toView: nil)
      }
      
      class func showSuccess(_ success: String? = nil, hideAfterDelay time: TimeInterval, toView view: UIView? = nil) {
          show(success, animationType: .success, hideAfterDelay: time, view: view)
      }
      
      class func showSuccess(_ success: String? = nil, toView view: UIView? = nil) {
          showSuccess(success, hideAfterDelay: 1.0, toView: view)
      }
      
      class func showSuccess(_ success: String? = nil) {
          showSuccess(success, toView: nil)
      }
      
      class func show(_ text: String?, animationType: XAnimationType, hideAfterDelay time: TimeInterval, view: UIView?) {
          guard let window = UIDevice.keyWindow() else {return}
          let hudView = view ?? window
          
          let hud = MBProgressHUD.showAdded(to: hudView, animated: true)
          
          if let text = text {
              hud.label.text = text
          }
          
          let suc = XSuccessView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
          suc.animationType = animationType
          hud.customView = suc
          hud.mode = .customView
          
          hud.removeFromSuperViewOnHide = true
          hud.hide(animated: true, afterDelay: time)
      }
    
    
}

extension MBProgressHUD {
    class func x_hideHUD(for view: UIView? = nil) {
        guard let window = UIDevice.keyWindow() else {return}
        let hudView = view ?? window
        hide(for: hudView, animated: true)
    }
    
    class func x_hideHUD() {
        x_hideHUD(for: nil)
    }
    
}
