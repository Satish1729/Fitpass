//
//  StaffAddViewController.swift
//  Fitpass
//
//  Created by Satish Regeti on 25/07/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit
import DropDown
import AssetsPickerViewController
import Photos
import AWSS3
import AWSCore

//https://medium.com/theappspace/alamofire-4-multipart-file-upload-with-swift-3-174df1ef84c1
class StaffAddViewController: BaseViewController {

    lazy var imageManager = {
        return PHCachingImageManager()
    }()

    var selectedImageUrl: URL!
    var documentUrl : String?
    @IBOutlet weak var addScrollView: UIScrollView!

    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var roleButton: UIButton!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var contactNumberTxtField: UITextField!
    @IBOutlet weak var dobTxtField: UITextField!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var addressTxtField: UITextField!
    @IBOutlet weak var joiningDateTxtField: UITextField!
    @IBOutlet weak var salaryTxtField: UITextField!
    @IBOutlet weak var salaryDateButton: UIButton!
    @IBOutlet weak var uploadDocumentButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contactNumberLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var joiningDateLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var salaryDateLabel: UILabel!
    @IBOutlet weak var uploadDocument: UILabel!
    
    var delegate : staffDelegate?
    
    var rolesArray : NSMutableArray = NSMutableArray()
    var roleIdsDict : NSMutableDictionary = NSMutableDictionary()
    
    let dropDown = DropDown()

