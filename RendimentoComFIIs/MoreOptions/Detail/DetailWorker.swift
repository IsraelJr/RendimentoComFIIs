//
//  DetailWorker.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit
import FirebaseFirestore

typealias responseHandlerAboutFii = (_ response: [(title: String, description: String?)]) ->()
typealias responseHandlerGlossary = (_ response: DetailModel.FetchGlossary.Response) ->()
typealias responseHandlerBooks = (_ response: DetailModel.FetchBooks.Response) ->()
typealias responseHandlerCourses = (_ response: DetailModel.FetchCourses.Response) ->()
typealias responseHandlerBrokers = (_ response: DetailModel.FetchBrokers.Response) ->()
typealias responseHandlerTax = (_ response: DetailModel.FetchTax.Response) ->()


class DetailWorker {
    
    init() {
        ConfigureDataBase.instance.clearPersistence()
    }
    
    func fetchAboutFii(complete:@escaping(responseHandlerAboutFii)) {
        if DetailModel.aboutFii.isEmpty {
            ConfigureDataBase.instance.collection(ConfigureDataBase.collectionAboutFii).getDocuments { querySnapshot, error in
                if error == nil {
                    ConfigureDataBase.FieldsAboutFii.allCases.forEach({ item in
                        let x = querySnapshot?.documents.first(where: {item.rawValue == $0.documentID})
                        var desc = "\(x!.data()[Util.locale] as! String)\("\n\n\n\n")\(NSLocalizedString("source", comment: "")):\n"
                        (x!.data()["refSource"] as? [String])?.forEach({
                            desc += "\($0)\n\n"
                        })
                        DetailModel.aboutFii.append((title: NSLocalizedString(x!.documentID, comment: ""), desc))
                    })
                    complete(DetailModel.aboutFii)
                } else {
                    complete(.init())
                }
            }
        } else {
            complete(DetailModel.aboutFii)
        }
    }
    
    func fetchLibrary(complete:@escaping(responseHandlerArray)) {
        ConfigureDataBase.instance.collection(ConfigureDataBase.collectionLibrary).getDocuments { querySnapshot, error in
            if error == nil {
                var result = [String]()
                for doc in querySnapshot!.documents {
                    result.append(doc.data()[Util.locale] as! String)
                }
                result.sort(by: {$0 < $1})
                complete(result)
            } else {
                complete(.init())
            }
        }
    }
    
    func fetchGlossary(complete:@escaping(responseHandlerGlossary)) {
        ConfigureDataBase.instance.collection(ConfigureDataBase.collectionGlossary).getDocuments { querySnapshot, error in
            if error == nil {
                var list = [DetailModel.FetchGlossary.Glossary]()
                for doc in querySnapshot!.documents {
                    let obj = DetailModel.FetchGlossary.Glossary(
                        name: (doc.data()["field_name"] as! [String:Any])[Util.locale] as? String,
                        desc: (doc.data()["field_desc"] as! [String:Any])[Util.locale] as? String,
                        source: doc.data()["refSource"] as? [String],
                        new: doc.data()["new"] as? Bool,
                        updated: doc.data()["updated"] as? Bool
                    )
                    list.append(obj)
                }
                list.sort(by: {$0.name < $1.name})
                complete(.init(list: list, isError: false, message: nil))
            } else {
                complete(.init(list: nil, isError: true, message: ""))
            }
        }
    }
    
    func fetchBooks(complete:@escaping(responseHandlerBooks)) {
        ConfigureDataBase.instance.collection(ConfigureDataBase.collectionBooks).getDocuments { querySnapshot, error in
            if error == nil {
                var list = [DetailModel.FetchBooks.Books]()
                for doc in querySnapshot!.documents {
                    let obj = DetailModel.FetchBooks.Books(
                        isbn13: doc.data()["isbn13"] as? String,
                        title: doc.data()["title"] as? String,
                        about: doc.data()["about"] as? String,
                        author: doc.data()["author"] as? String,
                        image: doc.data()["image"] as? String,
                        pages: doc.data()["pages"] as? String,
                        language: doc.data()["language"] as? String,
                        new: doc.data()["new"] as? Bool,
                        updated: doc.data()["updated"] as? Bool
                    )
                    list.append(obj)
                }
                list.sort(by: {$0.title < $1.title})
                complete(.init(list: list, isError: false, message: nil))
            } else {
                complete(.init(list: nil, isError: true, message: ""))
            }
        }
    }
    
    func fetchCourses(complete:@escaping(responseHandlerCourses)) {
        ConfigureDataBase.instance.collection(ConfigureDataBase.collectionCourses).getDocuments { querySnapshot, error in
            if error == nil {
                var list = [DetailModel.FetchCourses.Courses]()
                for doc in querySnapshot!.documents {
                    let obj = DetailModel.FetchCourses.Courses(
                        img: doc.data()["image"] as? String,
                        institution: doc.data()["institution"] as? String,
                        title: doc.data()["title"] as? String,
                        isFree: doc.data()["isFree"] as? Bool,
                        modality: DetailModel.FetchCourses.Modality(rawValue: doc.data()["modality"] as! String),
                        url: doc.data()["url"] as? String,
                        workload: doc.data()["workload"] as? String,
                        about: doc.data()["about"] as? String,
                        new: doc.data()["new"] as? Bool,
                        updated: doc.data()["updated"] as? Bool
                    )
                    list.append(obj)
                }
                list.sort(by: {$0.title < $1.title})
                complete(.init(list: list, isError: false, message: nil))
            } else {
                complete(.init(list: nil, isError: true, message: ""))
            }
        }
    }
    
    func fetchBrokers(complete:@escaping(responseHandlerBrokers)) {
        ConfigureDataBase.instance.collection(ConfigureDataBase.collectionBrokers).getDocuments { querySnapshot, error in
            if error == nil {
                var list = [DetailModel.FetchBrokers.Brokers]()
                for doc in querySnapshot!.documents {
                    let obj = DetailModel.FetchBrokers.Brokers(
                        title: doc.data()["title"] as? String,
                        url: doc.data()["url"] as? String,
                        about: doc.data()["about"] as? String,
                        image: doc.data()["image"] as? String,
                        new: doc.data()["new"] as? Bool,
                        updated: doc.data()["updated"] as? Bool
                    )
                    list.append(obj)
                }
                list.sort(by: {$0.title < $1.title})
                complete(.init(list: list, isError: false, message: nil))
            } else {
                complete(.init(list: nil, isError: true, message: ""))
            }
        }
    }
    
    func fetchTax(complete:@escaping(responseHandlerTax)) {
        ConfigureDataBase.instance.collection(ConfigureDataBase.collectionTax).getDocuments { querySnapshot, error in
            if error == nil {
                var list = [DetailModel.FetchTax.Tax]()
                for doc in querySnapshot!.documents {
                    let obj = DetailModel.FetchTax.Tax(name: (doc.data()["field_name"] as! [String:Any])[Util.locale] as? String,
                                                       desc: (doc.data()["field_desc"] as! [String:Any])[Util.locale] as? String,
                                                       source: doc.data()["refSource"] as? [String],
                                                       new: doc.data()["new"] as? Bool,
                                                       updated: doc.data()["updated"] as? Bool
                    )
                    list.append(obj)
                }
                complete(.init(list: list, isError: false, message: nil))
            } else {
                complete(.init(list: nil, isError: true, message: "Deu erro"))
            }
        }
    }
}
