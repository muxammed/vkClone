// NewsViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// экран новостей
final class NewsViewController: UITableViewController {
    // MARK: - Private properties

    private var news: [News] = []
    private var myFriends: [Friend] = []
    private var newsTexts = [
        Constants.newsTextOne,
        Constants.newsTextTwo,
        Constants.newsTextThree,
        Constants.newsTextFour,
        Constants.newsTextFive
    ]
    private var photos = [
        Constants.photoOne,
        Constants.photoTwo,
        Constants.photoThree,
        Constants.photoFour,
        Constants.photoFive,
        Constants.photoSix,
        Constants.photoSeven,
    ]

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDummyNews()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(NewsViewCell.nib(), forCellReuseIdentifier: NewsViewCell.identifier)
        tableView.reloadData()
    }

    // MARK: - Private methods

    private func loadDummyNews() {
        loadDummyFriends()
        for _ in 0 ... 10 {
            var news = News(
                newsText: newsTexts[Int.random(in: 0 ..< newsTexts.count)],
                newsPhotos: [],
                newsUser: myFriends[Int.random(in: 0 ..< myFriends.count)],
                likesCount: Int.random(in: 0 ... 1000),
                commentsCount: Int.random(in: 0 ... 100)
            )
            for _ in 0 ..< Int.random(in: 1 ... 10) {
                news.newsPhotos.append(photos[Int.random(in: 0 ... 6)])
            }
            self.news.append(news)
        }
    }

    private func loadDummyFriends() {
        myFriends = [
            Friend(
                friendNickName: "Friend",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "",
                photos: [
                    Photo(photoName: "photo1", likesCount: 10),
                    Photo(photoName: "photo2", likesCount: 1),
                    Photo(photoName: "photo3", likesCount: 12)
                ]
            ), Friend(
                friendNickName: "Friend2",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "",
                photos: [
                    Photo(photoName: "photo4", likesCount: 10),
                    Photo(photoName: "photo5", likesCount: 14),
                    Photo(photoName: "photo6", likesCount: 13)
                ]
            ), Friend(
                friendNickName: "Friend3",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "Команда ВКонтакте",
                photos: [
                    Photo(photoName: "photo7", likesCount: 11),
                    Photo(photoName: "photo1", likesCount: 16),
                    Photo(photoName: "photo2", likesCount: 18)
                ]
            ), Friend(
                friendNickName: "Ariend4",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "",
                photos: [
                    Photo(photoName: "photo3", likesCount: 15),
                    Photo(photoName: "photo4", likesCount: 15),
                    Photo(photoName: "photo5", likesCount: 19)
                ]
            ), Friend(
                friendNickName: "Friend5",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "Команда ВКонтакте",
                photos: [
                    Photo(photoName: "photo6", likesCount: 10),
                    Photo(photoName: "photo7", likesCount: 10),
                    Photo(photoName: "photo1", likesCount: 10)
                ]
            ), Friend(
                friendNickName: "Ariend6",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "",
                photos: [
                    Photo(photoName: "photo2", likesCount: 10),
                    Photo(photoName: "photo3", likesCount: 10),
                    Photo(photoName: "photo4", likesCount: 10)
                ]
            ),
            Friend(
                friendNickName: "UFriend",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "",
                photos: [
                    Photo(photoName: "photo1", likesCount: 10),
                    Photo(photoName: "photo2", likesCount: 1),
                    Photo(photoName: "photo3", likesCount: 12)
                ]
            ), Friend(
                friendNickName: "ZFriend2",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "",
                photos: [
                    Photo(photoName: "photo4", likesCount: 10),
                    Photo(photoName: "photo5", likesCount: 14),
                    Photo(photoName: "photo6", likesCount: 13)
                ]
            ), Friend(
                friendNickName: "ZFriend3",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "Команда ВКонтакте",
                photos: [
                    Photo(photoName: "photo7", likesCount: 11),
                    Photo(photoName: "photo1", likesCount: 16),
                    Photo(photoName: "photo2", likesCount: 18)
                ]
            ), Friend(
                friendNickName: "UAriend4",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "",
                photos: [
                    Photo(photoName: "photo3", likesCount: 15),
                    Photo(photoName: "photo4", likesCount: 15),
                    Photo(photoName: "photo5", likesCount: 19)
                ]
            ), Friend(
                friendNickName: "DFriend5",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "Команда ВКонтакте",
                photos: [
                    Photo(photoName: "photo6", likesCount: 10),
                    Photo(photoName: "photo7", likesCount: 10),
                    Photo(photoName: "photo1", likesCount: 10)
                ]
            ), Friend(
                friendNickName: "DoAriend6",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "",
                photos: [
                    Photo(photoName: "photo2", likesCount: 10),
                    Photo(photoName: "photo3", likesCount: 10),
                    Photo(photoName: "photo4", likesCount: 10)
                ]
            )
        ]
    }
}

/// UITableViewDelegate, UITableViewDataSource
extension NewsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        news.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsViewCell.identifier,
            for: indexPath
        ) as? NewsViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: news[indexPath.item])
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToPhotoGallerySegue", sender: self)
    }
}

/// константы
extension NewsViewController {
    enum Constants {
        static let newsTextOne = "asdasd ad asd ada dad asd asd asd asd adas" +
            "dasd asd asd asd asd asda sda sda sdas dasd asd asd asd "
        static let newsTextTwo = "text two text two text two"
        static let newsTextThree = "text three text three text three text three" +
            "dasd asd asd asd asd asda text three text three" +
            "dasd asd asd asd asd asda text three text three"
        static let newsTextFour = "newsTextFour newsTextFour newsTextFour" +
            "newsTextFour newsTextFour newsTextFour newsTextFournewsTextFour" +
            "newsTextFour newsTextFour newsTextFour newsTextFournewsTextFour"
        static let newsTextFive = "newsTextFive asd asd adas" +
            "dasd newsTextFive newsTextFive newsTextFive newsTextFive newsTextFive "
        static let friendImageNameText = "friend2"
        static let photoOne = "image1"
        static let photoTwo = "image2"
        static let photoThree = "image3"
        static let photoFour = "image4"
        static let photoFive = "image5"
        static let photoSix = "image6"
        static let photoSeven = "image7"
    }
}
