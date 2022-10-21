//
//  StubResponse.swift
//  AutocryptTests
//
//  Created by Siwon Kim on 2022/10/21.
//

import Foundation

struct StubResponse {
    static let vaccinationCenterList: Data = """
{
    "currentCount": 5,
    "data": [
        {
            "address": "서울특별시 성동구 고산자로 270",
            "centerName": "코로나19 서울특별시 성동구 예방접종센터",
            "centerType": "지역",
            "createdAt": "2021-03-15 00:03:43",
            "facilityName": "성동구청 대강당(3층)",
            "id": 6,
            "lat": "37.563457",
            "lng": "127.036981",
            "org": "",
            "phoneNumber": "02-2286-5084",
            "sido": "서울특별시",
            "sigungu": "성동구",
            "updatedAt": "2021-07-16 04:55:09",
            "zipCode": "04750"
        },
        {
            "address": "부산 부산진구 시민공원로 73",
            "centerName": "코로나19 부산광역시 부산진구 예방접종센터",
            "centerType": "지역",
            "createdAt": "2021-03-15 00:03:43",
            "facilityName": "부산시민공원 시민사랑채",
            "id": 7,
            "lat": "35.170182",
            "lng": "129.059301",
            "org": "",
            "phoneNumber": "051-605-8633",
            "sido": "부산광역시",
            "sigungu": "부산진구",
            "updatedAt": "2021-07-16 04:55:09",
            "zipCode": "47197"
        },
        {
            "address": "인천광역시 연수구 경원대로 526",
            "centerName": "코로나19 인천광역시 연수구 예방접종센터",
            "centerType": "지역",
            "createdAt": "2021-03-15 00:03:43",
            "facilityName": "선학경기장 선학체육관",
            "id": 8,
            "lat": "37.429571",
            "lng": "126.703271",
            "org": "",
            "phoneNumber": "032-749-8121",
            "sido": "인천광역시",
            "sigungu": "연수구",
            "updatedAt": "2021-07-16 04:55:10",
            "zipCode": "21908"
        },
        {
            "address": "광주광역시 서구 금화로 278",
            "centerName": "코로나19 광주광역시 서구 예방접종센터",
            "centerType": "지역",
            "createdAt": "2021-03-15 00:03:43",
            "facilityName": "빛고을체육관",
            "id": 9,
            "lat": "35.135361",
            "lng": "126.8771731",
            "org": "",
            "phoneNumber": "062-371-8731",
            "sido": "광주광역시",
            "sigungu": "서구",
            "updatedAt": "2021-07-16 04:55:10",
            "zipCode": "62048"
        },
        {
            "address": "대전광역시 유성구 유성대로 978",
            "centerName": "코로나19 대전광역시 유성구 예방접종센터",
            "centerType": "지역",
            "createdAt": "2021-03-15 00:03:44",
            "facilityName": "유성종합스포츠센터",
            "id": 10,
            "lat": "36.378512",
            "lng": "127.344399",
            "org": "",
            "phoneNumber": "042-611-2498",
            "sido": "대전광역시",
            "sigungu": "유성구",
            "updatedAt": "2021-07-16 04:55:11",
            "zipCode": "34128"
        }
    ],
    "matchCount": 284,
    "page": 2,
    "perPage": 5,
    "totalCount": 284
}
""".data(using: .utf8)!
}
