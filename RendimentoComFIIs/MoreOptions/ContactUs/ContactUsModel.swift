//
//  ContactUsModel.swift
//  Pods
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

enum TypeMessageTitle: String, CaseIterable {
    case compliment
    case review
    case suggestion
    case other
    case pix
    
    func description() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

enum TypeMessage: String {
    case sent
    case received
}

struct ContactUsModel: Decodable {
    struct Fetch {
        struct Request {
            var object: ContactUs!
        }
        struct Response {
            var object: ContactUs?
            var isError: Bool!
            var message: String?
        }
        struct ContactUs {
            var id: String!
            var name: String?
            var email: String?
            var typeTitle: TypeMessageTitle!
            var message: String?
            var attach: String?
            var typeMessage: TypeMessage = .sent
        }
    }
}
