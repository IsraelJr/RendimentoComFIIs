//
//  AttachViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 02/10/22.
//

import UIKit

protocol AttachViewControllerDelegate: AnyObject {
    func close(image: UIImage?)
}


class AttachViewController: UIViewController {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnAttach: UIButton!
    
    var imagePicker: ImagePicker!
    var delegate: AttachViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showImagePicker(UIButton())
    }
    
    private func setupLayout() {
        viewHeader.delegate = self
        viewHeader.setTitleHeader(name: NSLocalizedString("title_document", comment: ""))
        viewHeader.btnReturn.isHidden = true
        
        imageView.layer.cornerRadius = 16
        
        btnSearch.setTitle(NSLocalizedString("search", comment: ""), for: .normal)
        
        btnAttach.isEnabled = false
        btnAttach.setTitle(NSLocalizedString("attach", comment: ""), for: .normal)
    }
    
    @IBAction func showImagePicker(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.delegate?.close(image: imageView.image)
        self.dismiss(animated: true)
    }
    
}

extension AttachViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let img = image else { return }
        DispatchQueue.main.async {
            self.imageView.image = img
            self.btnAttach.isEnabled = true
        }
    }
    
}


extension AttachViewController: NavigationBarHeaderDelegate {
    func didTapButtonBack(_ sender: UIButton) {
        dismissWith()
    }
}
