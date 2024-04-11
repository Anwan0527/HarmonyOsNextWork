import request from '@ohos.request'
import { BASE_URL, TOKEN_KEY } from '../constants'

import { Request as RequestClass } from '../utils'
import http from '@ohos.net.http'

class FileParams {
  imageName: string = ""
}

interface filesRes {
  filename: string,
  name: string,
  uri: string,
  type: string
}

interface EndNum {
  end: number,
  filenamed: string,
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
  try {
    const UploadTask = await request.uploadFile(context, config)
    UploadTask.on('fail', (state) => {
      AlertDialog.show({
        message: '图片上传失败'
      })
    })
    UploadTask.on('complete', async (data) => {

      const token: string = AppStorage.get(TOKEN_KEY)!
      //map files图片地址 然后 输出地址
      // req.request("https://slwl-api.itheima.net/driver/files/imageUrl?imageName="+)
      const req = http.createHttp()
      const testmessage = files.map<string>(item => item.filename)

      AlertDialog.show({
        message: testmessage.toString()
      })
      req.request("https://slwl-api.itheima.net/driver/files/imageUrl?=" + testmessage.slice(0, testmessage.length - 4), {
        method: http.RequestMethod.GET,
        header: {
          // Authorization: "eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI0MDQwODA5NTAyMzQ5MTMxNTE0IiwiYWNjb3VudCI6InRlc3QwMDEiLCJuYW1lIjoi5Y-45py6Iiwib3JnaWQiOjEwMjQ5OTA3MjY1MTk0MDM0NTcsInN0YXRpb25pZCI6MTAyNDcwNzUzNTg5MTk0NDc2OSwiYWRtaW5pc3RyYXRvciI6ZmFsc2UsImV4cCI6MTcxMjYxNDUzOX0.yfYpg-JTilGyLEf2Af-sIACUUPNEyvgkQS8WwORHXZu1Ho2vIdFeztIx2S3DREeU1fdPbsCDFbOUd7CKByhXew"
          Authorization: token
        }
      })
        .then(res => {
          AlertDialog.show({
            message: JSON.stringify(res.result.toString())
          })
        })
      // AlertDialog.show({
      //   message: JSON.stringify(fileName)
      // })
      // const result = await Promise.all<string>(files.map(item => RequestClass.get<string>("/files/imageUrl", {
      //   imageName: item.filename.slice(0, item.filename.indexOf('.'))
      // } as FileParams)))

    })
  } catch (error) {
    AlertDialog.show({
      message: error.message
    })
  }

}