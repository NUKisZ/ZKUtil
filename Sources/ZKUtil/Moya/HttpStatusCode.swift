//
//  ErrorCode.swift
//  LoveDiary
//
//  Created by 张坤 on 2019/7/15.
//  Copyright © 2019 张坤. All rights reserved.
//

import Foundation
enum HttpStatusCode:Int {
    case sys_success = 200
    case sys_tokenExpired = 401
    case sys_tokenFailure = 402
}
