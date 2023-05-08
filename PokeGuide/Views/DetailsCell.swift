//
//  DetailsCell.swift
//  PokeGuide
//
//  Created by Beavean on 06.05.2023.
//

import SnapKit
import UIKit

final class DetailsCell: UITableViewCell, ReuseIdentifier {
    // MARK: - UI Elements

    private let leadingLabel = UILabel().apply {
        $0.textColor = Constants.Colors.mainLabelColor.color
        $0.font = UIFont.boldTextCustomFont(size: 16)
    }

    private let trailingLabel = UILabel().apply {
        $0.textColor = Constants.Colors.mainLabelColor.color
    }

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configure(leadingLabelText: String, trailingLabelText: String?) {
        leadingLabel.text = leadingLabelText
        trailingLabel.text = trailingLabelText
    }

    private func setUp() {
        backgroundColor = .clear
        contentView.addSubview(leadingLabel)
        contentView.addSubview(trailingLabel)
        leadingLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Constants.StyleDefaults.innerPadding)
            $0.centerY.equalToSuperview()
        }
        trailingLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Constants.StyleDefaults.innerPadding)
            $0.centerY.equalToSuperview()
        }
    }
}
