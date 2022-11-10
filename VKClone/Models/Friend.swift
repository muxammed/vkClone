// Friend.swift
// Copyright © RoadMap. All rights reserved.

/// друг
struct Friend {
    let friendNickName: String
    let friendImageName: String
    let friendGroupName: String
    let photos: [Photo]
}

/// для удобного выявления уникальных первых букв в имени друга
extension Friend: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendNickName.first)
    }

    static func == (lhs: Friend, rhs: Friend) -> Bool {
        lhs.friendNickName.first == rhs.friendNickName.first
    }

    static func makeDummyData() -> [Friend] {
        let friends = [
            Friend(
                friendNickName: "Friend",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "",
                photos: [
                    Photo(photoName: "photo1", likesCount: 10),
                    Photo(photoName: "photo2", likesCount: 1),
                    Photo(photoName: "photo3", likesCount: 12)
                ]
            ),
            Friend(
                friendNickName: "Friend2",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "",
                photos: [
                    Photo(photoName: "photo4", likesCount: 10),
                    Photo(photoName: "photo5", likesCount: 14),
                    Photo(photoName: "photo6", likesCount: 13)
                ]
            ),
            Friend(
                friendNickName: "Friend3",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "Команда ВКонтакте",
                photos: [
                    Photo(photoName: "photo7", likesCount: 11),
                    Photo(photoName: "photo1", likesCount: 16),
                    Photo(photoName: "photo2", likesCount: 18)
                ]
            ),
            Friend(
                friendNickName: "Ariend4",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "",
                photos: [
                    Photo(photoName: "photo3", likesCount: 15),
                    Photo(photoName: "photo4", likesCount: 15),
                    Photo(photoName: "photo5", likesCount: 19)
                ]
            ),
            Friend(
                friendNickName: "Friend5",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "Команда ВКонтакте",
                photos: [
                    Photo(photoName: "photo6", likesCount: 10),
                    Photo(photoName: "photo7", likesCount: 10),
                    Photo(photoName: "photo1", likesCount: 10)
                ]
            ),
            Friend(
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
            ),
            Friend(
                friendNickName: "ZFriend2",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "",
                photos: [
                    Photo(photoName: "photo4", likesCount: 10),
                    Photo(photoName: "photo5", likesCount: 14),
                    Photo(photoName: "photo6", likesCount: 13)
                ]
            ),
            Friend(
                friendNickName: "ZFriend3",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "Команда ВКонтакте",
                photos: [
                    Photo(photoName: "photo7", likesCount: 11),
                    Photo(photoName: "photo1", likesCount: 16),
                    Photo(photoName: "photo2", likesCount: 18)
                ]
            ),
            Friend(
                friendNickName: "UAriend4",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "",
                photos: [
                    Photo(photoName: "photo3", likesCount: 15),
                    Photo(photoName: "photo4", likesCount: 15),
                    Photo(photoName: "photo5", likesCount: 19)
                ]
            ),
            Friend(
                friendNickName: "DFriend5",
                friendImageName: Constants.friendImageNameText,
                friendGroupName: "Команда ВКонтакте",
                photos: [
                    Photo(photoName: "photo6", likesCount: 10),
                    Photo(photoName: "photo7", likesCount: 10),
                    Photo(photoName: "photo1", likesCount: 10)
                ]
            ),
            Friend(
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
        return friends
    }
}

/// фотографий
struct Photo {
    let photoName: String
    let likesCount: Int
}

/// константы
extension Friend {
    enum Constants {
        static let friendImageNameText = "friend2"
    }
}
