//
//  ViewController.swift
//  Lottie-Refresher
//
//  Created by amovision on 2025/7/4.
//

import UIKit
import MJRefresh

class ViewController: UIViewController {
  private var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .cyan
    tableView = UITableView(frame: CGRectMake(0, 88, view.bounds.width, view.bounds.height - 128))
    tableView.backgroundColor = .systemBackground
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.delegate = self
    tableView.dataSource = self
    view.addSubview(tableView)
    let refresher = MJRefreshLottieHeader { [unowned self] in
      DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [unowned self] in
        tableView.mj_header?.endRefreshing()
      }
    }
    refresher.animationResources = [
      .idle: "lottie_done",
      .pulling: "lottie_pulling",
      .refreshing: "lottie_refreshing"
    ]
    tableView.mj_header = refresher
  }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 100
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
    cell.textLabel?.text = "\(indexPath.row)"
    return cell
  }
}
