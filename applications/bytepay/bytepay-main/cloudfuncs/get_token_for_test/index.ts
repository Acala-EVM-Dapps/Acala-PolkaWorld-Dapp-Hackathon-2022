

import cloud from '@/cloud-sdk'

exports.main = async function (ctx: FunctionContext) {
  // body, query 为请求参数, auth 是授权对象
  const { auth, body, query } = ctx

  // 数据库操作
  const db = cloud.database()
  const r = await db.collection('user').where({id: 37979965}).getOne()

  return r.data.token
}
