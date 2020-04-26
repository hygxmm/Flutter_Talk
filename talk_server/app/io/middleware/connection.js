module.exports = () => {
    return async (ctx, next) => {
        const { app, socket, helper } = ctx;
        const id = socket.id;
        const { userId } = socket.handshake.query;
        const nsp = app.io.of('/');
        socket.user = userId;
        const user = await ctx.model.User.findOne({ _id: userId });
        const groups = await ctx.model.Group.find({ members: user });
        groups.forEach(group => {
            ctx.socket.join(group._id.toString());
            nsp.to(group._id.toString()).emit('online', { test: `测试 ${user.username} 上线啦` });
        });
        const ip = socket.handshake.headers['x-real-ip'] || socket.request.connection.remoteAddress;
        socket.ip = ip;
        console.log(`连接上啦!!! =====>>> socket_id: ${id}`)
        await ctx.model.Socket.create({ id: id, ip: socket.ip });
        console.log(user);
        await ctx.model.Socket.updateOne({ id: id }, { user: user._id });
        await next();

        console.log("用户离开");
        groups.forEach(group => {
            ctx.socket.leave(group._id.toString());
            nsp.to(group._id.toString()).emit('online', { test: `测试 ${user.username} 推出本群` });
        });
        await ctx.model.Socket.deleteOne({ id });
    }
}