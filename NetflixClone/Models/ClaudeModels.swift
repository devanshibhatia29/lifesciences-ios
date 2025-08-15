//
//  ClaudeModels.swift
//  NetflixClone
//
//  Created by Developer on 2024/01/01.
//

import Foundation

// MARK: - Claude API Request Models

struct ClaudeRequest: Codable {
    let model: String
    let maxTokens: Int
    let messages: [ClaudeMessage]
    
    enum CodingKeys: String, CodingKey {
        case model
        case maxTokens = "max_tokens"
        case messages
    }
}

struct ClaudeMessage: Codable {
    let role: String
    let content: String
}

// MARK: - Claude API Response Models

struct ClaudeResponse: Codable {
    let id: String?
    let type: String?
    let role: String?
    let content: [ClaudeContent]?
    let model: String?
    let stopReason: String?
    let stopSequence: String?
    let usage: ClaudeUsage?
    
    enum CodingKeys: String, CodingKey {
        case id, type, role, content, model
        case stopReason = "stop_reason"
        case stopSequence = "stop_sequence"
        case usage
    }
}

struct ClaudeContent: Codable {
    let type: String
    let text: String
}

struct ClaudeUsage: Codable {
    let inputTokens: Int
    let outputTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case inputTokens = "input_tokens"
        case outputTokens = "output_tokens"
    }
}