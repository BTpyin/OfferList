//
//  StringExtension.swift
//  OfferList
//
//  Created by Bowie Tso on 7/7/2024.
//

import Foundation
extension String {
    
    func encodeUrl() -> String? {
        return self.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)?.replacingOccurrences(of: "&", with: "%26")
    }
    
    func decodeUrl() -> String? {
        return self.removingPercentEncoding
    }
    
    func convertHtmlToAttributedString() -> NSAttributedString {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data,
                                          options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html,
                                                    NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
}
