const c = @import("c.zig").node_api;
const Error = @import("Error.zig");

pub fn new(env: c.napi_env, value: bool) !c.napi_value {
    var result: c.napi_value = undefined;
    if (c.napi_get_boolean(env, value, &result) != c.napi_ok) {
        return Error.throw(env, "Failed to create boolean");
    }
    return result;
}
