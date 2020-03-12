const jwt = require('jsonwebtoken');

module.exports = (options, app) => {
    return async function userInterceptor(ctx, next) {
        let authToken = ctx.get('Authorization');
        console.log('Token=======>', authToken)
        if (authToken) {
            let decoded = jwt.verify(authToken, ctx.app.config.jwt.secret);
            const { uid, iat, exp } = decoded;
            let nowDate = new Date().getTime();
            if (nowDate >= exp * 1000) {
                ctx.body = {
                    code: 202,
                    msg: 'token失效',
                    data: null
                }
            } else {
                ctx.uid = uid;
                await next();
            }
        } else {
            ctx.body = {
                code: 201,
                msg: '未登录',
                data: null
            }
        }
    }
}