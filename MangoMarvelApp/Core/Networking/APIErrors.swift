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
            return "COMICS_API_ERROR_NO_DATA".localized
        case .parseError:
            return "COMICS_API_ERROR_PARSE".localized
        case .unknown:
            return "COMICS_API_ERROR_UNKNOWN".localized
        case .badRequest:
            return "COMICS_API_ERROR_BAD_REQUEST".localized
        case .notFound:
            return "COMICS_API_ERROR_NOT_FOUND".localized
        case .serverError:
            return "COMICS_API_ERROR_SERVER_ERROR".localized
        case .missingParameter(message: let message):
            return message ?? "COMICS_API_ERROR_MISSING_PARAMETER".localized
        case .invalid(message: let message):
            return message ?? "COMICS_API_ERROR_INVALID_PARAMETER".localized
        case .methodNotAllowed:
            return "COMICS_API_ERROR_METHOD_NOT_ALLOWED".localized
        case .forbidden:
            return "COMICS_API_ERROR_FORBIDDEN".localized
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
