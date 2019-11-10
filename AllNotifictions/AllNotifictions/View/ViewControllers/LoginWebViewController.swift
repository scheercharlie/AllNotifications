//
//  LoginWebViewController.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 11/8/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class LoginWebViewController: UIViewController, WKNavigationDelegate {
    var selectedService: NotificationHost!
    
    @IBOutlet weak var webKitView: WKWebView!
    
    override func viewDidAppear(_ animated: Bool) {
        webKitView.navigationDelegate = self
        
        guard let url = getLoginURL() else {
            //TO DO: Display alert that url could not be loaded
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        let request = URLRequest(url: url)
        
        webKitView.load(request)
    }
    
    fileprivate func getLoginURL() -> URL? {
        var urlString = ""
        
        let hostType = selectedService.getTypeFromHostTypeData()
        
        switch hostType?.type {
        case .github:
            print("github")
        case .wordpress:
            urlString = WordpressAPIClient.endpoints.authentication.stringValue
        default:
            return nil
        }
        
        
        
        return URL(string: urlString)
    }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            print("did commit")
            if let url = webView.url,
                let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                switch components.path {
                case "/wordpress/":
                    WordpressAPIClient.authenticate(components: components, host:selectedService, completion: handleLoginResponse(success:error:))
                default:
                    break
                }
            }
        }
        
        fileprivate func handleLoginResponse(success: Bool, error: Error?) {
            if error != nil {
                //TO DO: Display error
                print(error)
            } else {
                print(success)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
