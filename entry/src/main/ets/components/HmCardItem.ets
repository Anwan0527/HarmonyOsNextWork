@Component
struct HmCardItem {
  leftTitle: string = ''
  showBottomBorder: boolean = true
  showRightIcon: boolean = true
  @Prop rightText: string

  onRightClick: () => void = () => {
  }

  build() {
    Row() {
      Text(this.leftTitle).fontSize(16).fontWeight(400).fontColor($r('app.color.text_primary'))
      Row() {
        if (this.rightText) {
          Text(this.rightText).fontColor($r("app.color.text_secondary")).fontWeight(400).fontSize(14)
        }
        if (this.showRightIcon) {
          Image($r("app.media.ic_btn_more")).width(24).height(24)
        }
      }.onClick(() => {
        this.onRightClick()
      })
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .border({
      width: {
        bottom: this.showBottomBorder ? 1 : 0
      },
      color: $r('app.color.background_divider')
    })
    .width('100%')
    .height(60)
  }
}

export { HmCardItem }