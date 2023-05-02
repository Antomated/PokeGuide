//
//  PokemonCell.swift
//  PokeGuide
//
//  Created by Beavean on 25.04.2023.
//

import RxSwift
import SDWebImage
import SnapKit
import UIKit

final class PokemonCell: UICollectionViewCell {
    // MARK: - UI Elements

    private let imageView = UIImageView().apply {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
    }
    private let nameLabel = UILabel().apply {
        $0.textColor = Constants.Colors.mainAccentColor.color
        $0.numberOfLines = 0
        $0.layer.contentsGravity = .bottom
        $0.clipsToBounds = true
        $0.font = .boldTextCustomFont()
    }
    private let abilityLabel = UILabel().apply {
        $0.textColor = Constants.Colors.secondaryLabelColor.color
        $0.numberOfLines = 0
        $0.font = .regularTextCustomFont()
    }

    // MARK: - Properties

    static let reuseIdentifier = String(describing: PokemonCell.self)
    private let defaultNameLabelText = "Pokemon"
    private let defaultAbilityLabelText = "..."
    private let cornerRadius: CGFloat = 5
    private let shadowOpacity: Float = 0.15
    private let shadowRadius: CGFloat = 3
    private let shadowOffset = CGSize(width: 0, height: 2)
    private let imageViewWidthRatio = 2.5
    private let innerPadding = Constants.StyleDefaults.innerPadding
    private let compositeDisposable = CompositeDisposable()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        compositeDisposable.dispose()
        imageView.image = Constants.Images.placeholder.image
        nameLabel.text = defaultNameLabelText
        abilityLabel.text = defaultAbilityLabelText
    }

    // MARK: - Configuration

    func configure(with viewModel: PokemonCellViewModel) {
        nameLabel.text = viewModel.name
        let cellDisposeBag = DisposeBag()

        viewModel.imageUrl
            .subscribe(onNext: { [weak self] imageUrl in
                guard let self, let imageUrl else { return }
                self.imageView.sd_setImage(with: URL(string: imageUrl))
            })
            .disposed(by: cellDisposeBag)

        viewModel.ability
            .subscribe(onNext: { [weak self] abilityName in
                guard let self, let abilityName else { return }
                self.abilityLabel.text = abilityName
            })
            .disposed(by: cellDisposeBag)
    }

    // MARK: - UI Setup

    private func setUp() {
        contentView.backgroundColor = Constants.Colors.cellBackgroundColor.color
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.masksToBounds = false
        layer.shadowColor = Constants.Colors.shadowColor.color?.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true

        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.bottom.right.top.equalToSuperview().inset(innerPadding)
            $0.width.equalToSuperview().dividedBy(imageViewWidthRatio)
        }

        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(innerPadding)
            make.trailing.equalTo(imageView.snp.leading).inset(innerPadding)
            make.bottom.equalTo(contentView.snp.centerY)
        }

        contentView.addSubview(abilityLabel)
        abilityLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(innerPadding)
            make.trailing.equalTo(imageView.snp.leading).inset(innerPadding)
            make.top.equalTo(contentView.snp.centerY)
        }
    }
}
