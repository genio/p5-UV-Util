use strict;
use warnings;

use UV::Util ();

use Test::More;

require Alien::libuv;
diag "version        = ", Alien::libuv->config('version');
diag "cflags         = ", Alien::libuv->cflags;
diag "cflags_static  = ", Alien::libuv->cflags_static;
diag "libs           = ", Alien::libuv->libs;
diag "libs_static    = ", Alien::libuv->libs_static;
diag "bin_dir        = ", $_ for Alien::libuv->bin_dir;
diag "Install type   = ", Alien::libuv->install_type;

diag " ";
diag " ";

can_ok(
    'UV::Util', (
        qw(UV_UNKNOWN_HANDLE UV_ASYNC UV_CHECK UV_FS_EVENT UV_FS_POLL),
        qw(UV_HANDLE UV_IDLE UV_NAMED_PIPE UV_POLL UV_PREPARE UV_PROCESS),
        qw(UV_STREAM UV_TCP UV_TIMER UV_TTY UV_UDP UV_SIGNAL UV_FILE),
        qw(UV_HANDLE_TYPE_MAX),
    ),
);
can_ok(
    'UV::Util', (
        qw(hrtime get_free_memory get_total_memory loadavg),
        qw(uptime resident_set_memory interface_addresses cpu_info),
        qw(getrusage guess_handle_type version),
    )
);

diag("This is LibUV version: ".UV::Util::version());
ok(UV::Util::hrtime(), 'hrtime: Got a time');
ok(UV::Util::get_free_memory(), 'get_free_memory: Got memory size');
ok(UV::Util::get_total_memory(), 'get_total_memory: Got memory sizez');
ok(UV::Util::get_total_memory() > UV::Util::get_free_memory(), 'memory: more total than free');
isa_ok(UV::Util::loadavg(), 'ARRAY', 'loadavg: array ref received');
ok(UV::Util::uptime(), 'uptime: got uptime');

{
    # doesn't work in MinGW
    my $rss;
    my $err = do { # catch
        local $@;
        eval { $rss = UV::Util::resident_set_memory(); 1; }; # try
        $@;
    };
    if ($^O eq 'cygwin') {
        ok(!$rss, "resident_set_memory: not implemented on cygwin. no response.");
        like($err, qr/function not implemented/, 'resident_set_memory: got the appropriate error on cygwin');
    }
    else {
        ok(!$err, 'resident_set_memory: did not error out on this platform');
        ok($rss, 'resident_set_memory: got value');
    }
}

isa_ok(UV::Util::interface_addresses(), 'ARRAY', 'interface_addresses: array ref received');

{
    # doesn't work in MinGW
    my $cpu;
    my $err = do { # catch
        local $@;
        eval { $cpu = UV::Util::cpu_info(); 1; }; # try
        $@;
    };
    if ($^O eq 'cygwin') {
        ok(!$cpu, "cpu_info: not implemented on cygwin. no response.");
        like($err, qr/function not implemented/, 'cpu_info: got the appropriate error on cygwin');
    }
    else {
        ok(!$err, 'cpu_info: did not error out on this platform');
        ok($cpu, 'cpu_info: got value');
    }
}

isa_ok(UV::Util::getrusage, 'HASH', 'getrusage: got hashref');
ok(UV::Util::guess_handle_type(\*STDIN), 'guess_handle_type: got a result');
ok(UV::Util::version(), 'version: got back a string representation');
done_testing();
