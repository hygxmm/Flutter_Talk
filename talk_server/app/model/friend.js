module.exports = app => {
    const mongoose = app.mongoose;
    const Schema = mongoose.Schema;

    const FriendSchema = new Schema({
        createTime: {
            type: Date,
            default: Date.now
        },
        from: {
            type: Schema.Types.ObjectId,
            ref: 'User',
            index: true,
        },
        to: {
            type: Schema.Types.ObjectId,
            ref: 'User',
        },
    });
    return mongoose.model('Friend', FriendSchema);
}