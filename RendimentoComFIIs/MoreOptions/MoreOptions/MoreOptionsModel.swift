//
//  MoreOptionsModel.swift
//  Pods
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

enum CellContactUs: String, CaseIterable {
    case evaluation
    case exit_app
    case feedback
    case suggest
    case irpf
    case contactus
    
    static let allValues = [evaluation, suggest, feedback, exit_app, irpf, contactus]    //.exit sempre por ultimo
    
    init?(id: Int) {
        switch id {
        case 1: self = .evaluation
        case 2: self = .exit_app
        case 3: self = .suggest
        case 4: self = .feedback
        case 5: self = .irpf
        case 6: self = .contactus
        default: return nil
        }
    }
}



struct MoreOptionsModel: Decodable {
    struct Fetch {
        struct Request {
            var object: MoreOptions!
        }
        struct Response {
            var object: MoreOptions?
            var isError: Bool!
            var message: String?
        }
        struct MoreOptions {
            var id: String?
        }
    }
}
