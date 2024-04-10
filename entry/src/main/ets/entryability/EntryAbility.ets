import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import hilog from '@ohos.hilog';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import { UserSettingClass } from '../utils';
import { AdvertClass } from '../models';
import http from '@ohos.net.http';


export default class EntryAbility extends UIAbility {
  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    const userSetting = new UserSettingClass(this.context)
    // 这里要尝试去读一下运营的配置-我们现在还没有实现接口，直接模拟一下
    // const result = await new Promise<AdvertClass>((resolve, reject) => {
    //   setTimeout(() => {
    //     resolve({
    //       showAd: true,
    //       adTime: 10,
    //       adImg: "https://pic1.zhimg.com/50/fe762e46aff74bfb5ffe6a7bee3bda70_hd.jpg"
    //     } as AdvertClass)
    //   }, 500)
    // })
    // await userSetting.setUserAd(result) // 写入首选项
    const adSetting = await userSetting.getUserAd()

    if (adSetting.showAd) {
      // 显示广告
      windowStage.loadContent('pages/Start/Start'); // 跳转广告页
    } else {
      const token = await userSetting.getUserToken()
      // AlertDialog.show({
      //   message: JSON.stringify(token)
      // })
      if (token) {
        // 有token
        windowStage.loadContent('pages/Index/Index'); //跳转首页
      } else {
        windowStage.loadContent('pages/Login/Login'); //跳转登陆页
      }
    }
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
