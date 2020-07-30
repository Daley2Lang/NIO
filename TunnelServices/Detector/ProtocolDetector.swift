//
//  ProtocolDetector.swift
//  SwiftNIO
//
//  Created by Lojii on 2018/8/16.
//  Copyright © 2018年 Lojii. All rights reserved.
//
// 协议探测器
import UIKit
import NIO
import NIOHTTP1
//import NIOTransportServices

//final  修饰的类 变量 或者 方法无法被继承

/*
 ChannelHandler 是用来处理数据，如客户端向服务端发送数据，服务端的数据处理就是在ChannelHandler中完成。ChannelHandler 本身是一个protocol，我们用到的有ChannelInboundHandler和ChannelOutboundHandler这两个，ChannlPipeline（通道管道）会从头到尾顺序调用ChannelInboundHandler处理数据，从尾到头调用ChannelOutboundHandler数据。
 */

public final class ProtocolDetector: ChannelInboundHandler, RemovableChannelHandler {
    public typealias InboundIn =  ByteBuffer
    public typealias InboundOut = ByteBuffer
    
    private var buf:ByteBuffer?
    
    private var index:Int = 0 //

    private let matcherList: [ProtocolMatcher]
    public var task:Task
    
    init(task:Task ,matchers:[ProtocolMatcher]) {
        self.matcherList = matchers
        self.task = task
    }
    
    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        
         LogOnline.sendLog(msg: "流程打印 \(#function) in \(type(of: self))")
        
        if let local = context.channel.localAddress?.description {
            let isLocal = local.contains("127.0.0.1")
            if (isLocal && task.localEnable == 0) || (!isLocal && task.wifiEnable == 0) {
                context.flush()
                context.close(promise: nil)
//                print("channel:\(context.channel.localAddress?.description ?? "") close !")
                return
            }
        }
//        print("channel:\(context.channel.localAddress?.description ?? "") open !")
//        print("channelRead")
//        print("******监听管道：",context.channel)
        let buffer = unwrapInboundIn(data)
        //TODO: 需要处理粘包情况以及数据不完整情况
        for i in index..<matcherList.count {
            
            LogOnline.sendLog(msg: "处理器的数量:\(matcherList.count)")
            
            let matcher = matcherList[i]
            let match = matcher.match(buf: buffer)
            if match == ProtocolMatcher.MATCH {
                matcher.handlePipeline(pipleline: context.pipeline, task: task)
                context.fireChannelRead(data)
                context.pipeline.removeHandler(self, promise: nil)
                return
            }
            if match == ProtocolMatcher.PENDING {
                index = i
                return
            }
        }
        // all miss
        context.flush()
        context.close(promise: nil)
        print("unsupported protocol")
    }
    
    public func userInboundEventTriggered(context: ChannelHandlerContext, event: Any) {
        print("userInboundEventTriggered:\(event)")
//        context.channel.
    }
    
    public func errorCaught(context: ChannelHandlerContext, error: Error) {
        print("ProtocolDetector error: \(error.localizedDescription)")
        context.close(promise: nil)
    }
    
    private func startReading(context: ChannelHandlerContext) {
        print("startReading")
    }
    
    private func deliverPendingRequests(context: ChannelHandlerContext) {
        print("deliverPendingRequests")
    }
    
}
