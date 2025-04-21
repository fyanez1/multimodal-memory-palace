//
//  LLM_calls.swift
//  arbasicapp
//
//  Created by Fabian Yanez-Laguna on 4/20/25.
//

import Foundation

class LLMService {
    static let shared = LLMService()

    private init() {}

    func fetchFacts(completion: @escaping ([String]) -> Void) {
        let prompts = [
            "Tell me a cool fact about robots.",
            "Tell me a cool fact about airplanes.",
            "Tell me a cool fact about cars."
        ]

        var results: [String] = Array(repeating: "", count: prompts.count)
        let dispatchGroup = DispatchGroup()

        for (i, prompt) in prompts.enumerated() {
            dispatchGroup.enter()

            var request = URLRequest(url: URL(string: "https://openrouter.ai/api/v1/chat/completions")!)
            request.httpMethod = "POST"
            request.setValue("Bearer YOUR_API_KEY_HERE", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let body: [String: Any] = [
                "model": "openchat/openchat-3.5-1210", // Free and open
                "messages": [["role": "user", "content": prompt]]
            ]

            request.httpBody = try? JSONSerialization.data(withJSONObject: body)

            URLSession.shared.dataTask(with: request) { data, _, _ in
                defer { dispatchGroup.leave() }

                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let choices = json["choices"] as? [[String: Any]],
                      let message = choices.first?["message"] as? [String: Any],
                      let content = message["content"] as? String else {
                    results[i] = "Error fetching response."
                    return
                }

                results[i] = content.trimmingCharacters(in: .whitespacesAndNewlines)
            }.resume()
        }

        dispatchGroup.notify(queue: .main) {
            completion(results)
        }
    }
}
