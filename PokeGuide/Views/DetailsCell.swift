//
//  DetailsCell.swift
//  PokeGuide
//
//  Created by Beavean on 06.05.2023.
//

import SnapKit
import UIKit

final class DetailsCell: UITableViewCell, ReuseIdentifier {
    let keyLabel = UILabel().apply {
        $0.textColor = Constants.Colors.mainLabelColor.color
        $0.font = UIFont.boldTextCustomFont(size: 16)
    }

    let valueLabel = UILabel().apply {
        $0.textColor = Constants.Colors.mainLabelColor.color
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.addSubview(keyLabel)
        contentView.addSubview(valueLabel)
        keyLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.StyleDefaults.innerPadding)
            make.centerY.equalToSuperview()
        }
        valueLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Constants.StyleDefaults.innerPadding)
            make.centerY.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
