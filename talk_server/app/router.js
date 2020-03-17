module.exports = app => {
  const { router, controller, io } = app;
  const jwt = app.middleware.jwt();
  router.get('/', (ctx) => ctx.body = '聊天后台,管理界面暂未开发');

  router.post('/api/user/login', controller.user.login);
  router.post('/api/user/register', controller.user.register);
  router.post('/api/user/loginByToken', jwt, controller.user.loginByToken);


  router.post('/api/system/search', controller.system.search);

  router.post('/api/user/addFriend', jwt, controller.user.addFriend);



  // socket.io
  io.of('/').route('exchange', io.controller.default.exchange);
  io.of('/').route('sendMessage', io.controller.default.sendMessage);
};
