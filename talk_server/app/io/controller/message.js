const Controller = require('egg').Controller;
const assert = require('assert');
const isValid = require('mongoose').Types.ObjectId.isValid;

class MessageController extends Controller {
    async sendMessage() {
        const { ctx, app } = this;



    }
}

module.exports = MessageController;
