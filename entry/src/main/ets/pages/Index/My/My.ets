import { getUserInfo, getUserTaskInfo } from '../../../api'
import { HmCard, HmCardItem } from '../../../components'

import {
  ResponseData,
  UserInfo,
  UserInfoModel,
  UserTaskInfo,
  UserTaskInfoModel,
  UserTaskInfoParamsModel
} from '../../../models'
import router from '@ohos.router'
import { TOKEN_KEY } from '../../../constants'
import { http } from '@kit.NetworkKit'


@Preview
@Component
struct My {
  @State token: string = ''
  @State //获取个人信息
  userInfo: UserInfoModel = new UserInfoModel({} as UserInfo)
  @State //获取任务数据
  userTaskInfo: UserTaskInfoModel = new UserTaskInfoModel({} as UserTaskInfo)
  queryTaskParams: UserTaskInfoParamsModel = new UserTaskInfoParamsModel({
    year: new Date().getFullYear().toString(),
    month: (new Date().getMonth() + 1).toString()
  })

  aboutToAppear() {
    this.token = AppStorage.get(TOKEN_KEY)!
    this.getUserInfo()
    this.getUserTaskInfo()
    // AlertDialog.show({
    //   message: JSON.stringify(AppStorage.get(TOKEN_KEY))
    // })
  }

  async getUserTaskInfo() {
    // this.userTaskInfo = await getUserTaskInfo(this.queryTaskParams)
    const req = http.createHttp()
    req.request("https://slwl-api.itheima.net/driver/users/taskReport?month=" + this.queryTaskParams.month + "&year=" + this.queryTaskParams.year, {
      method: http.RequestMethod.GET,
      header: {
        // Authorization: "eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI0MDQwODA5NTAyMzQ5MTMxNTE0IiwiYWNjb3VudCI6InRlc3QwMDEiLCJuYW1lIjoi5Y-45py6Iiwib3JnaWQiOjEwMjQ5OTA3MjY1MTk0MDM0NTcsInN0YXRpb25pZCI6MTAyNDcwNzUzNTg5MTk0NDc2OSwiYWRtaW5pc3RyYXRvciI6ZmFsc2UsImV4cCI6MTcxMjYxNDUzOX0.yfYpg-JTilGyLEf2Af-sIACUUPNEyvgkQS8WwORHXZu1Ho2vIdFeztIx2S3DREeU1fdPbsCDFbOUd7CKByhXew"
        Authorization: this.token
      }
    })
      .then(res => {
        const usertaskinfo = JSON.parse(res.result.toString()) as ResponseData<UserTaskInfoModel>
        // AlertDialog.show({
        //   message: JSON.stringify(res.result.toString())
        // })
        this.userTaskInfo = usertaskinfo.data as UserTaskInfoModel

      })
  }

  async getUserInfo() {
    const req = http.createHttp()
    req.request("https://slwl-api.itheima.net/driver/users", {
      method: http.RequestMethod.GET,
      header: {
        // Authorization: "eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI0MDQwODA5NTAyMzQ5MTMxNTE0IiwiYWNjb3VudCI6InRlc3QwMDEiLCJuYW1lIjoi5Y-45py6Iiwib3JnaWQiOjEwMjQ5OTA3MjY1MTk0MDM0NTcsInN0YXRpb25pZCI6MTAyNDcwNzUzNTg5MTk0NDc2OSwiYWRtaW5pc3RyYXRvciI6ZmFsc2UsImV4cCI6MTcxMjYxNDUzOX0.yfYpg-JTilGyLEf2Af-sIACUUPNEyvgkQS8WwORHXZu1Ho2vIdFeztIx2S3DREeU1fdPbsCDFbOUd7CKByhXew"
        Authorization: this.token
      }
    })
      .then(res => {
        const userinfo = JSON.parse(res.result.toString()) as ResponseData<UserInfoModel>
        this.userInfo = userinfo.data as UserInfoModel
        // AlertDialog.show({
        //   message: JSON.stringify(userinfo)
        // })
      })

  }

  build() {
    Column() {
      // 基本信息
      Column() {
        Image(this.userInfo.avatar || $r("app.media.ic_avatar_driver"))
          .width(67)
          .height(67)
          .borderRadius(34.5)
          .backgroundColor($r('app.color.white'))
        Text(this.userInfo.name || "司机")
          .fontSize(18)
          .fontWeight(600)
          .lineHeight(25)
          .margin({
            top: 9,
            bottom: 9
          })
          .fontColor($r('app.color.white'))
        Text(`司机编号: ${this.userInfo.number}`)
          .fontSize(14)
          .fontWeight(400)
          .lineHeight(20)
          .fontColor($r('app.color.white'))
        Text(`手机号: ${this.userInfo.phone}`)
          .fontSize(14)
          .fontWeight(400)
          .lineHeight(20)
          .margin({
            top: 10
          })
          .fontColor($r('app.color.white'))
      }
      .backgroundImage($r("app.media.bg_page_my"))
      .backgroundImageSize(ImageSize.Cover)
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .height(292)
      .margin({
        top: -2
      })

      // 本月任务
      Column() {
        Text("- 本月任务 -").fontSize(14).fontColor($r('app.color.text_secondary')).lineHeight(20)
        Row() {
          Column() {
            Text(this.userTaskInfo.taskAmounts?.toString() || '')
              .fontSize(18)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(25)
              .margin({
                bottom: 17
              })
            Text("任务总量").fontSize(12).fontColor($r('app.color.text_primary')).lineHeight(17)
          }.justifyContent(FlexAlign.SpaceAround).layoutWeight(1)

          Column() {
            Text(this.userTaskInfo.completedAmounts?.toString() || '')
              .fontSize(18)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(25)
              .margin({ bottom: 17 })
            Text("完成任务量").fontSize(12).fontColor($r('app.color.text_primary')).lineHeight(17)
          }.justifyContent(FlexAlign.SpaceAround).layoutWeight(1)

          Column() {
            Text(this.userTaskInfo.transportMileage?.toString() || '')
              .fontSize(18)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(25)
              .margin({ bottom: 17 })
            Text("运输里程(km)").fontSize(12).fontColor($r('app.color.text_primary')).lineHeight(17)
          }.justifyContent(FlexAlign.SpaceAround).layoutWeight(1)
        }.justifyContent(FlexAlign.SpaceBetween).width('100%').layoutWeight(1)
      }
      .backgroundColor($r('app.color.white'))
      .borderRadius(8)
      .margin({ left: 14.5, right: 14.5, top: -55, bottom: 15 })
      .height(134)
      .padding({ top: 13.5, bottom: 13.5 })
      .justifyContent(FlexAlign.SpaceBetween)

      // 信息列表---用HmCard 和HmCardItem 抽取
      HmCard() {
        HmCardItem({ leftTitle: '车辆信息', rightText: '' })
        HmCardItem({ leftTitle: '任务设置', rightText: '' })
        HmCardItem({
          leftTitle: '系统设置', rightText: '', onRightClick: () => {
            router.pushUrl({
              url: 'pages/Setting/Setting'
            })
          }
        })
      }

    }.width('100%').height('100%').backgroundColor($r('app.color.background_page')).borderRadius(8)
  }
}

export default My