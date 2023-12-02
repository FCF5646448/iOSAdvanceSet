//
//  SettingView.swift
//  PokeMaster
//
//  Created by fengcaifan on 2023/10/23.
//

import SwiftUI
import Combine

struct SettingView: View {
    @EnvironmentObject var store: Store
    
    // 对于长的数据，可以使用这种方案包一层。使用起来更简洁明了
    private var settings: AppState.Settings { store.appState.settings }
    private var settingsBinding: Binding<AppState.Settings> { $store.appState.settings }
    
    var body: some View {
        Form {
            accountSection
            optionSection
            actionSection
        }
        .alert(item: settingsBinding.loginError) { error in
            Alert(title: Text(error.localizedDescription))
        }
    }
    
    var accountSection: some View {
        Section(header: Text("账户"), content: {
            if settings.loginUser == nil {
                Picker(selection: settingsBinding.checker.accountBehavior, label: Text("")) {
                    ForEach(AppState.Settings.AccountBehavior.allCases, id: \.self) {
                        Text($0.text)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                TextField("电子邮箱", text: settingsBinding.checker.email)
                SecureField("密码", text: settingsBinding.checker.password)
                if settings.checker.accountBehavior == .register {
                    SecureField("确认密码", text: settingsBinding.checker.verifyPassword)
                }
                if settings.loginRequesting {
                    Text("\(settings.checker.accountBehavior.text)中...")
                        .foregroundColor(.gray)
                } else {
                    Button(settings.checker.accountBehavior.text) {
                        print("登录/注册")
                        let checker = settings.checker
                        switch checker.accountBehavior {
                        case .login:
                            self.store.dispatch(.login(email: checker.email,
                                                       password: checker.password))
                        case .register:
//                            self.store.dispatch(.resest))
    //                        self.store.dispatch(.register(email: checker.email, password: checker.password))
                            break
                        }
                    }
                }
            } else {
                Text(settings.loginUser!.email)
                Button("注销") {
                    print("注销")
                    self.store.dispatch(.logout)
                }
            }
        })
    }
    
    var optionSection: some View {
        Section(header: Text("选项")) {
            Toggle(isOn: settingsBinding.showEnglishName, label: {
                Text("显示英文名")
            })
            Picker(selection: settingsBinding.sorting, label: Text("排列方式")) {
                ForEach(AppState.Settings.Sorting.allCases, id: \.self) {
                    Text($0.text)
                }
            }
            Toggle(isOn: settingsBinding.showFavoriteOnly, label: {
                Text("只显示收藏")
            })
        }
    }
    
    var actionSection: some View {
        Section {
            Button(action: {
                print("清空缓存")
            }, label: {
                Text("清空缓存").foregroundColor(.red)
            })
        }
    }
}

extension AppState.Settings.AccountBehavior {
    var text: String {
        switch self {
        case .register:
            return "注册"
        case .login:
            return "登录"
        }
    }
}

extension AppState.Settings.Sorting {
    var text: String {
        switch self {
        case .id:
            return "ID"
        case .name:
            return "名字"
        case .color:
            return "颜色"
        case .favorite:
            return "最爱"
        }
    }
}

#Preview {
    SettingView().environmentObject(Store())
}
