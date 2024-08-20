//
//  TestViewController.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 12.08.2024.
//

import UIKit

class ShowLableViewController: UIViewController {
    
    let label: String
    
    lazy var labelView = UILabel()
    
    init(label: String) {
        self.label = label
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelView.text = label
        view.addSubview(labelView)
        labelView.frame = .init(origin: .init(x: 0, y: 200), size: .init(width: 100, height: 20))
    }
}

class TestViewController: UIViewController {
    
    let label: String
    
    init(label: String) {
        self.label = label
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let person = Person(name: "Vladimir")
        person.printDescription()
        
        PersonStorage.save(person: person)
        
        
        let ownCalculator = OwnCalculator()
        ownCalculator.multiply()
        ownCalculator.result()
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
