import { TOKEN_KEY } from '../../constants'
import { TabClass } from '../../models'
import My from './My/My'
import TaskTabs from './Task/TaskTabs'

PersistentStorage.persistProp(TOKEN_KEY, "")

@Entry
@Component
struct Index {
  @State tabsData: TabClass[] = [{
    title: '任务',
    name: 'task',
    icon: $r("app.media.ic_tab_btn_task")
  }, {
    title: '消息',
    name: 'message',
    icon: $r("app.media.ic_tab_btn_mess_nor")
  }, {
    title: '我的',
    name: 'my',
    icon: $r("app.media.ic_tab_btn_mine_nor")
  }]
  @State currentName: string = 'task'

  @Builder
  getTabBar(item: TabClass) {
    Column() {
      Image(item.icon).width(22).height(22).fillColor(item.name === this.currentName ?
      $r('app.color.primary') : $r('app.color.text_secondary'))
      Text(item.title)
        .fontSize(12)
        .fontWeight(400)
        .fontColor(item.name === this.currentName ?
        $r('app.color.primary') : $r('app.color.text_secondary'))
        .margin({ top: 5 })
    }.alignItems(HorizontalAlign.Center)
  }

  build() {
    Tabs({ barPosition: BarPosition.End }) {
      ForEach(this.tabsData, (item: TabClass) => {
        TabContent() {
          if (item.name === 'task') {
            TaskTabs()
          }
          else if (item.name === 'message') {
            Text("消息组件")
          }
          else {
            My() //todo 代码美化
          }
        }
        .tabBar(this.getTabBar(item))
      })
    }
    .onChange(index => {
      this.currentName = this.tabsData[index].name
    })
    .animationDuration(300)
  }
}