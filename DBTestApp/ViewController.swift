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

let host_address = "http://192.168.1.59:5027/"

class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var responseLabel: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var getButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    
    var responseText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func submitAction(_ sender: Any) {
//        let dataStruct = DataJSON(name: nameTextField.text ?? "", email: emailTextField.text ?? "", phone: phoneTextField.text ?? "")
//        let data = try! JSONEncoder().encode(dataStruct)
        //        print(data!.name)
        
        sendDataPOST(name: nameTextField.text ?? ""
                     , email: emailTextField.text ?? ""
                     , phone: phoneTextField.text ?? ""
                     , responseLabel: responseLabel)
        
        responseLabel.text = responseText
        print("Action text \(responseText)")

    }
        
    @IBAction func getAction(_ sender: Any) {
        sendTestGET()
    }
    
    @IBAction func postAction(_ sender: Any) {
        sendTestPOST(name: nameTextField.text ?? ""
                     , email: emailTextField.text ?? ""
                     , phone: phoneTextField.text ?? "")
    }
    
    func sendTestGET() {
//        let url = URL(string: "https://httpbin.org/post")
        let url = URL(string: host_address)
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
         
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "accept: application/json, accept: application/json, text: 124";
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
    
    func sendTestPOST(name: String, email: String, phone: String) {
//        let url = URL(string: "https://httpbin.org/post")
        let url = URL(string: host_address)
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
         
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let body = ["user_id": "15", "name": name, "email": email, "phone": phone]
//        let body = ["accept": "application/json", "text": "124"]
        let postString = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        // Set HTTP Request Body
        request.httpBody = postString
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
    
    func sendDataPOST(name: String, email: String, phone: String, responseLabel: UILabel) {
        // Create a URLRequest for an API endpoint
        let url = URL(string: host_address)!
        var request = URLRequest(url: url)
        
        var responseMessage: String?
                
        // Configure request authentication
        request.setValue(
            "authToken",
            forHTTPHeaderField: "Authorization"
        )
        // Serialize HTTP Body data as JSON
        let body = ["user_id": "12", "name": name, "email": email, "phone": phone]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        // Change the URLRequest to a POST request
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.allHTTPHeaderFields = ["accept-encoding": "json"]
        
        // Create the HTTP request
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error took place \(error)")
                //                label.text = "\(error)"
                return
            }
            
            DispatchQueue.global(qos: .background).async {
                
                var textBuffer = String()
                
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("Response data string:\n \(dataString)")
                    textBuffer = dataString
                }
                
                DispatchQueue.main.async {
                    responseLabel.text = textBuffer
                }
            }
            

        }
        task.resume()

    }
    
//    func updateLabelText(flag: Bool, data: String) {
//        guard flag else {
//            return
//        }
//
//        responseText = data
//        print("Update text \(responseText)")
////        responseLabel.text = data
//    }
    
//    func loadData(from url: URL, completion: @escaping (Result<Data?, URLError>) -> Void) throws {
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let urlError = error as? URLError {
//                completion(.failure(urlError))
//            }
//
//            if let data = data {
//                completion(.success(data))
//            }
//        }.resume()
//    }
    
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

