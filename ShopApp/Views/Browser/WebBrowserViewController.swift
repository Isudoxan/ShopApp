//
//  WebBrowserViewController.swift
//  ShopApp
//
//  Created by Danylo Liubyi on 10.10.2025.
//

import UIKit
import WebKit

final class WebBrowserViewController: UIViewController, WKNavigationDelegate {

    // MARK: - Properties

    var initialURL: URL?
    private var lastAttemptedURL: URL?
    private var webView: WKWebView?
    private var progressView: UIProgressView?
    private var errorCard: UIView?
    private var isLoadingInitialRequest = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupWebView()
        setupToolbar()
        setupErrorCard()

        if let url = initialURL {
            load(url)
        } else {
            showError()
        }
    }

    // MARK: - Setup Methods

    private func setupWebView() {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        self.webView = webView

        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)
        self.progressView = progressView

        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new, context: nil)

        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            webView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupToolbar() {
        let back = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )

        let forward = UIBarButtonItem(
            image: UIImage(systemName: "chevron.forward"),
            style: .plain,
            target: self,
            action: #selector(goForward)
        )

        let refresh = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(reloadPage)
        )

        let close = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(close)
        )

        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolbar)
        toolbar.setItems([back, flexible, forward, flexible, refresh, flexible, close], animated: false)

        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView?.bottomAnchor.constraint(equalTo: toolbar.topAnchor) ?? NSLayoutConstraint()
        ])
    }

    private func setupErrorCard() {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .secondarySystemBackground
        card.layer.cornerRadius = 16
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.15
        card.layer.shadowOffset = CGSize(width: 0, height: 3)
        card.layer.shadowRadius = 6
        card.isHidden = true
        view.addSubview(card)
        self.errorCard = card

        let icon = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = .systemRed
        card.addSubview(icon)

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.text = "Failed to load."
        card.addSubview(label)

        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Try Again", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(retry), for: .touchUpInside)
        card.addSubview(button)

        NSLayoutConstraint.activate([
            card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            card.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            card.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            card.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24),
            card.widthAnchor.constraint(lessThanOrEqualToConstant: 300),

            icon.topAnchor.constraint(equalTo: card.topAnchor, constant: 24),
            icon.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            icon.heightAnchor.constraint(equalToConstant: 40),
            icon.widthAnchor.constraint(equalToConstant: 40),

            label.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),

            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            button.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20),
            button.centerXAnchor.constraint(equalTo: card.centerXAnchor)
        ])
    }

    // MARK: - Loading

    func load(_ url: URL) {
        hideError()
        lastAttemptedURL = url
        isLoadingInitialRequest = true
        webView?.load(URLRequest(url: url))
    }

    // MARK: - Actions

    @objc private func goBack() {
        guard let webView, webView.canGoBack else { return }
        webView.goBack()
    }

    @objc private func goForward() {
        guard let webView, webView.canGoForward else { return }
        webView.goForward()
    }

    @objc private func reloadPage() {
        webView?.reload()
    }
    
    @objc private func close() {
        guard let google = URL(string: "https://www.google.com") else { return }
        load(google)
    }

    @objc private func retry() {
        if let url = lastAttemptedURL {
            load(url)
        }
    }

    // MARK: - Error Handling

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideError()
        isLoadingInitialRequest = false
        if let currentURL = webView.url {
            lastAttemptedURL = currentURL
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if isLoadingInitialRequest {
            showError()
            isLoadingInitialRequest = false
        }
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if isLoadingInitialRequest {
            showError()
            isLoadingInitialRequest = false
        }
    }

    private func showError() {
        errorCard?.isHidden = false
    }

    private func hideError() {
        errorCard?.isHidden = true
    }

    // MARK: - Progress Observer

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        guard keyPath == #keyPath(WKWebView.estimatedProgress),
              let progressView,
              let webView else { return }

        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = progressView.progress >= 1.0
    }

    // MARK: - Deinit

    deinit {
        if let webView {
            webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        }
    }
}
