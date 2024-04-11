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

import TaskItemCard from './TaskItemCard'
import { HmList, HmLoading } from '../../../components'
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
  @State allPage: number = 1 // 总页数先设置为1页 后续会更新
  @State
  loading: boolean = false // 是否正在加载中
  @State
  refreshing: boolean = false //下拉

  aboutToAppear() {
    this.getTaskList(true)
  }

  //加载方法进行判断，如果当前页数已经大于总页数，则不能再继续加载，否则继续
  async getTaskList(append: boolean) {
    const result = await getTaskList(this.queryParams)
    // this.taskListData = result.items
    // ---------- 以下为新代码 -------------
    // const req = http.createHttp()
    // req.request(`https://slwl-api.itheima.net/driver/tasks/list?page=${this.queryParams.page}&pageSize=${this.queryParams.pageSize}&status=${this.queryParams.status}`, {
    //   method: http.RequestMethod.GET,
    //   header: {
    //     // Authorization: "eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI0MDQwODA5NTAyMzQ5MTMxNTE0IiwiYWNjb3VudCI6InRlc3QwMDEiLCJuYW1lIjoi5Y-45py6Iiwib3JnaWQiOjEwMjQ5OTA3MjY1MTk0MDM0NTcsInN0YXRpb25pZCI6MTAyNDcwNzUzNTg5MTk0NDc2OSwiYWRtaW5pc3RyYXRvciI6ZmFsc2UsImV4cCI6MTcxMjYxNDUzOX0.yfYpg-JTilGyLEf2Af-sIACUUPNEyvgkQS8WwORHXZu1Ho2vIdFeztIx2S3DREeU1fdPbsCDFbOUd7CKByhXew"
    //     Authorization: this.token
    //   }
    // })// AlertDialog.show({
    //   //   message: JSON.stringify(result)
    //   // })
    //   .then(res => {
    //     const TaskListRes = JSON.parse(res.result.toString()) as ResponseData<TaskListData>
    // this.taskListData = TaskListRes.data?.items!
    if (append) {
      this.taskListData = this.taskListData.concat(result.items || []) // 连接新的数组
    } else {
      this.taskListData = result.items || []
      // this.loading = false // 这行代码必须加- 因为要考虑已经滑到底部的情况，此时loading 为true 如果不开放这个状态 无法进行上拉加载
      // this.refreshing = false // 关闭下拉状态
    }
    this.allPage = result.pages // 赋值总页数
    this.queryParams.page++ // 页码+1
    // AlertDialog.show({
    //   message: JSON.stringify(res.result.toString())
    // })

  }

  async onRefresh() {
    this.allPage = 1
    this.queryParams.page = 1
    await this.getTaskList(false)
    promptAction.showToast({
      message: '刷新成功'
    })
    // this.refreshing = false
  }

  @Builder
  renderItem(item: object) {
    TaskItemCard({ taskItemData: item as TaskInfoItemModel })
  }

  build() {
    HmList({
      onLoad: async () => {
        await this.getTaskList(true)
      },
      onRefresh: async () => {
        await this.onRefresh()
      },
      dataSource: $taskListData,
      renderItem: this.renderItem,
      finished: this.allPage < this.queryParams.page,
      finishText: '没啦没啦',
      loadingText: '拼命加载中'
    })
  }
}


export default TaskList
