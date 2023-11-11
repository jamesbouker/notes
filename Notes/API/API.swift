//
//  API.swift
//  Notes
//
//  Created by james bouker on 11/10/23.
//

import Foundation

class API {
    
    // MARK: - Notes (CRUD)
    
    static func createNote(_ text: String) async -> Note? {
        let parameters = "{\"text\": \"\(text)\"\n}"
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: "\(baseURL)/notes")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        guard let data = await self.data(request) else { return nil }
        return (try? JSONDecoder().decode(Note.self, from: data)) ?? nil
    }
    
    static func notes() async -> [Note] {
        let request = URLRequest(url: URL(string: "\(baseURL)/notes")!)
        guard let data = await self.data(request) else { return [] }
        return (try? JSONDecoder().decode([Note].self, from: data)) ?? []
    }
    
    static func note(_ id: String) async -> Note? {
        let request = URLRequest(url: URL(string: "\(baseURL)/notes/\(id)")!)
        guard let data = await self.data(request) else { return nil }
        return (try? JSONDecoder().decode(Note.self, from: data)) ?? nil
    }
    
    static func updateNote(_ id: String, text: String) async -> Note? {
        let parameters = "{\n    \"text\": \"\(text)\"\n}"
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: "\(baseURL)/notes/\(id)")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        request.httpBody = postData
        
        guard let data = await self.data(request) else { return nil }
        return (try? JSONDecoder().decode(Note.self, from: data)) ?? nil
    }
    
    static func deleteNote(_ id: String) async -> Bool {
        var request = URLRequest(url: URL(string: "\(baseURL)/notes/\(id)")!)
        request.httpMethod = "DELETE"
        guard let response = await self.response(request) else { return false }
        return (response as? HTTPURLResponse)?.statusCode == 200
    }
    
    // MARK: - Private Helpers
    
    private static func data(_ request: URLRequest) async -> Data? {
        guard let (data, _) = try? await URLSession.shared.data(for: request) else {
            return nil
        }
        return data
    }
    
    private static func response(_ request: URLRequest) async -> URLResponse? {
        guard let (_, response) = try? await URLSession.shared.data(for: request) else {
            return nil
        }
        return response
    }
    
    private static var baseURL: String {
        "https://notes-udemy-bbd84652ed0e.herokuapp.com"
    }
}
