import UIKit

class UserTableViewCell: UITableViewCell {
  
  var user: UserDBModel? {
    didSet {
      userName.text = user?.name
      userPhone.text = user?.phone
      userTemper.text = user?.temperament
    }
  }
  
  private let userName: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont.boldSystemFont(ofSize: 24)
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  private let userPhone: UILabel = {
    let label = UILabel()
    label.textColor = .gray
    label.font = UIFont.systemFont(ofSize: 16)
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false

    return label
  }()
  
  private let userTemper: UILabel = {
    let label = UILabel()
    label.textColor = .gray
    label.font = UIFont.systemFont(ofSize: 16)
    label.textAlignment = .right
    label.translatesAutoresizingMaskIntoConstraints = false

    return label
  }()
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    addSubview(userName)
    addSubview(userPhone)
    addSubview(userTemper)
    
    NSLayoutConstraint.activate([
      userName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
      userName.bottomAnchor.constraint(equalTo: userPhone.topAnchor),
      userName.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
      userName.trailingAnchor.constraint(equalTo: userTemper.leadingAnchor),
      userName.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/5),
      
      userPhone.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
      userPhone.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
      userPhone.trailingAnchor.constraint(equalTo: userTemper.leadingAnchor),
      
      userTemper.topAnchor.constraint(equalTo: contentView.topAnchor),
      userTemper.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      userTemper.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
