//
//  HomeModel.swift
//  Pods
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

struct HomeModel: Decodable {
    static var tenRandomFiis: [FIIModel.Fetch.FII]?
    static var listPublication = [FiisNews]()
    static var listAllPublication = [FiisNews]()
    static var listHighLow = [FIIModel.Fetch.FII]()
    static var isVIPShow = true
    static var phrase = (HomeModel.FetchPhrase.Phrase)()
    static var listItensLibrary = [(String,String)]()
    
    struct Fetch {
        struct Request {
            var object: Home!
        }
        struct Response {
            var object: Home?
            var isError: Bool!
            var message: String?
        }
        struct Home {
            var id: String?
        }
    }
    
    struct FetchPhrase {
        struct Request {
            var id = "0"
        }
        struct Response {
            var object: Phrase? = Phrase()
            var isError: Bool! = true
            var message: String?
        }
        struct Phrase {
            var author: String? = "Benjamin Franklin"
            var phrase: String? = "Investir em conhecimento sempre rende os melhores juros."
        }
    }
}
