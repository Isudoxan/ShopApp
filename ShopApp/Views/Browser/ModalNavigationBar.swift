//
//  ModalNavigationBar.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 11.10.2025.
//

import UIKit

protocol ModalNavigationBarDelegate: AnyObject {
    func didTapBack()
    func didTapForward()
    func didTapReload()
    func didTapClose()
}

class ModalNavigationBar: UIView {
    
    // MARK: - Properties
    
    weak var delegate: ModalNavigationBarDelegate?
    
    // MARK: - Subviews
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let forwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let reloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Style
    
    private func setupStyle() {
        backgroundColor = .systemBackground
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
    }
    
    // MARK: - Setup Subviews
    
    private func setupSubviews() {
        [backButton, forwardButton, reloadButton, closeButton].forEach {
            addSubview($0)
            $0.tintColor = .label
        }
        
        addSubview(titleLabel)
        
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(forwardTapped), for: .touchUpInside)
        reloadButton.addTarget(self, action: #selector(reloadTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        let backButtonConstraints = [
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            backButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 28),
            backButton.heightAnchor.constraint(equalToConstant: 28)
        ]
        
        let forwardButtonConstraints = [
            forwardButton.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8),
            forwardButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            forwardButton.widthAnchor.constraint(equalToConstant: 28),
            forwardButton.heightAnchor.constraint(equalToConstant: 28)
        ]
        
        let closeButtonConstraints = [
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            closeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 28),
            closeButton.heightAnchor.constraint(equalToConstant: 28)
        ]
        
        let reloadButtonConstraints = [
            reloadButton.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -8),
            reloadButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            reloadButton.widthAnchor.constraint(equalToConstant: 28),
            reloadButton.heightAnchor.constraint(equalToConstant: 28)
        ]
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: forwardButton.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: reloadButton.leadingAnchor, constant: -8),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(backButtonConstraints)
        NSLayoutConstraint.activate(forwardButtonConstraints)
        NSLayoutConstraint.activate(reloadButtonConstraints)
        NSLayoutConstraint.activate(closeButtonConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
    
    // MARK: - Configure
    
    func configure(title: String?) {
        titleLabel.text = title
    }
    
    func setNavigationEnabled(back: Bool? = nil,
                              forward: Bool? = nil,
                              reload: Bool? = nil,
                              close: Bool? = nil) {
        if let back = back{
            backButton.isEnabled = back
            backButton.tintColor = back ? .label : .systemGray3
        }
        if let forward = forward {
            forwardButton.isEnabled = forward
            forwardButton.tintColor = forward ? .label : .systemGray3
        }
        if let reload = reload {
            reloadButton.isEnabled = reload
            reloadButton.tintColor = reload ? .label : .systemGray3
        }
        if let close = close {
            closeButton.isEnabled = close
            closeButton.tintColor = close ? .label : .systemGray3
        }
    }
    
    // MARK: - Actions
    
    @objc private func backTapped() { delegate?.didTapBack() }
    @objc private func forwardTapped() { delegate?.didTapForward() }
    @objc private func reloadTapped() { delegate?.didTapReload() }
    @objc private func closeTapped() { delegate?.didTapClose() }
}
