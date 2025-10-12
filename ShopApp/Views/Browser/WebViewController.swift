//
//  WebViewController.swift
//  ShopApp
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    // MARK: - Properties
    
    var url: URL?
    
    // MARK: - Subviews
    
    private let navigationBar: ModalNavigationBar = {
        let navigationBar = ModalNavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.tintColor = .systemBlue
        progressView.trackTintColor = .clear
        return progressView
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
    private lazy var emptyStateViewController: WebViewEmptyStateViewController = {
        let controller = WebViewEmptyStateViewController()
        controller.actionHandler = { [weak self] in
            self?.reloadURL()
        }
        return controller
    }()
    
    private var initialURL: URL?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupSubviews()
        setupLayout()
        setupWebView()
        loadURL()
    }
    
    // MARK: - Setup Style
    
    private func setupStyle() {
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Setup Subviews
    
    private func setupSubviews() {
        navigationBar.delegate = self
        
        view.addSubview(webView)
        view.addSubview(progressView)
        view.addSubview(navigationBar)
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        let navigationBarConstraints = [
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        let progressViewConstraints = [
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2)
        ]
        
        let webViewConstraints = [
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(navigationBarConstraints)
        NSLayoutConstraint.activate(progressViewConstraints)
        NSLayoutConstraint.activate(webViewConstraints)
    }
    
    // MARK: - Configure
    
    func configure(url: String, title: String? = nil) {
        guard let url = URL(string: url) else { return }
        self.url = url
        self.initialURL = url
        navigationBar.configure(title: title)
    }
    
    private func setupWebView() {
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil
        )
    }
    
    // MARK: - Methods
    
    private func loadURL() {
        guard let url else { return }
        
        hideEmptyState()
        progressView.progress = 0
        progressView.alpha = 1
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func reloadURL() {
        if webView.backForwardList.currentItem != nil {
            hideEmptyState()
            progressView.progress = 0
            progressView.alpha = 1
            webView.reload()
        } else {
            loadURL()
        }
    }
    
    private func updateButtons() {
        navigationBar.setNavigationEnabled(back: webView.canGoBack, forward: webView.canGoForward)
    }
    
    // MARK: - Empty State
    
    private func showEmptyState() {
        addChild(emptyStateViewController)
        emptyStateViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyStateViewController.view)
        emptyStateViewController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            emptyStateViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateViewController.view.topAnchor.constraint(equalTo: progressView.bottomAnchor),
            emptyStateViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func hideEmptyState() {
        emptyStateViewController.willMove(toParent: nil)
        emptyStateViewController.view.removeFromSuperview()
        emptyStateViewController.removeFromParent()
    }
    
    // MARK: - Observe Progress
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "estimatedProgress" else { return }
        
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = webView.estimatedProgress >= 1.0
    }
}

// MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateButtons()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showEmptyState()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showEmptyState()
    }
}

// MARK: - WKUIDelegate

extension WebViewController: WKUIDelegate { }

// MARK: - ModalNavigationBarDelegate

extension WebViewController: ModalNavigationBarDelegate {
    func didTapBack() {
        webView.goBack()
    }
    
    func didTapForward() {
        webView.goForward()
    }
    
    func didTapReload() {
        webView.reload()
    }
    
    func didTapClose() {
        guard let initialURL else { return }
        self.url = initialURL
        loadURL()
    }
}
