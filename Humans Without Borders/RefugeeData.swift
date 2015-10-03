//
//  RefugeeData.swift
//  Humans Without Borders
//
//  Created by Matthew Allen Lin on 10/3/15.
//  Copyright © 2015 Humans Without Borders. All rights reserved.
//

import Foundation

let SPDefaultClientName:String = "jenny";
let SPBaseCapabilityTokenUrl:String = "http://example.com/generateToken?%@"
let SPTwiMLAppSid:String = "APxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";

class RefugeeData {
    var device:TCDevice? = nil;
    var connection:TCConnection? = nil;
    
    func login() {
        var url:String = self.getCapabilityTokenUrl();
    }
    
    func getCapabilityTokenUrl() -> String {
        
        var querystring:String = String();
        
        querystring += String(format:"&sid=%@", SPTwiMLAppSid);
        querystring += String(format:"&name=%@", SPDefaultClientName);
        
        return String(format:SPBaseCapabilityTokenUrl, querystring);
    }
}