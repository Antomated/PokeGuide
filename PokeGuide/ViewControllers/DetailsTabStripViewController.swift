//
//  PokemonTabStripViewController.swift
//  PokeGuide
//
//  Created by Beavean on 05.05.2023.
//

import Foundation
import RxSwift
import SnapKit
import UIKit
import XLPagerTabStrip

final class DetailsTabStripViewController: ButtonBarPagerTabStripViewController {
    // MARK: - Properties

    private let barButtonFontSize: CGFloat = 16
    private let viewModel: DetailsTabStripViewModel
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        configureTabStrip()
        super.viewDidLoad()
        bindViewModel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        reloadPagerTabStripView()
    }

    // MARK: - Initialization

    init(viewModel: DetailsTabStripViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    private func configureTabStrip() {
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = Constants.Colors.mainAccentColor.color ?? .clear
        settings.style.buttonBarItemTitleColor = Constants.Colors.mainAccentColor.color
        settings.style.buttonBarItemFont = UIFont.boldTextCustomFont() ?? .boldSystemFont(ofSize: barButtonFontSize)
    }

    private func bindViewModel() {
        viewModel.tabViewModels
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.reloadPagerTabStripView()
            })
            .disposed(by: disposeBag)
    }

    // MARK: - ButtonBarPagerTabStrip methods

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        viewModel.tabViewModels.value.map { viewModel in
            let viewController = DetailsTabViewController(viewModel: viewModel)
            return viewController
        }
    }
}
