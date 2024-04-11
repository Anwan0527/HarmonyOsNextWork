//上传组件
import { picker } from '@kit.CoreFileKit';
import fs from '@ohos.file.fs'
import { util } from '@kit.ArkTS';
import { request } from '@kit.BasicServicesKit';
import { uploadImage } from '../api';

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
    if (result.photoUris?.length) {
      try {
        // 循环处理
        let files: request.File[] = []
        const addFolderName = 'wuliu'
        const defaultDir = getContext(this).cacheDir + '/' + addFolderName // 默认路径
        result.photoUris.forEach(url => {
          const file = fs.openSync(url, fs.OpenMode.READ_ONLY) // 同步读取

          const tempFileName = util.generateRandomUUID() + '.jpg' // 生成一个唯一的文件名 后面有用
          if (!fs.listFileSync(getContext(this).cacheDir).includes(addFolderName)) {
            fs.mkdirSync(defaultDir)
          }

          const fileUri = defaultDir + '/' + tempFileName
          fs.copyFileSync(file.fd, fileUri) // 同步拷贝
          files.push({
            filename: tempFileName,
            name: 'file',
            uri: `internal://cache/${addFolderName}/${tempFileName}`,
            // 这里说明一下 internal协议会自动获取当前上下文协议的沙箱路径
            type: 'jpg'
          })
        })
        //输出图片url
        const urls = await uploadImage(getContext(this), files)
        AlertDialog.show({
          message: JSON.stringify(urls)
        })
        // AlertDialog.show({
        //   message: JSON.stringify(files)
        // })
        uploadImage(getContext(this), files)
      } catch (error) {
        AlertDialog.show({
          message: error.message
        })
      }
    }


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