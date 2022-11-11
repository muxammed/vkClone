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

    private var selectedNews: News?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDummyNews()
        configTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Private methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedNews = selectedNews,
              let photoGalleryViewController = segue.destination as? PhotoGalleryViewController else { return }
        photoGalleryViewController.userImagesArray = selectedNews.newsPhotos
    }

    private func configTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(NewsViewCell.nib(), forCellReuseIdentifier: NewsViewCell.identifier)
        tableView.reloadData()
    }

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
        myFriends = Friend.makeDummyData()
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNews = news[indexPath.item]
        performSegue(withIdentifier: "goToPhotoGallerySegue", sender: self)
    }
}

/// константы
extension NewsViewController {
    enum Constants {
        static let newsTextOne = """
                    asdasd ad asd ada dad asd asd asd asd adas \
                    dasd asd asd asd asd asda sda sda sdas dasd asd asd asd
        """
        static let newsTextTwo = "text two text two text two"
        static let newsTextThree = """
        text three text three text three text three \
                    "dasd asd asd asd asd asda text three text three \
                    "dasd asd asd asd asd asda text three text three
        """
        static let newsTextFour = """
                newsTextFour newsTextFour newsTextFour \
                    newsTextFour newsTextFour newsTextFour newsTextFournewsTextFour \
                    newsTextFour newsTextFour newsTextFour newsTextFournewsTextFour
        """
        static let newsTextFive = """
        newsTextFive asd asd adas \
                    dasd newsTextFive newsTextFive newsTextFive newsTextFive newsTextFive
        """
        static let photoOne = "image1"
        static let photoTwo = "image2"
        static let photoThree = "image3"
        static let photoFour = "image4"
        static let photoFive = "image5"
        static let photoSix = "image6"
        static let photoSeven = "image7"
    }
}
