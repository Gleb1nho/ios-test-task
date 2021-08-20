import UIKit

class UsersTableViewController: UITableViewController {
  private lazy var userCells: [UserDBModel] = fetchCellsData()
    
  private var isSearchBarEmpty: Bool {
    searchController.searchBar.text?.isEmpty ?? true
  }
  
  private var isFiltering: Bool {
    searchController.isActive && !isSearchBarEmpty
  }
  
  private var searchTimer: Timer?
  private var toastTimer: Timer?
  
  private let searchController: UISearchController = {
    let searchController = UISearchController(searchResultsController: nil)
    return searchController
  }()
  
  private func filterUsersForSearchText(query: String?) {
    let userCells = try! AppDatabase.shared.getUsersByQuery(query: query ?? "")
    self.userCells = userCells.sorted(by: { $0.name < $1.name })
  }
  
  private func configureRefreshControl() {
    tableView.refreshControl = UIRefreshControl()
    tableView.refreshControl?.addTarget(
      self,
      action: #selector(handleRefreshControl),
      for: .valueChanged
    )
  }
  
  private func fetchCellsData() -> [UserDBModel] {
    let userCells = try! AppDatabase.shared.getUsersByQuery(query: "")
    return userCells.sorted(by: { $0.name < $1.name })
  }
  
  @objc private func handleRefreshControl() {
    RequsetProvider().updateUsersData()

    DispatchQueue.main.async {
      self.userCells = self.fetchCellsData().sorted(by: { $0.name < $1.name })
      self.tableView.reloadData()
      self.tableView.refreshControl?.endRefreshing()
    }
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    userCells.count
  }
  
  override func viewDidLoad() {
    tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "cellId")
    tableView.rowHeight = 64.0
    tableView.cellLayoutMarginsFollowReadableWidth = true
    tableView.tableFooterView = UIView()
    
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    definesPresentationContext = true
    
    configureRefreshControl()
    
    navigationItem.searchController = searchController
    let navigationBarAppearance = UINavigationBarAppearance()
    navigationBarAppearance.configureWithDefaultBackground()
    navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.title = "Contacts"
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! UserTableViewCell
    let currentUser = userCells[indexPath.row]
    cell.user = currentUser
    cell.accessoryType = .disclosureIndicator
    
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

extension UsersTableViewController {
  func showErrorToast() {
    self.toastTimer?.invalidate()
    
    let toastLabel = UILabel()
    
    toastLabel.backgroundColor = .black
    toastLabel.textColor = .white
    toastLabel.text = "Нет подключения к сети"
    toastLabel.font = .boldSystemFont(ofSize: 20)
    toastLabel.backgroundColor = UIColor(white: 0, alpha: 0.6)
    toastLabel.layer.cornerRadius = 10
    toastLabel.layer.masksToBounds = true
    toastLabel.translatesAutoresizingMaskIntoConstraints = false
    toastLabel.textAlignment = .center
    
    view.addSubview(toastLabel)
    
    NSLayoutConstraint.activate([
      toastLabel.topAnchor.constraint(equalTo: view.readableContentGuide.bottomAnchor, constant: -60),
      toastLabel.bottomAnchor.constraint(equalTo: view.readableContentGuide.bottomAnchor),
      toastLabel.centerXAnchor.constraint(equalTo: view.readableContentGuide.centerXAnchor),
      toastLabel.widthAnchor.constraint(equalTo: view.readableContentGuide.widthAnchor, multiplier: 8/9)
    ])
    
    toastTimer = Timer.scheduledTimer(
      withTimeInterval: 2,
      repeats: false,
      block: { timer in
        DispatchQueue.global(qos: .userInteractive).async {
          DispatchQueue.main.async {
            toastLabel.removeFromSuperview()
          }
        }
      }
    )
  }
}
