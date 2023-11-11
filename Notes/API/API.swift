//
//  API.swift
//  Notes
//
//  Created by james bouker on 11/10/23.
//

import Foundation

class API {
    
    // MARK: - Notes (CRUD)
    
    @discardableResult
    static func createNote(_ text: String) async -> Note? {
        struct Body: Encodable {
            var text: String
            let secret: String = "60042feb-d259-4245-9147-e67ea45813e4"
        }
        return await perform(path: "/notes", method: .POST, body: Body(text: text)).output
    }
    
    static func notes() async -> [Note] {
        await perform(path: "/notes").output ?? []
    }
    
    static func note(_ id: String) async -> Note? {
        await perform(path: "/notes/\(id)").output
    }
    
    @discardableResult
    static func updateNote(_ id: String, text: String) async -> Note? {
        struct Body: Encodable {
            let text: String
            let secret: String = "60042feb-d259-4245-9147-e67ea45813e4"
        }
        return await perform(path: "/notes/\(id)", method: .PATCH, body: Body(text: text)).output
    }
    
    @discardableResult
    static func deleteNote(_ id: String) async -> Bool {
        struct Body: Encodable {
            let secret: String = "60042feb-d259-4245-9147-e67ea45813e4"
        }
        let result: PerformResult<String?> = await perform(path: "/notes/\(id)", method: .DELETE, body: Body())
        return result.code == 200
    }
    
    // MARK: - Private Helpers

    struct PerformResult<Output: Decodable> {
        var output: Output?
        var code: Int
    }
    
    enum Method: String {
        case GET
        case POST
        case PATCH
        case DELETE
    }
    
    struct EmptyBody: Encodable {}
    
    private static func perform<T: Encodable, Output: Decodable>(path: String,
                                                                 method: Method = .GET,
                                                                 body: T) async -> PerformResult<Output> {
        let url = URL(string: baseURL + path)!
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if !(body is EmptyBody) {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try! JSONEncoder().encode(body)
        }
        
        guard let response = try? await URLSession.shared.data(for: request) else {
            return .init(output: nil, code: 408)
        }
        let code = (response.1 as? HTTPURLResponse)?.statusCode ?? 200
        let output = try? JSONDecoder().decode(Output.self, from: response.0)
        return .init(output: output, code: code)
    }
    
    private static func perform<Output: Decodable>(path: String,
                                                   method: Method = .GET) async -> PerformResult<Output> {
        await self.perform(path: path, method: method, body: EmptyBody())
    }
    
    private static var baseURL: String {
        "https://notes-udemy-bbd84652ed0e.herokuapp.com"
    }
}
