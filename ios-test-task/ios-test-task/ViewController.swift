import UIKit

class ViewController: UIViewController {
  var executeButton = UIButton(type: .roundedRect)
  var loadedData = UITextView()
  let requsetProvider = RequsetProvider()
  
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
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    requsetProvider.getFirstUrlData()
    setup()
  }
}
