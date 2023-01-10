//
//  AboutAppModel.swift
//  Pods
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

struct AboutAppModel: Decodable {
    struct Fetch {
        struct Request {
            var object: AboutApp!
        }
        struct Response {
            var object: AboutApp?
            var isError: Bool!
            var message: String?
        }
        struct AboutApp {
            static var description = ""
        }
    }
}
