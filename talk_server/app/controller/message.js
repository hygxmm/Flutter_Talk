const Controller = require('egg').Controller;
const assert = require('assert');
const isValid = require('mongoose').Types.ObjectId.isValid;

class MessageController extends Controller {
    async index() {
        const { ctx } = this;
        ctx.body = 'hi, egg';
    }
}

module.exports = MessageController;
