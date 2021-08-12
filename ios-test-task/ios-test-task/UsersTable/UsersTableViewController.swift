import UIKit

class UsersTableViewController: UITableViewController {
  private let userCells = try! AppDatabase.shared.getUsersByQuery(query: "")
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    userCells.count
  }
  
  override func viewDidLoad() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    tableView.rowHeight = 64.0
    tableView.cellLayoutMarginsFollowReadableWidth = true
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
    let currentUser = userCells[indexPath.row]
    
    cell.accessoryType = .disclosureIndicator
    
    cell.textLabel?.text = currentUser.name
    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    
    cell.detailTextLabel?.text = currentUser.phone
    cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
    cell.detailTextLabel?.textColor = .gray
    
    let temperLabel = UILabel()
    temperLabel.text = currentUser.temperament
    temperLabel.font = UIFont.systemFont(ofSize: 15)
    temperLabel.textAlignment = .right
    temperLabel.textColor = .gray
    
    cell.contentView.preservesSuperviewLayoutMargins = true
    temperLabel.translatesAutoresizingMaskIntoConstraints = false
    cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false
    
    cell.contentView.addSubview(temperLabel)
    
    NSLayoutConstraint.activate([
      temperLabel.heightAnchor.constraint(equalToConstant: 24),
      temperLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
      temperLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: cell.contentView.leadingAnchor, multiplier: 2),
      cell.contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: temperLabel.trailingAnchor, multiplier: 2),
      cell.textLabel!.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
      cell.textLabel!.bottomAnchor.constraint(equalTo: cell.detailTextLabel!.topAnchor),
      cell.textLabel!.leadingAnchor.constraint(equalTo: cell.detailTextLabel!.leadingAnchor),
      cell.textLabel!.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.6)
    ])
    return cell
  }
}
