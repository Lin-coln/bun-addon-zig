const napi = @import("napi//napi.zig");
const c = napi.c;

export fn napi_register_module_v1(env: c.napi_env, exports: c.napi_value) c.napi_value {
    const foo = napi.Boolean.new(env, true) catch return null;
    napi.Object.setProp(env, exports, "foo", foo) catch return null;
    return exports;
}
