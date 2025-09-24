//
//  ProductListViewController.swift
//  PowerPlay-Assignment
//
//  Created by jatin on 24/09/25.
//

import UIKit

final class ProductListViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let footerSpinner = UIActivityIndicatorView(style: .medium)
    private let controlsContainer = UIStackView()
    private let prevButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    private let pageLabel = UILabel()
    private let noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "No products found"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let errorView = ErrorView()

    private var products: [Product] = []
    private var isLoading: Bool = false
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    private let pageLimit: Int = 10
    private let category: String = "electronics"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Products"
        view.backgroundColor = .systemBackground
        setupTableView()
        setupLoading()
        setupControls()
        setupErrorView()
        fetchInitial()
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        view.addSubview(tableView)
        view.addSubview(noDataLabel)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        footerSpinner.hidesWhenStopped = true
        let footerContainer = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 80))
        footerSpinner.translatesAutoresizingMaskIntoConstraints = false
        controlsContainer.translatesAutoresizingMaskIntoConstraints = false
        footerContainer.addSubview(controlsContainer)
        footerContainer.addSubview(footerSpinner)
        NSLayoutConstraint.activate([
            controlsContainer.leadingAnchor.constraint(equalTo: footerContainer.leadingAnchor, constant: 16),
            controlsContainer.trailingAnchor.constraint(equalTo: footerContainer.trailingAnchor, constant: -16),
            controlsContainer.topAnchor.constraint(equalTo: footerContainer.topAnchor, constant: 8),

            footerSpinner.topAnchor.constraint(equalTo: controlsContainer.bottomAnchor, constant: 8),
            footerSpinner.centerXAnchor.constraint(equalTo: footerContainer.centerXAnchor)
        ])
        tableView.tableFooterView = footerContainer
    }

    private func setupControls() {
        controlsContainer.axis = .horizontal
        controlsContainer.alignment = .center
        controlsContainer.distribution = .equalCentering
        controlsContainer.spacing = 12
        controlsContainer.translatesAutoresizingMaskIntoConstraints = false

        prevButton.setTitle("< Prev", for: .normal)
        nextButton.setTitle("Next >", for: .normal)
        prevButton.addTarget(self, action: #selector(tapPrev), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(tapNext), for: .touchUpInside)

        pageLabel.textColor = .secondaryLabel
        pageLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)

        let spacerLeft = UIView()
        let spacerRight = UIView()

        controlsContainer.addArrangedSubview(prevButton)
        controlsContainer.addArrangedSubview(pageLabel)
        controlsContainer.addArrangedSubview(nextButton)

        updateControls()
    }

    private func setupLoading() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupErrorView() {
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.isHidden = true
        errorView.onRetry = { [weak self] in
            self?.errorView.isHidden = true
            self?.fetchInitial()
        }
        view.addSubview(errorView)
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func fetchInitial() {
        products = []
        tableView.reloadData()
        noDataLabel.isHidden = true
        activityIndicator.startAnimating()
        currentPage = 1
        fetchPage(currentPage)
    }

    private func fetchPage(_ page: Int) {
        guard !isLoading else { return }
        isLoading = true
        footerSpinner.startAnimating()
        prevButton.isEnabled = false
        nextButton.isEnabled = false

        
        APIClient.shared.fetchProducts(page: page - 1, limit: pageLimit, category: category) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()
                self.footerSpinner.stopAnimating()
                self.isLoading = false

                switch result {
                case .success(let response):
                    self.products = response.products
                    self.tableView.reloadData()
                 
                    if self.tableView.numberOfRows(inSection: 0) > 0 {
                        self.tableView.setContentOffset(.zero, animated: true)
                    }
                    if let total = response.total, let limit = response.limit, limit > 0 {
                        self.totalPages = max(1, Int(ceil(Double(total) / Double(limit))))
                    }
                    
                    let resolvedPage = max(1, response.page ?? page)
                    self.currentPage = resolvedPage
                    self.updateControls()
                    self.noDataLabel.isHidden = !self.products.isEmpty
                case .failure(let error):
                    switch error {
                    case .network:
                        self.showError(message: "No internet connection. Please try again.")
                    default:
                        self.showError(message: "Something went wrong. Please try again.")
                    }
                    // Re-enable controls to allow retry
                    self.updateControls()
                }
            }
        }
    }

    @objc private func tapPrev() {
        guard currentPage > 1 else { return }
        activityIndicator.startAnimating()
        fetchPage(currentPage - 1)
    }

    @objc private func tapNext() {
        guard currentPage < totalPages else { return }
        activityIndicator.startAnimating()
        fetchPage(currentPage + 1)
    }

    private func updateControls() {
        pageLabel.text = "Page \(currentPage) / \(totalPages)"
        prevButton.isEnabled = currentPage > 1
        nextButton.isEnabled = currentPage < totalPages
        prevButton.alpha = prevButton.isEnabled ? 1.0 : 0.5
        nextButton.alpha = nextButton.isEnabled ? 1.0 : 0.5
    }

    private func showError(message: String) {
        errorView.isHidden = false
        errorView.setMessage(message)
    }
}

extension ProductListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.reuseIdentifier, for: indexPath) as! ProductTableViewCell
        cell.configure(with: products[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        let vc = ProductDetailViewController(product: product)
        navigationController?.pushViewController(vc, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) { }
}

// MARK: - Error View

final class ErrorView: UIView {
    private let stack = UIStackView()
    private let messageLabel = UILabel()
    private let retryButton = UIButton(type: .system)
    var onRetry: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .systemBackground
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        messageLabel.text = "No internet connection"
        messageLabel.textColor = .label
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center

        retryButton.setTitle("Retry", for: .normal)
        retryButton.addTarget(self, action: #selector(tapRetry), for: .touchUpInside)

        addSubview(stack)
        stack.addArrangedSubview(messageLabel)
        stack.addArrangedSubview(retryButton)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20)
        ])
    }

    func setMessage(_ message: String) {
        messageLabel.text = message
    }

    @objc private func tapRetry() {
        onRetry?()
    }
}


