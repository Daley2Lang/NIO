//
//  LogOnline.swift
//  PacketTunnel
//
//  Created by Qi Liu on 2020/7/30.
//  Copyright © 2020 fengfeng. All rights reserved.
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

class LogOnline: NSObject {
    public static  func sendLog(msg:String) -> Void {
          print("请求")
         let urlStr  = String.init(format: ("http://182.92.2.5:8805/write?msg=\(msg)" as NSString) as String)
         let fiaurl = URL.init(string: urlStr.tun_urlEncoded())
          let request = URLRequest.init(url: fiaurl!)
          let session = URLSession.shared
          session.dataTask(with: request) { (dataT, resp, err) in
              if err != nil{
              }else{
                  let str = NSString.init(data: dataT! , encoding:String.Encoding.utf8.rawValue)
                  print("返回结果:\(String(describing: str))")
              }
          }.resume()
      }
}

// LogOnline.sendLog(msg: "流程打印 \(#function) in \(type(of: self))")
