//
//  SearchModel.swift
//  Pods
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

struct SearchModel: Decodable {
    struct Fetch {
        struct Request {
            var object: Search!
        }
        struct Response {
            var object: Search?
            var isError: Bool!
            var message: String?
        }
        struct Search {
            var id: String?
        }
    }
}
