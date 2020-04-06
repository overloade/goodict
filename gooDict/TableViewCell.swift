//  *************
//  TableViewCell is used for configuring cell in TableViewController
//  *************

import UIKit
import Foundation

class TableViewCell: UITableViewCell {
  
    @IBOutlet weak var wordDict: UILabel!
    @IBOutlet weak var translationDict: UILabel!
    @IBOutlet weak var exampleDict: UILabel!
    
    // Default methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
