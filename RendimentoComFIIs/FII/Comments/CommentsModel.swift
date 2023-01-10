//
//  CommentsModel.swift
//  Pods
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

struct CommentsModel: Decodable {
    struct Fetch {
        struct Request {
            var object: Comments!
        }
        struct Response {
            var object: Comments?
            var isError: Bool!
            var message: String?
        }
        struct Comments {
            var id: String?
        }
    }
}
