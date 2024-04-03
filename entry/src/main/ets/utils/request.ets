import http from '@ohos.net.http'
import { BASE_URL, TOKEN_KEY } from '../constants'
import { ResponseData } from '../models'
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { UserSettingClass } from '.';

const httpRequest = http.createHttp()

async function requestHttp<T>(url: string = "", method: http.RequestMethod = http.RequestMethod.GET, data?: object): Promise<T> {
  let urlStr = BASE_URL + url
  // 这里虽然官方文档说 get类型可以通过extraData传递过去，但是测试证明不可以-还是老老实实的自己拼接吧
  if (method === http.RequestMethod.GET) {
    if (data && Object.keys(data).length) {
      urlStr += "?" + Object.keys(data).map(key => {
        if (data[key]) {
          return `${key}=${data[key]}`
        }
        return ""
      }).join('&')
    }
    // AlertDialog.show({
    //   message: urlStr
    // })
  }
  // 设置请求头
  const config: http.HttpRequestOptions = {
    header: {
      'Content-Type': 'application/json',
      "Authorization": AppStorage.get(TOKEN_KEY) || ""
    },
    method,
    readTimeout: 10000, // 超时时间
    extraData: method === http.RequestMethod.GET ? "" : data
  }
  try {
    const res = await httpRequest.request(urlStr, config)
    // AlertDialog.show({
    //   message: res.responseCode.toString()
    // })
    if (res.responseCode === 401) {
      promptAction.showToast({ message: 'token超时' })
      AppStorage.set(TOKEN_KEY, "") // 删除token 这里为什么不用Delete
      new UserSettingClass(getContext()).setUserToken("") // 清空首选项的token
      router.replaceUrl({
        url: 'pages/Login/Login'
      })
      return Promise.reject(new Error("token不存在或超时"))
    } else if (res.responseCode === 404) {
      promptAction.showToast({ message: '请求地址不正确' })
      return Promise.reject(new Error('请求地址不正确'))
    }
    else {
      const result = JSON.parse(res.result as string) as ResponseData<T>
      if (result.code === 200) {
        // 执行成功
        // AlertDialog.show({
        //   message: "执行成功"
        // })
        return result.data as T // 直接返回数据
      }
      else {
        promptAction.showToast({ message: '服务器异常' })
        return Promise.reject(new Error(result.msg))
      }
    }
  } catch (error) {
    AlertDialog.show({
      message: error
    })
    promptAction.showToast({ message: error.message })
    return Promise.reject(error)
  }
  finally {
    httpRequest.destroy(); // 销毁请求
  }
}

// 导出一个类的静态方法
export class Request {
  static get<T>(url: string, data?: object): Promise<T> {
    // console.log("url", url)
    return requestHttp<T>(url, http.RequestMethod.GET, data)

  }

  static post<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.POST, data)
  }

  static delete<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.DELETE, data)
  }

  static put<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.PUT, data)
  }
}
