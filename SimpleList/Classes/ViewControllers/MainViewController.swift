//
//  MainViewController.swift
//  SimpleList
//
//  Created by Kesava Jawaharlal on 15/05/2020.
//  Copyright © 2020 Small Screen Science Ltd. All rights reserved.
//

import Cocoa
import AVKit

class MainViewController: NSViewController {

    // MARK:  - Vars
    private var mockURLSession = MockURLSession()
    private var networkService: NetworkServiceProtocol!
    var viewModel: MainViewModel!

    @IBOutlet weak var tableView: NSTableView!
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sending mock data for the sake of this app
        networkService = NetworkService(session: mockURLSession)
        mockURLSession.data = getContents(from: "MockData")?.data(using: .utf8)
        viewModel = MainViewModel(networkService: networkService, delegate: self)

        viewModel.loadContents()
    }
}

extension MainViewController: ViewModelDelegate {
    func refreshView() {
        tableView.reloadData()
    }
}

// MARK: - Table View DS and Delegate methods
extension MainViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return viewModel.noOfRowsAvailable()
    }
        
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let content = viewModel.contentFor(row: row) else { return nil }
        
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "titleColumn") {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "titleColumn")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            
            cellView.textField?.stringValue = content.title
            return cellView
        }
        
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "imageColumn") {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "imageColumn")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? ImageCell else { return nil }
            if content.contentType == .image {
                cellView.iconImage.image = NSImage(named: content.contentFileName)
            } else {
                cellView.playerView.player = AVPlayer(url: Bundle.main.url(forResource: content.contentFileName, withExtension: "mov")!)
                cellView.iconImage.image = nil
            }
            return cellView
        }
        
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "contentTypeColumn") {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "contentTypeColumn")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            
            cellView.textField?.stringValue = content.contentType.rawValue
            return cellView
        }
     
        return nil
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if let cell = tableView.rowView(atRow: row, makeIfNecessary: false)?.view(atColumn: 2) as? ImageCell {
            if let content = viewModel.contentFor(row: row) {
                if content.contentType == .video {
//                    cell.playerView.enterFullScreenMode(NSScreen(), withOptions: nil)
                    cell.playerView.player?.play()
                } else {
                    if let window = NSStoryboard.main?.instantiateController(withIdentifier: "ImageWindow") as? NSWindowController,
                        let imageVC = window.contentViewController as? ImageViewController {
                        imageVC.bgImage.image = NSImage(named: content.contentFileName)
                        window.showWindow(self)
                    }
                }
            }
        }
        
        return true
    }
}

// MARK: - Collection View DS and Delegate methods
extension MainViewController: NSCollectionViewDataSource, NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.noOfPages()
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        if let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "LabelCollectionViewItem"), for: indexPath) as? LabelCollectionViewItem {
            item.label.stringValue = "\(indexPath.item + 1)"
            return item
        }
        return NSCollectionViewItem()
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        if let indexPath = indexPaths.first {
            viewModel.pageNumber = indexPath.item
            tableView.reloadData()
        }
    }
}

