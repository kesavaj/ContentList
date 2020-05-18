//
//  ImageCell.swift
//  SimpleList
//
//  Created by Kesava Jawaharlal on 18/05/2020.
//  Copyright © 2020 Small Screen Science Ltd. All rights reserved.
//

import Cocoa
import AVKit

class ImageCell: NSTableCellView {
    @IBOutlet weak var playerView: AVPlayerView!
    @IBOutlet weak var iconImage: NSImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        playerView.player = nil
        iconImage.image = nil
    }
}
