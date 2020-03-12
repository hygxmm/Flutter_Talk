const ip = require('ip');
const AvatarCount = 8;
const publicPath = `http://${ip.address()}:7001/public/avatar/`;

module.exports = {
    // 封装数据格式
    parseMsg(action, payload = {}, metadata = {}) {
        const meta = Object.assign({}, {
            timestamp: Date.now(),
        }, metadata);

        return {
            meta,
            data: {
                action,
                payload
            },
        };
    },
    // 创建随机头像
    getRandomAvatar() {
        const number = Math.floor(Math.random() * AvatarCount);
        return `${publicPath}/${number}.png`

    }

}