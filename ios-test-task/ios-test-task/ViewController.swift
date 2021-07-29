import UIKit

class ViewController: UIViewController {
  
  var executeButton = UIButton(type: .roundedRect)
  var loadedData = UITextView()
  
  struct UserData: Decodable {
    let id: String
    let name: String
    let phone: String
    let height: Float
    let biography: String
    
    enum Temperament: String, Decodable {
      case sanguine
      case choleric
      case phlegmatic
      case melancholic
    }
    let temperament: Temperament
    
    struct EducationPeriod: Decodable {
      let start: Date
      let end: Date
    }
    let educationPeriod: EducationPeriod
  }
  
  let networkingManager = NetworkManager()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
  }

  private func setup() {
    executeButton.addTarget(self, action: #selector(executeRequest), for: .touchUpInside)
    view.preservesSuperviewLayoutMargins = true
    
    executeButton.translatesAutoresizingMaskIntoConstraints = false
    loadedData.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(executeButton)
    view.addSubview(loadedData)
    
    NSLayoutConstraint.activate([
      loadedData.topAnchor.constraint(equalTo: view.readableContentGuide.topAnchor),
      loadedData.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
      loadedData.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
      executeButton.topAnchor.constraint(equalTo: loadedData.bottomAnchor),
      executeButton.bottomAnchor.constraint(equalTo: view.readableContentGuide.bottomAnchor),
      executeButton.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
      executeButton.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor)
    ])
    
    executeButton.setTitle("Baton", for: .normal)
    loadedData.backgroundColor = .systemGray6
  }
  
  @objc func executeRequest(_ sender: Any) {
    guard let urlToExecute = URL(string: "https://raw.githubusercontent.com/SkbkonturMobile/mobile-test-ios/master/json/generated-01.json") else {
      return
    }
    
    networkingManager.execute(urlToExecute) { [unowned self] (json, error) in
      if let error = error {
        self.loadedData.text = error.localizedDescription
      } else if let json = json {
        do {
          let decoder = JSONDecoder()
          decoder.dateDecodingStrategy = .iso8601
          let usersData: [UserData] = try decoder.decode([UserData].self, from: json)
          print(usersData[0].educationPeriod.start)
          self.loadedData.text = usersData[0].name
        } catch let error {
          print(error)
          return
        }
      }
    }
  }
}
