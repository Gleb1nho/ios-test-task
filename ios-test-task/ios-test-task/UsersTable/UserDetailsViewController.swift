import UIKit

class UserDetailsViewController: UIViewController, UITextViewDelegate {
  private let userInfo: UserDBModel
  
  private let containerView: UIView = {
    let view = UIView()
    
    view.preservesSuperviewLayoutMargins = true
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .white
    
    return view
  }()
  
  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    
    scrollView.preservesSuperviewLayoutMargins = true
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.backgroundColor = .white
    scrollView.addSubview(containerView)
    
    return scrollView
  }()
  
  private lazy var nameLabel: UILabel = {
    let nameLabel = UILabel()
    
    nameLabel.text = userInfo.name
    nameLabel.numberOfLines = 0
    nameLabel.textAlignment = .center
    nameLabel.font = UIFont.systemFont(ofSize: 48)
    nameLabel.sizeToFit()
    nameLabel.adjustsFontSizeToFitWidth = true
    nameLabel.translatesAutoresizingMaskIntoConstraints = false

    return nameLabel
  }()
  
  private lazy var dateOfEducationLabel: UILabel = {
    let dateOfEducationLabel = UILabel()
    
    dateOfEducationLabel.text = "\(formateEducationDate(userInfo.educationPeriodStart))-\(formateEducationDate(userInfo.educationPeriodEnd))"
    dateOfEducationLabel.textAlignment = .center
    dateOfEducationLabel.font = UIFont.systemFont(ofSize: 24)
    dateOfEducationLabel.numberOfLines = 0
    dateOfEducationLabel.sizeToFit()
    dateOfEducationLabel.textColor = .gray
    dateOfEducationLabel.translatesAutoresizingMaskIntoConstraints = false

    return dateOfEducationLabel
  }()
  
  private lazy var temperLabel: UILabel = {
    let temperLabel = UILabel()
    
    temperLabel.text = userInfo.temperament
    temperLabel.textAlignment = .center
    temperLabel.font = UIFont.systemFont(ofSize: 20)
    temperLabel.numberOfLines = 0
    temperLabel.sizeToFit()
    temperLabel.textColor = .gray
    temperLabel.translatesAutoresizingMaskIntoConstraints = false

    return temperLabel
  }()
  
  private lazy var phoneLabel: UITextView = {
    let phoneLabel = UITextView()
    
    let attributedString = NSMutableAttributedString(string: "📞 \(userInfo.phone)")
    attributedString.addAttribute(.link, value: "tel:+\(userInfo.formattedPhone)", range: NSRange(location: 0, length: 20))
    
    phoneLabel.attributedText = attributedString
    phoneLabel.textAlignment = .center
    phoneLabel.font = UIFont.systemFont(ofSize: 20)
    phoneLabel.isScrollEnabled = false
    phoneLabel.isEditable = false
    phoneLabel.translatesAutoresizingMaskIntoConstraints = false

    return phoneLabel
  }()
  
  private lazy var biographyLabel: UILabel = {
    let biographyLabel = UILabel()
    
    biographyLabel.text = "\(userInfo.biography)"
    biographyLabel.numberOfLines = 0
    biographyLabel.textAlignment = .center
    biographyLabel.textColor = .gray
    biographyLabel.sizeToFit()
    biographyLabel.font = UIFont.systemFont(ofSize: 20)
    biographyLabel.translatesAutoresizingMaskIntoConstraints = false

    return biographyLabel
  }()
  
  private lazy var topSeparator: UIView = {
    let topSeparator = UIView()
    topSeparator.backgroundColor = .gray
    topSeparator.translatesAutoresizingMaskIntoConstraints = false

    return topSeparator
  }()
  
  private lazy var bottomSeparator: UIView = {
    let botttomSeparator = UIView()
    botttomSeparator.backgroundColor = .gray
    botttomSeparator.translatesAutoresizingMaskIntoConstraints = false
    
    return botttomSeparator
  }()

  init(userInfo: UserDBModel) {
    self.userInfo = userInfo
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    setup()
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
    view.addSubview(scrollView)
    
    containerView.addSubview(nameLabel)
    containerView.addSubview(dateOfEducationLabel)
    containerView.addSubview(temperLabel)
    containerView.addSubview(topSeparator)
    containerView.addSubview(phoneLabel)
    containerView.addSubview(bottomSeparator)
    containerView.addSubview(biographyLabel)
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      
      scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      scrollView.topAnchor.constraint(equalTo: containerView.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
      
      scrollView.widthAnchor.constraint(equalTo: containerView.widthAnchor),

      nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: containerView.safeAreaLayoutGuide.topAnchor, multiplier: 3),
      nameLabel.bottomAnchor.constraint(equalTo: dateOfEducationLabel.topAnchor),
      nameLabel.centerXAnchor.constraint(equalTo: containerView.readableContentGuide.centerXAnchor),
      nameLabel.widthAnchor.constraint(equalTo: containerView.readableContentGuide.widthAnchor),
      
      dateOfEducationLabel.bottomAnchor.constraint(equalTo: temperLabel.topAnchor),
      dateOfEducationLabel.centerXAnchor.constraint(equalTo: containerView.readableContentGuide.centerXAnchor),
      dateOfEducationLabel.widthAnchor.constraint(equalTo: containerView.readableContentGuide.widthAnchor),
      
      temperLabel.bottomAnchor.constraint(equalTo: topSeparator.topAnchor, constant: -24),
      temperLabel.centerXAnchor.constraint(equalTo: containerView.readableContentGuide.centerXAnchor),
      temperLabel.widthAnchor.constraint(equalTo: containerView.readableContentGuide.widthAnchor),
      
      topSeparator.bottomAnchor.constraint(equalTo: phoneLabel.topAnchor, constant: -8),
      topSeparator.centerXAnchor.constraint(equalTo: containerView.readableContentGuide.centerXAnchor),
      topSeparator.widthAnchor.constraint(equalTo: containerView.readableContentGuide.widthAnchor),
      topSeparator.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
      
      phoneLabel.bottomAnchor.constraint(equalTo: bottomSeparator.topAnchor, constant: -8),
      phoneLabel.centerXAnchor.constraint(equalTo: containerView.readableContentGuide.centerXAnchor),
      phoneLabel.widthAnchor.constraint(equalTo: containerView.readableContentGuide.widthAnchor),
      
      bottomSeparator.bottomAnchor.constraint(equalTo: biographyLabel.topAnchor, constant: -24),
      bottomSeparator.centerXAnchor.constraint(equalTo: containerView.readableContentGuide.centerXAnchor),
      bottomSeparator.widthAnchor.constraint(equalTo: containerView.readableContentGuide.widthAnchor),
      bottomSeparator.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
      
      biographyLabel.centerXAnchor.constraint(equalTo: containerView.readableContentGuide.centerXAnchor),
      biographyLabel.widthAnchor.constraint(equalTo: containerView.readableContentGuide.widthAnchor),
      biographyLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    ])
  }
  
  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    UIApplication.shared.open(URL)
    return false
  }
}
