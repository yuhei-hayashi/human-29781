# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# アプリ名
* human-29781

# 実装機能

## 人材情報管理
* 新規登録
* 一覧表示・検索機能
* 詳細表示
* 編集
* 削除
* 契約状況の自動更新（契約開始時、終了時、入社時の自動更新）

## 契約情報管理
* 新規登録
* 編集・更新
* 削除
* 契約予定契約の自動開始
* 退職時の契約自動終了
* 同一人物の同時契約の防止

## 取引先情報管理
* 新規登録
* 一覧表示
* 詳細表示（単価平均や過去契約数の自動計算）
* 編集
* 削除

## 打ち合わせ日程管理
* 新規登録
* 一覧表示
* 編集
* 削除

# 本番環境
## URL
  https://human-29781.herokuapp.com/

## ユーザー認証
* ID:zigen
* pass:0323

## テストアカウント
* ユーザー名：test
* email:test.com
* pass:aaa111

# 制作背景
前職にて人材派遣の営業を行なっていました。その際日々変化する人材情報の管理に時間を取られ、業務効率が悪いと感じていました。
特に前職では待機社員の一覧情報をExcelで管理しており、詳細を調べる際は別手段をもって調べないといけないため同時に複数のツールを使い検索を行う必要がありました。
そこで前職の業務の効率を上げるためにはどのような機能を持ったシステムが必要か考え下記項目を満たすシステムがあれば効率が上がるという結論に至りました、
## 必要な機能
* 一覧表示画面での複数条件の検索機能
* 詳細情報への簡易遷移
* 派遣社員ごとの契約管理
* 取引先ごとの契約情報の管理
* 打ち合わせ日程の共有
上記の項目を満たし、その上で出来る限り自動化を行なったシステムを作成しようと思い今回のアプリを作成しました。

# DEMO

# 工夫したポイント
 * 自動更新機能
 契約変更時の契約状況の変更や入社前社員の入社日の自動入社など自動で行うことが出来る作業は自動化を行なった。
 * 打ち合わせ作成時の日程表示
 打ち合わせを新規作成する際、登録しようとしている社員の１週間分の打ち合わせが表示される。
 それによりダブルブッキングなどを防ぐことが出来る。

# DB設計

## usersテーブル
| Column | Type | Option |
| ------ | ---- | ------ |
| user_name | string | null: false |
| email | string | null: false |
| password | string | null: false |

### Association

- has_many :contracts
- has_many :meetings

## temporariesテーブル
| Column | Type | Option |
| ------ | ---- | ------ |
| full_name | string | null: false |
| full_name_reading | string | null: false |
| temporary_number | integer | null: false |
| birthday | date | null: false |
| hire_date | date | null: false |
| genre_id | integer | null: false |
| contract_status_id | integer | null: false |

### Association

- has_many :contracts
- has_many :meetings
- has_one :address
- has_one_attached :resume
- has_one_attached :skillsheet

## contractsテーブル
| Column | Type | Option |
| ------ | ---- | ------ |
| start_day | date | null: false |
| finish_day | date | null: false |
| price | integer | null: false |
| status_id | integer | null: false |
| company_id | references | null: false , foreign_key: true |
| temporary_id | references | null: false , foreign_key: true |
| user_id | references | null: false , foreign_key: true |


### Association

- belongs_to :company
- belongs_to :temporary
- belongs_to :user

## meetingsテーブル
| Column | Type | Option |
| ------ | ---- | ------ |
| company_name | string | null: false |
| day | date | null: false |
| time | datetime | null: false |
| temporary_id | references | null: false , foreign_key: true |
| user_id | references | null: false , foreign_key: true |

### Association

- belongs_to :user
- belongs_to :temporary

## Addressesテーブル
| Column | Type | Option |
| ------ | ---- | ------ |
| post_code | string | null: false |
| prefecture_id | integer | null: false |
| city | string | null: false |
| house_number | string | null: false |
| building_name | string | null: false |
| telephone | string | null: false |
| temporary_id | references | null: false , foreign_key: true |

### Association

- belongs_to :temporary
