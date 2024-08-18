//
//  SummaryModel.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

struct SummaryModel: Decodable {
    struct Fetch {
        struct Request {
            var object: Summary!
        }
        struct Response {
            var object: Summary?
            var isError: Bool!
            var message: String?
        }
        struct Summary {
            var id: String?
        }
    }
    
    struct Section {
        var mainCellTitle: String
        var expandableCellOptions: [String]
        var isExpandableCellsHidden: Bool
    }
    
}
