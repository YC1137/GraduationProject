import request from './request'

export const mintDigitalAsset = async (payload) => {
  return request.post('/digital-asset/mint', payload, { timeout: 120000 })
}

export const getUserDigitalAssets = async (userId) => {
  return request.get(`/digital-asset/user/${userId}`)
}

export const getDigitalCollectionList = async (saleStatus) => {
  const params = saleStatus ? { saleStatus } : {}
  return request.get('/digital-collection/list', { params })
}

