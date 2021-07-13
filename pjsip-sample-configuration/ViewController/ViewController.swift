//
//  ViewController.swift
//  pjsip-sample-configuration
//
//  Created by Now Software on 5/27/21.
//

import UIKit


class ViewController: UIViewController {

    var pool: pj_pool_t!
       
    let toneGenerator = ToneGenerator()
    let notificationCenter = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setDefaults()
       
        
        
//        let address = "<sip:tha923046889373@paidcall.talkhomeappcall.com>;tag=eBdwH8fepAJeg3hiD7uTV3jyLOIoectD"
//        let _val = fetchNumberAddress(_uri:address)
//        print("Number: \(_val.number ?? "") Address: \(_val.address ?? "")")
//
        
        
    }

    
    func setDefaults() {
        
        let config:AccountConfigurationDelegate = AccountConfiguration(authScheme: "demo")
        print("CONFIG: \(config.authScheme)")
        
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)

    }
    
    @objc func appMovedToBackground() {
        print("App moved to background!")
        
        if toneGenerator.player?.isPlaying ?? false {
            
            toneGenerator.volumeDown()
        }
    }
    
    @objc func appMovedToForeground() {
        print("App moved to foreground!")
        
        if toneGenerator.player?.isPlaying ?? false {
            
            toneGenerator.volumeUp()
        }
    }

    @IBAction func onPlayPressed(_ sender: Any) {


        toneGenerator.playSound()
        
    }
    @IBAction func onStopPressed(_ sender: Any) {
        
        toneGenerator.stopSound()
    }
    
    
    @available(iOS 13.0, *)
    func playHaptic() {
        
        if let hapticManager = HapticManager() {

            hapticManager.playSlice()
            
        } else {
            
            print("Device doesnt support haptics")
        }
        
    }
    

}




extension ViewController {
    
    func fetchNumberAddress(_uri:String)->(number:String?,address:String?){
        
        var uri:String = _uri
        let spaceSet = CharacterSet(charactersIn: " ")

        uri = uri.trimmingCharacters(in: spaceSet)
        
        if uri.range(of: "\"<") != nil && uri.range(of: ">\"") != nil {
            if let leftBraceOriginal = uri.range(of: "\"<") {
                uri = uri.replacingCharacters(in: leftBraceOriginal, with: "\"")
            }
            if let rightBraceOriginal = uri.range(of: ">\"") {
                uri = uri.replacingCharacters(in: rightBraceOriginal, with: "\"")
             }
        }
            
        if uri.range(of: "<") == nil && uri.range(of: ">") ==  nil {

            return (nil, nil)
        }
        
        var addressLocation: Int = 0
        if let _ranged =  uri.range(of: "<sip:tha") {
            
            let length = uri.distance(from: _ranged.lowerBound, to: _ranged.upperBound)

            let startIndex = uri.range(of: "<sip:tha")?.lowerBound.utf16Offset(in: uri) ?? 0

            addressLocation = startIndex + length
        } else {
            
            if let _ranged =  uri.range(of: "<") {
            
            let length = uri.distance(from: _ranged.lowerBound, to: _ranged.upperBound)

                let startIndex = uri.range(of: "<sip:tha")?.lowerBound.utf16Offset(in: uri) ?? 0

                addressLocation = startIndex + length
            }
        }
        
        
        
        let startIndex = uri.range(of: ">")?.lowerBound.utf16Offset(in: uri) ?? 0

        let addressRange = NSRange(location: addressLocation, length: startIndex - addressLocation)
        
        guard let _range = Range(addressRange, in: uri) else { return (nil,nil) }
        
        let address = uri.substring(with: _range)
        
        if address.contains("@") {
        let splitAddress = address.split(separator: "@")
        return (splitAddress[0].description,splitAddress[1].description)
        } else {
            return (nil,nil)
        }
    }

    
}
