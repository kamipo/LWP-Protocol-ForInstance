use inc::Module::Install;
name 'LWP-Protocol-ForInstance';
all_from 'lib/LWP/Protocol/ForInstance.pm';

requires 'LWP::UserAgent';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More' => 0.88; # done_testing()
use_test_base;
auto_include;
WriteAll;
