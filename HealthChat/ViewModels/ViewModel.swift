//
//  APICaller.swift
//  sdkTest
//
//  Created by Onur on 13.09.2023.
//

import Foundation
import OpenAI



class ViewModel: NSObject{
    
    var gptResponse: String = ""
    var previousResponse: String = ""
    var chatArray: [ChatData] = []
    let apiKey: String = "XXX"
    func getDataFromAPI(prompt: String, completion: @escaping (Result<String,Error>) -> Void){
        let aiClient = OpenAI(apiToken: apiKey)
        let query = ChatQuery(model: .gpt3_5Turbo0613,
                              messages:
                                [.init(role: .system, content: "You are a psychologist"),
                                 .init(role: .assistant, content: self.previousResponse),
                                .init(role: .user, content: prompt)],
                              maxTokens: 400)
        aiClient.chats(query: query) { [self] result in
            switch result{
            case .success(let completionResult):
                if let content = completionResult.choices.first?.message.content {
                    gptResponse = content
                    completion(.success(gptResponse))
                } else {
                    let error = NSError(domain: "YourErrorDomain", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Content not found"])
                    completion(.failure(error))}
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

