@Preview
@Component
struct HmLoading {
  @State
  num: number = 0
  maxNumber: number = 100
  timer: number = -1
  hWidth: number = 40

  aboutToAppear() {
    this.timer = setInterval(() => {
      if (this.num === this.maxNumber) {
        this.num = 0
      }
      this.num++
    }, 10)
  }

  aboutToDisappear() {
    clearInterval(this.timer)
  }

  build() {
    Progress({
      value: this.num,
      total: this.maxNumber,
      type: ProgressType.ScaleRing
    }).color($r('app.color.text_secondary'))
      .width(this.hWidth)
      .style({ strokeWidth: 2 })
  }
}

export { HmLoading }