//
//  PopUpViewController.swift
//  gooDict
//
//  Created by home on 17/03/2020.
//  Copyright © 2020 home. All rights reserved.
//
//  *************
//  PopUp emerges when user press "Need some help" button, shows translation gotten by Yandex.translate.
//  *************

import UIKit

class PopUpViewController: ViewController {
    
    var activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    struct Translations: Decodable {
        let text: [String]
        let lang: String
    }

    @IBOutlet weak var MessagePopUpView: UIView!
    @IBOutlet weak var textInsidePopUp: UILabel!
    var popUpWord: String = ""
    
    @IBAction func closePopUp(_ sender: Any) {
        //self.view.removeFromSuperview()
        self.removeAnimate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        activityIndicatorView.color = UIColor.black
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.frame = self.view.frame
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        // translate(text: popUpWord, into: "en-ru") { (translation, error) in self.textInsidePopUp.text = translation! }
        translate(text: popUpWord, into: "en-ru", completion: {
            (translation, error) in self.textInsidePopUp.text = translation!
        })
     }
    
    override func viewDidLoad() {
        textInsidePopUp.sizeToFit()
        MessagePopUpView.layer.cornerRadius = 24
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
    }
    
    //MARK: Translate Endpoint
    func translate(text: String, into: String, completion: @escaping (_ translations: String?, _ error: Error?) -> Void) {
           
             //Construct url for translate end point
             var urlComponents = URLComponents(string: "https://translate.yandex.net/api/v1.5/tr.json/translate")
             var queryItems = [URLQueryItem]()
             queryItems.append(URLQueryItem(name: "text", value: text))
             queryItems.append(URLQueryItem(name: "lang", value: into))
             queryItems.append(URLQueryItem(name: "key", value: "trnsl.1.1.20200312T191316Z.5e6f87369c723313.199692406ba4f853188f186f54bd30b3d1eaddef"))
             queryItems.append(URLQueryItem(name: "format", value: "plain"))
             queryItems.append(URLQueryItem(name: "options", value: "1"))
             urlComponents?.queryItems = queryItems
             guard let url = urlComponents?.url else { return }
             // Here is URL ready to use.
             let request = URLRequest(url: url)
             let session = URLSession.shared
             let task = session.dataTask(with: request) { (data, response, error) in
                 DispatchQueue.main.async {
                     guard let data = data,
                     let response = response as? HTTPURLResponse,
                     (200 ..< 300).contains(response.statusCode),
                     error == nil else {
                         completion("Error was occured", error)
                         return
                     }
                     let decoder = JSONDecoder()
                     let decodedJSON = try? decoder.decode(Translations.self, from: data)
                    
                     completion(decodedJSON!.text[0], error)
                     self.activityIndicatorView.stopAnimating()
                     // completion(decodedJSON, error)
                     // Translations(text: decodedJSON, lang: "en-ru")
                     // print("From inner method: ", decodedJSON!.text[0])
                  }
             }
             task.resume()
    }

    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished : Bool) in
            if (finished) {
                self.view.removeFromSuperview()
            }
        })
    }
    
}
