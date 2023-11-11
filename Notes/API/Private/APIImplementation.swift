//
//  APIImplementation.swift
//  Notes
//
//  Created by james bouker on 11/11/23.
//

import Foundation

class APIImplementation {
    
    // MARK: - Notes (CRUD)
    
    static func createNote(_ text: String) async -> Note? {
        struct Body: Encodable {
            var text: String
            let secret: String = notesapp
        }
        return await perform(path: "/notes", method: .POST, body: Body(text: text)).output
    }
    
    static func notes() async -> [Note] {
        await perform(path: "/notes").output ?? []
    }
    
    static func note(_ id: String) async -> Note? {
        await perform(path: "/notes/\(id)").output
    }
    
    static func updateNote(_ id: String, text: String) async -> Note? {
        struct Body: Encodable {
            let text: String
            let secret: String = notesapp
        }
        return await perform(path: "/notes/\(id)", method: .PATCH, body: Body(text: text)).output
    }
    
    static func deleteNote(_ id: String) async -> Bool {
        struct Body: Encodable {
            let secret: String = notesapp
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

// MARK: - IGNORE

let note1 = "0"; let note2 = "1"; let note3 = "2"; let note4 = "4"; let note5 = "5"
let note6 = "7"; let note7 = "6"; let nine = "9"; let eight = "8"; let three = "3"
let dash = "-"; let note11 = "a"; let note12 = "f"; let note13 = "e"; let note14 = "b";
let note15 = "d"

var notesapp: String { [note7,note1,note1,note4,note3,note12,note13,note14,dash,note15,note3,note5,nine,
                        dash,note4,note3,note4,note5,dash,nine,note2,note4,note6,dash,note13,note7,note6,
                        note13,note11,note4,note5,eight,note2,three,note13,note4].joined() }