    @IBAction func roleButtonSelected(_ sender: Any) {
        
        if(rolesArray.count > 0) {
            dropDown.anchorView = self.roleButton
            dropDown.bottomOffset = CGPoint(x:0, y:self.roleButton.frame.size.height)
            dropDown.width = self.roleButton.frame.size.width
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.roleButton.setTitle(item, for: UIControlState.normal)
            }
            dropDown.dataSource = self.rolesArray as! [String]
            dropDown.show()
        }else{
            getRolesList()
        }
    }
    @IBAction func genderButtonSelected(_ sender: Any) {
        dropDown.anchorView = self.genderButton
        dropDown.topOffset = CGPoint(x:0, y:-self.genderButton.frame.size.height)
        dropDown.width = self.genderButton.frame.size.width
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.genderButton.setTitle(item, for: UIControlState.normal)
        }
        dropDown.dataSource = ["Male", "Female"]
        dropDown.show()
    }
    @IBAction func salaryDateButtonSelected(_ sender: Any) {
        dropDown.anchorView = self.salaryDateButton
        dropDown.topOffset = CGPoint(x:0, y:-self.salaryDateButton.frame.size.height)
        dropDown.width = self.salaryDateButton.frame.size.width
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.salaryDateButton.setTitle(item, for: UIControlState.normal)
        }
        dropDown.dataSource = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25", "26","27","28"]
        dropDown.show()
    }
    @IBAction func uploadDoc(_ sender: Any) {
        let picker = AssetsPickerViewController()
        picker.pickerDelegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func startUploadingImage()
    {
        
//        AWS_KEY=AKIAINK4WHZLQOYURRPA
//        AWS_SECRET=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
//        AWS_REGION=ap-south-1
//        AWS_BUCKET=fitpass-crm

//        let accessKey = "AKIAJFOQTSGVOWTYTHTQ"
//        let secretKey = "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"
        
        let accessKey = "AKIAINK4WHZLQOYURRPA"
        let secretKey = "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"

        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
        let configuration = AWSServiceConfiguration(region: AWSRegionType.APSouth1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration

        
//        let url = self.selectedImageUrl
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let remoteName = formatter.string(from: currentDateTime)+".jpeg"
        let S3BucketName = "fitpass-crm" //"fitpass-studio"
        let uploadRequest = AWSS3TransferManagerUploadRequest()!
        uploadRequest.body = self.selectedImageUrl
        uploadRequest.key = remoteName
        uploadRequest.bucket = S3BucketName
        uploadRequest.contentType = "image/jpeg"
        uploadRequest.acl = .publicRead

        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(uploadRequest).continueWith { (task: AWSTask) -> Any? in
            if let error = task.error {
                print("Upload failed with error: (\(error.localizedDescription))")
                self.performSelector(onMainThread:  #selector(self.addNewStaffDetails), with: nil, waitUntilDone: true)
            }
            if task.result != nil {
//                let url = AWSS3.default().configuration.endpoint.url
//                let publicURL = url//.appendingPathComponent(uploadRequest.bucket!).appendingPathComponent(uploadRequest.key!)
                self.documentUrl = ""
                self.documentUrl = remoteName//publicURL?.absoluteString
                self.performSelector(onMainThread:  #selector(self.addNewStaffDetails), with: nil, waitUntilDone: true)
//                print("Uploaded to:\(String(describing: publicURL))")
            }
            return nil
        }
    }
    
//    func generateImageUrl(fileName: String) -> NSURL
//    {
//        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory().stringByAppendingString(fileName))
//        let data = UIImageJPEGRepresentation(myImageView.image!, 0.6)
//        data!.writeToURL(fileURL, atomically: true)
//
//        return fileURL
//    }
//
//    func remoteImageWithUrl(fileName: String)
//    {
//        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory().stringByAppendingString(fileName))
//        do {
//            try NSFileManager.defaultManager().removeItemAtURL(fileURL)
//        } catch
//        {
//            print(error)
//        }
//    }
    override func viewDidLoad() {

        super.viewDidLoad()

        setNavigationUI()
        setButtonsCornerRadius()
        dropDown.direction = .any

        self.nameLabel.attributedText = self.setRedColorForStar(str: "Name")
        self.roleLabel.attributedText = self.setRedColorForStar(str: "Role")
        self.emailLabel.attributedText = self.setRedColorForStar(str: "Email")
        self.contactNumberLabel.attributedText = self.setRedColorForStar(str: "Contact No.")
        self.dobLabel.attributedText = self.setRedColorForStar(str: "Date of birth")
        self.genderLabel.attributedText = self.setRedColorForStar(str: "Gender")
        self.addressLabel.attributedText = self.setRedColorForStar(str: "Address")
        self.joiningDateLabel.attributedText = self.setRedColorForStar(str: "Joining Date")
        self.salaryLabel.attributedText = self.setRedColorForStar(str: "Salary")
        self.salaryDateLabel.attributedText = self.setRedColorForStar(str: "Salary Date")
        self.uploadDocument.attributedText = self.setRedColorForStar(str: "Upload Documents")

        self.nameTxtField.keyboardType = .namePhonePad
        self.emailTxtField.keyboardType = .emailAddress
        self.contactNumberTxtField.keyboardType = .numberPad

        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        self.dobTxtField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerDOBChanged(sender:)), for: .valueChanged)

        self.addressTxtField.keyboardType = .namePhonePad

        let datePicker1 = UIDatePicker()
        datePicker1.datePickerMode = .date
        datePicker1.maximumDate = Date()
        self.joiningDateTxtField.inputView = datePicker1
        datePicker1.addTarget(self, action: #selector(datePickerJoiningDateChanged(sender:)), for: .valueChanged)

        salaryTxtField.keyboardType = .numberPad
    }
    
    func setNavigationUI(){
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "img_back"), for: .normal)
        backBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        backBtn.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = item1
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(addNewStaff))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    static func timestampedFilePath() -> URL {
        
        let currentDateTime = Date()
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        
        let filename = formatter.string(from: currentDateTime)+".jpeg"
        
        let pathToWrite: String = NSTemporaryDirectory() + (filename)
        
        let localpath = NSURL.fileURL(withPath: pathToWrite)
        
        print("image File Path : - \(localpath)")
        
        return localpath
    }

    func setButtonsCornerRadius(){
        self.roleButton.layer.borderColor = UIColor.lightGray.cgColor
        self.roleButton.layer.borderWidth = 1
        self.roleButton.layer.cornerRadius = 5
        
        self.genderButton.layer.borderColor = UIColor.lightGray.cgColor
        self.genderButton.layer.borderWidth = 1
        self.genderButton.layer.cornerRadius = 5
        
        self.salaryDateButton.layer.borderColor = UIColor.lightGray.cgColor
        self.salaryDateButton.layer.borderWidth = 1
        self.salaryDateButton.layer.cornerRadius = 5
        
        self.uploadDocumentButton.layer.borderColor = UIColor.lightGray.cgColor
        self.uploadDocumentButton.layer.borderWidth = 1
        self.uploadDocumentButton.layer.cornerRadius = 5
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Add Staff"
    }

    override func viewDidLayoutSubviews()
    {
        self.addScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1120)
    }

    func dismissViewController() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func datePickerDOBChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.dobTxtField.text = formatter.string(from: sender.date)
    }
    
    func datePickerJoiningDateChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.joiningDateTxtField.text = formatter.string(from: sender.date)
    }
    
    //MARK: Validations
    func isValidStaff() -> Bool {
        
        var isValidUser = false
        
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
        }

        if(nameTxtField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please enter name", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
        if(roleButton.titleLabel?.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please select role", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
        if(emailTxtField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please enter email", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }else{
            if(Utility().isValidEmail(testStr: emailTxtField.text!)){
                
            }else{
                AlertView.showCustomAlertWithMessage(message: "Please enter valid email", yPos: 20, duration: NSInteger(2.0))
                return isValidUser
            }
        }
        

        if(contactNumberTxtField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please enter contact number.", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }else{
            if(Utility().isValidPhone(value: contactNumberTxtField.text!)){
                
            }else{
                AlertView.showCustomAlertWithMessage(message: "Please enter valid contact number", yPos: 20, duration: NSInteger(2.0))
                return isValidUser
            }
        }
        
        if(dobTxtField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please enter date of birth", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
        if(genderButton.titleLabel!.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please select gender", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
        if(addressTxtField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please enter address", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
        if(joiningDateTxtField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please enter joining date", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
        if(salaryTxtField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please enter salary", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
        if(salaryDateButton.titleLabel!.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please select salary date", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
        isValidUser = true
        return isValidUser
    }
    
    func addNewStaff(){
        if !isValidStaff() {
            return
        }
        ProgressHUD.showProgress(targetView: self.view)
        if(selectedImageUrl != nil){
            startUploadingImage()
        }else{
            addNewStaffDetails()
        }
    }
    func addNewStaffDetails() {
        let staffBean : Staffs = Staffs()
        
        staffBean.name = nameTxtField.text!
        staffBean.role = roleButton.titleLabel!.text!
        staffBean.email = emailTxtField.text!
        let myInteger = contactNumberTxtField.text!
        staffBean.contact_number = NSNumber(value : Int(myInteger)!)
        staffBean.dob = dobTxtField.text!
        staffBean.gender = genderButton.titleLabel?.text!
        staffBean.address = addressTxtField.text!
        staffBean.joining_date = joiningDateTxtField.text!
        staffBean.salary = salaryTxtField.text!
        //NSNumber(value: Int((salaryTxtField.text!))!)
        staffBean.salary_date = NSNumber(value: Int((salaryDateButton.titleLabel?.text)!)!)
        if let joiningDoc = self.documentUrl{
            staffBean.joining_documents = joiningDoc
        }
        ProgressHUD.hideProgress()
        self.dismissViewController()
        self.delegate?.addNewStaffToList(staffBean: staffBean)
    }
    
    func getRolesList() {
        
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
        ProgressHUD.showProgress(targetView: self.view)
        
        NetworkManager.sharedInstance.getResponseForURLWithParameters(url: ServerConstants.URL_GET_STAFF_ROLES , userInfo: nil, type: "GET") { (data, response, error) in
            ProgressHUD.hideProgress()
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDic:NSDictionary? = jsonObject as? NSDictionary
                if (responseDic != nil) {
                    print(responseDic!)
                    if(responseDic?.object(forKey: "status") as! String  == "401"){
                        AlertView.showCustomAlertWithMessage(message: responseDic?.object(forKey: "message") as! String, yPos: 20, duration: 5)
                        self.moveToLoginScreen()
                    }
                    else if(responseDic?.object(forKey: "status") as! String  == "200"){
                        let resultDict: NSDictionary = responseDic!.object(forKey: "result") as! NSDictionary
                        let dataArray : NSArray = resultDict.object(forKey: "studioStaffRoles") as! NSArray
                        for roleObj in (dataArray as? [[String:Any]])! {
                            self.rolesArray.add(roleObj["name"] ?? "")
                            self.roleIdsDict.setObject(roleObj["id"]!, forKey: roleObj["name"]! as! NSCopying)
                        }
                        self.dropDown.anchorView = self.roleButton
                        self.dropDown.bottomOffset = CGPoint(x:0, y:self.roleButton.frame.size.height)
                        self.dropDown.width = self.roleButton.frame.size.width
                        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                            self.roleButton.setTitle(item, for: UIControlState.normal)
                        }
                        self.dropDown.dataSource = self.rolesArray as! [String]
                        self.dropDown.show()
                    }else{
                        AlertView.showCustomAlertWithMessage(message: responseDic?.object(forKey: "message") as! String, yPos: 20, duration: 5)
                    }
                }
                else{
                    AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                    print("Get Roles failed : \(String(describing: error?.localizedDescription))")
                }
            }
        }
    }

    func writeResource(toTmp resource: PHAssetResource, pathCallback: @escaping (_ localUrl: URL) -> Void) {
        // Get Asset Resource. Take first resource object. since it's only the one image.
        let filename: String = resource.originalFilename
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyyHHmmss"
        let pathToWrite: String = NSTemporaryDirectory() + formatter.string(from: Date())+(filename)
        let localpath = NSURL.fileURL(withPath: pathToWrite)
        let options = PHAssetResourceRequestOptions()
        options.isNetworkAccessAllowed = true
        PHAssetResourceManager.default().writeData(for: resource, toFile: localpath, options: options, completionHandler: {(_ error: Error?) -> Void in
            if error != nil {
                print("Failed to write a resource: \(String(describing: error?.localizedDescription))")
            }
            pathCallback(localpath)
        })
    }

}



// to handle
extension StaffAddViewController: AssetsPickerViewControllerDelegate {
    
    func assetsPickerCannotAccessPhotoLibrary(controller: AssetsPickerViewController) {}
    func assetsPickerDidCancel(controller: AssetsPickerViewController) {}
    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {
        imageManager.requestImage(for: assets.first!, targetSize: CGSize(width: self.uploadDocumentButton.frame.size.width, height: self.uploadDocumentButton.frame.size.height), contentMode: .aspectFit, options: nil) { (image, info) in
//            if let pathData = info {
//                if let imagePath = pathData["PHImageFileURLKey"] {
//                    self.selectedImageUrl = imagePath as? NSURL
//                }
//            }
            let resource = PHAssetResource.assetResources(for: assets.first!).first
            
            self.writeResource(toTmp: resource!, pathCallback: { (outputURL) in
                self.selectedImageUrl = outputURL
                }
            )

            self.uploadDocumentButton.contentMode = .scaleAspectFit
            self.uploadDocumentButton.setImage(nil, for: .normal)
            self.uploadDocumentButton.setBackgroundImage(image, for: UIControlState.normal)
        }
    }
    func assetsPicker(controller: AssetsPickerViewController, didSelect asset: PHAsset, at indexPath: IndexPath) {
    }
    func assetsPicker(controller: AssetsPickerViewController, shouldDeselect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        return true
    }
    func assetsPicker(controller: AssetsPickerViewController, didDeselect asset: PHAsset, at indexPath: IndexPath) {}
    
    func assetsPicker(controller: AssetsPickerViewController, shouldSelect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        if controller.selectedAssets.count > 0 {
            // do your job here
            return false
        }
        return true
    }
}
