//
//  Utils.swift
//  Assignment-Karan-iOS
//
//  Created by Karan Gavali on 02/12/17.
//  Copyright © 2017 Karan Gavali. All rights reserved.
//

import Foundation
import UIKit


/// Custom Weather Error
///
/// - unsupportedUrl: throws if url is invalid
/// - invalidHtml: throws if html is invalid
enum WeatherError {
    enum Request:Error {
        case unsupportedUrl
    }
    
    enum Parser: Error {
        case invalidHtml
    }
}


/// App Constants

struct Constants {
    
    /// URL Constants
    struct Path {
        static let url = "https://www.metoffice.gov.uk/climate/uk/summaries/datasets"
    }
    
    
    /// Segue Constants
    struct Segue {
        static let detailIdentifier = "weatherSegue"
    }
    
    
    /// Error Message
    struct Message {
        struct ErrorMessage {
            static let somethingWentWrong = "OOPS!!! Something went wrong."
            static let unableToParseTextFile = "Unable to parse text file."
            static let invalidHtml = "Invalid Html format."
            static let failToWriteCSV = "Fail to write CSV file."
            static let noInternetConnection = "It seems to be there is no internet connection available."
        }
        
    }
}


/// Responsible for constant Parameter
struct Params {
    
    
    /// Responsible for get month
    ///
    /// - Parameter index: index of month should be in range 1...12
    /// - Returns: Returns a month depending on index
    static func getMonth(index: Int) -> String {
        switch index {
        case 1:
            return "JAN"
        case 2:
            return "FEB"
        case 3:
            return "MAR"
        case 4:
            return "APR"
        case 5:
            return "MAY"
        case 6:
            return "JUN"
        case 7:
            return "JUL"
        case 8:
            return "AUG"
        case 9:
            return "SEP"
        case 10:
            return "OCT"
        case 11:
            return "NOV"
        case 12:
            return "DEC"
        default:
            return ""
        }
    }
    
    
    /// Responsible for get Region Code
    ///
    /// - Parameter index: index of region code should be in range 0...3
    /// - Returns: Returns a region code depending on index
    static func getRegionCode(index:Int) -> String {
        switch index {
        case 0:
            return "UK"
        case 1:
            return "England"
        case 2:
            return "Wales"
        case 3:
            return "Scotland"
        default:
            return ""
        }
    }
    
    
    /// Rsponsible for getting the weather param
    ///
    /// - Parameter index: index of weather param should be in range 0...3
    /// - Returns: index of weather param should be in range 0...4
    static func getWeatherParam(index:Int) -> String {
        switch index {
        case 0:
            return "Max Temp"
        case 1:
            return "Min Temp"
        case 2:
            return "Mean Temp"
        case 3:
            return "Sunshine"
        case 4:
            return "Rainfall"
        default:
            return ""
        }
    }
}



/// Protocol for alert

protocol Aletable {}


extension Aletable where Self: UIViewController {
    
    /// Responsible for showing an alert controller
    ///
    /// - Parameter message: alert message
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: title, message: "Weather", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
           self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    /// Responsible for showing loading view
    func showSpinner() {
        let alertController = UIAlertController(title: nil, message: "Loading \n\n", preferredStyle: .alert)
        
        let spinnerIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        
        alertController.view.addSubview(spinnerIndicator)
        
        if let presentedViewController = self.presentedViewController {
            if presentedViewController.isKind(of: UIAlertController.self) {
                self.present(alertController, animated: false, completion: nil)
            }
        } else {
            self.present(alertController, animated: false, completion: nil)
        }
    }
    
    
    /// Responsible for dissmiss a loading view
    func dissmissSpinner() {
        if let presentedViewController = self.presentedViewController {
            if presentedViewController.isKind(of: UIAlertController.self) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
}


extension String {
    
    /// Responsible for removing multiple spaces between word's
    ///
    /// - Returns: String with containing single space between word's
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy:NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}


