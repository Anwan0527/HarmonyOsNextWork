import { TaskInfoItem, TaskInfoItemModel } from '../../../models'
import router from '@ohos.router';

@Preview
@Component
struct TaskItemCard {
  taskItemData: TaskInfoItemModel = new TaskInfoItemModel({} as TaskInfoItem)

  // 去提货
  toPickUp() {
    if (this.getBtnEnable()) {
      router.pushUrl({
        url: 'pages/TaskDetail/TaskDetail',
        params: {
          id: this.taskItemData.id
        }
      })
    }
  }

  // 获取按钮是否可提货
  getBtnEnable() {
    if (this.taskItemData.enablePickUp) {
      return true
    }
    return false
  }

  build() {
    Column() {
      Row() {
        Text(`任务编号：${this.taskItemData.id}`)
          .fontSize(16)
          .fontColor($r("app.color.text_primary"))
          .fontWeight(500)
          .lineHeight(22)
      }.justifyContent(FlexAlign.SpaceBetween).width('100%')

      Row() {
        Text("起")
          .fontSize(12)
          .fontColor($r("app.color.white"))
          .backgroundColor($r("app.color.text_primary"))
          .width(22)
          .height(22)
          .borderRadius(11)
          .textAlign(TextAlign.Center)
        Text(this.taskItemData.startAddress)
          .margin({ left: 11.5 })
          .fontColor($r('app.color.text_secondary'))
          .fontSize(14)
      }.margin({ top: 21 }).width('100%')

      Row() {
        Text("止")
          .fontSize(12)
          .fontColor($r("app.color.white"))
          .backgroundColor($r('app.color.primary'))
          .width(22)
          .height(22)
          .borderRadius(11)
          .textAlign(TextAlign.Center)
        Text(this.taskItemData.endAddress)
          .margin({ left: 11.5 })
          .fontColor($r('app.color.text_secondary'))
          .fontSize(14)
      }.margin({ top: 14.5 }).width('100%')

      Divider()
        .vertical(true)
        .height(2)
        .color($r('app.color.background_divider'))
        .opacity(0.6)
        .margin({ left: 8, right: 8, top: 21 })
      Row() {
        Column() {
          Text('提货时间').fontSize(14).fontColor($r('app.color.text_secondary'))
          Text(this.taskItemData.planDepartureTime)
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .margin({ top: 4 })
        }.alignItems(HorizontalAlign.Start)

        Button("提货", { type: ButtonType.Capsule })
          .backgroundColor(this.getBtnEnable() ? $r('app.color.primary') : $r('app.color.primary_disabled'))
          .fontColor($r("app.color.white"))
          .fontSize(14)
          .height(32)
          .enabled(this.getBtnEnable())
          .onClick(() => {
            this.toPickUp()
          })
      }.justifyContent(FlexAlign.SpaceBetween).width('100%')
    }
    .margin({ left: 15, right: 15, top: 15 })
    .padding({ left: 19.5, right: 19.5, bottom: 18.5, top: 18.5 })
    .borderRadius(10)
    .backgroundColor($r('app.color.white'))

  }
}

export default TaskItemCard