const Controller = require('egg').Controller;
const jwt = require('jsonwebtoken');
const assert = require('assert');
const crypto = require('crypto');
const isValid = require('mongoose').Types.ObjectId.isValid;

class GroupController extends Controller {
    // 创建群组
    async createGroup() {
        const { ctx, config } = this;
        const ownGroupCount = await ctx.model.Group.count({ creator: ctx.uid });
        assert(ownGroupCount < 3, '创建群组失败,你已经创建了3个群组啦');
        const { name } = ctx.request.body;
        assert(name, '群组名不能为空');
        const group = await ctx.model.Group.findOne({ name });
        assert(!group, '该群组已存在');
        let newGroup = null;
        try {
            newGroup = await ctx.model.Group.create({
                name,
                avatar: ctx.helper.getRandomAvatar(),
                creator: ctx.uid,
                members: [ctx.uid]
            }, { _id: 1, name: 1, avatar: 1, createTime: 1, creator: 1 });
        } catch (error) {
            if (error.name === 'ValidationError') {
                return '群组名包含不支持的字符或者长度超过限制';
            }
            throw error;
        }
        ctx.socket.join(newGroup._id);
        ctx.body = {
            code: 0,
            msg: '创建成功',
            data: newGroup
        };
    }
    // 加入群组
    async joinGroup() {
        const { ctx } = this;
        const { groupId } = ctx.request.body;
        assert(isValid(groupId), '无效的群组id');
        const group = await ctx.model.Group.findOne({ _id: groupId });
        assert(group, '群组不存在')
        assert(!group.members.includes(ctx.uid), '你已经在群组中');
        group.members.push(ctx.uid);
        await ctx.model.Group.save();
        const message = await ctx.model.Message.find(
            { toGroup: groupId },
            { type: 1, content: 1, from: 1, createTime: 1 },
            { sort: { createTime: -1 }, limit: 3 },
        ).populate('from', { username: 1, avatar: 1 });
        message.reverse();
        ctx.socket.join(group._id.toString());
        ctx.body = {
            code: 0,
            msg: '加入成功',
            data: {
                _id: group._id,
                name: group.name,
                avatar: group.avatar,
                createTime: group.createTime,
                creator: group.creator,
                messages,
            }
        }
    }
    // 退出群组
    async leaveGroup() {
        const { ctx } = this;
        const { groupId } = ctx.request.body;
        assert(isValid(groupId), '无效的群组ID');
        const group = await ctx.model.Group.findOne({ _id: groupId });
        assert(group, '群组不存在');
        // 默认群组没有creator
        if (group.creator) {
            assert(group.creator.toString() !== ctx.uid.toString(), '群组不能退出自己创建的群');
        }
        const index = group.members.indexOf(ctx.uid);
        assert(index !== -1, '你不在群组里');
        group.members.splice(index, 1);
        await group.save();
        ctx.socket.leave(group._id.toString());
        ctx.body = {
            code: 0,
            msg: '操作成功',
        }
    }
    // 获取群组在线成员
    async getGroupOnlineMembers() {
        const { ctx } = this;
        const { groupId } = ctx.request.body;
        assert(isValid(groupId), '无效的群组ID');
        const group = await ctx.model.Group.findOne({ _id: groupId });
        assert(group, '群组不存在');
        return

    }

    // 获取指定群组的在线用户
}

module.exports = GroupController;
