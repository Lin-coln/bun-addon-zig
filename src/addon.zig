const napi = @import("napi/index.zig");

comptime {
    napi.registerModule(init);
}

fn init(ctx: napi.Ctx, exports: napi.Obj) !void {
    try exports.set("foo", try ctx.boolean(true));
    try exports.set("bar", try ctx.object());
}