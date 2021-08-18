import UIKit

class UsersTableViewController: UITableViewController {
  private var userCells: [UserDBModel] = {
    let userCells = try! AppDatabase.shared.getUsersByQuery(query: "")
    return userCells.sorted(by: { $0.name < $1.name })
  }()
    
  private var isSearchBarEmpty: Bool {
    searchController.searchBar.text?.isEmpty ?? true
  }
  
  private var isFiltering: Bool {
    searchController.isActive && !isSearchBarEmpty
  }
  
  private var searchTimer: Timer?
  
  private let searchController: UISearchController = {
    let searchController = UISearchController(searchResultsController: nil)
    return searchController
  }()
  
  private func filterUsersForSearchText(query: String?) {
    let userCells = try! AppDatabase.shared.getUsersByQuery(query: query ?? "")
    self.userCells = userCells.sorted(by: { $0.name < $1.name })
  }
  
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
    
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    definesPresentationContext = true
    
    navigationItem.searchController = searchController
    
    let navigationBarAppearance = UINavigationBarAppearance()
    navigationBarAppearance.configureWithDefaultBackground()
    navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    navigationController?.navigationBar.prefersLargeTitles = true
    
    navigationItem.title = "Contacts"
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
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let detailedUserVC = UserDetailsViewController(userInfo: userCells[indexPath.row])
    navigationController?.pushViewController(detailedUserVC, animated: true)
  }
}

extension UsersTableViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    self.searchTimer?.invalidate()
    
    guard let searchText = searchController.searchBar.text else { return }
    
    searchTimer = Timer.scheduledTimer(
      withTimeInterval: 0.5,
      repeats: false,
      block: { [weak self] timer in
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
          self?.filterUsersForSearchText(query: searchText)
          DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
          }
        }
      }
    )
  }
}
