//
//  QuizModel.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

struct QuizModel: Decodable {
    struct Fetch {
        struct Request {
            var object: Question!
        }
        struct Response {
            var object: Question?
            var isError: Bool!
            var message: String?
        }
        struct Question {
            var id: Int
            var question: String
            var answers: [(id: Int, response: String)]
            var correctAnswer: Int
            
            init(id: Int, question: String, answers: [(id: Int, response: String)], correctAnswer: Int){
                self.id = id
                self.question = question
                self.answers = answers
                self.correctAnswer = correctAnswer
            }
        }
    }
}
