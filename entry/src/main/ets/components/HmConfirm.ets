@Preview
@CustomDialog
@Component
struct HmConfirm {
  // 必不可少的属性 用来控制这个结构的显示和隐藏的
  controller: CustomDialogController
  message: string = "确定要退出登录吗？"
  buttonList: HmConfirmButton[] = [{
    text: '确定',
    fontSize: 14,
    fontColor: $r('app.color.text_secondary')
  }]

  build() {
    Row() {
      Column() {
        Row() {
          Text(this.message)
            .fontSize(16)
            .fontColor($r('app.color.text_primary'))
        }
        .width('100%')
        .height(88)
        .justifyContent(FlexAlign.Center)
        .border({
          color: $r('app.color.background_divider'),
          width: {
            bottom: 0.5
          }
        })

        Row() {
          ForEach(this.buttonList, (item: HmConfirmButton, index: number) => {
            Text(item.text)
              .fontSize(item.fontSize || 16)
              .textAlign(TextAlign.Center)
              .fontColor(item.fontColor || $r('app.color.text_secondary'))
              .layoutWeight(1)
              .border({
                color: $r('app.color.background_divider'),
                width: {
                  right: this.buttonList.length > 1 && index !== this.buttonList.length - 1
                    ? 0.5 : 0
                }
              })
              .height('100%')
              .onClick(async () => {
                if (item.action) {
                  await item.action()
                }
                this.controller.close()
              })
          })
        }
        .height(49)
        .width('100%')
      }
    }
    .width(278)
    .borderRadius(12)
    .backgroundColor($r('app.color.white'))
  }
}

export { HmConfirm }

class HmConfirmButton {
  fontColor?: ResourceStr = ''
  fontSize?: number = 16
  text: string = ""
  action?: () => void = () => {
  }
}