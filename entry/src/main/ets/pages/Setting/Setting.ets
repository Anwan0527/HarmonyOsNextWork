import { HmCard, HmCardItem, HmConfirm, HmNavBar } from '../../components'
import { TOKEN_KEY } from '../../constants'
import { UserSettingClass } from '../../utils'
import router from '@ohos.router'


@Entry
@Component
struct Setting {
  confirm: CustomDialogController = new CustomDialogController({
    builder: HmConfirm({
      message: '确定要退出登录吗?',
      buttonList: [{
        text: '取消'
      }, {
        text: '确定',
        fontColor: $r('app.color.primary'),
        action: () => {
          this.logout()
        }
      }]
    }),
    customStyle: true,
    alignment: DialogAlignment.Center,
    autoCancel: false
  })

  logout() {
    // 删除token
    AppStorage.set<string>(TOKEN_KEY, "")
    new UserSettingClass(getContext(this)).setUserToken("")
    // AlertDialog.show({
    //   message: TOKEN_KEY
    // })
    router.replaceUrl({
      url: 'pages/Login/Login'
    })
  }

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column }) {
        HmNavBar({ title: '系统设置' })

        HmCard() {
          HmCardItem({ leftTitle: '换绑手机', rightText: '' })
          HmCardItem({ leftTitle: '修改密码', rightText: '' })
          HmCardItem({ leftTitle: '消息通知设置', rightText: '' })
          HmCardItem({ leftTitle: '清理缓存', rightText: '', showBottomBorder: false })
        }

        Row() {
          Button("退出", { type: ButtonType.Normal })
            .onClick(() => {
              this.confirm.open()
            })
            .backgroundColor($r('app.color.white'))
            .fontColor($r("app.color.text_primary"))
            .width('100%')
            .borderRadius(8)
            .height(60)
        }.width('100%').margin({
          top: 20
        }).padding({
          left: 15,
          right: 15
        })
        .justifyContent(FlexAlign.Center)
      }
    }.width('100%')
    .height('100%').backgroundColor($r('app.color.background_page'))
  }
}