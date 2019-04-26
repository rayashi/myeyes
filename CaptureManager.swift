

import Foundation
import AVKit

class CaptureManager {
    
    lazy var session: AVCaptureSession = {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        return captureSession
    }()
    
    weak var bufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate?
    
    init() {
        
    }
    
    func startCapture() -> AVCaptureVideoPreviewLayer? {
        guard askPermission() else { return nil }
        guard let device = AVCaptureDevice.default(for: .video) else { return nil }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return nil }
        session.addInput(input)
        session.startRunning()
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(bufferDelegate, queue: DispatchQueue(label: "camera"))
        session.addOutput(output)
        return AVCaptureVideoPreviewLayer(session: session)
    }
    
    func askPermission() -> Bool {
        var hasPermission = true
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            hasPermission = true
        case .denied, .restricted:
            hasPermission = false
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (success) in
                hasPermission = success
            }
        }
        return hasPermission
    }
}

