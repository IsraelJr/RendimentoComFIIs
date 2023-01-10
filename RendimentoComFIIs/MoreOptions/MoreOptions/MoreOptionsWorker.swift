//
//  MoreOptionsWorker.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 26/03/22.
//

import Foundation
import UIKit

typealias responseHandlerMoreOptions = (_ response: MoreOptionsModel.Fetch.Response) ->()

class MoreOptionsWorker {
    
    init() {
        ConfigureDataBase.instance.clearPersistence()
    }
    
}
