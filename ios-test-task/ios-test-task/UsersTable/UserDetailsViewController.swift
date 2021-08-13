import UIKit

class UserDetailsViewController: UIViewController, UITextViewDelegate {
  private var userInfo: UserDBModel
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.backgroundColor = .white
    return scrollView
  }()
  
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
        
    let nameLabel = UILabel()
    let dateOfEducationLabel = UILabel()
    let temperLabel = UILabel()
    let phoneLabel = UITextView()
    let biographyLabel = UILabel()
    let topSeparator = UIView()
    let botttomSeparator = UIView()
    
    topSeparator.backgroundColor = .gray
    botttomSeparator.backgroundColor = .gray
    
    nameLabel.text = userInfo.name
    nameLabel.numberOfLines = 0
    nameLabel.textAlignment = .center
    nameLabel.font = UIFont.systemFont(ofSize: 48)
    nameLabel.adjustsFontSizeToFitWidth = true
    
    let attributedString = NSMutableAttributedString(string: "📞 \(userInfo.phone)")
    attributedString.addAttribute(.link, value: "tel:+\(userInfo.formattedPhone)", range: NSRange(location: 0, length: 20))

    dateOfEducationLabel.text = "\(formateEducationDate(userInfo.educationPeriodStart))-\(formateEducationDate(userInfo.educationPeriodEnd))"
    dateOfEducationLabel.textAlignment = .center
    dateOfEducationLabel.font = UIFont.systemFont(ofSize: 24)
    dateOfEducationLabel.textColor = .gray
    
    temperLabel.text = userInfo.temperament
    temperLabel.textAlignment = .center
    temperLabel.font = UIFont.systemFont(ofSize: 20)
    temperLabel.textColor = .gray
    
    phoneLabel.attributedText = attributedString
    phoneLabel.textAlignment = .center
    phoneLabel.font = UIFont.systemFont(ofSize: 20)
    phoneLabel.isEditable = false
    
    biographyLabel.text = userInfo.biography
    biographyLabel.numberOfLines = 0
    biographyLabel.textAlignment = .center
    biographyLabel.textColor = .gray
    biographyLabel.font = UIFont.systemFont(ofSize: 20)
    
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    dateOfEducationLabel.translatesAutoresizingMaskIntoConstraints = false
    phoneLabel.translatesAutoresizingMaskIntoConstraints = false
    biographyLabel.translatesAutoresizingMaskIntoConstraints = false
    temperLabel.translatesAutoresizingMaskIntoConstraints = false
    topSeparator.translatesAutoresizingMaskIntoConstraints = false
    botttomSeparator.translatesAutoresizingMaskIntoConstraints = false
    
    scrollView.addSubview(nameLabel)
    scrollView.addSubview(dateOfEducationLabel)
    scrollView.addSubview(temperLabel)
    scrollView.addSubview(topSeparator)
    scrollView.addSubview(phoneLabel)
    scrollView.addSubview(botttomSeparator)
    scrollView.addSubview(biographyLabel)
    view.addSubview(scrollView)
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      
      nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: scrollView.safeAreaLayoutGuide.topAnchor, multiplier: 3),
      nameLabel.bottomAnchor.constraint(equalTo: dateOfEducationLabel.topAnchor, constant: -16),
      nameLabel.centerXAnchor.constraint(equalTo: scrollView.readableContentGuide.centerXAnchor),
      nameLabel.widthAnchor.constraint(equalTo: scrollView.readableContentGuide.widthAnchor),
      
      dateOfEducationLabel.bottomAnchor.constraint(equalTo: temperLabel.topAnchor),
      dateOfEducationLabel.centerXAnchor.constraint(equalTo: scrollView.readableContentGuide.centerXAnchor),
      dateOfEducationLabel.widthAnchor.constraint(equalTo: scrollView.readableContentGuide.widthAnchor),
      
      temperLabel.bottomAnchor.constraint(equalTo: topSeparator.topAnchor, constant: -24),
      temperLabel.centerXAnchor.constraint(equalTo: scrollView.readableContentGuide.centerXAnchor),
      temperLabel.widthAnchor.constraint(equalTo: scrollView.readableContentGuide.widthAnchor),
      
      topSeparator.bottomAnchor.constraint(equalTo: phoneLabel.topAnchor, constant: -8),
      topSeparator.centerXAnchor.constraint(equalTo: scrollView.readableContentGuide.centerXAnchor),
      topSeparator.widthAnchor.constraint(equalTo: scrollView.readableContentGuide.widthAnchor),
      topSeparator.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
      
      phoneLabel.bottomAnchor.constraint(equalTo: botttomSeparator.topAnchor, constant: -8),
      phoneLabel.centerXAnchor.constraint(equalTo: scrollView.readableContentGuide.centerXAnchor),
      phoneLabel.widthAnchor.constraint(equalTo: scrollView.readableContentGuide.widthAnchor),
      phoneLabel.heightAnchor.constraint(equalTo: scrollView.readableContentGuide.heightAnchor, multiplier: 0.07),
      
      botttomSeparator.bottomAnchor.constraint(equalTo: biographyLabel.topAnchor, constant: -16),
      botttomSeparator.centerXAnchor.constraint(equalTo: scrollView.readableContentGuide.centerXAnchor),
      botttomSeparator.widthAnchor.constraint(equalTo: scrollView.readableContentGuide.widthAnchor),
      botttomSeparator.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
      
      biographyLabel.centerXAnchor.constraint(equalTo: scrollView.readableContentGuide.centerXAnchor),
      biographyLabel.widthAnchor.constraint(equalTo: scrollView.readableContentGuide.widthAnchor)
    ])
  }
  
  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    UIApplication.shared.open(URL)
    return false
  }
}
