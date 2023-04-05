//
//  MyCalendarApp.swift
//  MyCalendar
//
//  Created by Aleksei Tiurnin on 07.03.2023.
//

import Apexy
import ApexyURLSession
import SwiftUI

// https://raw.githubusercontent.com/d10xa/holidays-calendar/master/json/consultant2023.json

let client: Client = {
    let requestAdapter = BaseRequestAdapter(baseURL: URL(string: "https://raw.githubusercontent.com/")!)
    let client = URLSessionClient(requestAdapter: requestAdapter, configuration: .default)
    return client
}()

let decoder: JSONDecoder = {
   let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom({ decoder in
        let container = try decoder.singleValueContainer()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter.date(from: try container.decode(String.self))!
    })
    return decoder
}()

struct BusinessCalendarEndpoint: Endpoint, URLRequestBuildable {
    typealias Content = BusinessCalendar
    
    let year: Int
    
    func makeRequest() throws -> URLRequest {
        get(URL(string: "d10xa/holidays-calendar/master/json/consultant\(year).json")!, queryItems: nil)
    }
    
    func content(from response: URLResponse?, with body: Data) throws -> Content {
        return try decoder.decode(Content.self, from: body)
    }
}

@main
struct MyCalendarApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
