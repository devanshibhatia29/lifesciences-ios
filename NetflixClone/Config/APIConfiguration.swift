//
//  APIConfiguration.swift
//  NetflixClone
//
//  Created by Developer on 2024/01/01.
//

import Foundation

struct APIConfiguration {
    static let shared = APIConfiguration()
    
    private init() {}
    
    // TMDB API Configuration
    var tmdbAPIKey: String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let key = plist["TMDB_API_KEY"] as? String else {
            fatalError("TMDB API Key not found in Config.plist")
        }
        return key
    }
    
    // Claude API Configuration
    var claudeAPIKey: String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let key = plist["CLAUDE_API_KEY"] as? String else {
            fatalError("Claude API Key not found in Config.plist")
        }
        return key
    }
    
    // Base URLs
    let tmdbBaseURL = "https://api.themoviedb.org/3"
    let tmdbImageBaseURL = "https://image.tmdb.org/t/p/w500"
    let claudeBaseURL = "https://api.anthropic.com/v1"
    
    // Validate API keys
    func validateAPIKeys() -> Bool {
        return !tmdbAPIKey.isEmpty && 
               !claudeAPIKey.isEmpty && 
               tmdbAPIKey != "YOUR_TMDB_API_KEY" && 
               claudeAPIKey != "YOUR_CLAUDE_API_KEY"
    }
}