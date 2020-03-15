const Controller = require('egg').Controller;
const assert = require('assert');
// const isValid = require('mongoose').Types.ObjectId.isValid;

class SystemController extends Controller {
    // 搜索用户和群组
    async search() {
        const { ctx } = this;
        const { keywords } = ctx.request.body;
        assert(keywords, '请输入关键字');
        const users = await ctx.model.User.find({ username: { $regex: keywords } }, { avatar: 1, username: 1 });
        const groups = await ctx.model.Group.find({ name: { $regex: keywords } }, { avatar: 1, name: 1, members: 1 });
        ctx.body = {
            code: 0,
            msg: '查询成功',
            data: {
                users,
                groups: groups.map(group => {
                    return {
                        _id: group._id,
                        avatar: group.avatar,
                        name: group.name,
                        members: group.members.length
                    }
                })
            }
        };
    }
}

module.exports = SystemController;
