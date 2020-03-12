/** 内存数据存储键值 */
const MemoryDataStorageKey = [
    /** 封禁用户列表 */
    'SealUserList',
    /** 封禁ip列表 */
    'SealIpList',
    /** 新注册用户列表 */
    'NewUserList',
];

/** 内存数据 */
const memoryData = new Map();

/**
 * 更新指定键值数据
 * @param key 键值
 * @param set 新值
 */
export function setMemoryData(key, set) {
    memoryData.set(key, set);
}

/**
 * 想指定键值添加数据
 * @param key 键值
 * @param value 要添加的值
 */
export function addMemoryData(key, value) {
    if (value) {
        const set = memoryData.get(key);
        set.add(value);
    }
}

/**
 * 获取指定键值数据
 * @param key 键值
 */
export function getMemoryData(key) {
    return memoryData.get(key);
}

/**
 * 判断指定键值数据中是否存在目标值
 * @param key 键值
 * @param value 要判断的值
 */
export function existMemoryData(key, value) {
    return memoryData.get(key).has(value);
}

/**
 * 删除指定键值数据中的目标值
 * @param key 键值
 * @param value 要删除的值
 */
export function deleteMemoryData(key, value) {
    if (value) {
        const set = memoryData.get(key);
        set.delete(value);
    }
}

// 自动初始化各个 key 的 value
MemoryDataStorageKey.forEach((key) => {
    const id = parseInt(key, 10);
    if (!Number.isNaN(id)) {

        setMemoryData(id, new Set());
    }
});
