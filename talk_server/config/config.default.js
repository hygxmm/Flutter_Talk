const path = require('path');

module.exports = appInfo => {
	return {
		keys: appInfo.name + '_1583485072824_1796',
		middleware: [],
		cors: {
			origin: '*',
			allowMethods: 'GET,HEAD,PUT,POST,DELETE,PATCH,OPTIONS'
		},
		security: {
			csrf: {
				enable: false,
			},
			domainWhiteList: ['*'],
		},
		jwt: {
			secret: 'gfkb2q14bso1do0u1a4a',
		},
		// 密码加盐
		secret: 'svr894p5gpg1do19618t',
		mongoose: {
			client: {
				url: 'mongodb://127.0.0.1/Talk',
				options: {
					useNewUrlParser: true,
					useFindAndModify: false,
					useUnifiedTopology: true
				},

			}
		},
		static: {
			prefix: '/public/',
			dir: path.join(appInfo.baseDir, 'app/public'),
			dynamic: true,
			preload: false,
			buffer: false,
			maxFiles: 1000
		},
		io: {
			namespace: {
				'/': {
					connectionMiddleware: ['connection'],
					packetMiddleware: ['packet'],
				}
			},
		}
	}
};

