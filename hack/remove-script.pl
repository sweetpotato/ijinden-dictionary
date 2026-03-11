use strict;
use warnings;
use utf8;

local $/ = undef;
$_ = <>;
s|<meta\s*http-equiv="Content-Security-Policy"\s*.*?>||s;
s|<script\s*.*?>.*?</script>||gs;
print;
