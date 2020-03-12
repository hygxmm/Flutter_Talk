module.exports = app => {
    const mongoose = app.mongoose;
    const Schema = mongoose.Schema;

    const MessageSchema = new Schema({
        createTime: {
            type: Date,
            default: Date.now,
            index: true
        },
        from: {
            type: Schema.Types.ObjectId,
            ref: 'User',
        },
        to: {
            type: String,
            index: true,
        },
        type: {
            type: String,
            enum: ['text', 'image', 'code', 'invite', 'system'],
            default: 'text',
        },
        content: {
            type: String,
            default: '',
        },
    });
    return mongoose.model('Message', MessageSchema);
}