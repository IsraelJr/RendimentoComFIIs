//
//  LoginModel.swift
//  Pods
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

struct DataUser {
    static var name: String? = ""
    static var email: String? = ""
    static var gender: String? = ""
    static var vip: Int?
}

struct LoginModel: Decodable {
    struct Fetch {
        struct Request {
            var object: Login!
        }
        struct Response {
            var object: Login?
            var isError: Bool!
            var message: String?
        }
        struct Login {
            var id: String?
        }
    }
    
    struct FetchTerms {
        struct Request {
        }
        struct Response {
            var object: Terms?
            var isError: Bool!
            var message: String?
        }
        struct Terms {
            var title: String?
            var description: String?
        }
    }
}
