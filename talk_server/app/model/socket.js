module.exports = app => {
    const mongoose = app.mongoose;
    const Schema = mongoose.Schema;
    const SocketSchema = new Schema({
        createTime: {
            type: Date,
            default: Date.now,
        },
        id: {
            type: String,
            unique: true,
            index: true,
        },
        user: {
            type: Schema.Types.ObjectId,
            ref: 'User',
            index: true,
        },
        ip: String,
        os: {
            type: String,
            default: '',
        },
        browser: {
            type: String,
            default: '',
        },
        environment: {
            type: String,
            default: '',
        },
    })
    return mongoose.model('Socket', SocketSchema);
}
