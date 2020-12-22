//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

struct DataJSON: Decodable {
    var price: String
    var location: String
    var address: String
}

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 100, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
//        print("\(5+3)")
        let priceTF = UITextField()
        priceTF.frame = CGRect(x: 150, y: 150, width: 200, height: 20)
        priceTF.placeholder = "price"
        priceTF.backgroundColor = .systemGray4
        let locationTF = UITextField()
        locationTF.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        locationTF.placeholder = "location"
        locationTF.backgroundColor = .systemGray4
        let addressTF = UITextField()
        addressTF.frame = CGRect(x: 150, y: 250, width: 200, height: 20)
        addressTF.placeholder = "address"
        addressTF.backgroundColor = .systemGray4
        
        let submitButton = UIButton()
        submitButton.frame = CGRect(x: 150, y: 300, width: 200, height: 20)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = .black
        submitButton.addTarget(self, action: #selector(decodeData), for: .touchUpInside)
        
        view.addSubview(priceTF)
        view.addSubview(locationTF)
        view.addSubview(addressTF)
        view.addSubview(submitButton)
        
        view.addSubview(label)
        self.view = view
    }
    
//    func submitFunc(price: String, location: String, address: String) {
//        var array = Data(price: price, location: location, address: address)
//
//    }
    
    struct BlogPost: Decodable {
        let title: String
    }
    
    @objc func decodeData(sender: UIButton!) {
        
//        let jsonData = try! Data(from: url)
        
        
        let _JSON = """
            {
            "title": "Optionals in Swift explained: 5 things you should know",
            "address": "https://www.avanderlee.com/swift/optionals-in-swift-explained-5-things-you-should-know/",
            "location": "swift",
            "price": "47093"
            }
            """
        //        let jsonData = _JSON.data(using: .utf8)!
        
//        let url = Bundle.main.url(forResource: "cardsDataJSON_one", withExtension: "json")!
        let url = Bundle.main.url(forResource: "cardsDataJSON", withExtension: "json")!
        
        let jsonData = try! Data(contentsOf: url)
        let blogPost: [Int: DataJSON] = try! JSONDecoder().decode([Int: DataJSON].self, from: jsonData)
//        print(blogPost.title)
        print(blogPost[2]!.price)
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
