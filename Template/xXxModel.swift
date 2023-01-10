//
//  xXxModel.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

struct xXxModel: Decodable {
    struct Fetch {
        struct Request {
            var object: xXx!
        }
        struct Response {
            var object: xXx?
            var isError: Bool!
            var message: String?
        }
        struct xXx {
            var id: String?
        }
    }
}
