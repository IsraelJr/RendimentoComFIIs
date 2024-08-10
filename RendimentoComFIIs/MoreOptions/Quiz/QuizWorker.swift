//
//  QuizWorker.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import Foundation
import UIKit

typealias responseHandlerQuiz = (_ response: QuizModel.Fetch.Response) ->()

class QuizWorker {
    init() {
        ConfigureDataBase.instance.clearPersistence()
    }
    
    func doSomething(request: QuizModel.Fetch.Request, success:@escaping(responseHandlerQuiz), fail:@escaping(responseHandlerQuiz)) {
        let doc = ConfigureDataBase.instance.collection(ConfigureDataBase.collectionUser).document(DataUser.email ?? "")
        doc.getDocument { document, error in
            //            success(.init(object: nil, isError: false, message: nil))
            //
            //            fail(.init(object: nil, isError: false, message: nil))
        }
    }
    
}
