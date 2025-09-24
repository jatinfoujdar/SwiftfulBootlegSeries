//
//  ProductTableViewCell.swift
//  PowerPlay-Assignment
//
//  Created by jatin on 24/09/25.
//

import UIKit

final class ProductTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ProductTableViewCell"

    private let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = UIColor(white: 0.95, alpha: 1)
        iv.layer.cornerRadius = 8
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var imageTask: URLSessionDataTask?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        imageTask?.cancel()
        imageTask = nil
    }

    private func setupUI() {
        selectionStyle = .none

        contentView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(priceLabel)

        let spacing: CGFloat = 12

        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            productImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -spacing),
            productImageView.widthAnchor.constraint(equalToConstant: 90),
            productImageView.heightAnchor.constraint(equalToConstant: 90),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            titleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: spacing),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            categoryLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6),
            categoryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            priceLabel.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: productImageView.bottomAnchor, constant: spacing),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: categoryLabel.bottomAnchor, constant: spacing)
        ])
    }

    func configure(with product: Product) {
        titleLabel.text = product.title
        descriptionLabel.text = product.description
        categoryLabel.text = product.category
        priceLabel.text = String(format: "$%.2f", product.price)

        if let url = product.imageUrl {
            imageTask = ImageLoader.shared.loadImage(from: url) { [weak self] image in
                self?.productImageView.image = image
            }
        } else {
            productImageView.image = nil
        }
    }
}


