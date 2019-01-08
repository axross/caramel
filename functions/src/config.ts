import * as functions from 'firebase-functions';

interface Config {
  onesignal: {
    api_key: string;
    channel_ids: {
      chat_message: string;
    };
    app_id: string;
  };
}

export default functions.config() as Config;
