//
//  BusinessCalendarManager.swift
//  WallCall
//
//  Created by Aleksei Tiurnin on 05.04.2023.
//  Copyright © 2023 Redmadrobot OOO. All rights reserved.
//

import Apexy
import ApexyURLSession
import Foundation

struct BusinessCalendar: Codable {
    let holidays: [Date]
    let preholidays: [Date]
}

// https://raw.githubusercontent.com/d10xa/holidays-calendar/master/json/consultant2023.json

private class BusinessCalendarNetworkClient {
    
    private static var defalutFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }
    
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(defalutFormatter)
        return decoder
    }()
    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(defalutFormatter)
        return encoder
    }()
    
    private let client: Client = {
        let requestAdapter = BaseRequestAdapter(baseURL: URL(string: "https://raw.githubusercontent.com/")!)
        let client = URLSessionClient(requestAdapter: requestAdapter, configuration: .default)
        return client
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
    
    func getCalendar(for year: Int) async throws -> BusinessCalendar {
        return try await client.request(BusinessCalendarEndpoint(year: year))
    }
}

class BusinessCalendarManager {
    
    private let client = BusinessCalendarNetworkClient()
    private var businessCalendars: [Int: BusinessCalendar] = [:]
    private let storage: UserDefaults = UserDefaults.standard
    
    func load(for date: Date) async {
        let year = calendar.component(.year, from: date)
        do {
            let calendar = try await client.getCalendar(for: year)
            businessCalendars[year] = calendar
            save(calendar: calendar, for: year)
        } catch {
        }
    }
    
    func getBusinessCalendar(for date: Date) -> BusinessCalendar? {
        let year = calendar.component(.year, from: date)
        if businessCalendars[year] == nil {
            businessCalendars[year] = loadCalendar(for: year)
        }
        return businessCalendars[year]
    }
    
    func save(calendar: BusinessCalendar, for year: Int) {
        let data = try? BusinessCalendarNetworkClient.encoder.encode(calendar)
        storage.set(data, forKey: "\(year)")
    }
    
    func loadCalendar(for year: Int) -> BusinessCalendar? {
        guard let data = storage.data(forKey: "\(year)"),
              let calendar = try? BusinessCalendarNetworkClient.decoder.decode(BusinessCalendar.self, from: data) else {
            return nil
        }
        return calendar
    }
}
