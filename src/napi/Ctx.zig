const c = @import("c.zig").c;
const call_node_api = @import("c.zig").call_node_api;
const utils = @import("utils.zig");
const Val = @import("utils.zig").Val;

c_env: c.napi_env,
const Ctx = @This();

pub fn boolean(
    self: Ctx,
    val: bool,
) !Val {
    var res: c.napi_value = undefined;
    try call_node_api(
        self.c_env,
        c.napi_get_boolean,
        .{ val, &res },
    );
    return Val{ .c_val = res, .ctx = self };
}

pub fn global(self: Ctx) !Val {
    var res: c.napi_value = undefined;
    try call_node_api(
        self.c_env,
        c.napi_get_global,
        .{&res},
    );
    return Val{ .c_val = res, .ctx = self };
}
