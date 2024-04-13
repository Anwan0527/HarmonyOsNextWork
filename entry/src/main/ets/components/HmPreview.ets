@CustomDialog
@Component
struct HmPreview {
  controller: CustomDialogController
  // 接收传入的图片列表
  urls: string [] = []
  selectIndex: number = -1
  build() {
     Column() {
       Row() {
         Swiper() {
           // N个的图片
           ForEach(this.urls, (url: string) => {
             Image(url)
               .width('100%')
               .objectFit(ImageFit.Cover)
           })
         }
         .indicator(false)
         .index(this.selectIndex) // 设置显示第几个
       }.height('100%')
       .onClick(() => {
         this.controller.close()
       })
     }
    .height('100%')
     .width('100%')
     .backgroundColor($r('app.color.black'))
  }
}
export { HmPreview  }