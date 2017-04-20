//
//  ViewController.swift
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    // MARK: - Private Fields
    
    private let BUTTON_IMMIDIATE = 1
    private let BUTTON_AFTER = 2

    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Notification許可要求
        self.requestNotificationAuthorization()
        
        // Viewの設定
        self.setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private & Internal Methods
    
    /// Notification許可要求
    private func requestNotificationAuthorization() {
        // Notificationの許可を要求
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
    }
    
    /// Viewの設定
    private func setupView() {
        // ボタンの設定
        self.setupButtons()
    }
    
    /// ボタンの設定
    private func setupButtons() {
        // ボタン共通設定
        let buttonSize = CGSize(width: 200.0,
                                height: 80.0)
        let buttonX: CGFloat = (self.view.bounds.width - buttonSize.width) / 2
        let buttonCornerRadius: CGFloat = 20.0
        
        // すぐにNotificationを発火するボタン
        let immidiateButtonPoint = CGPoint(x: buttonX,
                                           y: 200.0)
        let immidiateButton = UIButton(frame: CGRect(origin: immidiateButtonPoint,
                                                     size: buttonSize))
        
        immidiateButton.tag = BUTTON_IMMIDIATE
        immidiateButton.backgroundColor = UIColor.orange
        immidiateButton.setTitle("すぐに発火",
                                 for: .normal)
        
        immidiateButton.layer.masksToBounds = true;
        immidiateButton.layer.cornerRadius = buttonCornerRadius
        
        immidiateButton.addTarget(self,
                                  action: #selector(onButtonTapped(sender:)),
                                  for: .touchDown)
        
        self.view.addSubview(immidiateButton)
        
        // ちょっと後でNotificationを発火するボタン
        let afterButtonPoint = CGPoint(x: buttonX,
                                       y: 400)
        let afterButton = UIButton(frame: CGRect(origin: afterButtonPoint,
                                                 size: buttonSize))
        
        afterButton.tag = BUTTON_AFTER
        afterButton.backgroundColor = UIColor.blue
        afterButton.setTitle("ちょっと後で発火",
                             for: .normal)
        
        afterButton.layer.masksToBounds = true
        afterButton.layer.cornerRadius = buttonCornerRadius
        
        afterButton.addTarget(self,
                              action: #selector(onButtonTapped(sender:)),
                              for: .touchDown)
        
        self.view.addSubview(afterButton);
    }
    
    /// すぐにNotificationを表示
    private func showNotificationImmediately() {
        debugPrint(#function)
        
        // Notificationの内容を設定
        let content = UNMutableNotificationContent()
        
        content.title = "すぐに発火"
        content.body = "すぐに発火する通知"
        content.sound = UNNotificationSound.default()
        
        // Notificationのリクエスト生成
        let request = UNNotificationRequest.init(identifier: "NotificationImmediately",
                                                 content: content,
                                                 trigger: nil)
        
        // Notificationを発行
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.add(request) { (error) in
            if (error != nil) {
                print(error ?? "Error!")
            }
        }
    }
    
    /// ちょっと後でNotificationを表示
    private func showNotificationAfter() {
        debugPrint(#function)
        
        // Notificationの内容を設定
        let content = UNMutableNotificationContent()
        
        content.title = "ちょっと後で発火"
        content.body = "ちょっと後で発火する通知"
        content.sound = UNNotificationSound.default()
        
        // NotificationのTrigger生成
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5,
                                                             repeats: false)
        
        // Notificationのリクエスト生成
        let request = UNNotificationRequest.init(identifier: "NotificationAfter",
                                                 content: content,
                                                 trigger: trigger)
        
        // Notificationを発行
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.add(request) { (error) in
            if (error != nil) {
                print(error ?? "Error!")
            }
        }
    }
    
    /// ボタンタップイベント
    internal func onButtonTapped(sender: UIButton) {
        debugPrint(#function)
        
        switch sender.tag {
            
            case BUTTON_IMMIDIATE:  // "すぐに発火"ボタン
                // すぐにNotificationを表示
                self.showNotificationImmediately()
                break;
            case BUTTON_AFTER:      // "ちょっと後で発火"ボタン
                // ちょっと後でNotificationを表示
                self.showNotificationAfter()
                break;
            default:
                break;
        }
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        debugPrint(#function)
        
        completionHandler([.sound, .alert])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        debugPrint(#function)
        
        debugPrint("Notification opened.")
        
        completionHandler()
    }
}

