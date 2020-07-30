//
//  StringCode.swift
//  TunnelServices
//
//  Created by Qi Liu on 2020/7/29.
//  Copyright © 2020 Lojii. All rights reserved.
//

import Foundation
public extension String {
    //将原始的url编码为合法的url
    func tun_urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
     
    //将编码后的url转换回原始的url
    func tun_urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
}
