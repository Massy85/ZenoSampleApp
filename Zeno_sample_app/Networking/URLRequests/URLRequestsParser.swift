//
//  URLRequestsParser.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 17/03/22.
//

import Foundation

internal class URLRequestsParser {
    private init() {}
    
    static func login(_ username: String, _ password: String) -> URLRequest? {
        guard let url = URL(string: "https://www.cloud.urmet.com/tool/zenoapi/REST/v2/auth/login") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String : Any] = ["account" : username, "password" : password]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            print(error)
        }
        
        return request
    }
    
    static func getPanelMode(_ token: String) -> URLRequest? {
        guard let url = URL(string: "https://www.cloud.urmet.com/tool/zenoapi/REST/v2/panel/mode") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "token")
        
        //        var urlComponents = URLComponents(string: url.absoluteString)
        //        var queries: [URLQueryItem] = []
        //        queries.append(URLQueryItem(name: "mac", value: mac))
        //        urlComponents?.queryItems = queries
        //        request.url = urlComponents?.url
        
        return request
    }
    
    static func setPanelMode(_ token: String, _ area: String, _ mode: String, _ pincode: String, _ format: String, _ bypass: String) -> URLRequest? {
        guard let url = URL(string: "https://www.cloud.urmet.com/tool/zenoapi/REST/v2/panel/mode") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "token")
        
        let parameters: [String : Any] = [
            "area" : area,
            "mode" : mode,
            "pincode" : pincode,
            "format" : format,
            "bypass" : bypass
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            return nil
        }
        
        return request
    }
    
    static func getPanelDevice(_ token: String) -> URLRequest? {
        guard let url = URL(string: "https://www.cloud.urmet.com/tool/zenoapi/REST/v2/panel/device") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "token")
        return request
    }
    
    static func getEvents(_ token: String, _ events: String, _ type: String?, _ date: String?) -> URLRequest? {
        guard let url = URL(string: "https://www.cloud.urmet.com/tool/zenoapi/REST/v2/event") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "token")
        
        var urlComponents = URLComponents(string: url.absoluteString)
        var queries: [URLQueryItem] = []
        
        queries.append(URLQueryItem(name: "num", value: events))
        
        if let type = type {
            let query = URLQueryItem(name: "type", value: type)
            queries.append(query)
        }
        
        if let date = date {
            let query = URLQueryItem(name: "event_date", value: date)
            queries.append(query)
        }
        
        urlComponents?.queryItems = queries
        
        request.url = urlComponents?.url
        return request
    }
    
    static func getFaultDashboard(_ token: String) -> URLRequest? {
        guard let url = URL(string: "https://www.cloud.urmet.com/tool/zenoapi/REST/v2/fault/dashboard") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "token")
        
        //        var urlComponents = URLComponents(string: url.absoluteString)
        //        var queries: [URLQueryItem] = []
        //        queries.append(URLQueryItem(name: "mac", value: mac))
        //        urlComponents?.queryItems = queries
        //        request.url = urlComponents?.url
        
        return request
    }
}
