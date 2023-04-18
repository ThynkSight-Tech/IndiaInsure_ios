//
//  UploadPrescriptionMD_VC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 14/10/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class UploadPrescriptionMD_VC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    

    @IBOutlet weak var imgCollectionView: UICollectionView!
    @IBOutlet weak var topImgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var btnDeliveryAdd: UIButton!
    
    @IBOutlet weak var viewImgView: UIView!
    @IBOutlet weak var imgPreview: UIImageView!
    var memberInfoObj : FamilyDetailsModel?
    var imagesArray = [UIImage]()
    var mediaURLArray = [URL]()
    

    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        
        super.viewDidLoad()
        self.viewImgView.isHidden = true

        self.title = "Upload Prescription"
        print("In \(self.title ?? "") UploadPrescriptionMD_VC")
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        btnDeliveryAdd.backgroundColor = UIColor(hexFromString: "#959494")
        btnDeliveryAdd.isEnabled = false

        btnChange.backgroundColor = Color.buttonBackgroundGreen.value

        btnChange.layer.cornerRadius = btnChange.frame.height / 2
        self.lblName.text = memberInfoObj?.PersonName
        
        self.btnDeliveryAdd.makeCicular()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewImageTapped(_:)))
        viewImgView.isUserInteractionEnabled = true
        viewImgView.addGestureRecognizer(tap)

}
    
   @objc private func viewImageTapped(_ sender : UITapGestureRecognizer) {
        self.viewImgView.isHidden = true
    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeMemberDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    @IBAction func cameraTapped(_ sender: Any) {
        openCamera()
    }
    
    @IBAction func gallaryTapped(_ sender: Any) {
        self.openGallary()
    }
    @IBAction func selectDeliveryAddressTapped(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "MedicineDelivery", bundle: nil).instantiateViewController(withIdentifier: "SelectAddressMD_VC") as! SelectAddressMD_VC
        vc.memberInfoObj = memberInfoObj
        vc.imageArray = imagesArray
        navigationController?.pushViewController(vc, animated: true)

    }
    
    func openGallary()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        //imagePicker.allowsEditing = true
        
        
        imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    

    
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//
//
//        if #available(iOS 11.0, *) {
//            if let imgUrl = info[UIImagePickerControllerImageURL] as? URL{
//                let imgName = imgUrl.lastPathComponent
//                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
//                let localPath = documentDirectory?.appending(imgName)
//
//                let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//                let data = UIImagePNGRepresentation(image)! as NSData
//                data.write(toFile: localPath!, atomically: true)
//                //let imageData = NSData(contentsOfFile: localPath!)!
//                let photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
//                print(photoURL)
//
//                if mediaURLArray.contains(photoURL) == false {
//                self.mediaURLArray.append(photoURL)
//                self.imagesArray.append(image)
//                }
//            }
//
//
//
//        } else {
//            // Fallback on earlier versions
//        }
//
//        picker.dismiss(animated: true, completion: nil)
//
//
//
//        self.imgCollectionView.reloadData()
//    }
    /*
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //
        //        var fileURL: URL!
        //
        //        if #available(iOS 11.0, *) {
        //            fileURL = info[UIImagePickerControllerImageURL] as? URL
        //        } else
        //        {
        //            // Fallback on earlier versions
        //        }
        
        if #available(iOS 11.0, *) {
            if let imgUrl = info[UIImagePickerControllerImageURL] as? URL{
                let imgName = imgUrl.lastPathComponent
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                let localPath = documentDirectory?.appending(imgName)
                
                let image = info[UIImagePickerControllerOriginalImage] as! UIImage
                let data = UIImagePNGRepresentation(image)! as NSData
                data.write(toFile: localPath!, atomically: true)
                //let imageData = NSData(contentsOfFile: localPath!)!
                let photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
                print(photoURL)
                self.mediaURLArray.append(photoURL)
                self.imagesArray.append(image)
            }
        } else {
            // Fallback on earlier versions
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        
        //let url = info[UIImagePickerControllerMediaURL] as! URL
        //        if mediaURLArray.contains(fileURL) == false {
        //            self.imagesArray.append(image)
        //            self.mediaURLArray.append(fileURL)
        //        }
        self.imgCollectionView.reloadData()
    }
    */
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        var fileURL: URL!

        if #available(iOS 11.0, *) {
            fileURL = info[UIImagePickerControllerImageURL] as? URL
            
        } else
        {
            // Fallback on earlier versions
        }
        //let url = info[UIImagePickerControllerMediaURL] as! URL
        //if mediaURLArray.contains(fileURL) == false {
            self.imagesArray.append(image)
            //self.mediaURLArray.append(fileURL)
       // }
        self.imgCollectionView.reloadData()
        if imagesArray.count > 0 {
            btnDeliveryAdd.backgroundColor = Color.buttonBackgroundGreen.value
            btnDeliveryAdd.isEnabled = true
        }
        
    }
 
    

    //MARK:- UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellForUploadPrescription", for: indexPath)  as! CollectionViewCellForUploadPrescription
        cell.imgView.image = imagesArray[indexPath.row]
        cell.btnClose.tag = indexPath.row
        cell.btnClose.addTarget(self, action: #selector(deleteImageTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let img = imagesArray[indexPath.row]
        self.imgPreview.image = img
        self.viewImgView.isHidden = false
    }
    
    
    
    
    @objc private func deleteImageTapped(_ sender: UIButton){
        self.imagesArray.remove(at: sender.tag)
        self.imgCollectionView.reloadData()
        
        if imagesArray.count == 0 {
            btnDeliveryAdd.backgroundColor = UIColor(hexFromString: "#959494")
            btnDeliveryAdd.isEnabled = false
        }
    }
}


class CollectionViewCellForUploadPrescription: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    
}
