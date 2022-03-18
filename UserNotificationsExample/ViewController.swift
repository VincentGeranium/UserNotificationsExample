//
//  ViewController.swift
//  UserNotificationsExample
//
//  Created by Morgan Kang on 2022/03/18.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    private let button: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("알림 울리기", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13.0, weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12.0
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        return button
    }()
    
    let notificationCenter = UNUserNotificationCenter.current()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        // 경고창, 뱃지, 사운드를 사용하는 알림 환경 정보 생성 등의 여부창.
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if error != nil {
                fatalError()
            } else {
                switch granted {
                case true:
                    print("알람 허용")
                case false:
                    print("알람 거부")
                }
            }
        }
        
        setupViews()
    }
    
    func setupViews() {
        setupButtonLayout()
    }
}

private extension ViewController {
    
    
    
    private func setupButtonLayout() {
        self.view.addSubview(button)
        
        button.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(35)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    
    
    @objc func didTapButton() {
        sendNotification(identifier: "identifier")
    }
}

extension ViewController: UNUserNotificationCenterDelegate {
    
    
    // 앱이 foreground에 있는 경우 호출되는 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .badge, .banner, .sound])
    }
}

extension ViewController {
    
    
    
    func sendNotification(identifier: String) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == UNAuthorizationStatus.authorized else { return }
            
            // 알람 콘텐츠 객체
            let content = UNMutableNotificationContent()
            
            content.title = "title:알림 요청 입니다."
            content.subtitle = "subTitle:많은 것을 배워갑니다."
            content.body = "body:진심으로 감사드립니다."
            content.badge = 1
            content.sound = UNNotificationSound.default
            
            
            // 알림 발송조건 객체
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            // 알림 요청 객체
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
}
