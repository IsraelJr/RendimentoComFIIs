//
//  WalletModel.swift
//  Pods
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

struct WalletModel: Decodable {
    struct Fetch {
        struct Request {
            var object: Wallet!
        }
        struct Response {
            var object: Wallet?
            var isError: Bool!
            var message: String?
        }
        struct Wallet {
            var annualEarnings: [String:Any]?
            var wallet: [[String:Int64]]?
        }
    }
}
