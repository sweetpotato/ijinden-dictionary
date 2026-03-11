use strict;
use warnings;
use utf8;
use Encode;
use JSON::PP;
binmode STDERR, ':utf8';

sub process_card {
  my ($card) = @_;

  my $file = "../public/$card->{name}.html";
  if (! -f $file) {
    warn "skip $file";
    return;
  }

  my $type_text = "";
  if ($card->{type} == 1) {
    $type_text = "イジン";
  } elsif ($card->{type} == 2) {
    $type_text = "ハイケイ";
  } elsif ($card->{type} == 3) {
    $type_text = "マホウ";
  } elsif ($card->{type} == 4) {
    $type_text = "マリョク";
  } else {
    die;
  }

  my $color_text = "";
  if ($card->{color} == 1) {
    $color_text = "赤";
  } elsif ($card->{color} == 2) {
    $color_text = "青";
  } elsif ($card->{color} == 4) {
    $color_text = "緑";
  } elsif ($card->{color} == 8) {
    $color_text = "黄";
  } elsif ($card->{color} == 16) {
    $color_text = "紫";
  } elsif ($card->{color} == 41) {
    $color_text = "赤・黄";
  } elsif ($card->{color} == 42) {
    $color_text = "青・黄";
  } elsif ($card->{color} == 44) {
    $color_text = "緑・黄";
  } elsif ($card->{color} == 64) {
    $color_text = "無色";
  } else {
    die;
  }

  my $tcl_line = "";
  if ($card->{type} == 3) { # マホウ
    $tcl_line = "${type_text}／${color_text}／$card->{level}／魔力コスト$card->{cost}"
  } else {
    $tcl_line = "${type_text}／${color_text}／$card->{level}"
  }

  my $rule_text = $card->{ruleText} || "";
  $rule_text =~ s|¶|</p>\r\n<p>|g;

  my $snippet = "";
  $snippet .= "<p>$card->{id}</p>\r\n";
  $snippet .= "<p>$card->{name}</p>\r\n";
  $snippet .= "<p>${tcl_line}</p>\r\n";
  if (defined $card->{traitText}) {
    $snippet .= "<p>特性：$card->{traitText}</p>\r\n";
  }
  if ($rule_text ne "") {
    $snippet .= "<p>${rule_text}</p>\r\n";
  }
  if (defined $card->{power}) {
    $snippet .= "<p>$card->{power}</p>\r\n";
  }
  if (defined $card->{legacyText}) {
    $snippet .= "<p>遺業能力：$card->{legacyText}</p>\r\n";
  }

  $snippet = "<blockquote>\r\n${snippet}</blockquote>\r\n";

  open(my $in, $file) or die;
  binmode $in, ':utf8';
  local $/ = undef;
  my $content = <$in>;
  close($in);

  $content =~ s|(.*?<div id="content">\s*)(.*)|$1${snippet}$2|s;

  open(my $out, ">$file") or die;
  print $out "$content";
  close($out);
}

while (my $json = <>) {
  my $card = decode_json($json);
  process_card($card);
}
