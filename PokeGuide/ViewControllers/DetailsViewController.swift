//
//  DetailsViewController.swift
//  PokeGuide
//
//  Created by Beavean on 04.05.2023.
//

import RxCocoa
import RxSwift
import SDWebImage
import SnapKit
import UIKit
import XLPagerTabStrip

final class DetailsViewController: UIViewController {
    // MARK: - UI Elements

    private let nameLabel = UILabel().apply {
        $0.font = UIFont.boldTextCustomFont(size: 24)
        $0.textColor = Constants.Colors.mainAccentColor.color
    }

    private let imageView = UIImageView().apply {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
    }

    private let nameImageViewContainer = UIView()
    private let detailsViewContainer = UIView().apply {
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.backgroundColor = Constants.Colors.cellBackgroundColor.color
    }

    // MARK: - Properties

    private let outerPadding = Constants.StyleDefaults.outerPadding
    private let nameLabelHeight: CGFloat = 32
    private let backButtonImageSize: CGFloat = 24
    private let viewModel: DetailsViewModel
    private let disposeBag = DisposeBag()

    // MARK: - Initialization

    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindViewModel()
        embedTabStripViewController()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateConstraintsForOrientation(orientation: UIApplication.shared.statusBarOrientation)
    }

    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
    }

    // MARK: - Actions

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Configuration

    private func configureNavigationBar() {
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationItem.hidesBackButton = true
        configureBackButton()
    }

    private func configureBackButton() {
        let imageSize: CGFloat = backButtonImageSize
        let backButtonImage = Constants.Symbols.backArrow.symbol?.withRenderingMode(.alwaysTemplate)
        let resizedImage = backButtonImage?.scale(to: CGSize(width: imageSize, height: imageSize))
        let backBarButtonItem = UIBarButtonItem(image: resizedImage,
                                                style: .plain,
                                                target: self,
                                                action: #selector(backButtonTapped))
        backBarButtonItem.tintColor = Constants.Colors.mainAccentColor.color
        navigationItem.leftBarButtonItem = backBarButtonItem
        navigationItem.leftBarButtonItem?.isEnabled = true
    }

    private func setupViews() {
        view.backgroundColor = Constants.Colors.screenBackgroundColor.color
        view.addSubview(nameImageViewContainer)
        nameImageViewContainer.addSubview(nameLabel)
        nameImageViewContainer.addSubview(imageView)
        view.addSubview(detailsViewContainer)
    }

    private func setupConstraints() {
        updateConstraintsForOrientation(orientation: UIApplication.shared.statusBarOrientation)
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(outerPadding)
            $0.top.equalToSuperview()
            $0.height.equalTo(nameLabelHeight)
        }
        imageView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }
    }

    private func updateConstraintsForOrientation(orientation: UIInterfaceOrientation) {
        let viewSafeArea = view.safeAreaLayoutGuide
        nameImageViewContainer.snp.remakeConstraints {
            $0.left.equalTo(viewSafeArea.snp.left)
            if orientation.isLandscape {
                $0.top.equalTo(viewSafeArea.snp.top)
                $0.width.equalTo(viewSafeArea.layoutFrame.width / 2)
                $0.height.equalTo(viewSafeArea.layoutFrame.height)
            } else {
                $0.top.equalTo(viewSafeArea.snp.top).offset(-UIApplication.shared.statusBarFrame.size.height)
                $0.width.equalTo(viewSafeArea.layoutFrame.width)
                $0.height.equalTo(viewSafeArea.layoutFrame.height / 2)
            }
        }
        detailsViewContainer.snp.remakeConstraints {
            if orientation.isLandscape {
                $0.top.equalTo(viewSafeArea.snp.top)
                $0.left.equalTo(nameImageViewContainer.snp.right).inset(outerPadding)
                $0.right.equalTo(viewSafeArea.snp.right).offset(-outerPadding)
                $0.height.equalTo(nameImageViewContainer.snp.height)
            } else {
                $0.top.equalTo(nameImageViewContainer.snp.bottom)
                $0.left.equalTo(viewSafeArea.snp.left).inset(outerPadding)
                $0.right.equalTo(viewSafeArea.snp.right).offset(-outerPadding)
                $0.bottom.equalTo(viewSafeArea.snp.bottom).inset(outerPadding)
            }
        }
    }

    private func bindViewModel() {
        viewModel.pokemon
            .subscribe(onNext: { [weak self] pokemon in
                guard let self, let imageUrl = pokemon.officialArtworkImageUrl else { return }
                self.imageView.sd_setImage(with: URL(string: imageUrl))
                self.nameLabel.text = pokemon.name.capitalized
            })
            .disposed(by: disposeBag)
    }

    private func embedTabStripViewController() {
        let tabStripVC = DetailsTabStripViewController(viewModel: viewModel.tabStripViewModel)
        addChild(tabStripVC)
        detailsViewContainer.addSubview(tabStripVC.view)
        tabStripVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constants.StyleDefaults.innerPadding)
        }
        tabStripVC.didMove(toParent: self)
    }
}
