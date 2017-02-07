//
//  CollectionViewController.swift
//  HeckelDiffUpdateFail
//
//  Created by Alex Tang on 2/7/17.
//  Copyright © 2017 Funkware. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var a1 = [SessionCacheDatum]()
    var a2 = [SessionCacheDatum]()

    var sessionData: [SessionCacheDatum]!
    override func viewDidLoad() {
        super.viewDidLoad()

        a1.append (SessionCacheDatum(sessionId: "session1", sessionDetail: "detail1"))
        a1.append (SessionCacheDatum(sessionId: "session2", sessionDetail: "detail2"))
        a2.append (SessionCacheDatum(sessionId: "session2", sessionDetail: "detail3"))

        self.sessionData = a1

        self.collectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goTapped(_ sender: Any) {
        self.sessionData = self.a2

        self.collectionView.applyDiff(self.a1, self.a2, inSection: 0) { (completed: Bool) in
            NSLog("Done!")
        }

    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sessionData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.detailTextLabel!.text = self.sessionData[indexPath.row].sessionDetail
        cell.textLabel!.text = self.sessionData[indexPath.row].sessionId
        return cell

    }
}
