const std = @import("std");
const c = @import("c.zig").c;
const Ctx = @import("Ctx.zig");

pub const Val = struct { c_val: c.napi_value, ctx: Ctx };

pub fn isReturnValue(fn_info: std.builtin.Type.Fn) bool {
    if (fn_info.return_type) |ret_type| {
        return typeHasCVal(ret_type);
    }
    return false;
}

pub fn isReturnErrValue(fn_info: std.builtin.Type.Fn) bool {
    if (fn_info.return_type) |ret_type| {
        switch (@typeInfo(ret_type)) {
            .error_union => |err_union| return typeHasCVal(err_union.payload),
            else => {},
        }
    }
    return false;
}

pub fn isReturnErrVoid(fn_info: std.builtin.Type.Fn) bool {
    if (fn_info.return_type) |ret_type| {
        switch (@typeInfo(ret_type)) {
            .error_union => |err_union| return err_union.payload == void,
            else => {},
        }
    }
    return false;
}

pub fn typeHasCVal(comptime T: type) bool {
    return switch (@typeInfo(T)) {
        .@"struct" => |S| blk: {
            inline for (S.fields) |field| {
                if (std.mem.eql(u8, field.name, "c_val") and
                    field.type == c.napi_value)
                {
                    break :blk true;
                }
            }
            break :blk false;
        },
        else => false,
    };
}
