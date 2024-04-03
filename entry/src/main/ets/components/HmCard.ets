@Component
struct HmCard {
  @BuilderParam
  HmCardFn: () => void

  build() {
    Column() {
      Column() {
        if (this.HmCardFn) {
          this.HmCardFn()
        }
      }
      .backgroundColor($r('app.color.white'))
      .borderRadius(10)
      .width('100%')
      .padding({
        left: 15,
        right: 15
      })
      .backgroundColor($r('app.color.white'))
    }.width('100%').padding(15)
  }
}

export { HmCard }