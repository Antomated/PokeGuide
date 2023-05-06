//
//  DetailsTabViewController.swift
//  PokeGuide
//
//  Created by Beavean on 05.05.2023.
//

import RxCocoa
import RxSwift
import UIKit
import XLPagerTabStrip

final class DetailsTabViewController: UIViewController, IndicatorInfoProvider {
    private let itemInfo: IndicatorInfo!
    private let viewModel: DetailsTabViewModel!

    private let disposeBag = DisposeBag()
    private let tableView = UITableView()
    private let dataSourceRelay = BehaviorRelay<[DetailsDataSource]>(value: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
    }

    override func viewDidLayoutSubviews() {
        tableView.isScrollEnabled = tableView.contentSize.height >= tableView.bounds.size.height
    }

    init(viewModel: DetailsTabViewModel!) {
        itemInfo = IndicatorInfo(title: viewModel.title)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.allowsSelection = false
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.StyleDefaults.innerPadding)
        }
        tableView.register(DetailsCell.self, forCellReuseIdentifier: DetailsCell.reuseIdentifier)
    }

    private func bindViewModel() {
        dataSourceRelay.accept(viewModel.keyValueDataSource)
        dataSourceRelay
            .map { $0 }
            .bind(to: tableView.rx.items(cellIdentifier: DetailsCell.reuseIdentifier,
                                         cellType: DetailsCell.self)) { _, item, cell in
                cell.keyLabel.text = item.key
                cell.valueLabel.text = item.value
            }
            .disposed(by: disposeBag)
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        itemInfo
    }
}
