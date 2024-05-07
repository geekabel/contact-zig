const std = @import("std");
const sqlite = @import("std").sqlite;

const Contact = @import("contact.zig").Contact;

pub const Database = struct {
    connection: sqlite.Connection,
};

pub fn openDatabase(path: []const u8) anyerror!Database {
    const db = try sqlite.open(path);
    const createTableQuery = "CREATE TABLE IF NOT EXISTS contacts (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phone TEXT);";
    try db.exec(createTableQuery);

    return Database{ .connection = db };
}

pub fn insertContact(db: *Database, contact: Contact) anyerror!void {
    const insertQuery = "INSERT INTO contacts (name, phone) VALUES (?, ?);";
    try db.connection.exec(insertQuery, .{ contact.name, contact.phone });
}

pub fn getContacts(db: *Database) anyerror![]Contact {
    const selectQuery = "SELECT name, phone FROM contacts;";
    const result = try db.connection.query(selectQuery);

    var contacts = []Contact{};

    while (result.next()) |row| {
        const name = try row.getText(0);
        const phone = try row.getText(1);
        contacts = try std.mem.append(&contacts, &[1]Contact{Contact{ .name = name, .phone = phone }});
    }

    return contacts;
}

pub fn deleteContact(db: *Database, name: []const u8) anyerror!void {
    const deleteQuery = "DELETE FROM contacts WHERE name = ?;";
    try db.connection.exec(deleteQuery, .{name});
}
