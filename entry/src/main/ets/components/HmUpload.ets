//上传组件
import { picker } from '@kit.CoreFileKit';
import fs from '@ohos.file.fs'
import { util } from '@kit.ArkTS';
import { request } from '@kit.BasicServicesKit';
import { uploadImage } from '../api';
import { ImageList } from '../models';
import { HmPreview } from './HmPreview';

@Component
struct HmUpload {
  @Prop
  canUpload: boolean = true // 默认可上传
  title: string = ""
  maxNumber: number = 3
  @State
  index: number = -1
  @Prop
  imgList: ImageList[] = []
  preview: CustomDialogController = new CustomDialogController({
    autoCancel: false,
    customStyle: true,
    alignment: DialogAlignment.Center,
    builder: HmPreview({
      urls: this.imgList.map(item => item.url),
      selectIndex: this.index
    })
  })
  onListChange: (list: ImageList[]) => void = () => {
  }

  // 弹出相册选择器
  async selectImage() {
    const photoPicker = new picker.PhotoViewPicker();
    const result = await photoPicker.select({
      MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE,
      maxSelectNumber: this.maxNumber
    })
    //循环数组
    if (result.photoUris?.length) {
      // 循环处理
      this.imgList = this.imgList.concat(result.photoUris.map(url => {
        return { url } as ImageList
      }))
      this.onListChange(this.imgList)
    }
  }

  build() {
    Column() {
      Text(this.title)
        .fontSize(14)
        .fontColor($r("app.color.text_secondary"))
        .margin({
          top: 16,
          bottom: 16
        })

      //渲染图片
      Grid() {
        ForEach(this.imgList, (item: ImageList, index: number) => {
          GridItem() {
            Stack({ alignContent: Alignment.TopEnd }) {
              Image(item.url)
                .width(95)
                .height(95)
                .borderRadius(4)
                .onClick(() => {
                  this.index = index
                  this.preview.open()
                })
              if (this.canUpload) {
                Image($r("app.media.ic_btn_delete"))
                  .width(30)
                  .height(30)
                  .onClick(() => {
                    this.imgList.splice(index)
                  })
              }
            }
            .margin({
              right: 15,
              bottom: 10
            })
          }
        })
        if (this.imgList.length < this.maxNumber && this.canUpload) {
          GridItem() {
            Row() {
              Image($r("app.media.ic_add_img"))
                .width(30)
                .height(30)
            }
            .width(95)
            .height(95)
            .backgroundColor($r("app.color.upload_panel"))
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              this.selectImage()
            })
          }
        }
      }
      .height(Math.ceil(this.maxNumber / 3) * 105)
      .columnsTemplate("1fr 1fr 1fr")
      .rowsGap(10)
    }.alignItems(HorizontalAlign.Start)
    .width('100%')
  }
}

const UploadFile = async (list: ImageList[]) => {
  const addFolderName = 'wuliu'
  const defaultDir = getContext().cacheDir + '/' + addFolderName // 默认路径
  let files: request.File[] = [] //声明参数
  list.forEach(item => {
    const file = fs.openSync(item.url, fs.OpenMode.READ_ONLY) // 同步读取

    const tempFileName = util.generateRandomUUID() + '.jpg' // 生成一个唯一的文件名 后面有用
    if (!fs.listFileSync(getContext().cacheDir).includes(addFolderName)) {
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
    fs.closeSync(file.fd)
  })
  //输出图片url
  return await uploadImage(getContext(), files)

}


export { HmUpload, UploadFile }