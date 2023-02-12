//
//  PublicModel.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

struct PublicModel: Decodable {
    struct Fetch {
        struct Request {
            var object: Public!
        }
        struct Response {
            var object: Public?
            var isError: Bool!
            var message: String?
        }
        struct Public {
            var id: String!
            var rating: WalletRating!
            var description: String!
            var fiis: [(String,String)]?
            var segments: [(String,String)]?
        }
    }
}
