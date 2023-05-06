//
//  PokemonsViewController.swift
//  PokeGuide
//
//  Created by Beavean on 24.04.2023.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class PokemonsViewController: UIViewController {
    // MARK: - UI Elements

    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let loader = LoaderBarButtonItem()

    // MARK: - Properties

    private let viewModel: PokemonsViewModel
    private let appTitle = "Pokémon Guide"
    private let navigationBarTitleFontSize: CGFloat = 24
    private let numberOfColumnsInLandscape: CGFloat = 4
    private let numberOfColumnsInPortrait: CGFloat = 2
    private let cellSizeRatio: CGFloat = 10 / 15
    private let rowsBeforePagination = PokemonAPI.pokemonsListLimit
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        navigationItem.title = appTitle
        navigationItem.rightBarButtonItem = loader
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        guard let font = UIFont.boldTextCustomFont(size: navigationBarTitleFontSize) else { return }
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: Constants.Colors.mainAccentColor.color as Any
        ]
        navigationController?.navigationBar.largeTitleTextAttributes = attributes
        navigationController?.navigationBar.titleTextAttributes = attributes
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        coordinator.animate { _ in
            self.updateFlowLayout(for: size, flowLayout: flowLayout)
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    // MARK: - Initialization

    init(viewModel: PokemonsViewModel = PokemonsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        configureCollectionViewLayout()
        bindViewModelToCollectionView()
        configurePagination()
        bindLoaderBarButtonItem()
        configureCellSelection()
    }

    private func configureCollectionViewLayout() {
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.reuseIdentifier)
        collectionView.backgroundColor = Constants.Colors.screenBackgroundColor.color
        setupFlowLayout()
    }

    private func bindViewModelToCollectionView() {
        viewModel.detailedPokemons
            .compactMap { $0 }
            .bind(to: collectionView.rx.items(cellIdentifier: PokemonCell.reuseIdentifier,
                                              cellType: PokemonCell.self)) { _, item, cell in
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)
        viewModel.errorRelay
            .subscribe(onNext: { [weak self] error in
                self?.showError(error)
            })
            .disposed(by: disposeBag)
    }

    private func configurePagination() {
        collectionView.rx.willDisplayCell
            .flatMap { [weak self] _, indexPath -> Observable<IndexPath> in
                guard let self,
                      !self.viewModel.isFetchingMoreData,
                      indexPath.row >= self.collectionView.numberOfItems(inSection: 0) - self.rowsBeforePagination
                else { return .empty() }
                return .just(indexPath)
            }
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.loadMorePokemons()
            })
            .disposed(by: disposeBag)
    }

    private func bindLoaderBarButtonItem() {
        viewModel.isFetchingDetailedPokemons.asObservable()
            .bind { [weak self] isLoading in
                isLoading ? self?.loader.startAnimating() : self?.loader.stopAnimating()
            }
            .disposed(by: disposeBag)
    }

    private func configureCellSelection() {
        collectionView.rx.modelSelected(DetailedPokemon.self)
            .subscribe(onNext: { [weak self] selectedPokemon in
                guard let self = self else { return }
                let pokemonDetailViewModel = DetailsViewModel(pokemon: selectedPokemon)
                let pokemonDetailViewController = DetailsViewController(viewModel: pokemonDetailViewModel)
                self.navigationController?.pushViewController(pokemonDetailViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func setupFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        updateFlowLayout(for: view.bounds.size, flowLayout: flowLayout)
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
    }

    // MARK: - Helpers

    private func updateFlowLayout(for size: CGSize, flowLayout: UICollectionViewFlowLayout) {
        let isLandscape = size.width > size.height
        let numberOfColumns: CGFloat = isLandscape ? numberOfColumnsInLandscape : numberOfColumnsInPortrait
        let spacing: CGFloat = Constants.StyleDefaults.innerPadding
        let itemWidth = (size.width - (numberOfColumns + 1) * spacing) / numberOfColumns
        let itemHeight = itemWidth * cellSizeRatio
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        flowLayout.minimumLineSpacing = spacing
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PokemonsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isLandscape = view.bounds.width > view.bounds.height
        let numberOfColumns: CGFloat = isLandscape ? numberOfColumnsInLandscape : numberOfColumnsInPortrait
        let spacing: CGFloat = Constants.StyleDefaults.innerPadding
        let itemWidth = (view.bounds.width - (numberOfColumns + 1) * spacing) / numberOfColumns
        let itemHeight = itemWidth * cellSizeRatio
        return CGSize(width: itemWidth, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.StyleDefaults.innerPadding
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constants.StyleDefaults.innerPadding
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let spacing = Constants.StyleDefaults.innerPadding
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
}
