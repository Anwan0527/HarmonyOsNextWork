import { HmLoading } from './HmLoading'

@Component
struct HmList {
  @State
  refreshIng: boolean = false // 控制下拉刷新
  @State
  loading: boolean = false // 控制上拉加载
  @Prop
  finished: boolean // 是否结束
  @Link
  dataSource: object[] // 数据源
  @BuilderParam
  renderItem: (item: object) => void
  loadingText: string = "加载数据中" // 加载中文本
  finishText: string = "没有内容啦" // 结束文本
  showLoadingIcon: boolean = true // 是否显示加载进度
  onLoad: () => void = () => {
  } // 上拉加载函数
  onRefresh: () => void = () => {
  } // 下拉刷新函数

  // 获取底部显示的文本
  @Builder
  getBottomDisplay() {
    Row({ space: 10 }) {
      if (this.finished) {
        Text(this.finishText)
          .fontSize(14)
          .fontColor($r("app.color.text_secondary"))
      } else {
        if (this.loading) {
          Text(this.loadingText)
            .fontSize(14)
            .fontColor($r("app.color.text_secondary"))
          if (this.showLoadingIcon) {
            HmLoading({
              hWidth: 20
            })
          }
        }
      }
    }
    .height(50)
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Refresh({ refreshing: $$this.refreshIng }) {
      List() {
        ForEach(this.dataSource, (item: object) => {
          ListItem() {
            if (this.renderItem) {
              this.renderItem(item)
            }
          }.width('100%')
        })
        ListItem() {
          this.getBottomDisplay()
        }
      }
      .onReachEnd(async () => {
        if (!this.finished && !this.loading) {
          this.loading = true
          await this.onLoad()
          this.loading = false
        }
      })
    }
    .onStateChange(async value => {
      if (value === RefreshStatus.Refresh) {
        await this.onRefresh()
        this.refreshIng = false
        this.loading = false
      }
    })
  }
}

export { HmList }