//
//  ListWalletPublicModel.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

struct ListWalletPublicModel: Decodable {
    struct Fetch {
        struct Request {
            var object: ListWalletPublic!
        }
        struct Response {
            var object: ListWalletPublic?
            var isError: Bool!
            var message: String?
        }
        struct ListWalletPublic {
            var id: String!
            var rating: WalletRating!
            var description: String!
            var fiis: [String:String]!
            var segments: [String:String]!
        }
    }
}
