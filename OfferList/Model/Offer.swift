//
//  Offer.swift
//  OfferList
//
//  Created by Bowie Tso on 7/7/2024.
//

import Foundation

// MARK: - WelcomeElement
struct Offer: Codable {
    let badge1: String?
    let badge2: String?
    let description, endDate: String?
    let offerAppImageURL: String?
    let offerID, offerName: String?
    let sticker: String?
    let tnc: String?

    enum CodingKeys: String, CodingKey {
        case badge1, badge2, description, endDate
        case offerAppImageURL = "offerAppImageUrl"
        case offerID = "offerId"
        case offerName, sticker, tnc
    }
}

typealias OfferList = [Offer]
