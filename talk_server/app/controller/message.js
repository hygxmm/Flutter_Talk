const Controller = require('egg').Controller;
const assert = require('assert');
const isValid = require('mongoose').Types.ObjectId.isValid;

class MessageController extends Controller {
    // 获取一组联系人的最后历史消息
    async getLinkmansLastMessages() {
        const { ctx } = this;
        const { linkmans } = ctx.request.body;
        assert(Array.isArray(linkmans), '参数linkmans应该是Array');
        const promises = linkmans.map(linkman => {
            return ctx.model.Message.find(
                { to: linkman },
                { type: 1, content: 1, from: 1, createTime: 1 },
                { sort: { createTime: -1, limit: 15 } },
            ).populate('from', { username: 1, avatar: 1 });
        })
        const results = await Promise.all(promises);
        const messages = linkmans.reduce((result, linkman, index) => {
            result[linkman] = (results[index] || []).reverse();
            return result;
        }, {});
        ctx.body = {
            code: 0,
            msg: '获取成功',
            data: messages,
        }
    }
    // 获取联系人的历史消息
    async getLinkmanHistoryMessage() {
        const { ctx } = this;
        const { linkman, existCount } = ctx.request.body;
        const messages = await ctx.model.Message.find(
            { to: linkman },
            { type: 1, content: 1, from, createTime: 1 },
            { sort: { createTime: -1 }, limit: existCount + 30 },
        ).populate('from', { username: 1, avatar: 1 });
        const result = messages.slice(existCount).reverse();
        ctx.body = {
            code: 0,
            msg: '获取成功',
            data: result,
        }

    }

}

module.exports = MessageController;