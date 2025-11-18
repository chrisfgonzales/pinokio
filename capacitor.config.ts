import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'computer.pinokio',
  appName: 'Pinokio',
  webDir: 'www',
  server: {
    androidScheme: 'https',
    // For development, you can connect to local server
    // url: 'http://localhost:42000',
    // cleartext: true
  },
  android: {
    buildOptions: {
      keystorePath: undefined,
      keystoreAlias: undefined,
    }
  }
};

export default config;
