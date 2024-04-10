//上传组件
@Component
struct HmUpload {
  title: string = ""

  build() {
    Column() {
      Text(this.title).fontSize(14).fontColor($r("app.color.text_secondary")).margin({
        top: 16,
        bottom: 16
      })
      Row() {
        Image($r("app.media.ic_add_img")).width(30).height(30)
      }
      .width(95)
      .height(95)
      .backgroundColor('#F2F2F2')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }.alignItems(HorizontalAlign.Start).width('100%')
  }
}

export { HmUpload }