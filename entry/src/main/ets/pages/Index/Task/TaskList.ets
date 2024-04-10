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

  aboutToAppear() {
    this.token = AppStorage.get(TOKEN_KEY)!
    console.log("token", this.token)
    this.getTaskList()
  }

  async getTaskList() {
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
        this.taskListData = TaskListRes.data?.items!
        AlertDialog.show({
          message: JSON.stringify(res.result.toString())
        })

      })
  }

  build() {
    List() {
      ForEach(this.taskListData, (item: TaskInfoItemModel) => {
        ListItem() {
          TaskItemCard({ taskItemData: item })
        }
      })
    }
  }
}

export default TaskList
