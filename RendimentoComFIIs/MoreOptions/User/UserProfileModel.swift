//
//  UserProfileModel.swift
//  Pods
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

struct UserProfileModel: Decodable {
    struct Fetch {
        struct Request {
            var object: UserProfile!
        }
        struct Response {
            var object: UserProfile?
            var isError: Bool!
            var message: String?
        }
        struct UserProfile {
            var name: String? = DataUser.name
            var email: String? = DataUser.email
        }
    }
}
