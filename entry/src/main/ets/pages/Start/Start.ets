import { AdvertClass } from '../../models'
import { UserSettingClass } from '../../utils'
import router from '@ohos.router'
import { TOKEN_KEY } from '../../constants'

PersistentStorage.persistProp(TOKEN_KEY, "")

@Entry
@Component
struct Start {
  userSetting: UserSettingClass = new UserSettingClass(getContext(this))
  @State
  adObj: AdvertClass = {
    showAd: false,
    adTime: 0,
    adImg: $r("app.media.start")
  }
  timer: number = -1

  toNext() {
    if (AppStorage.get<string>(TOKEN_KEY)) {
      router.replaceUrl({ url: 'pages/Index/Index' })
    } else {
      router.replaceUrl({ url: 'pages/Login/Login' })
    }
  }

  async aboutToAppear() {
    this.adObj = await this.userSetting.getUserAd()
    this.timer = setInterval(() => {
      if (this.adObj.adTime === 0) {
        clearInterval(this.timer)
        router.replaceUrl({ url: 'pages/Login/Login' })
        return
      }
      this.adObj.adTime--
    }, 1000)
  }

  aboutToDisappear() {
    clearInterval(this.timer)
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Image(this.adObj.adImg).objectFit(ImageFit.Cover)
      Text(`${this.adObj.adTime}秒后跳过`)
        .padding({ left: 10, right: 10 })
        .margin({ right: 20, top: 20 })
        .height(30)
        .fontSize(14)
        .borderRadius(15)
        .backgroundColor($r('app.color.background_page'))
        .textAlign(TextAlign.Center)
        .onClick(() => {
          this.toNext()
        })

    }.height('100%').width('100%')
  }
}
