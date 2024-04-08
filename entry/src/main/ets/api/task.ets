import { TaskListData, TaskListParams } from '../models'
import { Request } from '../utils'

// 获取任务列表

export const getTaskList = (params: TaskListParams) => {
  return Request.get<TaskListData>("/tasks/list", params)
} //todo  修复