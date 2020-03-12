const Service = require('egg').Service;

class UserService extends Service {
    // 根据id查找用户
    async findUserById(uid) {
        const { ctx } = this;
        const user = await ctx.model.User.findOne({ _id: uid }, { _id: 1, username: 1, avatar: 1, mobile: 1 });
        return user;
    }
    // 根据手机号查找用户
    async findUserByName(username) {
        const { ctx } = this;
        const user = await ctx.model.User.findOne({ username });
        return user;
    }
    // 创建用户
    async createUser(username, password, avatar) {
        const { ctx } = this;
        const user = await ctx.model.User.create({ username, password, avatar });
        return user;
    }
    // 更新用户信息
    async updateUser(params) {
        const { ctx } = this;
        await ctx.model.User.updateOne(...params)
    }
}

module.exports = UserService;
