//
//  ProductDetailViewController.swift
//  PowerPlay-Assignment
//
//  Created by jatin on 24/09/25.
//

import UIKit

final class ProductDetailViewController: UIViewController {
    private let product: Product

    private let scrollView = UIScrollView()
    private let stack = UIStackView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let priceLabel = UILabel()
    private let descriptionLabel = UILabel()

    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Details"
        setupUI()
        configure()
    }

    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16)
        ])

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        imageView.heightAnchor.constraint(equalToConstant: 220).isActive = true

        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.numberOfLines = 0

        categoryLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        categoryLabel.textColor = .systemBlue

        priceLabel.font = UIFont.preferredFont(forTextStyle: .title3)

        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0

        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(categoryLabel)
        stack.addArrangedSubview(priceLabel)
        stack.addArrangedSubview(descriptionLabel)
    }

    private func configure() {
        titleLabel.text = product.title
        categoryLabel.text = product.category
        priceLabel.text = String(format: "$%.2f", product.price)
        descriptionLabel.text = product.description
        if let url = product.imageUrl {
            _ = ImageLoader.shared.loadImage(from: url) { [weak self] image in
                self?.imageView.image = image
            }
        }
    }
}


