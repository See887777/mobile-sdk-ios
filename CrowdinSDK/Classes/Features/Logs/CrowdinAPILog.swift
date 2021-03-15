//
//  CrowdinAPILog.swift
//  CrowdinSDK
//
//  Created by Nazar Yavornytskyy on 2/16/21.
//

import Foundation
import BaseAPI

struct CrowdinAPILog {
    
    static func logRequest(
        method: RequestMethod,
        url: String,
        parameters: [String: String]? = nil,
        headers: [String: String]? = nil,
        body: Data? = nil,
        responseData: Data? = nil,
        error: Error? = nil
    ) {
        let urlMethod = method.rawValue
        let message = [urlMethod, url].joined(separator: ", ")
        let attributedText = AttributedTextFormatter.make(
            method: method,
            url: url,
            parameters: parameters,
            headers: headers,
            body: body,
            responseData: responseData
        )
        
        guard url.contains("mapping") else {
            CrowdinLogsCollector.shared.add(log: .rest(with: message, attributedDetails: attributedText))
            return
        }
        
        CrowdinLogsCollector.shared.add(log: .info(with: message, attributedDetails: attributedText))
    }
    
    static func logRequest(
        response: ManifestResponse,
        stringURL: String,
        message: String
    ) {
        let url = URL(string: stringURL)?.deletingLastPathComponent().description.dropLast().description ?? stringURL
        let details = response.files.map({ $0 }).joined(separator: "\n")
        let attributedText: NSMutableAttributedString = NSMutableAttributedString()
        attributedText.append(AttributeFactory.make(.url(url + details)))
        CrowdinLogsCollector.shared.add(
            log: CrowdinLog(
                type: .info,
                message: message,
                attributedDetails: attributedText
            )
        )
    }
}
