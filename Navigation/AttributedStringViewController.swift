//
//  AttributedStringViewController.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 19.08.2024.
//

import UIKit

class AttributedStringViewController: UIViewController {
    
    lazy var textLabel: UITextView = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        let string = "Если у вас остались вопросы, Вы всегда можете связаться с нами по этой ссылке"
        let attrString = NSMutableAttributedString(string: string)
        textLabel.isEditable = false
        
        let color = [UIColor.red, UIColor.green, UIColor.blue, UIColor.yellow, UIColor.black, UIColor.cyan]
        
//        for (index, _) in string.enumerated() {
//            let randColor = color.randomElement()
//            let range = (10...40)
//            attrString.addAttributes([
//                .foregroundColor: randColor,
//                .font : UIFont.systemFont(ofSize: CGFloat(range.randomElement()!))
//            ], range: .init(location: index, length: 1))
//        }
//        
        let range = (string as NSString).range(of: "по этой ссылке")
        let secondRange = (string as NSString).range(of: "с нами по")
        attrString.addAttributes([
            .foregroundColor : UIColor.red,
            .backgroundColor : UIColor.yellow,
            .font : UIFont(name: "Roboto-Light", size: 20),
            .link : NSURL(string: "https://google.com"),
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor.green
        ], range: range)
        
        attrString.addAttributes([
            .foregroundColor : UIColor.red,
            .backgroundColor : UIColor.yellow,
            .font : UIFont(name: "Roboto-Regular", size: 20),
            .link : NSURL(string: "https://google.com"),
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor.green
        ], range: secondRange)
        
        view.backgroundColor = .gray
        textLabel.backgroundColor = .gray
        textLabel.attributedText = attrString
        textLabel.isUserInteractionEnabled = true
        view.addSubview(textLabel)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textLabel.frame = .init(x: 0, y: 200,
                                width: view.bounds.width, height: 400)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
