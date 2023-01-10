//
//  ReportModel.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

struct ReportModel: Decodable {
    static var patrimony: ReportModel.Fetch.Report?
    struct Fetch {
        struct Request {
            var object: Report!
        }
        struct Response {
            var object: Report?
            var isError: Bool!
            var message: String?
        }
        struct Report {
            var patrimony: [String:[String:Double]]
        }
    }
}
