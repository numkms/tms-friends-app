//
//  TestViewController.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 12.08.2024.
//

import UIKit

class TestViewController: UIViewController {

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
