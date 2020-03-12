const Controller = require('egg').Controller;
const jwt = require('jsonwebtoken');
const assert = require('assert');
const crypto = require('crypto');

class UserController extends Controller {
    /**
     * 注册
     * params { username }
     * params { password }
     */
    async register() {
        const { ctx, config } = this;
        const { username, password } = ctx.request.body;
        assert(username, '用户名不能为空');
        assert(password, '密码不能为空');
        const user = await ctx.service.user.findUserByName(username);
        assert(!user, '该用户名已存在');
        const hash = crypto.createHmac("sha256", config.secret).update(password).digest("base64");
        const avatar = 'http://localhost:7001/public/avatar/' + Math.ceil(Math.random() * 8) + '.png';
        const newUser = await ctx.service.user.createUser(username, hash, avatar);
        if (newUser) {
            ctx.body = {
                code: 0,
                message: '注册成功',
                data: {
                    // token,
                    user: {
                        id: newUser._id,
                        name: newUser.username,
                        avatar: newUser.avatar,
                    }
                }
            }
        } else {
            ctx.body = {
                code: 1,
                message: '用户名不符合要求',
                data: null
            }
        }
    }
    /**
     * 登录
     * params { username }
     * params { password }
     */
    async login() {
        const { ctx, config } = this;
        const { username, password } = ctx.request.body;
        assert(username, '手机号不能为空');
        assert(password, '密码不能为空');
        const user = await ctx.service.user.findUserByName(username);
        assert(user, '未找到此用户');
        const hash = crypto.createHmac("sha256", config.secret).update(password).digest("base64");
        if (user.password === hash) {
            await ctx.service.user.updateUser([{ 'lastLoginTime': Date.now() }]);
            // //生成 token
            const token = jwt.sign({ uid: user._id }, config.jwt.secret, { expiresIn: '7d' })
            ctx.body = {
                code: 0,
                message: '登录成功',
                data: {
                    token,
                    user: {
                        id: user._id,
                        name: user.username,
                        avatar: user.avatar,
                    }
                }
            }
        } else {
            ctx.body = {
                code: 1,
                msg: '账号或密码错误',
                data: null,
            }
        }
    }
    /**
     * 获取用户信息
     */
    async userInfo() {
        const { ctx, config } = this;
        const token = ctx.get('Token');
        var decoded = jwt.verify(token, config.jwt.secret);
        try {
            const user = await ctx.service.public.findUserById(decoded.uid);
            if (user) {
                ctx.body = {
                    code: 0,
                    msg: '查询成功',
                    data: user
                }
            } else {
                ctx.body = {
                    code: 1,
                    msg: '查询失败',
                    data: null
                }
            }
        } catch (error) {
            ctx.body = {
                code: 1,
                msg: 'token不合法',
                data: null
            }
        }
    }
    /**
     * 修改用户信息
     */
    async editUser() {
        const { ctx } = this;
        const { } = ctx.request.body; // post 获取参数
        ctx.body = 'hi, egg';
    }
}

module.exports = UserController;
