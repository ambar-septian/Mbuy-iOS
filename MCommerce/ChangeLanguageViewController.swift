//
//  ChangeLanguageViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 7/5/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class ChangeLanguageViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let languages: [(title:String, localize: Language)] =
            [(title:"English", localize: .EN),
             (title:"Indonesia", localize: .ID)]
    
    fileprivate var titleVC:String {
        return "changeLanguage".localize
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = titleVC
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()    }
}

extension ChangeLanguageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let language = languages[indexPath.row]
        cell.textLabel?.text = language.title
        cell.accessoryType = Localize.shared.language == language.localize ? .checkmark : .none
        return cell
    }
}

extension ChangeLanguageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        Localize.shared.language = languages[indexPath.row].localize
        tableView.reloadData()
        
        navigationItem.title = titleVC
        setupTitleTabBar()
    }
}
