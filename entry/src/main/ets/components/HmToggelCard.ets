@Preview
@Component
struct HmToggleCard {
  @BuilderParam
  CardContent: () => void
  title: string = "测试"
  @State
  toggleCard: boolean = true

  build() {
    Column() {
      Row() {
        Text(this.title).fontSize(16).fontColor($r('app.color.text_primary')).fontWeight(500)
        Image(this.toggleCard ? $r("app.media.ic_btn_cut") : $r("app.media.ic_btn_add"))
          .width(24)
          .height(24)
          .onClick(() => {
            animateTo({ duration: 300 }, () => {
              this.toggleCard = !this.toggleCard
            })
          })
      }.justifyContent(FlexAlign.SpaceBetween).width('100%').height(50)
      //   主要显示内容
      if (this.toggleCard) {
        if(this.CardContent) {
          this.CardContent()
        }
      }
    }.margin({
      left: 15,
      right: 15,
      top: 15
    }).padding({
      left: 19.5,
      right: 19.5,
      bottom: 18.5,
    }).borderRadius(10).backgroundColor($r('app.color.white'))

  }
}

export { HmToggleCard }