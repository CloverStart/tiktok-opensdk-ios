/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit
@testable import TikTokOpenSDKCore
@testable import TikTokOpenShareSDK

open class MockURLOpener: TikTokURLOpener {
    public func canOpenURL(_ url: URL) -> Bool {
        return true
    }
    
    public func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?) {
        completion?(true)
    }
    
    @objc
    public func isTikTokInstalled() -> Bool {
        return true
    }
}

@objc
open class MockBundle: NSObject {
    @objc
    func infoDictionary() -> [String: Any]? {
        return ["TikTokClientKey": "aaaa"]
    }
}

class TikTokTestEnv {
    static var initialized = false
    
    static func setUpEnv() {
        if !initialized {
            initialized = true
            ttsdk_swizzleBundleInfoDictionary()
        }
    }
    
    private static func ttsdk_swizzleBundleInfoDictionary() {
        enableTestMethodSwizzle(Bundle.self,
                                #selector(getter: Bundle.infoDictionary),
                                MockBundle.self,
                                #selector(MockBundle.infoDictionary))
    }
    
    private static func enableTestMethodSwizzle(_ cls1: AnyClass?, _ selector1: Selector, _ cls2: AnyClass?, _ selector2: Selector) {
        guard let originalMethod = class_getInstanceMethod(cls1, selector1), let newMethod = class_getInstanceMethod(cls2, selector2) else {
            return
        }
        method_exchangeImplementations(originalMethod, newMethod)
    }
}
