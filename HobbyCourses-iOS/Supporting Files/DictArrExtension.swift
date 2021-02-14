//
//  DictArrExtension.swift
//  Webservice
//
//  Created by Nitin on 7/2/18.
//  Copyright © 2018 Nitin. All rights reserved.
//

import Foundation
extension Dictionary where Key == String {


    func getIntValue(forkey key : String) -> Int{
        if let value = self[key] as? Int {
            return value
        }else{
            return 0
        }
    }
    func getStringValue(forkey key : String) -> String{
        if let value = self[key] as? String {
            if  value == "<null>"{
                return ""
            }
            return value
        }else if let value = self[key] {
            return "\(value)"
        }
        return ""
    }
    func getStringIntValue(forkey key : String) -> String{
        if let value = self[key] as? String {
            return value
        }else{
            if let value = self[key] as? Int {
                return "\(value)"
            }
        }
         return ""
    }
    func getDoubleValue(forkey key : String) -> Double{
        if let value = self[key] as? Double {
            return value
        }else{
            return 0.0
        }
    }
    func getFloatValue(forkey key : String) -> Float{
        if let value = self[key] as? Float {
            return value
        }else{
            return 0.0
        }
    }
    func getDictionaryValue(forkey key : String) -> Dictionary<String,Any>{
        if let value = self[key] as? Dictionary<String,Any> {
            return value
        }else{
            return [:]
        }
    }
    func getArrayValue(forkey key : String) -> [Any]{
        if let value = self[key] as? [Any] {
            return value
        }else{
            return []
        }
    }
    
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .init(rawValue: 2))
            let myJson = String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
//            myJson = myJson.replacingOccurrences(of: "\n", with: "")
//            myJson = myJson.replacingOccurrences(of: " ", with: "")
//            myJson = myJson.replacingOccurrences(of: "\"", with: "")
            
            return myJson
        } catch {
            return invalidJson
        }
    }
    
   /* var jsonViaEncoder: String {
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(self) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        }
       return ""
    }
    */
    
}
extension Array  {
    func getIntValue(atIndex index : Int) -> Int{
        if let value = self[index] as? Int {
            return value
        }else{
            return 0
        }
    }
    func getStringValue(atIndex index : Int) -> String{
        if let value = self[index] as? String {
            return value
        }else{
            return ""
        }
    }
    
    func getDoubleValue(atIndex index : Int) -> Double{
        if let value = self[index] as? Double {
            return value
        }else{
            return 0.0
        }
    }
    func getFloatValue(atIndex index : Int) -> Float{
        if let value = self[index] as? Float {
            return value
        }else{
            return 0.0
        }
    }
    func getDictionaryValue(atIndex index : Int) -> Dictionary<String,Any>{
        if let value = self[index] as? Dictionary<String,Any> {
            return value
        }else{
            return [:]
        }
    }
    func getArrayValue(atIndex index : Int) -> [Any]{
        if let value = self[index] as? [Any] {
            return value
        }else{
            return []
        }
    }
    
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .init(rawValue: 2))
            let myJson = String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson

            return myJson
        } catch {
            return invalidJson
        }
    }
    
   /* var jsonViaEncoder: String {
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(self) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        }
        return ""
    }
 */
}



