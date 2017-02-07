//
//  DiffTableViewController.swift
//  HeckelDiffExample
//
//  Created by Alex Tang on 2/7/17.
//  Copyright © 2017 Playlist. All rights reserved.
//

import UIKit
import HeckelDiff

struct SessionCacheDatum: Equatable, Hashable {
    let sessionId: String
    let sessionDetail: String

    static func ==(lhs: SessionCacheDatum, rhs: SessionCacheDatum) -> Bool {
        return lhs.sessionId == rhs.sessionId && lhs.sessionDetail == rhs.sessionDetail
    }

    var hashValue: Int {
        return sessionId.hashValue
    }
}

// This shows a bug in HeckelDiff when a row is deleted, and the new row at
// the indexPath that was deleted needs to be reloded, the update fails.
// This is because the "reload" is using the "new" index instead of the "old"
// index.  The docs for updating table rows says:
//
// https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/TableView_iPhone/ManageInsertDeleteRow/ManageInsertDeleteRow.html
//   It (the table view) defers any insertions of rows or sections until after
//   it has handled the deletions of rows or sections. The table view behaves 
//   the same way with reloading methods called inside an update block—the 
//   reload takes place with respect to the indexes of rows and sections before 
//   the animation block is executed
class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var a1 = [SessionCacheDatum]()
    var a2 = [SessionCacheDatum]()

    var sessionData: [SessionCacheDatum]!
    override func viewDidLoad() {
        super.viewDidLoad()

        a1.append (SessionCacheDatum(sessionId: "session1", sessionDetail: "detail1"))
        a1.append (SessionCacheDatum(sessionId: "session2", sessionDetail: "detail2"))
        a2.append (SessionCacheDatum(sessionId: "session2", sessionDetail: "detail3"))

        self.sessionData = a1

        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    @IBAction func goTapped(_ sender: Any) {
        self.sessionData = self.a2
        self.tableView.applyDiff(self.a1, self.a2, inSection: 0, withAnimation: UITableViewRowAnimation.fade)
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sessionData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.detailTextLabel!.text = self.sessionData[indexPath.row].sessionDetail
        cell.textLabel!.text = self.sessionData[indexPath.row].sessionId
        return cell
    }
}
