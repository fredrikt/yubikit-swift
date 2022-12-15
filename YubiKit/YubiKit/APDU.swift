//
//  APDU.swift
//  YubiKit
//
//  Created by Jens Utbult on 2021-12-07.
//

import Foundation

/*
@param cla
   The instruction class.
@param ins
   The instruction number.
@param p1
   The first instruction paramater byte.
@param p2
   The second instruction paramater byte.
@param data
   The command data.
@param type
   The type of the APDU, short or extended.
*/

public struct APDU {
    
    public enum ApduType {
        case short
        case extended
    }
    
    private let cla: UInt8
    private let ins: UInt8
    private let p1: UInt8
    private let p2: UInt8
    private let command: Data?
    private let type: ApduType
    
    init(cla: UInt8, ins: UInt8, p1: UInt8, p2: UInt8, command: Data? = nil, type: ApduType = .short) {
        self.cla = cla
        self.ins = ins
        self.p1 = p1
        self.p2 = p2
        self.command = command
        self.type = type
    }
    
    public var data: Data {
        var data = Data()
        data.append(cla)
        data.append(ins)
        data.append(p1)
        data.append(p2)

        switch type {
        case .short:
            if let command, command.count > 0 {
                guard command.count < UInt8.max else { fatalError() }
                let length = UInt8(command.count)
                data.append(length)
                data.append(command)
            }
        case .extended:
            if let command, command.count > 0 {
                let lengthHigh: UInt8 = UInt8(command.count / 256)
                let lengthLow: UInt8 = UInt8(command.count % 256)
                data.append(0x00)
                data.append(lengthHigh)
                data.append(lengthLow)
                data.append(command)
            } else {
                data.append(0x00)
                data.append(0x00)
                data.append(0x00)
            }
        }

        return data
    }
}
