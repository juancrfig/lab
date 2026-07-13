#!/usr/bin/perl
# Fabricates binary utmp/wtmp records (x86_64 glibc struct utmp, 384 bytes).
# utmpdump -r was rejected: its input parser is rigid and undocumented.
#
# Usage: mkutmp.pl wtmp > /var/log/wtmp
#        mkutmp.pl utmp > /var/run/utmp
use strict;
use warnings;

my $USER_PROCESS = 7;
my $DEAD_PROCESS = 8;

# struct utmp fields:
#   short ut_type (+2 pad), pid_t ut_pid, char ut_line[32], char ut_id[4],
#   char ut_user[32], char ut_host[256], struct exit_status (2 shorts),
#   int32 ut_session, int32 tv_sec, int32 tv_usec, int32 ut_addr_v6[4],
#   char __unused[20]  => 384 bytes total
sub rec {
    my ($type, $pid, $line, $id, $user, $host, $tv_sec) = @_;
    return pack("s x2 l a32 a4 a32 a256 s s l l l l4 a20",
        $type, $pid, $line, $id, $user, $host,
        0, 0,          # exit status
        0,             # session
        $tv_sec, 0,    # timeval
        0, 0, 0, 0,    # addr_v6
        "");
}

my $mode = shift @ARGV // die "usage: mkutmp.pl wtmp|utmp\n";

if ($mode eq 'wtmp') {
    # Chronological. Root session refutes claim (a): "I never used root."
    # 1783674862 = 2026-07-10 09:14:22 UTC, 1783677130 = 09:52:10 UTC
    print rec($USER_PROCESS, 1042, "pts/1", "ts/1", "root",  "10.0.0.57", 1783674862);
    print rec($DEAD_PROCESS, 1042, "pts/1", "ts/1", "",      "",          1783677130);
    # An earlier (relative to now) marta session, Jul 12 08:00-09:00 UTC
    print rec($USER_PROCESS, 2310, "pts/0", "ts/0", "marta", "10.0.0.23", 1783843200);
    print rec($DEAD_PROCESS, 2310, "pts/0", "ts/0", "",      "",          1783846800);
} elsif ($mode eq 'utmp') {
    # marta currently logged in — makes who/w show a second user.
    # ut_pid MUST be a live process: who/w silently drop entries whose pid is
    # dead. pid 1 is the only pid guaranteed to exist in the container.
    # 1783927800 = 2026-07-13 07:30:00 UTC
    print rec($USER_PROCESS, 1, "pts/0", "ts/0", "marta", "10.0.0.23", 1783927800);
} else {
    die "usage: mkutmp.pl wtmp|utmp\n";
}
