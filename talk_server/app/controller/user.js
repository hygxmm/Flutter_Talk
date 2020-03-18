const Controller = require('egg').Controller;
const jwt = require('jsonwebtoken');
const assert = require('assert');
const crypto = require('crypto');
const isValid = require('mongoose').Types.ObjectId.isValid;

class UserController extends Controller {
    // 注册
    async register() {
        const { ctx, config } = this;
        const { username, password } = ctx.request.body;
        assert(username, '用户名不能为空');
        assert(password, '密码不能为空');
        const user = await ctx.model.User.findOne({ username });
        assert(!user, '该用户名已存在');
        const hash = crypto.createHmac("sha256", config.secret).update(password).digest("base64");
        let newUser = null;
        try {
            newUser = await ctx.model.User.create({
                username,
                password: hash,
                avatar: ctx.helper.getRandomAvatar(),
            })
        } catch (error) {
            assert(!(error.name === 'ValidationError'), '用户名包含不支持的字符或长度超过限制');
            throw error;
        }
        ctx.body = {
            code: 0,
            message: '注册成功',
            data: {
                id: newUser._id,
                name: newUser.username,
                avatar: newUser.avatar,
            }
        }
    }
    // 登录
    async login() {
        const { ctx, config } = this;
        const { username, password } = ctx.request.body;
        assert(username, '用户名不能为空');
        assert(password, '密码不能为空');
        const user = await ctx.model.User.findOne({ username });
        assert(user, '该用户不存在');
        const hash = crypto.createHmac("sha256", config.secret).update(password).digest("base64");
        assert(user.password === hash, '密码错误');
        user.lastLoginTime = new Date();
        await user.save();
        // 查询好友
        const groups = await ctx.model.Group.find({ members: user }, { _id: 1, nme: 1, avatar: 1, creator: 1, createTime: 1 });
        // 查询好友
        const friends = await ctx.model.Friend.find({ from: user._id }).populate('to', { username: 1, avatar: 1 });
        // 生成 token
        const token = jwt.sign({ uid: user._id }, config.jwt.secret, { expiresIn: '7d' });
        ctx.body = {
            code: 0,
            message: '登录成功',
            data: {
                token,
                groups,
                friends,
                user: {
                    id: user._id,
                    username: user.username,
                    avatar: user.avatar,
                }
            }
        }
    }
    // token 登录
    async loginByToken() {
        const { ctx } = this;
        const user = await ctx.model.User.findOne({ _id: ctx.uid });
        assert(user, '该用户不存在');
        user.lastLoginTime = new Date();
        await user.save();
        // 查询好友
        const groups = await ctx.model.Group.find({ members: user }, { _id: 1, nme: 1, avatar: 1, creator: 1, createTime: 1 });
        // 查询好友
        const friends = await ctx.model.Friend.find({ from: user._id }).populate('to', { username: 1, avatar: 1 });
        // 生成 token
        ctx.body = {
            code: 0,
            message: '登录成功',
            data: {
                groups,
                friends,
                user: {
                    id: user._id,
                    username: user.username,
                    avatar: user.avatar,
                }
            }
        }




    }
    // 修改用户头像
    async changeAvatar() {
        const { ctx } = this;
        const { avatar } = ctx.request.body;
        assert(avatar, '头像连接不能为空');
        await ctx.model.User.updateOne({ _id: ctx.uid }, { avatar });
        ctx.body = {
            code: 0,
            msg: '修改成功',
        }
    }
    // 修改密码
    async changePassword() {
        const { ctx } = this;
        const { oldPassword, newPassword } = ctx.request.body;
        assert(newPassword, '新密码不能为空');
        assert(oldPassword !== newPassword, '新密码不能与旧密码相同');
        const user = await ctx.model.User.findOne({ _id: ctx.uid });
        const hash = crypto.createHmac("sha256", config.secret).update(oldPassword).digest("base64");
        assert(user.password === hash, '旧密码不正确');
        const newHash = crypto.createHmac("sha256", config.secret).update(newPassword).digest("base64");
        user.password = newHash;
        await user.save();
        ctx.body = {
            code: 0,
            msg: '修改成功'
        }
    }
    // 修改昵称
    async changeUsername() {
        const { ctx } = this;
        const { username } = ctx.request.body;
        assert(username, '用户名不能为空');
        const user = await ctx.model.User.findOne({ username });
        assert(!user, '该用户名已存在,换一个试试吧');
        const self = await ctx.model.User.findOne({ _id: ctx.uid });
        self.username = username;
        await self.save();
        ctx.body = {
            code: 0,
            msg: '修改成功'
        }
    }
    // 添加好友
    async addFriend() {
        const { ctx } = this;
        const { userId } = ctx.request.body;
        assert(isValid(userId), '无效的用户ID');
        assert(ctx.uid.toString() !== userId, '不能添加自己为好友');
        const user = await ctx.model.User.findOne({ _id: userId });
        assert(user, '用户不存在');
        const friend = await ctx.model.Friend.find({ from: ctx.uid, to: user._id });
        assert(friend.length === 0, '你们已经是好友了');
        const newFriend = await ctx.model.Friend.create({ from: ctx.uid, to: user._id });

        ctx.body = {
            code: 0,
            msg: '添加成功'
        }
    }
    // 删除好友
    async deleteFriend() {
        const { ctx } = this;
        const { userId } = ctx.request.body;
        assert(isValid(userId), '无效的用户ID');
        const user = await ctx.model.User.findOne({ _id: userId });
        assert(user, '用户不存在');
        await ctx.model.Friend.deleteOne({ from: ctx.uid, to: user._id });
        ctx.body = {
            code: 0,
            msg: '删除成功'
        }
    }
}

module.exports = UserController;
