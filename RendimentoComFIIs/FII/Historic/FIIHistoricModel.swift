//
//  FIIHistoricModel.swift
//  Pods
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

struct FIIHistoricModel: Decodable {
    struct Fetch {
        struct Request {
            var code: String!
        }
        struct Response {
            var object: FIIHistoric?
            var isError: Bool!
            var message: String?
        }
        struct FIIHistoric {
            var earnings: [[String:Any]]?
        }
    }
}
