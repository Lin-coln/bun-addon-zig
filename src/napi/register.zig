const std = @import("std");
const c = @import("c.zig").c;
const utils = @import("utils.zig");
const Ctx = @import("Ctx.zig");
const Obj = @import("Obj.zig");

pub fn registerModule(init_fn: anytype) void {
    const Closure = struct {
        fn init(c_env: c.napi_env, c_exports: c.napi_value) callconv(.c) c.napi_value {
            const fn_info = switch (@typeInfo(@TypeOf(init_fn))) {
                .@"fn" => |fn_info| fn_info,
                else => @compileError("`init_fn` must be a function"),
            };
            if (!(fn_info.params.len == 2 and fn_info.params[0].type == Ctx and fn_info.params[1].type == Obj)) {
                @compileError("`init` function requires two arguments: (Env, Obj).");
            }

            const ctx = Ctx{ .c_env = c_env };
            const exports = Obj{ .ctx = ctx, .c_val = c_exports };

            if (comptime utils.isReturnValue(fn_info)) {
                return init_fn(ctx, exports).c_val;
            } else if (comptime utils.isReturnErrValue(fn_info)) {
                const ret = init_fn(ctx, exports) catch |e| {
                    std.log.err("Init napi failed, err: {any}", .{e});
                    _ = c.napi_throw_error(c_env, null, @errorName(e));
                    return null;
                };
                return ret.c_val;
            } else {
                @compileError("`init_fn` function must return struct has field `c_val`");
            }
        }
    };

    @export(&Closure.init, .{ .name = "napi_register_module_v1" });
}
