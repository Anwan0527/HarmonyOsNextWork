import { TaskListData, TaskListParams } from '../models'
import { Request } from '../utils'
import { TaskDetailInfoModel } from '../models'

// 获取任务列表

export const getTaskList = (params: TaskListParams) => {
  return Request.get<TaskListData>("/tasks/list", params)
} //todo  修复


export const getTaskDetail = (id: string) => {
  return Request.get<TaskDetailInfoModel>(`/tasks/details/${id}`)
} //todo  我估计也白扯