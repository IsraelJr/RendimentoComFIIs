//
//  NewsletterModel.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

struct NewsletterModel: Decodable {
    static var listAllNews = [NewsletterModel.Fetch.Newsletter]()
    struct Fetch {
        struct Request {
//            var object: Newsletter!
        }
        struct Response {
            var object: [Newsletter]?
            var isError: Bool!
            var message: String?
        }
        struct Newsletter {
            var siteName: String?
            var image: UIImage!
            var date: String?
            var href: String!
            var title: String?
            var inserted_in: Date!
        }
    }
}
