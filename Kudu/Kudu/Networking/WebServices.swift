//
//  PaymentTestEndPoints.swift
//  Kudu
//
//  Created by Admin on 28/04/22.
//

import Foundation

final class WebServices
{
    final class PaymentTestEndPoints {
        static func payADollar(cardToken:String,success: @escaping SuccessCompletionBlock<EmptyDataResponse>, failure: @escaping ErrorFailureCompletionBlock)
        {
            Api.requestNew(endpoint: .payment(cardToken: cardToken), successHandler: success, failureHandler: failure)
        }
    }
}

