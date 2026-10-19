// The iOS app around a Kron program: it shows the pictures the program draws
// and passes it the touches and the keyboard. Everything else is Kron
// (templates/app.kr, built into KronApp.framework).
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = KronViewController()
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        kron_app_stop()
    }
}

final class KronViewController: UIViewController, UIKeyInput {
    private var link: CADisplayLink?
    private var pixels = [UInt32](repeating: 0, count: 2048 * 2048)
    private var pictureWidth = 1
    private var pictureHeight = 1
    private var started = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.layer.magnificationFilter = .linear
        view.isMultipleTouchEnabled = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if started { return }
        started = true
        let scale = UIScreen.main.nativeScale
        _ = kron_app_start(Int32(view.bounds.width * scale), Int32(view.bounds.height * scale))
        link = CADisplayLink(target: self, selector: #selector(showFrame))
        link?.add(to: .main, forMode: .common)
    }

    override var prefersStatusBarHidden: Bool { true }

    @objc private func showFrame() {
        if kron_app_running() == 0 {
            link?.invalidate()
            return
        }
        let wantsKeyboard = kron_app_wants_keyboard() != 0
        if wantsKeyboard && !isFirstResponder { becomeFirstResponder() }
        if !wantsKeyboard && isFirstResponder { resignFirstResponder() }

        let result = pixels.withUnsafeMutableBytes { raw in
            kron_app_frame(raw.baseAddress, Int64(raw.count))
        }
        if result == 0 { return }
        pictureWidth = Int(result & 0xFFFF_FFFF)
        pictureHeight = Int(result >> 32)
        let bytes = pictureWidth * pictureHeight * 4
        let data = pixels.withUnsafeBytes { Data($0.prefix(bytes)) }
        guard let provider = CGDataProvider(data: data as CFData) else { return }
        let info = CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.noneSkipFirst.rawValue
        guard let image = CGImage(width: pictureWidth, height: pictureHeight,
                                  bitsPerComponent: 8, bitsPerPixel: 32,
                                  bytesPerRow: pictureWidth * 4,
                                  space: CGColorSpaceCreateDeviceRGB(),
                                  bitmapInfo: CGBitmapInfo(rawValue: info),
                                  provider: provider, decode: nil,
                                  shouldInterpolate: true, intent: .defaultIntent) else { return }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        view.layer.contents = image
        CATransaction.commit()
    }

    // a touch, in the picture's pixels
    private func send(_ phase: Int32, _ touches: Set<UITouch>) {
        guard let t = touches.first else { return }
        let p = t.location(in: view)
        let x = Double(p.x / view.bounds.width) * Double(pictureWidth)
        let y = Double(p.y / view.bounds.height) * Double(pictureHeight)
        kron_app_touch(phase, x, y)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { send(1, touches) }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { send(2, touches) }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { send(3, touches) }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) { send(3, touches) }

    // the screen keyboard: characters as Latin-1, enter and backspace as keys
    override var canBecomeFirstResponder: Bool { true }
    var hasText: Bool { true }
    var autocorrectionType: UITextAutocorrectionType = .no
    var autocapitalizationType: UITextAutocapitalizationType = .none
    func insertText(_ text: String) {
        for scalar in text.unicodeScalars {
            if scalar == "\n" {
                kron_app_key(13, 0)
            } else if scalar.value < 256 {
                kron_app_key(0, Int32(scalar.value))
            }
        }
    }
    func deleteBackward() { kron_app_key(8, 0) }
}
