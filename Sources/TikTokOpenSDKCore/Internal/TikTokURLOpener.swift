/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

public protocol TikTokURLOpener {
    func canOpenURL(_ url: URL) -> Bool
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?)
    var keyWindow: UIWindow? { get }
    func isTikTokInstalled() -> Bool
}

@objc
extension UIApplication : TikTokURLOpener {
    //ps: --yb 这里是xcode16 导致的无法打包问题修复 暂时容错，代tiktok解决后，请切换到官方版本
    public func open(_ url: URL, options: [OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?) {
        open(url, options: options, completionHandler: completion)
    }
    
    @objc
    public func isTikTokInstalled() -> Bool {
        for scheme in TikTokInfo.schemes {
            if let schemeURL = URL(string: "\(scheme)://") {
                if canOpenURL(schemeURL) {
                    return true
                }
            }
        }
        return false
    }
    
}
