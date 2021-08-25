import UIKit

class UsersTableViewController: UITableViewController {
  lazy var userCells: [UserDBModel] = fetchCellsData()
  let firstLoadingIndicator = UIActivityIndicatorView(style: .large)

    
  private var isSearchBarEmpty: Bool {
    searchController.searchBar.text?.isEmpty ?? true
  }
  
  private var isFiltering: Bool {
    searchController.isActive && !isSearchBarEmpty
  }
  
  private var searchTimer: Timer?
  private var toastTimer: Timer?
  private var autoRefreshTimer: Timer?
  
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
  
  func fetchCellsData() -> [UserDBModel] {
    let userCells = try! AppDatabase.shared.getUsersByQuery(query: "")
    return userCells.sorted(by: { $0.name < $1.name })
  }
  
  @objc func handleRefreshControl() {
    RequsetProvider().updateUsersData() { [weak self] result in
      self?.autoRefreshTimer?.invalidate()
      guard result else {
        DispatchQueue.main.async { [weak self] in
          self?.tableView.refreshControl?.endRefreshing()
          self?.firstLoadingIndicator.stopAnimating()
          self?.startAutoRefresh()
          self?.showToast(message: "Нет подключения к интернету")
        }
        return
      }
      DispatchQueue.main.async { [weak self] in
        self!.userCells = self!.fetchCellsData()
        self?.tableView.reloadData()
        self?.tableView.refreshControl?.endRefreshing()
        self?.firstLoadingIndicator.stopAnimating()
        self?.startAutoRefresh()
        self?.showToast(message: "Fetch \(self!.userCells.count) users")
      }
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
    
    firstLoadingIndicator.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(firstLoadingIndicator)

    NSLayoutConstraint.activate([
      firstLoadingIndicator.centerXAnchor.constraint(equalTo: view.readableContentGuide.centerXAnchor),
      firstLoadingIndicator.centerYAnchor.constraint(equalTo: view.readableContentGuide.centerYAnchor)
    ])
    
    startAutoRefresh()
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
  func showToast(message: String) {
    self.toastTimer?.invalidate()
    
    let toastLabel = UILabel()
    
    toastLabel.backgroundColor = .black
    toastLabel.textColor = .white
    toastLabel.text = "\(message)"
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
        DispatchQueue.global(qos: .userInteractive).sync {
          DispatchQueue.main.async {
            toastLabel.removeFromSuperview()
          }
        }
      }
    )
  }
  
  func startAutoRefresh() {
    self.autoRefreshTimer?.invalidate()
    
    autoRefreshTimer = Timer.scheduledTimer(
      withTimeInterval: 10,
      repeats: true
    ) { timer in
      DispatchQueue.global(qos: .userInteractive).async {
        DispatchQueue.main.async { [weak self] in
          self?.firstLoadingIndicator.startAnimating()
          self?.handleRefreshControl()
        }
      }
    }
  }
}
