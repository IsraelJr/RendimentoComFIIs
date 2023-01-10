//
//  DetailModel.swift
//  Pods
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

enum ItemsLibrary: String {
    case glossary
    case books
    case courses
    case brokers
    case tax
    
    func description() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

struct DetailModel: Decodable {
    static var aboutFii = [(title: String, description: String?)]()
    struct FetchGlossary {
        struct Response {
            var list: [Glossary]?
            var isError: Bool!
            var message: String?
        }
        struct Glossary {
            var name: String!
            var desc: String!
            var source: [String]?
            var new: Bool!
            var updated: Bool!
//            var inserted_in:
        }
    }
    
    struct FetchBooks {
        struct Response {
            var list: [Books]?
            var isError: Bool!
            var message: String?
        }
        struct Books {
            var isbn13: String!
            var title: String!
            var about: String!
            var author: String!
            var image: String!
            var pages: String!
            var language: String!
            var new: Bool!
            var updated: Bool!
//            var inserted_in:
        }
    }
    
    struct FetchCourses {
        enum Modality: String {
            case online
            case inperson
            case blended
            case live
            
            func description() -> String {
                return NSLocalizedString(self.rawValue, comment: "")
            }
        }
        
        struct Response {
            var list: [Courses]?
            var isError: Bool!
            var message: String?
        }
        struct Courses {
            var img: String?
            var institution: String!
            var title: String!
            var isFree: Bool!
            var modality: Modality!
            var url: String!
            var workload: String?
            var about: String?
            var new: Bool!
            var updated: Bool!
//            var inserted_in: 
        }
    }
    
    struct FetchBrokers {
        struct Response {
            var list: [Brokers]?
            var isError: Bool!
            var message: String?
        }
        struct Brokers {
            var title: String!
            var url: String!
            var about: String!
            var image: String!
            var new: Bool!
            var updated: Bool!
//            var inserted_in:
        }
    }
    
    struct FetchTax {
        struct Response {
            var list: [Tax]?
            var isError: Bool!
            var message: String?
        }
        struct Tax {
            var name: String!
            var desc: String!
            var source: [String]?
            var new: Bool!
            var updated: Bool!
        }
    }
}
