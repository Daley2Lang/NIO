//
//  UDPHandler.swift
//  TunnelServices
//
//  Created by Qi Liu on 2020/8/3.
//  Copyright © 2020 Lojii. All rights reserved.
//

import Foundation
import NIO
import NIOTLS
import NIOHTTP1
import NIOConcurrencyHelpers
import NIOSSL
import Network
final class UDPHandler: ChannelInboundHandler {
      typealias InboundIn = AddressedEnvelope<ByteBuffer>
      typealias OutboundOut = AddressedEnvelope<ByteBuffer>
      
      func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
          let getData = unwrapInboundIn(data)
          print(getData.data)
      }
  }
