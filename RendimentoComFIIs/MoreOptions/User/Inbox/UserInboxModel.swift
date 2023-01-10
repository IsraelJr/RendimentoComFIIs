//
//  UserProfileModel.swift
//  Pods
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

struct UserInboxModel: Decodable {
    struct Fetch {
        struct Request {
            var object: Message!
        }
        struct Response {
            var object: Message?
            var isError: Bool!
            var message: String?
        }
        struct Message {
            var idBD: String
            var idLocal: String
            var owner: String
            var date: String
            var title: String
            var description: String
            var typeMessage: TypeMessage
            var read: Bool
        }
    }
}
