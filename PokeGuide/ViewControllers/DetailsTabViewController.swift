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
    // MARK: - UI Elements

    private let tableView = UITableView()

    // MARK: - Properties

    private let itemInfo: IndicatorInfo!
    private let viewModel: DetailsTabViewModel!
    private let disposeBag = DisposeBag()
    private let dataSourceRelay = BehaviorRelay<[DetailsDataSource]>(value: [])

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
    }

    override func viewDidLayoutSubviews() {
        tableView.isScrollEnabled = tableView.contentSize.height >= tableView.bounds.size.height
    }

    // MARK: - Initialization

    init(viewModel: DetailsTabViewModel!) {
        itemInfo = IndicatorInfo(title: viewModel.title)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.allowsSelection = false
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constants.StyleDefaults.innerPadding)
        }
        tableView.register(DetailsCell.self, forCellReuseIdentifier: DetailsCell.reuseIdentifier)
    }

    private func bindViewModel() {
        dataSourceRelay.accept(viewModel.tableViewDataSource)
        dataSourceRelay
            .map { $0 }
            .bind(to: tableView.rx.items(cellIdentifier: DetailsCell.reuseIdentifier,
                                         cellType: DetailsCell.self)) { _, item, cell in
                cell.configure(leadingLabelText: item.leadingText, trailingLabelText: item.trailingText)
            }
            .disposed(by: disposeBag)
    }

    // MARK: - IndicatorInfoProvider

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        itemInfo
    }
}
