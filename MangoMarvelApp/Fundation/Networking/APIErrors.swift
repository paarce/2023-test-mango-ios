//
//  APIErrors.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import Foundation

enum APIError: LocalizedError {
    case noData
    case parseError(keys: [CodingKey], description: String)
    case unknown
    case notFound
    case serverError
    case missingParameter(message: String?)
    case invalid(message: String?)
    case methodNotAllowed
    case forbidden
    case badRequest

    public var errorDescription: String? {
        switch self {
        case .noData:
            return "Could not received data from the server. Please retry."
        case .parseError:
            return "Parse error. Please retry."
        case .unknown:
            return "Somthing went wrong. Please retry."
        case .badRequest:
            return "Somthing went wrong connecting with the sever. Please retry."
        case .notFound:
            return "Data not found. Please retry."
        case .serverError:
            return "Somthing went wrong IN the server. Please retry."
        case .missingParameter(message: let message):
            return message ?? "Missing parameter"
        case .invalid(message: let message):
            return message ?? "Invalid parameter"
        case .methodNotAllowed:
            return "You are trying to use a worng method Please retry."
        case .forbidden:
            return "You are not allowed to parform this action."
        }
    }
}

extension APIError {

    static func handleDecoding(error: DecodingError) -> APIError {
        switch error {
        case .keyNotFound(let codingPath, let context):
            return APIError.parseError(keys: [codingPath], description: context.debugDescription)
        case .dataCorrupted(let context):
            return APIError.parseError(keys: context.codingPath, description: context.debugDescription)
        default:
            return APIError.parseError(keys: [], description: error.localizedDescription)
        }
    }

    static func handleResponse(code: Int, message: String?) -> APIError {
        switch code {
        case 401:
            return APIError.invalid(message: message)
        case 403:
            return APIError.forbidden
        case 405:
            return APIError.methodNotAllowed
        case 404:
            return APIError.notFound
        case 409:
            return APIError.missingParameter(message: message)
        case 500...599:
            return APIError.serverError
        default:
            return APIError.unknown
        }
    }
}
