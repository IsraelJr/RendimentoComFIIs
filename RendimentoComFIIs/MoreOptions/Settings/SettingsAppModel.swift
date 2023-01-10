//
//  SettingsAppModel.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

struct SettingsAppModel: Decodable {
    struct Fetch {
        struct Request {
            var object: SettingsApp!
        }
        struct Response {
            var object: SettingsApp?
            var isError: Bool?
            var message: String?
        }
        struct SettingsApp {
            var id: String?
        }
    }
}
