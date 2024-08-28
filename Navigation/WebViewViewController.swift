//
//  WebViewViewController.swift
//  Navigation
//
//  Created by Vladimir Kurdiukov on 26.08.2024.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {
    
    let webView: WKWebView = .init()
    lazy var urlField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите URL"
        return textField
    }()
    
    lazy var historyTable = UITableView()
    
    var urlsHistory: [URL] = []
    
    lazy var showHistory = UIButton(primaryAction: .init(handler: { _ in
        self.historyTable.isHidden = false
    }))
    
    lazy var loadButton = UIButton(primaryAction: .init(handler: { _ in
        guard let url = URL(string: self.urlField.text ?? "") else { return }
        self.webView.load(URLRequest(url: url))
    }))

    override func viewDidLoad() {
        super.viewDidLoad()
        historyTable.isHidden = true
        loadButton.setTitle("Go", for: .normal)
        
        view.backgroundColor = .white
        view.addSubview(loadButton)
        view.addSubview(showHistory)
        view.addSubview(urlField)
        view.addSubview(webView)
        view.addSubview(historyTable)
        historyTable.frame = view.bounds
        
        urlField.frame = .init(x: .zero, y: 50, width: view.bounds.width - 100, height: 50)
        
        showHistory.frame = .init(
            x: view.bounds.width - 100,
            y: 50,
            width: 50,
            height: 50
        )
        loadButton.frame = .init(
            x: view.bounds.width - 50,
            y: 50,
            width: 50,
            height: 50
        )
        
        showHistory.setTitle("?", for: .normal)
        webView.frame = .init(x: .zero, y: 100, width: view.bounds.width, height: view.bounds.height)
        webView.load(URLRequest(url: URL(string: "https://google.com")!))
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        
        historyTable.delegate = self
        historyTable.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension WebViewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urlsHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = urlsHistory[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = urlsHistory[indexPath.row]
        webView.load(URLRequest(url: url))
        urlField.text = url.description
        tableView.isHidden = true
    }
}
extension WebViewViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        urlsHistory.insert(url, at: 0)
        historyTable.reloadData()
    }
}
