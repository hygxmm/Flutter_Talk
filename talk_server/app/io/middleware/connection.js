// 前缀
const PREFIX = 'room';

module.exports = () => {
    return async (ctx, next) => {
        const { app, socket, helper } = ctx;
        const id = socket.id;
        const nsp = app.io.of('/');
        const query = socket.handshake.query;
        const { room, userId } = query;
        const rooms = [room];
        console.log(id, room, userId);
        // 用户加入
        socket.join(room);
        // 在线列表
        // console.log('房间列表', nsp.adapter.rooms);
        nsp.adapter.clients(rooms, (err, clients) => {
            // console.log('在线用户列表', clients)
            // 跟新在线用户列表
            nsp.to(room).emit('online', {
                clients,
                action: 'join',
                target: 'participator',
                message: `user ${id} join`
            })
        })

        await next();

        console.log("用户离开");

        nsp.adapter.clients(rooms, (err, clients) => {
            // console.log(clients);
            // 更新在线用户列表
            nsp.to(room).emit('online', {
                clients,
                action: 'leave',
                target: 'participator',
                message: `User(${id}) leaved.`,
            })
        })
    }
}