const c = @import("c.zig").node_api;
const Error = @import("Error.zig");

pub fn new(env: c.napi_env) !c.napi_value {
    var result: c.napi_value = undefined;
    if (c.napi_create_object(env, &result) != c.napi_ok) {
        return Error.throw(env, "Failed to create object");
    }
    return result;
}

pub fn setProp(env: c.napi_env, obj: c.napi_value, comptime key: [:0]const u8, val: c.napi_value) !void {
    if (c.napi_set_named_property(env, obj, key, val) != c.napi_ok) {
        return Error.throw(env, "Failed to set Prop" ++ key);
    }
}
