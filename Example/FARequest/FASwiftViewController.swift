//
//  FASwiftViewController.swift
//  FARequest_Example
//
//  Created by Fadi Abuzant on 3/13/18.
//  Copyright © 2018 fadizant. All rights reserved.
//

import UIKit
import FARequest
import AVFoundation
import AVKit
import MobileCoreServices // needed for video types
import AssetsLibrary

class FASwiftViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    // MARK: - UI
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Value
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.text = ""
        
        // Default configuration
        FARequest.setDefaultConfiguration(FARequestConfiguration(requestType: .GET,
                                                                 header: nil,
                                                                 object: nil,
                                                                 useCashe: false,
                                                                 encoding: false,
                                                                 timeOut: 120))
        
        // semple request
        FARequest.send(with: FARequestObject.init(url: URL.init(string: "https://jsonplaceholder.typicode.com/posts/1"))) { (response) in
            if response?.responseCode == FAResponseStatusOK {
                self.textView.text.append((response?.jsonResult as AnyObject).description)
                print((response?.jsonResult as AnyObject).description)
            }
        }
        
        //Status handler
        FARequest.setStatusHandler([FAResponseStatusOK:"successful"])
        NotificationCenter.default.addObserver(self, selector: #selector(successful(_:)), name: NSNotification.Name(rawValue: FARequest.notificationName(fromKey: FAResponseStatusOK as NSNumber)), object: nil)
        
        let requestObject1 = FARequestObject.init(url: URL.init(string: "https://jsonplaceholder.typicode.com/posts/1"))
        requestObject1?.configuration.object = 1
        
        let requestObject2 = FARequestObject.init(url: URL.init(string: "https://jsonplaceholder.typicode.com/posts/1"))
        requestObject2?.configuration.object = 2
        
        let requestObject3 = FARequestObject.init(url: URL.init(string: "https://jsonplaceholder.typicode.com/posts/1"))
        requestObject3?.configuration.object = 3
        
        
        let queue = FAQueueRequest.init(queue: NSMutableArray(array: [requestObject1 ?? FARequestObject(),
                                                                      requestObject2 ?? FARequestObject(),
                                                                      requestObject3 ?? FARequestObject()]));
        
        queue?.send(requestCompleted: { (request,response) in
            self.textView.text.append("\nQueue number = \(request?.configuration.object ?? 0)" )
            self.textView.text.append((response?.jsonResult as AnyObject).description)
        }, completed: { (finish) in
            self.textView.text.append("\nFinished \(finish)")
            FARequest.setStatusHandler(NSMutableDictionary())
        },stopped: {
            print("Stopped")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: FARequest.notificationName(fromKey: FAResponseStatusOK as NSNumber)), object: nil)
    }

    @objc func successful(_ notification:NSNotification){
    
        if notification.name == NSNotification.Name(rawValue: FARequest.notificationName(fromKey: FAResponseStatusOK as NSNumber)) {
            if let userInfo = notification.userInfo as NSDictionary? {
                let request = userInfo.object(forKey: FARequestNotificationRequest) as? FARequestObject
                let response = userInfo.object(forKey: FARequestNotificationResponse) as? FAResponse
                let requestCompleted = userInfo.object(forKey: FARequestNotificationRequestCompleted) as? requestCompleted
                print("From Notifications Request number = \(request?.configuration.object ?? 0) and code = \(response?.responseCode ?? 0)" )
                
                if let code = request?.configuration.object as? Int , code == 2 {
                    request?.configuration.object = 200
                    FARequest.send(with: request, requestCompleted: { (newRequest) in
                        if let sendComplete = requestCompleted{
                            sendComplete(newRequest)
                        }
                    })
                }
            }
        }
    }
    
    // MAKR:- Buttons
    @IBAction func uploadImage(_ sender: UIButton) {
        let pickerView = UIImagePickerController.init()
        pickerView.allowsEditing = false
        pickerView.delegate = self
        pickerView.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(pickerView, animated: true, completion: nil)
    }
    
    @IBAction func uploadVideo(_ sender: UIButton) {
        let pickerView = UIImagePickerController.init()
        pickerView.allowsEditing = false
        pickerView.delegate = self
        pickerView.modalPresentationStyle = UIModalPresentationStyle.currentContext;
        pickerView.mediaTypes = [kUTTypeMovie as String, kUTTypeAVIMovie as String, kUTTypeVideo as String, kUTTypeMPEG4 as String];
        self.present(pickerView, animated: true, completion: nil)
    }
    
    @IBAction func downloadVideo(_ sender: UIButton) {
        self.textView.text = ""
        self.progressView.progress = 0
        self.loadingIndicatorView.startAnimating()
        
        FARequest.getWith(FARequestObject.init(url: URL.init(string: "http://mirrors.standaloneinstaller.com/video-sample/jellyfish-25-mbps-hd-hevc.mp4"),
                                               saveInFolder: "Download",
                                               saveWithName: "video",
                                               saveWithExtension: "mp4",
                                               overWrite: true),
                          requestProgress: { (progress) in
                            self.progressView.progress = progress
        }) { (respons) in
            self.loadingIndicatorView.stopAnimating()
            if let response = respons, response.responseCode == FAResponseStatusOK && response.error == nil {
                self.textView.text = (response.jsonResult as AnyObject).description
                let videoURL = URL.init(fileURLWithPath: (response.jsonResult as AnyObject).description)
                //filePath may be from the Bundle or from the Saved file Directory, it is just the path for the video
                let player = AVPlayer.init(url: videoURL)
                let playerViewController = AVPlayerViewController.init()
                playerViewController.player = player;
                //[playerViewController.player play];//Used to Play On start
                self.present(playerViewController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK:- PickerDelegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if (info[UIImagePickerControllerOriginalImage] != nil) {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.sendWithImage(image)
            }
        }else{
            // This is the NSURL of the video object
            if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
                self.sendWithVideo(videoURL)
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func sendWithImage(_ image:UIImage) {
        self.textView.text = ""
        self.progressView.progress = 0
        self.loadingIndicatorView.startAnimating()
        
        let request = FARequestObject.init(url: URL.init(string: "http://168.144.38.45:8097/NewController/addMedia"))
        request?.configuration.requestType = .POST
        request?.mediaFiles = [FARequestMediaFile.init(name: "multifiles", image: image)]
        FARequest.send(with: request, requestProgress: { (progress) in
            print("progress = \(progress)")
            self.progressView.progress = progress
        }) { (response) in
            self.loadingIndicatorView.stopAnimating()
            if response?.responseCode == FAResponseStatusOK {
                self.textView.text = (response?.jsonResult as AnyObject).description
            }
        }
    }
    
    func sendWithVideo(_ url:URL)  {
        self.textView.text = ""
        self.progressView.progress = 0
        self.loadingIndicatorView.startAnimating()
        
        let request = FARequestObject.init(url: URL.init(string: "http://168.144.38.45:8097/NewController/addMedia"))
        request?.configuration.requestType = .POST
        request?.mediaFiles = [FARequestMediaFile.init(name: "multifiles", filePath: url.absoluteString)]
        FARequest.send(with: request, requestProgress: { (progress) in
            self.progressView.progress = progress
        }) { (response) in
            self.loadingIndicatorView.stopAnimating()
            if response?.responseCode == FAResponseStatusOK {
                self.textView.text = (response?.jsonResult as AnyObject).description
            }
        }
    }
}








