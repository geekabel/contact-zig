const std = @import("std");
const contact = @import("contact.zig");
const database = @import("database.zig");

pub fn main() anyerror!void {
    const db = try database.openDatabase("data/contacts.db");

    defer db.close();

    while (true) {
        std.debug.print("Contact Management System\n", .{});
        std.debug.print("1. Add Contact\n", .{});
        std.debug.print("2. List Contacts\n", .{});
        std.debug.print("3. Delete Contact\n", .{});
        std.debug.print("4. Exit\n", .{});
        std.debug.print("Choose an option: ", .{});

        var option: u8 = undefined;
        std.debug.scan(u8, &option, " %d");

        switch (option) {
            1 => {
                contact.addContact(db);
            },
            2 => {
                contact.listContacts(db);
            },
            3 => {
                contact.deleteContact(db);
            },
            4 => {
                break;
            },
            else => {
                std.debug.print("Invalid option. Please choose again.\n", .{});
            },
        }
    }
}
