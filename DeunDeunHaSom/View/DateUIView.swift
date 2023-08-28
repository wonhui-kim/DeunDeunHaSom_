//
//  DateUIView.swift
//  DeunDeunHaSom
//
//  Created by 김원희 on 2022/08/08.
//

import UIKit

protocol DateUIViewDelegate: AnyObject {
    func updateMenu(index: Int)
    func renewWeekData(parameter: [String:String])
}

final class DateUIView: UIView {
    
    //weak, AnyObject 사용 이유
    weak var delegate: DateUIViewDelegate?
    private let dateManager = DateManager.shared
    
    private let days = ["월", "화", "수", "목", "금"]
    private lazy var dates = dateManager.weekDate()
    
    //월화수목금 UILabel 생성
    private lazy var dayLabels: [UILabel] = days.map {
        let label = UILabel()
        label.text = $0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        return label
    }
    
    //날짜 버튼 5개 생성
    private lazy var dateButtons: [UIButton] = dates.map {
        let button = UIButton()
        button.setTitle($0, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.layer.cornerRadius = 13
        button.addTarget(self, action: #selector(dateButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    //dayStackView, dateStackView
    private func createStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .systemBackground
        return stackView
    }
    
    private lazy var dayStackView: UIStackView = createStackView()
    private lazy var dateStackView: UIStackView = createStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setupLayout()
        initialButtonStatus()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dayChanged(_:)), name: UIApplication.significantTimeChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

//view layout 관련 함수
extension DateUIView {
    
    private func configureUI() {
        [dayStackView, dateStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        dayLabels.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            dayStackView.addArrangedSubview($0)
        }
        
        dateButtons.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            dateStackView.addArrangedSubview($0)
        }
    }

    private func setupLayout() {
        let dayStackViewConstraints = [
            dayStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            dayStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            dayStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            dayStackView.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let dateStackViewConstraints = [
            dateStackView.topAnchor.constraint(equalTo: dayStackView.bottomAnchor),
            dateStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            dateStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            dateStackView.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        [dayStackViewConstraints, dateStackViewConstraints].forEach {
            NSLayoutConstraint.activate($0)
        }
    }
    
}

//기타 함수
extension DateUIView {
    //버튼 클릭 시 태그에 따른 식단 호출
    @objc
    private func dateButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        
        delegate?.updateMenu(index: tag)
        
        //선택된 버튼의 background를 pointcolor로 변경
        //선택된 버튼이 이미 존재하는지 확인
        if let selectedButton = dateButtons.firstIndex(where: { $0.isSelected }) {
            dateButtons[selectedButton].isSelected = false
            dateButtons[selectedButton].backgroundColor = .clear
        }
        
        sender.isSelected = true
        sender.backgroundColor = UIColor(named: "PointColor")
    }
    
    //초기 버튼 세팅
    private func initialButtonStatus() {
        //버튼 태그 설정
        for i in 0..<dateButtons.count {
            dateButtons[i].tag = i
        }
        
        let todayIndex = dateManager.todayIndex()
        defaultButtonTapped(todayIndex: todayIndex)
    }
    
    //default로 selected된 버튼
    private func defaultButtonTapped(todayIndex: Int) {
        //선택된 버튼이 이미 존재하는지 확인
        if let selectedButton = dateButtons.firstIndex(where: { $0.isSelected }) {
            dateButtons[selectedButton].isSelected = false
            dateButtons[selectedButton].backgroundColor = .clear
        }
        
        dateButtons[todayIndex].isSelected = true
        dateButtons[todayIndex].backgroundColor = UIColor(named: "PointColor")
    }
    
    private func updateDateButtons(dates: [String]) {
        for i in 0..<dateButtons.count {
            dateButtons[i].setTitle(dates[i], for: .normal)
        }
    }
    
    @objc
    private func dayChanged(_ notification: Notification) {
        let today = dateManager.today()
        
        if today == "일" || today == "월" {
            //dates buttons 날짜 모두 업데이트
            let dates = dateManager.weekDate()
            updateDateButtons(dates: dates)
            
            //모든 식단 데이터 다시 가져와서 오늘 날짜로 테이블 뷰 업데이트
            let startEndDate = dateManager.startEndDate()
            delegate?.renewWeekData(parameter: startEndDate)
        } else {
            //오늘 날짜로 date button selected
            let todayIndex = dateManager.todayIndex()
            defaultButtonTapped(todayIndex: todayIndex)
            
            //오늘 날짜 식단 보여주기
            delegate?.updateMenu(index: todayIndex)
        }
        
    }
}

