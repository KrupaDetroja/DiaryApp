//
//  Utilities.swift
//  Developer
//
//  Created by Krupa Detroja on 22/10/20.
//  Copyright © 2020 DIARY APP. All rights reserved.
//

import UIKit
import TTGSnackbar

enum SnackBarType {
    case Failure
    case Success
    case Warning
    case InfoOrNotes
}

extension UIViewController{
    
    func showSnackBarAlert(message: String, type: SnackBarType, duration : TTGSnackbarDuration = .middle, animationType : TTGSnackbarAnimationType = .slideFromBottomBackToBottom) {
        if message.count != 0 {
            let snackBar = TTGSnackbar(message: message, duration: duration)
            snackBar.messageTextColor = .white
            snackBar.animationType = animationType
            snackBar.show()
            switch type {
            case .Success:
                snackBar.backgroundColor = COLORS.snackBarColorSuccess
                break
            case .Failure:
                snackBar.backgroundColor = COLORS.snackBarColorFailure
                break
            case .Warning:
                snackBar.backgroundColor = COLORS.snackBarColorWarning
                break
            case .InfoOrNotes:
                snackBar.backgroundColor = COLORS.snackBarColorInfo
                break
            }
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                COMMON_SINON.SHARED.DLOG(message: error.localizedDescription)
            }
        }
        return nil
    }
    
    func loadTime(date:String) -> String {
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date1 = formatterDate.date(from: date)
        if(date1 != nil) {
            formatterDate.dateFormat = "dd/MM/yyyy"
            return formatterDate.string(from: date1!)
        }
        return ""
    }
    
    func getYoutubeId(youtubeUrl: String) -> String? {
        return URLComponents(string: youtubeUrl)?.queryItems?.first(where: { $0.name == "v" })?.value
    }
    
    func videoIDFromYouTubeURL(_ videoURL: URL) -> String? {
        if videoURL.pathComponents.count > 1 && (videoURL.host?.hasSuffix("youtu.be"))! {
            return videoURL.pathComponents[1]
        } else if videoURL.pathComponents.contains("embed") {
            return videoURL.pathComponents.last
        }
        return URLComponents(string: videoURL.absoluteString)?.queryItems?.first(where: { $0.name == "v" })?.value
    }
    
    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
    func cropBannerImage(img : UIImageView) {
        let path = UIBezierPath()
        let screenWidth : CGFloat = UIScreen.main.bounds.width
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: img.frame.size.height - 30))
        path.addQuadCurve(to: CGPoint(x: screenWidth, y: img.frame.size.height - 30), controlPoint: CGPoint(x: screenWidth / 2, y: img.frame.size.height ))
        path.addLine(to: CGPoint(x: screenWidth, y: 0))
        let mask = CAShapeLayer()
        mask.frame = img.bounds
        mask.path = path.cgPath
        img.layer.mask = mask
        UIColor.clear.setFill()
        path.fill()
    }
}

extension Date {
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        return end - start
    }
}

// MARK: - Encode Decode
func getAsciiUtf8EncodedString(_ stringToEncode: String) -> String {
    let data: Data? = stringToEncode.data(using: String.Encoding.nonLossyASCII)
    let Value = String(data: data!, encoding: String.Encoding.utf8)
    return Value ?? ""
}

func getAsciiUtf8DecodedString(_ stringToDecode: String) -> String {
    let strToDecode = stringToDecode.replacingOccurrences(of: "\\n", with: "")
    let data: Data? = strToDecode.data(using: String.Encoding.utf8)
    let Value = String(data: data!, encoding: String.Encoding.nonLossyASCII)
    if Value == nil {
        return stringToDecode
    }
    return Value ?? ""
}

