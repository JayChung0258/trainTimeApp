//
//  httpMeghod.swift
//  CleanTrainTime
//
//  Created by 洪丞桀 on 2019/1/31.
//  Copyright © 2019 JayChung. All rights reserved.
//

//

import Foundation
import UIKit
import CommonCrypto



//MARK: ENUM SET
enum CryptoAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

let APP_ID = "4d1061b7cc74406d8f7539ab5622f268"
let APP_KEY = "-9UiYog09_WC4dlqPPZBnCenTjk"


let xdate:String = getServerTime();
let signDate = "x-date: " + xdate;

let base64HmacStr = signDate.hmac(algorithm: .SHA1, key: APP_KEY)
let authorization:String = "hmac username=\""+APP_ID+"\", algorithm=\"hmac-sha1\", headers=\"x-date\", signature=\""+base64HmacStr+"\""



func setUpUrl(APIUrl: String) -> URLRequest {
    let url = URL(string: APIUrl)
    var request = URLRequest(url: url!)
    
    request.setValue(xdate, forHTTPHeaderField: "x-date")
    request.setValue(authorization, forHTTPHeaderField: "Authorization")
    request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
    
    return request
}

extension String {
    
    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        
        let cKey = key.cString(using: String.Encoding.utf8)
        let cData = self.cString(using: String.Encoding.utf8)
        let digestLen = algorithm.digestLength
        var result = [CUnsignedChar](repeating: 0, count: digestLen)
        CCHmac(algorithm.HMACAlgorithm, cKey!, strlen(cKey!), cData!, strlen(cData!), &result)
        let hmacData:Data = Data(bytes: result, count: digestLen)
        let hmacBase64 = hmacData.base64EncodedString(options: .lineLength64Characters)
        
        return String(hmacBase64)
    }
    
    func mySubString(to index: Int) -> String {
        return String(self[..<self.index(self.startIndex, offsetBy: index)])
    }
    
    func mySubString(from index: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: index)...])
    }
}

func getServerTime() -> String {
    
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "EEE, dd MMM yyyy HH:mm:ww zzz"
    dateFormater.locale = Locale(identifier: "en_US")
    dateFormater.timeZone = TimeZone(secondsFromGMT: 0)
    
    return dateFormater.string(from: Date())
}

