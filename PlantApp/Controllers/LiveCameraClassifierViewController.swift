////
////  LiveCameraClassifierViewController.swift
////  PlantApp
////
////  Created by SDC-USER on 12/12/25.
////
//// not implemented rn
//
//import UIKit
//import AVFoundation
//import Vision
//import CoreML
//
//final class LiveCameraClassifierViewController: UIViewController {
//
//    // MARK: - UI
//    private let previewView = UIView()
//    private let overlayLabel: UILabel = {
//        let l = UILabel()
//        l.backgroundColor = UIColor(white: 0, alpha: 0.45)
//        l.textColor = .white
//        l.font = .systemFont(ofSize: 16, weight: .semibold)
//        l.textAlignment = .center
//        l.layer.cornerRadius = 10
//        l.clipsToBounds = true
//        l.translatesAutoresizingMaskIntoConstraints = false
//        l.isHidden = true
//        return l
//    }()
//
//    // MARK: - AV / Vision
//    private let captureSession = AVCaptureSession()
//    private var previewLayer: AVCaptureVideoPreviewLayer!
//    private let videoOutput = AVCaptureVideoDataOutput()
//
//    // Vision model/request
//    private var vnModel: VNCoreMLModel!
//    private var vnRequest: VNCoreMLRequest!
//
//    // Throttling + smoothing
//    private let processingQueue = DispatchQueue(label: "live.camera.processing", qos: .userInitiated)
//    private var lastProcessTime: CFTimeInterval = 0
//    private let minFrameInterval: CFTimeInterval = 0.25 // 4 fps -> adjust
//    private var smoothingWindow: [String] = []
//    private let smoothingWindowSize = 5
//
//    // Whether to run
//    private var running = false
//
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .black
//        setupPreviewUI()
//        configureModel()
//        checkCameraAuthorizationAndStart()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        stopSession()
//    }
//
//    // MARK: - Setup UI
//    private func setupPreviewUI() {
//        previewView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(previewView)
//        NSLayoutConstraint.activate([
//            previewView.topAnchor.constraint(equalTo: view.topAnchor),
//            previewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            previewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            previewView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//
//        view.addSubview(overlayLabel)
//        NSLayoutConstraint.activate([
//            overlayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            overlayLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
//            overlayLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 340),
//            overlayLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 36)
//        ])
//    }
//
//    // MARK: - Model
//    private func configureModel() {
//        do {
//            // <-- REPLACE YourModel() with your actual generated model class name
//            let mlModel = try MyImageClassifier_2().model
//            vnModel = try VNCoreMLModel(for: mlModel)
//            vnRequest = VNCoreMLRequest(model: vnModel, completionHandler: visionRequestHandler)
//            vnRequest.imageCropAndScaleOption = .centerCrop
//        } catch {
//            print("Failed to load ML model:", error)
//        }
//    }
//
//    // MARK: - Camera
//    private func checkCameraAuthorizationAndStart() {
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .authorized:
//            startSession()
//        case .notDetermined:
//            AVCaptureDevice.requestAccess(for: .video) { granted in
//                DispatchQueue.main.async {
//                    if granted { self.startSession() } else { self.showCameraAccessDenied() }
//                }
//            }
//        default:
//            showCameraAccessDenied()
//        }
//    }
//
//    private func showCameraAccessDenied() {
//        let ac = UIAlertController(title: "Camera access required",
//                                   message: "Enable camera access in Settings to use live plant detection.",
//                                   preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
//            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
//            UIApplication.shared.open(url)
//        })
//        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        present(ac, animated: true)
//    }
//
//    private func startSession() {
//        guard !running else { return }
//        running = true
//
//        processingQueue.async {
//            self.setupCaptureSession()
//            self.captureSession.startRunning()
//            DispatchQueue.main.async {
//                self.setupPreviewLayer()
//            }
//        }
//    }
//
//    private func stopSession() {
//        guard running else { return }
//        running = false
//        captureSession.stopRunning()
//        previewLayer?.removeFromSuperlayer()
//    }
//
//    private func setupCaptureSession() {
//        captureSession.beginConfiguration()
//        captureSession.sessionPreset = .high
//
//        // input
//        guard let cam = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
//              let input = try? AVCaptureDeviceInput(device: cam),
//              captureSession.canAddInput(input) else {
//            print("Cannot create camera input.")
//            captureSession.commitConfiguration()
//            return
//        }
//        captureSession.addInput(input)
//
//        // output
//        let queue = DispatchQueue(label: "camera.frame.queue")
//        videoOutput.setSampleBufferDelegate(self, queue: queue)
//        videoOutput.alwaysDiscardsLateVideoFrames = true
//        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
//
//        if captureSession.canAddOutput(videoOutput) {
//            captureSession.addOutput(videoOutput)
//            // set orientation
//            if let connection = videoOutput.connection(with: .video), connection.isVideoOrientationSupported {
//                connection.videoOrientation = .portrait
//            }
//        } else {
//            print("Could not add video output")
//        }
//
//        captureSession.commitConfiguration()
//    }
//
//    private func setupPreviewLayer() {
//        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        previewLayer.videoGravity = .resizeAspectFill
//        previewLayer.frame = previewView.bounds
//        previewView.layer.insertSublayer(previewLayer, at: 0)
//
//        // Update frame on rotation
//        previewLayer.connection?.videoOrientation = currentVideoOrientation()
//    }
//
//    private func currentVideoOrientation() -> AVCaptureVideoOrientation {
//        let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
//        switch orientation {
//        case .landscapeLeft: return .landscapeLeft
//        case .landscapeRight: return .landscapeRight
//        case .portraitUpsideDown: return .portraitUpsideDown
//        default: return .portrait
//        }
//    }
//
//    // MARK: - Vision handling
//    private func visionRequestHandler(request: VNRequest, error: Error?) {
//        guard error == nil else {
//            print("Vision error:", error!)
//            return
//        }
//        guard let results = request.results as? [VNClassificationObservation], let top = results.first else {
//            DispatchQueue.main.async { self.overlayLabel.isHidden = true }
//            return
//        }
//
//        let label = top.identifier
//        let conf = top.confidence
//
//        // smoothing: maintain small rolling window of top labels
//        DispatchQueue.main.async {
//            self.smoothingWindow.append(label)
//            if self.smoothingWindow.count > self.smoothingWindowSize {
//                self.smoothingWindow.removeFirst()
//            }
//            // majority vote
//            let counts = Dictionary(grouping: self.smoothingWindow, by: { $0 }).mapValues { $0.count }
//            let best = counts.max(by: { $0.value < $1.value })?.key ?? label
//
//            self.overlayLabel.text = "\(best) — \(Int(conf * 100))%"
//            self.overlayLabel.isHidden = false
//        }
//    }
//
//    // MARK: - Clean up
//    deinit {
//        stopSession()
//    }
//}
//
//// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
//extension LiveCameraClassifierViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
//    func captureOutput(_ output: AVCaptureOutput,
//                       didOutput sampleBuffer: CMSampleBuffer,
//                       from connection: AVCaptureConnection) {
//
//        // Throttle by time
//        let now = CACurrentMediaTime()
//        if now - lastProcessTime < minFrameInterval { return }
//        lastProcessTime = now
//
//        // Get pixel buffer
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//
//        // Build a Vision request handler and perform request in processing queue
//        processingQueue.async {
//            // Create handler and perform request
//            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
//            do {
//                try handler.perform([self.vnRequest])
//            } catch {
//                // occasionally Vision may throw; ignore and continue
//                // print("Vision perform error:", error)
//            }
//        }
//    }
//}
