import request from '@ohos.request'
import { BASE_URL, TOKEN_KEY } from '../constants'
import { ImageList } from '../models'

import { Request as RequestClass } from '../utils'


class FileParams {
  imageName: string = ""
}




export const uploadImage = async (context: Context, files: request.File[]) => {
  const config: request.UploadConfig = {
    url: `${BASE_URL}/files/imageUpload`,
    method: 'POST',
    header: {
      'Accept': '*/*',
      'Authorization': `${AppStorage.get(TOKEN_KEY)}`,
      'Content-Type': 'multipart/form-data'
    },
    files,
    data: []
  }
  return new Promise <ImageList[]>(async (resolve, reject) => {
    try {
      const UploadTask = await request.uploadFile(context, config)
      UploadTask.on('fail', (state) => {
        AlertDialog.show({
          message: '图片上传失败'
        })

      })
      UploadTask.on('complete', async (data) => {
        //map files图片地址 然后 输出地址
        // req.request("https://slwl-api.itheima.net/driver/files/imageUrl?imageName="+)
        // AlertDialog.show({
        //   message: JSON.stringify(fileName)
        // })
        const result = await Promise.all<string>(files.map(item => RequestClass.get<string>("/files/imageUrl", {
          imageName: item.filename.slice(0, item.filename.indexOf('.'))
        } as FileParams)))
        // AlertDialog.show({
        //   message: JSON.stringify(result)
        // })
        resolve(result.map(url => ({ url } as ImageList)))
      })
    } catch (error) {
      AlertDialog.show({
        message: error.message
      })
    }
  })


}