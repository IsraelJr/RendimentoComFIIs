//
//  WalletHistoricModel.swift
//  Pods
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

struct WalletHistoricModel: Decodable {
    struct Fetch {
        struct Request {
            var object: WalletHistoric!
        }
        struct Response {
            var object: WalletHistoric?
            var isError: Bool!
            var message: String?
        }
        struct WalletHistoric {
            var month: String?
            var earnings: Double?
        }
    }
}
