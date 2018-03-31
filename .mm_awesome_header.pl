use Config;
use Alien::libuv ();

# Some options behave differently on Windows
sub WINLIKE () {
    return 1 if $^O eq 'MSWin32';
    # return 1 if $^O eq 'cygwin';
    return 1 if $^O eq 'msys';
    return '';
}
sub WINVER() {
    return undef unless WINLIKE();
    my $ver;
    my $err = do {
        local $@;
        eval { require Win32; $ver = Win32::GetOSName(); 1; };
        $@;
    };
    $ver = 'Win10' unless $ver; # just pick one if we couldn't find it
    if ($err) {
        warn "We had an error grabbing the Win32 OS Name: $err";
    }

    if ($ver =~ /^Win(?:Win32s|95|98|Me|NT4|NT3\.51|HomeSvr)/) {
        warn "This version of Windows is really old and we can't install here";
        exit(1);
    }
    return '0x0500' if $ver =~ /^Win2000/;
    return '0x0501' if $ver =~ /^WinXP\/\.Net/;
    return '0x0502' if $ver =~ /^Win2003/;
    return '0x0600' if $ver =~ /^Win(?:Vista|2008)/;
    return '0x0601' if $ver =~ /^Win7/;
    return '0x0603' if $ver =~ /^Win8\.1/;
    return '0x0602' if $ver =~ /^Win8/;
    return '0x0A00' if $ver =~ /^Win10/;
    return '0x0A00' if $ver =~ /^Win(?:2012|2014|2016)/; # not sure here

    warn "We couldn't determine the version of Windows you're on.";
    return undef;

}

# make sure we actually get stuff back from Alien::libuv
sub TRIM {
    my $s = shift;
    return '' unless $s;
    $s =~ s/\A\s*//;
    $s =~ s/\s*\z//;
    return $s;
}

my @flags = ('-I.', $Config{ccflags});
if (my $ver = WINVER()) {
    push @flags, "-D_WINVER=$ver";
    push @flags, "-D_WIN32_WINNT=$ver";
    push @flags, "-D_WIN32_WINDOWS=$ver";
    push @flags, "-D_WIN32_IE=$ver";
}
my $libs = Alien::libuv->libs();
$libs .= ' -lpsapi -luserenv -lIphlpapi' if WINLIKE();
{
    my $cflags = TRIM(Alien::libuv->cflags);
    my $cflags_s = TRIM(Alien::libuv->cflags_static);
    if ($cflags eq $cflags_s) {
        unshift @flags, $cflags if $cflags;
    }
    else {
        unshift @flags, $cflags if $cflags;
        unshift @flags, $cflags_s if $cflags_s;
    }
}
my %xsbuild = (
    XSMULTI => 1,
    # XSBUILD => {
    #     xs => {
    #         'lib/UV' => {
    #           OBJECT => 'lib/UV$(OBJ_EXT) lib/perl_math_int64$(OBJ_EXT)',
    #         },
    #     },
    # },
    # OBJECT  => '$(O_FILES)',
    LIBS => [$libs],
    CCFLAGS => join(' ', @flags),
);
