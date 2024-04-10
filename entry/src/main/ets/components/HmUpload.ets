//上传组件
import { picker } from '@kit.CoreFileKit';


@Component
struct HmUpload {
  title: string = ""
  maxNumber: number = 3

  // 弹出相册选择器
  async selectImage() {
    let photoPicker = new picker.PhotoViewPicker();
    const result = await photoPicker.select({
      MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE,
      maxSelectNumber: this.maxNumber
    })
    AlertDialog.show({
      message: JSON.stringify(result.photoUris)
    })
  }

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
      .onClick(() => {
        this.selectImage()
      })
    }.alignItems(HorizontalAlign.Start).width('100%')
  }
}

export { HmUpload }