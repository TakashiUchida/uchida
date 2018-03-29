//
//  ItemTableViewCell.swift
//  MyOkashi
//
//  Created by User5 on 2018/03/15.
//  Copyright © 2018年 User5. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemMakerLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    
    var itemUrl: String?
    var imageUrl: String?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        //元々入っている情報を再利用時にクリア
        itemImageView.image = nil
    }
    
}
