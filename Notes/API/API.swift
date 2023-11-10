//
//  API.swift
//  Notes
//
//  Created by james bouker on 11/10/23.
//

import Foundation

class API {
    static func notes() async -> [Note] {
        let request = URLRequest(url: URL(string: "\(baseURL)/notes")!)
        guard let data = await self.data(request) else { return [] }
        return (try? JSONDecoder().decode([Note].self, from: data)) ?? []
    }
    
    static func data(_ request: URLRequest) async -> Data? {
        guard let (data, _) = try? await URLSession.shared.data(for: request) else {
            return nil
        }
        return data
    }
    
    static var baseURL: String {
        "https://notes-udemy-bbd84652ed0e.herokuapp.com"
    }
}
