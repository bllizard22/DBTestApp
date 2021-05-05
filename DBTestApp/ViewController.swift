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

//let host_address = "http://127.0.0.1:127/"
let host_address = "http://10.101.63.45:5027/"

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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:))
                                               , name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:))
                                               , name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:))
                                               , name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
//    @objc func kbDidShow(notification: Notification) {
//        guard let userInfo = notification.userInfo else {
//            return
//        }
//        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//
//        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbFrameSize.height)
//        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
//    }
//
//    @objc func kbDidHide() {
//        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
//    }

    @IBAction func submitAction(_ sender: Any) {
//        let dataStruct = DataJSON(name: nameTextField.text ?? "", email: emailTextField.text ?? "", phone: phoneTextField.text ?? "")
//        let data = try! JSONEncoder().encode(dataStruct)
        //        print(data!.name)
        
        sendDataPOST(name: nameTextField.text ?? ""
                     , email: emailTextField.text ?? ""
                     , phone: phoneTextField.text ?? ""
                     , responseLabel: responseLabel)
        
        if responseText != nil {
            print("Action text \(responseText!)")
            responseLabel.text = responseText
        } else {
            responseLabel.text = "No response"
        }

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
        // No body in GET-request
        
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
        
//        var responseMessage: String?
                
        // Configure request authentication
        request.setValue(
            "authToken",
            forHTTPHeaderField: "Authorization"
        )
        // Serialize HTTP Body data as JSON
        let randomUID = String(Int.random(in: 10...20))
        let body = ["user_id": randomUID, "name": name, "email": email, "phone": phone]
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
            
            DispatchQueue.global(qos: .background).async {
                
                var textBuffer = String()
                
                if let error = error {
                                print("\nError took place\n \(error)")
                    textBuffer = error.localizedDescription
                }
                
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("\nResponse data string:\n \(dataString)")
                    textBuffer = dataString
                }
                
                DispatchQueue.main.async {
                    responseLabel.text = textBuffer
                }
            }
            

        }
        task.resume()

    }
    
    @objc func keyboardWillChange(notification: Notification) {

        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -(keyboardRect.height/4*3)
        }
        if notification.name == UIResponder.keyboardWillHideNotification {
            view.frame.origin.y = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.endEditing(true)
        emailTextField.endEditing(true)
        phoneTextField.endEditing(true)
    }
    
}

