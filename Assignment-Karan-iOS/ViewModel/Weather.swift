//
//  Weather.swift
//  Assignment-Karan-iOS
//
//  Created by Karan Gavali on 02/12/17.
//  Copyright © 2017 Karan Gavali. All rights reserved.
//

import Foundation
import SwiftSoup

class WeatherViewModel {
    
    private var listOfTerritories = [Territory]()
    private var csvText = "region_code,weather_param,year,key,value\n"
    
    typealias completion = (Bool,String,[Territory]) -> ()
    var callback: completion?


    //****************************************************************************************
    //MARK: Custom Method
    //****************************************************************************************
    
    func getYearOrderedStats(completion:@escaping completion) throws {
        callback = completion
        
        do {
            try ApiManager.getYearOrderedStats(callback: {(data,status,message) in
                
                if status {
                    if let data = data {
                        self.parseHtml(data)
                    } else{
                         completion(false,Constants.Message.ErrorMessage.somethingWentWrong,[])
                    }
                } else {
                     completion(false,message,[])
                }
            })
            
        } catch {
            throw WeatherError.Request.unsupportedUrl
        }
    }
    

    
    /// Responsible for Parsing HTML
    ///
    /// - Parameter data: Recieves data as Data parameter
    
    private func parseHtml(_ data: Data)  {
        do {
            let str = String(data: data, encoding: .utf8)
            let doc = try SwiftSoup.parse(str!)
            let table = try doc.select("table").array()
            
            let listOfTable = try table[1].select("tbody").select("tr").array()
            
            for i in 1...4 {
                
                let listOfTableData = try! listOfTable[i].select("td").array()
                
                var dto = Territory()
                dto.name = try listOfTableData[0].text()
                
                for j in 1...5 {
                    var temp = Temperature()
                    temp.url = try listOfTableData[j].child(0).attr("href")
                    
                    if let url = URL(string: temp.url) {
                        let name = "\(url.pathComponents[7])\(url.pathComponents[9])"
                        temp.name = name
                    }
                    
                    dto.temperature.append(temp)
                }
                listOfTerritories.append(dto)
            }
            getFile()
        } catch {
            callback?(false,Constants.Message.ErrorMessage.invalidHtml,[])
        }
    }

    
    /// Responsible for download file
    
    private func getFile() {
        let queue = OperationQueue()
        var listOp = [DownloadFile]()
        
        queue.maxConcurrentOperationCount = 1
        
        for i in 0..<listOfTerritories.count {
            
            for j in 0..<listOfTerritories[i].temperature.count {
                
                let operation = DownloadFile(withURLString: listOfTerritories[i].temperature[j].url)
                listOp.append(operation)
            }
        }
        let op = listOp[listOp.count-1]
        op.completionBlock = {
            self.parseTextFile()
        }
        queue.addOperations(listOp, waitUntilFinished: false)
    }
    
    
    /// Responsible for parsing text file
    
    private func parseTextFile() {
        
        for i in 0..<listOfTerritories.count {
            
            for j in 0..<listOfTerritories[i].temperature.count {
                
                let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = dir.appendingPathComponent(listOfTerritories[i].temperature[j].name)
                
                do {
                    var str = try String(contentsOf: fileURL, encoding: .utf8)
                    if let spaceRange = str.range(of: "\r\n\r\n") {
                        str.removeSubrange(str.startIndex...spaceRange.lowerBound)
                        let truncatedString = str.replacingOccurrences(of: "^\\s*", with: "", options: .regularExpression)
                        let temperationString = truncatedString.substring(to: truncatedString.index(truncatedString.endIndex, offsetBy: -1))

                        let listOfTemperature = temperationString.components(separatedBy: "\r\n")
                        for index in 1..<listOfTemperature.count {
                            let listOfTextValues = listOfTemperature[index].condenseWhitespace().components(separatedBy: " ")
                            var weather = Weather()
                            weather.year = listOfTextValues[0]
                            var listOfValues = [String]()
                            for valueIndex in 1...12 {
                                if listOfTextValues[0] == "2017" {
                                    if valueIndex < 11 {
                                        listOfValues.append(listOfTextValues[valueIndex])
                                        let newLine = "\(Params.getRegionCode(index: i)),\(Params.getWeatherParam(index: j)),\(listOfTextValues[0]),\(Params.getMonth(index: valueIndex)),\(listOfTextValues[valueIndex])\n"
                                        csvText.append(newLine)
                                    } else {
                                        listOfValues.append("N/A")
                                        let newLine = "\(Params.getRegionCode(index: i)),\(Params.getWeatherParam(index: j)),\(listOfTextValues[0]),\(Params.getMonth(index: valueIndex)),N/A\n"
                                        csvText.append(newLine)
                                    }
                                } else {
                                    listOfValues.append(listOfTextValues[valueIndex])
                                    let newLine = "\(Params.getRegionCode(index: i)),\(Params.getWeatherParam(index: j)),\(listOfTextValues[0]),\(Params.getMonth(index: valueIndex)),\(listOfTextValues[valueIndex])\n"
                                    csvText.append(newLine)
                                }
                            }
                            weather.listOfValues = listOfValues
                            listOfTerritories[i].temperature[j].listOfTemp.append(weather)
                        }
                    }
                } catch {
                    callback?(false,Constants.Message.ErrorMessage.unableToParseTextFile,[])
                }
            }
        }
        
//        print(csvText)
        
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = dir.appendingPathComponent("weather.csv")
        print("\n\nCSV file is Present at Document Directory please find it in location : \n\n***********************\n\n \(fileURL)\n\n")
        do {
            try? FileManager.default.removeItem(at: fileURL)
            try csvText.write(to: fileURL, atomically: true, encoding: .utf8)
            callback?(true,"",listOfTerritories)
        } catch {
            callback?(false,Constants.Message.ErrorMessage.failToWriteCSV,[])
        }
    }
}



