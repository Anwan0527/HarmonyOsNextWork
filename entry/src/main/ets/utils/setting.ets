import { AdvertClass } from '../models'
import preferences from '@ohos.data.preferences'
import { TOKEN_KEY, USER_SETTING, USER_SETTING_AD } from '../constants'

// 默认广告选项
const defaultAd: AdvertClass = {
  showAd: true,
  adTime: 5,
  adImg: $r('app.media.start')
}

export class UserSettingClass {
  context: Context

  constructor(context: Context) {
    this.context = context
  }

  // 获取存储用户信息的首选项仓库
  getStore() {
    return preferences.getPreferences(this.context, USER_SETTING)
  }

  // 设置用户广告设置
  async setUserAd(ad: AdvertClass) {
    const adStore = await this.getStore()
    await adStore.put(USER_SETTING_AD, JSON.stringify(ad))
    await adStore.flush()
  }

  // 获取广告配置
  async getUserAd(): Promise<AdvertClass> {
    const adStore = await this.getStore()
    return JSON.parse(await adStore.get(USER_SETTING_AD, JSON.stringify(defaultAd)) as string) as AdvertClass
  }

  //没有广告时判断
  async setUserToken(token: string) {
    const adStore = await this.getStore()
    await adStore.put(TOKEN_KEY, token)
    // 写入磁盘
    await adStore.flush()
  }

  async getUserToken(): Promise<string> {
    const adStore = await this.getStore()
    return await adStore.get(TOKEN_KEY, "") as string
  }
}