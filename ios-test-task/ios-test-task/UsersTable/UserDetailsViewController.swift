import UIKit

class UserDetailsViewController: UIViewController {
  private var userInfo: UserDBModel
  
  init(userInfo: UserDBModel) {
    self.userInfo = userInfo
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func viewDidLoad() {
    setup()
    super.viewDidLoad()
  }
  
  private func formateEducationDate(_ educationDate: Date) -> String {
    
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss +HHmm"

    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "dd.MM.yyyy"

    if let date = dateFormatterGet.date(from: "\(educationDate)") {
        return dateFormatterPrint.string(from: date)
    } else {
       return "\(educationDate)"
    }
    
  }
  
  private func setup() {
    
    view.backgroundColor = .white
    
    let nameLabel = UILabel()
    let dateOfEducationLabel = UILabel()
    let temperLabel = UILabel()
    let phoneLabel = UILabel()
    let biographyLabel = UILabel()
    let topSeparator = UIView()
    let botttomSeparator = UIView()
    
    topSeparator.backgroundColor = .gray
    botttomSeparator.backgroundColor = .gray
    
    nameLabel.text = userInfo.name
    nameLabel.numberOfLines = 0
    nameLabel.textAlignment = .center
    nameLabel.font = UIFont.systemFont(ofSize: 56)
    nameLabel.adjustsFontSizeToFitWidth = true

    dateOfEducationLabel.text = "\(formateEducationDate(userInfo.educationPeriodStart))-\(formateEducationDate(userInfo.educationPeriodEnd))"
    dateOfEducationLabel.textAlignment = .center
    dateOfEducationLabel.font = UIFont.systemFont(ofSize: 24)
    dateOfEducationLabel.textColor = .gray
    
    temperLabel.text = userInfo.temperament
    temperLabel.textAlignment = .center
    temperLabel.font = UIFont.systemFont(ofSize: 20)
    temperLabel.textColor = .gray
    
    phoneLabel.text = userInfo.phone
    phoneLabel.textAlignment = .center
    
    biographyLabel.text = userInfo.biography
    biographyLabel.numberOfLines = 0
    biographyLabel.textAlignment = .center
    
    view.preservesSuperviewLayoutMargins = true
    
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    dateOfEducationLabel.translatesAutoresizingMaskIntoConstraints = false
    phoneLabel.translatesAutoresizingMaskIntoConstraints = false
    biographyLabel.translatesAutoresizingMaskIntoConstraints = false
    temperLabel.translatesAutoresizingMaskIntoConstraints = false
    topSeparator.translatesAutoresizingMaskIntoConstraints = false
    botttomSeparator.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(nameLabel)
    view.addSubview(dateOfEducationLabel)
    view.addSubview(temperLabel)
    view.addSubview(topSeparator)
    view.addSubview(phoneLabel)
    view.addSubview(botttomSeparator)
    view.addSubview(biographyLabel)
    
    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      nameLabel.bottomAnchor.constraint(equalTo: dateOfEducationLabel.topAnchor),
      nameLabel.centerXAnchor.constraint(equalTo: view.readableContentGuide.centerXAnchor),
      nameLabel.widthAnchor.constraint(equalTo: view.readableContentGuide.widthAnchor),
      nameLabel.heightAnchor.constraint(equalTo: view.readableContentGuide.heightAnchor, multiplier: 0.15),
      
      dateOfEducationLabel.bottomAnchor.constraint(equalTo: temperLabel.topAnchor),
      dateOfEducationLabel.centerXAnchor.constraint(equalTo: view.readableContentGuide.centerXAnchor),
      dateOfEducationLabel.widthAnchor.constraint(equalTo: view.readableContentGuide.widthAnchor),
      dateOfEducationLabel.heightAnchor.constraint(equalTo: view.readableContentGuide.heightAnchor, multiplier: 0.05),
      
      temperLabel.bottomAnchor.constraint(equalTo: topSeparator.topAnchor),
      temperLabel.centerXAnchor.constraint(equalTo: view.readableContentGuide.centerXAnchor),
      temperLabel.widthAnchor.constraint(equalTo: view.readableContentGuide.widthAnchor),
      temperLabel.heightAnchor.constraint(equalTo: view.readableContentGuide.heightAnchor, multiplier: 0.05),
      
      topSeparator.bottomAnchor.constraint(equalTo: phoneLabel.topAnchor),
      topSeparator.centerXAnchor.constraint(equalTo: view.readableContentGuide.centerXAnchor),
      topSeparator.widthAnchor.constraint(equalTo: view.readableContentGuide.widthAnchor),
      topSeparator.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
      
      phoneLabel.bottomAnchor.constraint(equalTo: botttomSeparator.topAnchor),
      phoneLabel.centerXAnchor.constraint(equalTo: view.readableContentGuide.centerXAnchor),
      phoneLabel.widthAnchor.constraint(equalTo: view.readableContentGuide.widthAnchor),
      phoneLabel.heightAnchor.constraint(equalTo: view.readableContentGuide.heightAnchor, multiplier: 0.07),
      
      botttomSeparator.bottomAnchor.constraint(equalTo: biographyLabel.topAnchor),
      botttomSeparator.centerXAnchor.constraint(equalTo: view.readableContentGuide.centerXAnchor),
      botttomSeparator.widthAnchor.constraint(equalTo: view.readableContentGuide.widthAnchor),
      botttomSeparator.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
      
      biographyLabel.bottomAnchor.constraint(equalTo: view.readableContentGuide.bottomAnchor),
      biographyLabel.centerXAnchor.constraint(equalTo: view.readableContentGuide.centerXAnchor),
      biographyLabel.widthAnchor.constraint(equalTo: view.readableContentGuide.widthAnchor),
    ])
  }
}
