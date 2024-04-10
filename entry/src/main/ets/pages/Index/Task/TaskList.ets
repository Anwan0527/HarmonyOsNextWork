import { getTaskList } from '../../../api/task'
import {
  ResponseData,
  TaskInfoItem,
  TaskInfoItemModel,
  TaskListData,
  TaskListParams,
  TaskListParamsModel,
  TaskTypeEnum
} from '../../../models'
import { http } from '@kit.NetworkKit'
import { TOKEN_KEY } from '../../../constants'
import TaskItemCard from './TaskItemCard'
import { HmLoading } from '../../../components'
import { promptAction } from '@kit.ArkUI'

@Preview
@Component
struct TaskList {
  @State
  queryParams: TaskListParams = new TaskListParamsModel({
    status: TaskTypeEnum.Waiting,
    page: 1,
    pageSize: 5,

  } as TaskListParams)
  @State
  taskListData: TaskInfoItem[] = []
  @State token: string = ''
  @State allPage: number = 1 // 总页数先设置为1页 后续会更新
  @State
  loading: boolean = false // 是否正在加载中
  @State
  refreshing: boolean = false //下拉

  aboutToAppear() {
    this.token = AppStorage.get(TOKEN_KEY)!
    console.log("token", this.token)
    // this.getTaskList()
  }

  //加载方法进行判断，如果当前页数已经大于总页数，则不能再继续加载，否则继续
  async getTaskList(append: boolean) {
    // const result = await getTaskList(this.queryParams)
    // this.taskListData = result.items
    // ---------- 以下为新代码 -------------
    const req = http.createHttp()
    req.request(`https://slwl-api.itheima.net/driver/tasks/list?page=${this.queryParams.page}&pageSize=${this.queryParams.pageSize}&status=${this.queryParams.status}`, {
      method: http.RequestMethod.GET,
      header: {
        // Authorization: "eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI0MDQwODA5NTAyMzQ5MTMxNTE0IiwiYWNjb3VudCI6InRlc3QwMDEiLCJuYW1lIjoi5Y-45py6Iiwib3JnaWQiOjEwMjQ5OTA3MjY1MTk0MDM0NTcsInN0YXRpb25pZCI6MTAyNDcwNzUzNTg5MTk0NDc2OSwiYWRtaW5pc3RyYXRvciI6ZmFsc2UsImV4cCI6MTcxMjYxNDUzOX0.yfYpg-JTilGyLEf2Af-sIACUUPNEyvgkQS8WwORHXZu1Ho2vIdFeztIx2S3DREeU1fdPbsCDFbOUd7CKByhXew"
        Authorization: this.token
      }
    })// AlertDialog.show({
      //   message: JSON.stringify(result)
      // })
      .then(res => {
        const TaskListRes = JSON.parse(res.result.toString()) as ResponseData<TaskListData>
        // this.taskListData = TaskListRes.data?.items!
        if (append) {
          this.taskListData = this.taskListData.concat(TaskListRes.data?.items!) // 连接新的数组
        } else {
          this.taskListData = TaskListRes.data?.items!
          this.loading = false // 这行代码必须加- 因为要考虑已经滑到底部的情况，此时loading 为true 如果不开放这个状态 无法进行上拉加载
          this.refreshing = false // 关闭下拉状态
        }
        this.allPage = TaskListRes.data!.pages // 赋值总页数
        this.queryParams.page++ // 页码+1
        // AlertDialog.show({
        //   message: JSON.stringify(res.result.toString())
        // })
      })
  }

  async onRefresh() {
    this.allPage = 1
    this.queryParams.page = 1
    await this.getTaskList(false)
    promptAction.showToast({
      message: '刷新成功'
    })
  }

  build() {
    Refresh({ refreshing: $$this.refreshing }) {
      List() {
        ForEach(this.taskListData, (item: TaskInfoItemModel) => {
          ListItem() {
            TaskItemCard({ taskItemData: item })
          }
        })
        // ListItem() {
        //   this.getBottomDisplay() // 底部显示内容 todo 修复不显示的bug  --屌用没有
        // }

      }
      .onReachEnd(async () => {
        if (this.allPage >= this.queryParams.page) {
          if (!this.loading) {
            this.loading = true
            await this.getTaskList(true)
            // await this.getTaskList()
            this.loading = this.allPage < this.queryParams.page ? true : false
          }
        }
      })
    }
    .onStateChange((value: RefreshStatus) => {
      if (value === RefreshStatus.Refresh) {
        this.onRefresh()
      }
    })

  }

  //声明一个Builder来控制底部的显示和控制
  // 获取底部显示的文本
  @Builder
  getBottomDisplay() {
    Row({ space: 10 }) {
      if (this.loading) {
        Text(this.allPage < this.queryParams.page ? "已经没有内容拉" : "加载数据中")
          .fontSize(14)
          .fontColor($r("app.color.text_secondary"))
        if (this.allPage >= this.queryParams.page) {
          HmLoading({
            hWidth: 20
          })
        }
      }
    }
    .height(50)
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}

export default TaskList
