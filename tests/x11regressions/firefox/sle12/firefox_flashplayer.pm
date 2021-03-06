# SUSE's openQA tests
#
# Copyright © 2009-2013 Bernhard M. Wiedemann
# Copyright © 2012-2016 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# Summary: Case#1436061: Firefox: Flash Player
# Maintainer: wnereiz <wnereiz@gmail.com>

use strict;
use base "x11regressiontest";
use testapi;

sub run() {
    my ($self) = @_;
    $self->start_firefox;

    send_key "esc";
    send_key "alt-d";
    type_string "http://www.adobe.com/software/flash/about/\n";
    wait_still_screen 3;
    assert_screen ['firefox-reader-view', 'firefox-flashplayer-verify_loaded'], 90;
    if (match_has_tag 'firefox-reader-view') {
        assert_and_click('firefox-reader-close');
        assert_screen('firefox-flashplayer-verify_loaded');
    }

    send_key "pgdn";
    # flashplayer dropped since sled12 sp2
    while (assert_screen([qw(firefox-flashplayer-dropped firefox-flashplayer-verify)])) {
        last if (match_has_tag('firefox-flashplayer-dropped'));
        if (match_has_tag('firefox-flashplayer-verify')) {
            send_key "esc";
            send_key "alt-d";
            type_string "https://www.youtube.com/watch?v=Z4j5rJQMdOU\n";
            assert_screen('firefox-flashplayer-video_loaded', 90);
        }
        last;
    }

    $self->exit_firefox;
}
1;
# vim: set sw=4 et:
