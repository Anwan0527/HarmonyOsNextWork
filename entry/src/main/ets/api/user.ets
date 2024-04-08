import { Request } from '../utils'
import { LoginFormModel, UserInfoModel, UserTaskInfoModel, UserTaskInfoParamsModel } from '../models'

// 登录接口实现
export const login = (data: LoginFormModel) => {
  return Request.post<string>("/login/account", data)
}

// 获取用户信息
export const getUserInfo = () => {
  return Request.get<UserInfoModel>("/users")
} //todo 修复

// 获取用户任务数据
export const getUserTaskInfo = (data: UserTaskInfoParamsModel) => {
  return Request.get<UserTaskInfoModel>("/users/taskReport", data)
} //todo 修复