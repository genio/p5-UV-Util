# NAME

UV::Util - Some utility functions from libUV.

# SYNOPSIS

    #!/usr/bin/env perl
    use strict;
    use warnings;
    use feature ':5.14';

    use Data::Dumper::Concise qw(Dumper);
    use UV::Util;
    use Syntax::Keyword::Try;

    my $res;
    try {
      $res = UV::Util::cpu_info();
    }
    catch {
      die "Aw, man. $@";
    }

# DESCRIPTION

This module provides access to a few of the functions in the miscellaneous
[libUV](http://docs.libuv.org/en/v1.x/misc.html) utilities. While it's extremely
unlikely, all functions here can throw an exception on error unless specifically
stated otherwise in the function's description.

# CONSTANTS

[UV::Util](https://metacpan.org/pod/UV::Util) makes the following constants available that represent different
[handle types](http://docs.libuv.org/en/latest/handle.html#c.uv_handle_type).

## UV\_UNKNOWN\_HANDLE

    # 0

## UV\_ASYNC

    # 1

## UV\_CHECK

    # 2

## UV\_FS\_EVENT

    # 3

## UV\_FS\_POLL

    # 4

## UV\_HANDLE

    # 5

## UV\_IDLE

    # 6

## UV\_NAMED\_PIPE

    # 7

## UV\_POLL

    # 8

## UV\_PREPARE

    # 9

## UV\_PROCESS

    # 10

## UV\_STREAM

    # 11

## UV\_TCP

    # 12

## UV\_TIMER

    # 13

## UV\_TTY

    # 14

## UV\_UDP

    # 15

## UV\_SIGNAL

    # 16

## UV\_FILE

    # 17

## UV\_HANDLE\_TYPE\_MAX

    # 18

# FUNCTIONS

All functions provided here provide a Perl interface to their
[libUV](http://docs.libuv.org/en/latest/misc.html) equivalents.

## cpu\_info

    use Data::Dumper;
    use UV::Util;
    use Syntax::Keyword::Try;

    my $res;
    try { $res = UV::Util::cpu_info(); }
    catch { die "Aw, man. $@"; }
    say Dumper $res;
    # [
    #   {
    #     cpu_times => {
    #       idle => "1157161200",
    #       irq => 19912800,
    #       nice => 242400,
    #       sys => 8498700,
    #       user => 39428000
    #     },
    #     model => "Intel(R) Core(TM) i7-7700HQ CPU \@ 2.80GHz",
    #     speed => 1048
    #   },
    #   {
    #     cpu_times => {
    #       idle => 16922900,
    #       irq => 846300,
    #       nice => 371800,
    #       sys => 6491400,
    #       user => 34690000
    #     },
    #     model => "Intel(R) Core(TM) i7-7700HQ CPU \@ 2.80GHz",
    #     speed => 899
    #   }
    # ]

This [function](http://docs.libuv.org/en/v1.x/misc.html#c.uv_cpu_info)
returns an array reference full of hashrefs. Each hashref represents an
available CPU on your system. `cpu_times`, `model`, and `speed` will be
supplied for each.

## get\_free\_memory

    use UV::Util;
    use Syntax::Keyword::Try;

    my $res;
    try { $res = UV::Util::get_free_memory(); }
    catch { die "Aw, man. $@"; }
    say $res; # 23052402688

This function returns an unsigned integer representing the number of bytes of
free memory available.

## get\_total\_memory

    use UV::Util;
    use Syntax::Keyword::Try;

    my $res;
    try { $res = UV::Util::get_total_memory(); }
    catch { die "Aw, man. $@"; }
    say $res; # 33452101632

This function returns an unsigned integer representing the number of bytes of
total memory in the system.

## getrusage

    use Data::Dumper;
    use UV::Util;
    use Syntax::Keyword::Try;

    my $res;
    try { $res = UV::Util::getrusage(); }
    catch { die "Aw, man. $@"; }
    say Dumper $res;
    # {
    #   ru_idrss => 0,
    #   ru_inblock => 0,
    #   ru_isrss => 0,
    #   ru_ixrss => 0,
    #   ru_majflt => 0,
    #   ru_maxrss => 10132,
    #   ru_minflt => 1624,
    #   ru_msgrcv => 0,
    #   ru_msgsnd => 0,
    #   ru_nivcsw => 1,
    #   ru_nsignals => 0,
    #   ru_nswap => 0,
    #   ru_nvcsw => 1,
    #   ru_oublock => 0,
    #   ru_stime => "0.005963",
    #   ru_utime => "0.02801"
    # }

This [function](http://docs.libuv.org/en/v1.x/misc.html#c.uv_getrusage)
returns a hash reference of resource metrics for the current process.

## guess\_handle\_type

    use UV::Util;
    use Syntax::Keyword::Try;

    my $res;
    try { $res = UV::Util::guess_handle_type(\*STDIN); }
    catch { die "Aw, man. $@"; }
    say "yay!" if ($res == UV::Util::UV_TTY);

This [function](http://docs.libuv.org/en/latest/misc.html#c.uv_guess_handle)
takes in a reference to a handle (e.g. `\*STDIN`) and returns an integer that
represents one of the [CONSTANTS](https://metacpan.org/pod/UV::Util#CONSTANTS) above.

## hrtime

    use UV::Util;

    # does not throw exceptions
    my $time = UV::Util::hrtime();

This [function](http://docs.libuv.org/en/latest/misc.html#c.uv_hrtime)
returns the current high-resolution real time. This is expressed in nanoseconds.
It is relative to an arbitrary time in the past. It is not related to the time
of day and therefore not subject to clock drift. The primary use is for
measuring performance between intervals.

Not every platform can support nanosecond resolution; however, this value will
always be in nanoseconds.

## interface\_addresses

    use Data::Dumper qw(Dumper);
    use UV::Util;
    use Syntax::Keyword::Try;

    my $res;
    try { $res = UV::Util::interface_addresses(); }
    catch { die "Aw, man. $@"; }
    say Dumper $res;
    # [
    #   {
    #     address => "127.0.0.1",
    #     is_internal => 1,
    #     mac => "00:00:00:00:00:00",
    #     name => "lo",
    #     netmask => "255.0.0.0"
    #   },
    # ]

This [function](http://docs.libuv.org/en/latest/misc.html#c.uv_interface_addresses)
returns an array reference containing hash references representing each of your
available interfaces.

## loadavg

    use Data::Dumper qw(Dumper);
    use UV::Util;

    # does not throw exceptions
    my $res = UV::Util::loadavg();
    say Dumper $res;
    # [
    #   "0.43212890625",
    #   "0.39599609375",
    #   "0.27880859375"
    # ]

This [function](http://docs.libuv.org/en/latest/misc.html#c.uv_loadavg)
returns an array reference containing the
[load average](http://en.wikipedia.org/wiki/Load_\(computing\)).

On Windows, this will **always** return `[0,0,0]` as it's not implemented.

## resident\_set\_memory

    use Data::Dumper qw(Dumper);
    use UV::Util;
    use Syntax::Keyword::Try;

    my $res;
    try { $res = UV::Util::resident_set_memory(); }
    catch { die "Aw, man. $@"; }
    say Dumper $res; # 10473472

This [function](http://docs.libuv.org/en/latest/misc.html#c.uv_resident_set_memory)
returns an unsigned integer representing the resident set size (RSS) for the
current process.

## uptime

    use Data::Dumper qw(Dumper);
    use UV::Util;
    use Syntax::Keyword::Try;

    my $res;
    try { $res = UV::Util::resident_set_memory(); }
    catch { die "Aw, man. $@"; }
    say Dumper $res; # uptime

This [function](http://docs.libuv.org/en/latest/misc.html#c.uv_uptime)
returns a float representing the current system uptime.

# COPYRIGHT AND LICENSE

Copyright 2017, Chase Whitener.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.
