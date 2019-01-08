import axios from 'axios';
import config from '../config';

const onesignalAxios = axios.create({
  baseURL: 'https://onesignal.com/api/v1',
  headers: {
    authorization: `Basic ${config.onesignal.api_key}`,
  },
});

export default onesignalAxios;
