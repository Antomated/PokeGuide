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
        let backButtonImage = Constants.Symbols.backArrow.symbol
        let resizedImage = backButtonImage?.scale(to: CGSize(width: imageSize, height: imageSize))
        let backButtonImageView = UIImageView(image: resizedImage)
        backButtonImageView.contentMode = .scaleAspectFill
        backButtonImageView.tintColor = Constants.Colors.mainLabelColor.color
        backButtonImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        backButtonImageView.addGestureRecognizer(tapGestureRecognizer)
        let backBarButtonItem = UIBarButtonItem(customView: backButtonImageView)
        navigationItem.leftBarButtonItem = backBarButtonItem
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
        nameLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(outerPadding)
            make.height.equalTo(nameLabelHeight)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
    }

    private func updateConstraintsForOrientation(orientation: UIInterfaceOrientation) {
        let viewSafeArea = view.safeAreaLayoutGuide
        nameImageViewContainer.snp.remakeConstraints { make in
            make.left.equalTo(viewSafeArea.snp.left)
            if orientation.isLandscape {
                make.top.equalTo(viewSafeArea.snp.top)
                make.width.equalTo(viewSafeArea.layoutFrame.width / 2)
                make.height.equalTo(viewSafeArea.layoutFrame.height)
            } else {
                make.top.equalTo(viewSafeArea.snp.top).offset(-UIApplication.shared.statusBarFrame.size.height)
                make.width.equalTo(viewSafeArea.layoutFrame.width)
                make.height.equalTo(viewSafeArea.layoutFrame.height / 2)
            }
        }
        detailsViewContainer.snp.remakeConstraints { make in
            if orientation.isLandscape {
                make.top.equalTo(viewSafeArea.snp.top)
                make.left.equalTo(nameImageViewContainer.snp.right).inset(outerPadding)
                make.right.equalTo(viewSafeArea.snp.right).offset(-outerPadding)
                make.height.equalTo(nameImageViewContainer.snp.height)
            } else {
                make.top.equalTo(nameImageViewContainer.snp.bottom)
                make.left.equalTo(viewSafeArea.snp.left).inset(outerPadding)
                make.right.equalTo(viewSafeArea.snp.right).offset(-outerPadding)
                make.bottom.equalTo(viewSafeArea.snp.bottom)
            }
        }
    }

    private func bindViewModel() {
        viewModel.pokemon
            .subscribe(onNext: { [weak self] pokemon in
                guard let self, let imageUrl = pokemon.sprites?.other?.officialArtwork.frontDefault else { return }
                self.imageView.sd_setImage(with: URL(string: imageUrl))
                self.nameLabel.text = pokemon.name?.capitalized
            })
            .disposed(by: disposeBag)
    }

    private func embedTabStripViewController() {
        let tabStripVC = DetailsTabStripViewController(viewModel: viewModel.tabStripViewModel)

        addChild(tabStripVC)
        detailsViewContainer.addSubview(tabStripVC.view)
        tabStripVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.StyleDefaults.innerPadding)
        }
        tabStripVC.didMove(toParent: self)
    }
}
