//
//  DetailViewController.swift
//  Sketchpad
//
//  Created by Yash Bhojgarhia on 18/07/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var picture: Picture?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = picture?.name
        if let imageData = picture?.image {
            imageView.image = UIImage(data: imageData)
        }
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        if let image = imageView.image {
        let shareVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(shareVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let picToBeDeleted = picture {
                context.delete(picToBeDeleted)
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                navigationController?.popViewController(animated: true)
            }
        }
    }
}
