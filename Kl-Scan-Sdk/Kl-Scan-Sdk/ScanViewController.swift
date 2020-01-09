//
//  ScanViewController.swift
//  Kl-Scan-Sdk
//
//  Created by Aditya Chauhan on 27/11/19.
//  Copyright © 2019 Khosla Labs. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

public protocol ScanViewDelegate: class{
    
}

open class ScanViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private var captureSession : AVCaptureSession!
    private var videoPreviewLayer : AVCaptureVideoPreviewLayer!
    
    open weak var delegate: ScanViewDelegate?
    
    public init(withDelegate delegate: ScanViewDelegate){
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("ScanView: init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        captureSession = AVCaptureSession()
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        setupCapture(withAuthorizationStatus: authorizationStatus)
    }
    
    fileprivate func setupCapture(withAuthorizationStatus status: AVAuthorizationStatus){
        switch status{
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) {  granted in
                self.setupCapture(withAuthorizationStatus: granted ? .authorized : .denied)
            }
        case .restricted, .denied:
            let okAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            showAlertController(title: "Can not access camera", message: "Please go to settings ad enable camera access permission", actions: [okAlertAction])
        case .authorized:
            DispatchQueue.main.async {
                self.addCaptureDeviceInput()
            }
        @unknown default:
            fatalError()
        }
    }
    
    deinit {
        for input in captureSession.inputs{
            captureSession.removeInput(input)
        }
        for output in captureSession.outputs{
            captureSession.removeOutput(output)
        }
        captureSession = nil
        videoPreviewLayer = nil
    }
    
    fileprivate func addCaptureDeviceInput(){
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back)
        if let captureDevice = deviceDiscoverySession.devices.first{
            do{
                let captureInput = try AVCaptureDeviceInput(device: captureDevice)
                captureSession.beginConfiguration()
                guard captureSession.canAddInput(captureInput) else{
                    return
                }
                captureSession.addInput(captureInput)
                let captureOutput = AVCaptureVideoDataOutput()
                captureOutput.alwaysDiscardsLateVideoFrames = true
                let dispatchQueue = DispatchQueue(label: "com.adiPersonal.ScanSdkCameraSessionQueue", attributes: [])
                captureOutput.setSampleBufferDelegate(self, queue: dispatchQueue)
                guard self.captureSession.canAddOutput(captureOutput) else {
                    return
                }
                captureSession.addOutput(captureOutput)
                captureSession.sessionPreset = .photo
                captureSession.commitConfiguration()
                captureSession.startRunning()
                
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                videoPreviewLayer.videoGravity = .resizeAspectFill
                videoPreviewLayer.frame = self.view.layer.bounds
                view.layer.addSublayer(self.videoPreviewLayer)
            }catch{
                print("Can not get capture device inut")
            }
        }
        else{
            print("cannot get capture device")
            let okAlertAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            showAlertController(title: "Warning", message: "Canot get capture device", actions: [okAlertAction])
        }
    }
}

//extension ScanViewController: AVCaptureVideoDataOutputSampleBufferDelegate{
//}

extension ScanViewController: AlertControllerProtocol{ }
