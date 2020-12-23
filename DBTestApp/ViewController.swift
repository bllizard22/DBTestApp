//
//  ViewController.swift
//  DBTestApp
//
//  Created by Nikolay Kryuchkov on 20.12.2020.
//

import UIKit

struct DataJSON: Codable {
    var name: String
    var email: String
    var phone: String
}

class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func submitAction(_ sender: Any) {
//        let dataStruct = DataJSON(name: nameTextField.text ?? "", email: emailTextField.text ?? "", phone: phoneTextField.text ?? "")
//        let data = try! JSONEncoder().encode(dataStruct)
//        print(data!.name)
        
        sendTestPOST()

    }
    
    func sendTestPOST() {
//        let url = URL(string: "https://httpbin.org/post")
        let url = URL(string: "http://10.101.63.45:127/")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
         
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "accept: application/json, text: 124";
        // Set HTTP Request Body
//        request.httpBody = postString.data(using: String.Encoding.utf8);
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                // Check for Error
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
         
                // Convert HTTP Response Data to a String
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("Response data string:\n \(dataString)")
                }
        }
        task.resume()
    }
    
    func sendAnotherPOST() {
        // Create a URLRequest for an API endpoint
        let url = URL(string: "https://www.myapi.com/v1/user")!
        var request = URLRequest(url: url)
        
        // Configure request authentication
        request.setValue(
            "authToken",
            forHTTPHeaderField: "Authorization"
        )
        // Serialize HTTP Body data as JSON
        let body = ["user_id": "12"]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        // Change the URLRequest to a POST request
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        // Create the HTTP request
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error took place \(error)")
                return
            } else if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            } else {
                print("Unknown error! \(error)")            }
        }
        task.resume()
    }
    
//    @objc func encodeData(sender: UIButton!) {
//
////        let jsonData = try! Data(from: url)
//
//        let _JSON = """
//            {
//            "title": "Optionals in Swift explained: 5 things you should know",
//            "address": "https://www.avanderlee.com/swift/optionals-in-swift-explained-5-things-you-should-know/",
//            "location": "swift",
//            "price": "47093"
//            }
//            """
//                let jsonData = _JSON.data(using: .utf8)!
//
////        let url = Bundle.main.url(forResource: "cardsDataJSON_one", withExtension: "json")!
//        let url = Bundle.main.url(forResource: "cardsDataJSON", withExtension: "json")!
//
//        let jsonData = try! Data(contentsOf: url)
//        let data: [Int: DataJSON] = try! JSONDecoder().decode([Int: DataJSON].self, from: jsonData)
//
//    }
    
}