extension String {
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(start, offsetBy: r.upperBound - r.lowerBound)
        return String(self[(start ..< end)])
    }
    /**
     Pads the left side of a string with the specified string up to the specified length.
     Does not clip the string if too long.
     
     - parameter padding:   The string to use to create the padding (if needed)
     - parameter length:    Integer target length for entire string
     - returns: The padded string
     */
    func lpad(_ padding: String, length: Int) -> (String) {
        if self.count > length {
            return self
        }
        return "".padding(toLength: length - self.count, withPad:padding, startingAt:0) + self
    }
    /**
     Pads the right side of a string with the specified string up to the specified length.
     Does not clip the string if too long.
     
     - parameter padding:   The string to use to create the padding (if needed)
     - parameter length:    Integer target length for entire string
     - returns: The padded string
     */
    func rpad(_ padding: String, length: Int) -> (String) {
        if self.count > length { return self }
        return self.padding(toLength: length, withPad:padding, startingAt:0)
    }
    /**
     Returns string with left and right spaces trimmed off.
     
     - returns: Trimmed String
     */
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    
    /**
     Returns substring extracted from a string at start and end location.
     
     - parameter start:               Where to start (-1 acceptable)
     - parameter end:                 (Optional) Where to end (-1 acceptable) - default to end of string
     - returns: String
     */
    func stringFrom(_ start: Int, to end: Int? = nil) -> String {
        var maximum = self.count
        
        let i = start < 0 ? self.endIndex : self.startIndex
        let ioffset = min(maximum, max(-1 * maximum, start))
        let startIndex = self.index(i, offsetBy: ioffset)
        
        maximum -= start
        
        let j = end! < 0 ? self.endIndex : self.startIndex
        let joffset = min(maximum, max(-1 * maximum, end ?? 0))
        let endIndex = end != nil && end! < self.count ? self.index(j, offsetBy: joffset) : self.endIndex
        
        return String(self[startIndex..<endIndex])
    }
    /**
     Returns substring composed of only the allowed characters.
     
     - parameter allowed:             String list of acceptable characters
     - returns: String
     */
    func onlyCharacters(_ allowed: String) -> String {
        let search = allowed
        return self.filter({ search.contains($0) }).reduce("", { $0 + String($1) })
    }
    /**
     Returns substring composed of only the allowed characters.
     
     - parameter charactor:             characters need to remove from the list
     - returns: String
     */
    func removeMultipleCharactor(_ charactor: String) -> String {
        
        // Create character set with specified characters
        let characterSet = CharacterSet(charactersIn: charactor)
        // Build array of components using specified characters as separtors
        let arrayOfComponents = self.components(separatedBy: characterSet)
        // Create string from the array components
        let strOutput = arrayOfComponents.joined(separator: "")
        return strOutput
    }
    /**
     Simple pattern matcher. Requires full match (ie, includes ^$ implicitly).
     
     - parameter pattern:             Regex pattern (includes ^$ implicitly)
     - returns: true if full match found
     */
    func matches(_ pattern: String) -> Bool {
        let test = NSPredicate(format:"SELF MATCHES %@", pattern)
        return test.evaluate(with: self)
    }
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    var isValidEmail: Bool {
        
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidYoutubeURL: Bool {
        return true
        //        let emailRegEx = "(http:|https:)?(www\\.)?(youtube.com|youtu.be)\/(watch)?(\\?v=)?(\\S+)?"
        //
        //        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        //        return emailTest.evaluate(with: self)
    }
    
    var isValidPwdLenth: Bool {
        if self.count < 4{
            return false
        }else{
            return true
        }
    }
    var isValidPincode: Bool {
        if self.count == 5{
            return true
        }
        else{
            return false
        }
    }
    var isValidPhoneNo: Bool {
        let PHONE_REGEX = "^[0-9]{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
    var encodeString : String
    {
        return getAsciiUtf8EncodedString(self)
    }
    
    var decodeString : String
    {
        return getAsciiUtf8DecodedString(self)
    }
    func htmlAttributed(using font: UIFont, color: UIColor) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                //      "font-size: \(font.pointSize)pt !important;" +
                "color: #\(color.hexString!) !important;" +
                "font-family: \(font.familyName), Helvetica !important;" +
            "}</style> \(self)"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }
            
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            COMMON_SINON.SHARED.DLOG(message: "error: \(error)")
            return nil
        }
    }
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8),
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            COMMON_SINON.SHARED.DLOG(message: "error: \(error)")
            return nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    func stringByAddingPercentEncodingForRFC3986() -> String? {
        let unreserved = "-._~/?"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        
        return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
    }
}
extension UIColor {
    var hexString:String? {
        if let components = self.cgColor.components {
            let r = components[0]
            let g = components[1]
            let b = components[2]
            return  String(format: "%02X%02X%02X", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))
        }
        return nil
    }
}

extension NSMutableAttributedString {
    enum scripting: Int {
        case aSub = -1
        case aSuper = 1
    }
    
    func characterSubscriptAndSuperscript(string: String, characters: [Character], type: scripting, fontSize: CGFloat, scriptFontSize: CGFloat, offSet: Int, length: [Int], alignment: NSTextAlignment)-> NSMutableAttributedString {
        let paraghraphStyle = NSMutableParagraphStyle()
        // Set The Paragraph aligmnet , you can ignore this part and delet off the function
        paraghraphStyle.alignment = alignment
        var scriptedCharaterLocation = Int()
        //Define the fonts you want to use and sizes
        let stringFont = UIFont.systemFont(ofSize: fontSize)//UIFont.boldSystemFont(ofSize: fontSize)
        let scriptFont = UIFont.systemFont(ofSize: scriptFontSize)//UIFont.boldSystemFont(ofSize: scriptFontSize)
        // Define Attributes of the text body , this part can be removed of the function
        let attString = NSMutableAttributedString(string:string, attributes: [NSAttributedString.Key.font:stringFont,NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.paragraphStyle: paraghraphStyle])
        // the enum is used here declaring the required offset
        let baseLineOffset = offSet * type.rawValue
        // enumerated the main text characters using a for loop
        for (i,c) in string.enumerated() {
            // enumerated the array of first characters to subscript
            for (theLength,aCharacter) in characters.enumerated() {
                if c == aCharacter {
                    // Get to location of the first character
                    scriptedCharaterLocation = i
                    //Now set attributes starting from the character above
                    attString.setAttributes([NSAttributedString.Key.font:scriptFont,
                                             // baseline off set from . the enum i.e. +/- 1
                        NSAttributedString.Key.baselineOffset:baseLineOffset,
                        NSAttributedString.Key.foregroundColor:UIColor.black],
                                            // the range from above location
                        range:NSRange(location:scriptedCharaterLocation,
                                      // you define the length in the length array
                            // if subscripting at different location
                            // you need to define the length for each one
                            length:length[theLength]))
                    
                }
            }
        }
        return attString}
}

private var xoAssociationKey: UInt8 = 0
extension UIButton {
    var indexPath: IndexPath! {
        get {
            return objc_getAssociatedObject(self, &xoAssociationKey) as? IndexPath
        }
        set(newValue) {
            objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}
