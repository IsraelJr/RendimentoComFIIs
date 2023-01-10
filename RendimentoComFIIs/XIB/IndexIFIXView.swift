//
//  IndexIFIXViewController.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 07/04/22.
//

import UIKit

class IndexIFIXView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var viewData: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet var collectionLabel: [UILabel]!
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("IndexIFIXView", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        setup()
    }
    
    private func setup() {
        contentView.backgroundColor = .clear
        viewData.backgroundColor = .systemBackground
        viewData.layer.cornerRadius = 16
        
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        icon.layer.cornerRadius = 16
        
        collectionLabel.forEach({
            $0.font = UIFont.boldSystemFont(ofSize: 16)
            $0.numberOfLines = 1
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.1
            $0.text = ""
        })
        
        collectionLabel[0].font = UIFont.boldSystemFont(ofSize: 24)
        collectionLabel[5].font = UIFont.boldSystemFont(ofSize: 12)
        collectionLabel[5].textColor = .lightGray
        collectionLabel[5].textAlignment = .center
        
        loadingDataIFIX()
    }
    
    func loadingDataIFIX(msg: String = NSLocalizedString("load", comment: "")) {
        collectionLabel[6].text = msg
        collectionLabel[6].numberOfLines = 4
        collectionLabel[6].adjustsFontSizeToFitWidth = true
        collectionLabel[6].minimumScaleFactor = 0.1
        collectionLabel[6].textAlignment = .center
    }
    
    func setData(ifix: InitializationModel.FetchIFIX.IFIX) {
        collectionLabel[6].isHidden = true
        
        collectionLabel[0].text = "IFIX"
        collectionLabel[1].text = ifix.points!
        collectionLabel[2].text = ifix.percent ?? "0.0% Variação (dia)"
        collectionLabel[3].text = ifix.minimum!.uppercased()
        collectionLabel[4].text = ifix.maximum!.uppercased()
        collectionLabel[5].text = ifix.dateUpdate!
            .replacingOccurrences(of: "error_outline", with: "")
            .replacingOccurrences(of: "Atualizado", with: NSLocalizedString("updated", comment: ""))
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        collectionLabel[2].textColor =  UIColor.variationColor(to: ifix.percent ?? "0.0")
        icon.backgroundColor = collectionLabel[2].textColor
        
        if collectionLabel[2].textColor == .systemRed {
            icon.image = UIImage(systemName: "arrow.down")
        } else if collectionLabel[2].textColor == .systemGreen {
            icon.image = UIImage(systemName: "arrow.up")
        } else {
            icon.image = UIImage(systemName: "arrow.up.and.down")
        }
        
    }
}

