//
//  MainViewController.swift
//  IOS6-HW26-AlekseiKudinov
//
//  Created by Алексей Кудинов on 21.08.2022.
//

import UIKit

class MainViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.setTitle("Press", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(searchCharacters), for: .touchUpInside)

        return button
    }()

    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Print your name here"
        textField.textAlignment = .left
        textField.textColor = .black

        return textField
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 50
        stackView.distribution = .fillEqually

        return stackView
    }()

    private var presenter: PresenterInput!

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupHierarchy()
        self.setupLayout()
        self.setupTable()
        self.setupPresenter()

    }

    //MARK: - Methods

    private func setupView() {
        view.backgroundColor = .white
        navigationItem.title = "Users"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupHierarchy() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(button)
        view.addSubview(tableView)
    }

    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableCell.self, forCellReuseIdentifier: TableCell.identifier)
        tableView.backgroundColor = .white
    }

    private func setupLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 150),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            textField.rightAnchor.constraint(equalTo: button.leftAnchor),
            button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            button.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            button.rightAnchor.constraint(equalTo: stackView.rightAnchor)
        ])
    }

    private func setupPresenter() {
        presenter = Presenter(view: self)
        presenter.loadUsers()
    }

    @objc private func searchCharacters(_ sender: UIButton) {
        print("Add: \(textField.text ?? "")")
        presenter.addObject(name: textField.text ?? "", birthday: nil, gender: nil)
        textField.text = ""
    }
}

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfProducts
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = presenter.user(forRow: indexPath.row) else {
            return UITableViewCell()
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.identifier, for: indexPath) as? TableCell else {
            return UITableViewCell()
        }

        cell.configure(with: model)

        return cell
    }
}

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(DetailViewController(forRow: indexPath.row, presenter: presenter), animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            self.presenter.deleteObject(row: indexPath.row)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeActions
    }
}

extension MainViewController: PresenterOutput {
    func updateUsers() {
        self.tableView.reloadData()
    }
}


