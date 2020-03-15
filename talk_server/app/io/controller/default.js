const Controller = require('egg').Controller;
const assert = require('assert');
const isValid = require('mongoose').Types.ObjectId.isValid;


class DefaultController extends Controller {
    async exchange() {
        const { ctx, app } = this;
        const nsp = app.io.of('/');
        const message = ctx.args[0] || {};
        const socket = ctx.socket;
        const client = socket.id;
        console.log("message", message)
        console.log("client", client)

        try {
            const { target, payload } = message;
            if (!target) return;
            const msg = ctx.helper.parseMsg('exchange', payload, { client, target });
            nsp.emit(target, msg);
        } catch (error) {
            app.logger.error(error);
        }
    }
    // 发送消息
    // 如果是发送给群组,to是群组id
    // 如果是发送给好友,to是俩人的id按大小序拼接后的值
    async sendMessage() {
        const { ctx } = this;
        let { to, type, content } = ctx.args[0];
        const nsp = app.io.of('/');
        console.log('to', to);
        console.log('type', type);
        console.log('content', content);
        assert(to, '目标ID不能为空');
        let groupId = '', userId = '';
        if (isValid(to)) {
            groupId = to;
            const group = await ctx.model.Group.findOne({ _id: to });
            assert(group, '群组不存在');
        } else {
            userId = to.replace(ctx.socket.user.toString(), '');
            assert(isValid(userId), '无效的用户ID');
            const user = await ctx.model.User.findOne({ _id: userId });
            assert(user, '用户不存在');
        }
        let messageContent = content;
        if (type === 'text') {
            assert(messageContent.length <= 2048, '消息长度超过最大限制');
            const rollRegex = /^-roll(([0-9]*))?$/;
            if (rollRegex.test(messageContent)) {
                const regexResult = rollRegex.exec(messageContent);
                if (regexResult) {
                    let numberStr = regexResult[1] || '100';
                    if (numberStr.length > 5) {
                        numberStr = '99999';
                    }
                    const number = parseInt(numberStr, 10);
                    type = 'system';
                    messageContent = JSON.stringify({
                        command: 'roll',
                        value: Math.floor(Math.random() * (number + 1)),
                        top: number
                    });
                }
            } else if (/^-rps$/.test(messageContent)) {
                type = 'system';
                messageContent = JSON.stringify({
                    command: 'rps',
                    value: RPS[Math.floor(Math.random() * RPS.length)],
                });

            }
            messageContent = xss(messageContent);
        } else if (type == 'invite') {
            const group = await ctx.model.Group.findOne({ _id: to });
            assert(group, '群组不存在');
            const user = await ctx.model.User.findOne({ _id: ctx.socket.user });
            messageContent = JSON.stringify({
                inviter: user.username,
                groupId: group._id,
                groupName: group.name,
            })
        }
        const message = await ctx.model.Message.create({
            from: ctx.socket.user,
            to,
            type,
            content: messageContent,
        });
        const user = await ctx.model.User.findOne({ _id: ctx.socket.user }, { username: 1, avatar: 1 });
        const messageData = {
            _id: message._id,
            createTime: message.createTime,
            from: user.toObject(),
            to,
            type,
            content: messageContent
        }
        if (groupId) {
            ctx.socket.to(groupId).emit('message', messageContent);
        } else {
            const sockets = await ctx.model.Socket.find({ user: userId });
            sockets.forEach(socket => {
                nsp.to(socket.id).emit('message', messageData);
            })
            const selfSockets = await ctx.model.Socket.find({ user: ctx.socket.user });
            selfSockets.forEach(socket => {
                if (socket.id !== ctx.user.id) {
                    nsp.to(socket.id).emit('message', messageData);
                }
            })
        }
    }
}

module.exports = DefaultController;