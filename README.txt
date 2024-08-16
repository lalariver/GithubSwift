使用須知： 須先到 GithubApi headers Authorization 新增自己的 token
架構採用 MVVM, Combine，網路層也在另外抽出。
套件只有使用 Kingfisher, SnapKit。
GithubUsers 部分：
UsersViewModel 初始化後 call api，由於畫面較簡易直接由回傳 api 繼承 UserCellProtocol，更新 users 後 VC 監聽，再去更新 countLabel and reload table view。
點擊 cell 可進入下一頁 GithubUserDetailViewController，點擊時傳入 login，以便初始化 viewModel，
GithubUserDetailViewController 部分：
viewModel 初始化後一樣先帶入參數 call api，之後更新自己的屬性，一樣 VC 去綁定監聽更新畫面
saveButton 點擊後會更新 viewModel.name，假設有可更新 name 的 api 會呼叫 updateName 去執行
 NetworkService 部分：
用泛型去接回傳的 model，並且用 enum 的方式去設定每個 path, method 等等，讓 vm 只需專心處理 response or error。
 UIPaddingLabel：設置一個可圓角且有 padding 的 Label
 Extension UIColor：用 hex 可以設置顏色
 Extension Array：用 safe 可以安全取用 array

