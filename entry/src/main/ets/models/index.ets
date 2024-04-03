export * from './advert'

export * from './user'

export * from './tab'

export class ResponseData<T> {
  code: number = 0
  msg: string = ""
  data: T | null = null // 这里应该必须只能这么声明！！！！
}

