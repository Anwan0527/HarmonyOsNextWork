import router from '@ohos.router';

@Preview
@Component
struct HmNavBar {
  title: string = "测试个人中心"
  showBackIcon: boolean = true

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Row() {
        if (this.title) {
          Text(this.title).fontColor($r('app.color.text_primary')).fontSize(18).fontWeight(600)
        }
      }.justifyContent(FlexAlign.Center).alignItems(VerticalAlign.Center).width('100%').height('100%')

      if (this.showBackIcon) {
        Row() {
          Image($r("app.media.ic_btn_nav_back")).width(44).height(44).onClick(() => {
            router.back() // 回上一页
          })
        }.alignItems(VerticalAlign.Center).width(44)
      }
    }.backgroundColor($r('app.color.white')).height(50).width('100%').padding(10)
  }
}

export { HmNavBar }