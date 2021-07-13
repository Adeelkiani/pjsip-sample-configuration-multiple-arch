//
//  AccountConfiguration.swift
//  pjsip-sample-configuration
//
//  Created by Now Software on 7/8/21.
//

import Foundation

protocol AccountConfigurationDelegate {
    
    var displayName : String? {get set}
    var address : String? {get set}
    var domain : String? {get set}
    var proxy : String? {get set}
    var authScheme : String {get set}
    var authRealm : String {get set}
    var username : String? {get set}
    var password : String? {get set}
    var registerOnAdd : Bool {get set}
    var publishEnabled : Bool {get set}
    func getAddressFromUserName(userName:String,domain:String)->String
    
}

class AccountConfiguration:NSObject,AccountConfigurationDelegate {
 
    var displayName: String?
    
    var address: String?
    
    var domain: String?
    
    var proxy: String?
    
    var authScheme: String = "digest"
    
    var authRealm: String = "*"
    
    var username: String?
    
    var password: String?
    
    var registerOnAdd: Bool = false
    
    var publishEnabled: Bool = false
    
    
     func getAddressFromUserName(userName: String, domain: String) -> String {
         
        return "\(userName)@\(domain)"
     }
    
 
    
    convenience init(authScheme:String) {
        self.init()
        self.authScheme = authScheme
    }
    
}
