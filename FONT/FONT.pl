# BGI Stroke File Format

use strict;
use warnings;

my %opts = (
    font => 'LITT.CHR',
    datOutput => 0,
    dirIn => '.',
    dirOut => '.',
    javascriptOut => 0,
    lookUp => 0,
    verbose => 0,
    info => 0,
);

my %optValueDescriptions = (
    font => ["[path]", "default: $opts{font}"],
    datOutput => ["1/0", "default: $opts{datOutput}"],
    dirIn => ["[path]", "default: $opts{dirIn}"],
    dirOut => ["[path]", "default: $opts{dirOut}"],
    javascriptOut => ["1/0", "default: $opts{javascriptOut}"],
    lookUp => ["1/0", "default: $opts{lookUp}"],
    verbose => ["1/0", "default: $opts{verbose}"],
    info => ["", "Read and print info from font files in [dirIn]"],
);

if (@ARGV == 1 && $ARGV[0] eq 'info') {
    $opts{lookUp} = 1;
} elsif (@ARGV && not @ARGV % 2) {
    my %args = @ARGV;
    $opts{$_} = $args{$_} for keys %args;
} else {
    print "USAGE: $0 [OPTIONS]\n";
    print "OPTIONS:\n";
    foreach (sort keys %opts) {
        my $d = $optValueDescriptions{$_};
        printf "\t%s%s\n\t\t%s\n", $_, $d->[0] && " $d->[0]", $d->[1];
    }
    print "\n";
    exit 1;
}

##########################

use constant {
    OP_END => 0x0,
    OP_MOVE => 0x80,
    OP_DRAW => 0x8080,
};

my $opCount = 0;
my $outFh;

my @fonts;
if ($opts{lookUp}) {
    opendir (my $dh, $opts{dirIn}) or Error("$!");
    @fonts = grep { /\.CHR$/ } readdir $dh;
    closedir $dh;
} else {
    @fonts = $opts{font};
}

foreach (@fonts) {
    Print ("Font: $_");
    ConvertFile("$opts{dirIn}\\$_", "$opts{dirOut}\\$_.DAT");
}

my $newChar;

sub ProcessOperation {
    my ($op, $x, $y) = @_;
    $x -= 128 if $x > 63;
    $y -= 128 if $y > 63;

    if ($opts{datOutput}) {
        print $outFh pack("Css", $op, $x, $y);
    } elsif ($opts{javascriptOut}) {
        if ($op == 2) {
            print lastChar() ? "]],\n" : "],\n[";
            $newChar = 1;
        } else {
            $newChar //= 1;
            printf "," unless $newChar;
            printf "[%u,%d,%d]", $op, $x, $y;
            $newChar = 0;
        }
    }
    Print("%s %d, %d", $op ? ($op == 1 ? "DRAW" : "END") : "MOVE", $x, $y) if $opts{verbose};
}

sub ProcessVectorData {
    my ($buf, $offset, $remaining) = @_;
    Print ("Addr: $offset, $remaining") if $opts{verbose};

    while (1) {
        if ($remaining < 2) {
            Error ("End of file while parsing character definitions");
        }

        my $op = ($buf->[$offset] + ($buf->[$offset+1] << 8)) & 0x8080;

        if ($op == OP_DRAW) {
            ProcessOperation(1, $buf->[$offset] & 0x7F, $buf->[$offset+1] & 0x7F);
        } elsif ($op == OP_MOVE) {
            ProcessOperation(0, $buf->[$offset] & 0x7F, $buf->[$offset+1] & 0x7F);
        } elsif ($op == OP_END) {
            ProcessOperation(2, 0, 0);
            return;
        } else {
            Warn ("Input file contains invalid opcode 0x8000");
        }
        $opCount++;

        $offset += 2;
        $remaining -= 2;
    }
}

my $char;
my $lastChar;
sub lastChar { $char == $lastChar-1 }

sub ConvertFile {
    my ($input, $output) = @_;

    if ($opts{datOutput}) {
        die "File exists: $output" if -e $output;
        open ($outFh, '>', $output) or Error("$!");
        binmode $outFh;
    } elsif ($opts{javascriptOut}) {
        print "var font={\n";
        print "height:10,\n";
        print "chars:[[";
    }

    my $size;       # long
    my $buf;        # unsigned char*
    my $firstChar;  # unsigned
    my $charCount;  # unsigned
    #~ my $lastChar;   # unsigned
    #~ my $char;       # unsigned
    my $offs;       # unsigned
    my $offsetBuf;  # const unsigned char*
    my $widthBuf;   # const unsigned char*
    my $vectorBuf;  # const unsigned char*

    open (my $fh, '<', $input) or Error ("Cannot open %s: %s", $input, $!);
    binmode $fh;
    $size = -s $fh;

    if ($size > 32*1024) {
        Error ("Input file too large (max = 32k): %s", $input);
    } elsif ($size < 0x100) {
        Error ("Input file too small: %s", $input);
    }

    # Read the file contents into the buffer
    if (read($fh, $buf, $size) != $size) {
        Error ("Read error: %s'", $input);
    }

    close $fh;

    my @buf = unpack('C*', $buf);

    $firstChar = $buf[0x84];
    $charCount = $buf[0x81] + ($buf[0x82] << 8);
    $lastChar  = $firstChar + $charCount;
    Print ("FirstChar = %x, CharCount = %u", $firstChar, $charCount);
    if ($lastChar > 0x100) {
        Error ("%s contains too many character definitions", $input);
    } elsif ($firstChar > 0x20) {
        Error ("%s doesn't contain the chars we need", $input);
    }

    # Get pointers to the width table, the offset table and the vector
    # data table. The first two corrected for 0x20 as first entry.
    $offsetBuf = 0x90 + ((0x20 - $firstChar) * 2);
    $widthBuf  = 0x90 + ($charCount * 2) + (0x20 - $firstChar);
    $vectorBuf = 0x90 + ($charCount * 3);

    for ($char = $firstChar; $char < $lastChar; ++$char, $offsetBuf += 2) {
        $offs = $buf[$offsetBuf] + ($buf[$offsetBuf+1] << 8);

        my $remaining = $size - ($vectorBuf + $offs);

        if ($remaining <= 0) {
            Error ("Invalid data offset in input file: %s", $input);
        }

        ProcessVectorData (\@buf, $vectorBuf + $offs, $remaining);
    }

    if ($opts{datOutput}) {
        close $outFh;
    } elsif ($opts{javascriptOut}) {
        print "width:[";
        my $first = 1;
        for ($char = 0; $char < $charCount; ++$char) {
            $first ?  ($first = 0) : print ",";
            printf "%u", $buf[$widthBuf + $char];
        }
        print "]};\n";
    }

    Print ("Operations: $opCount");
}

sub Error {
    my $str = shift;
    die sprintf($str, @_);
}

sub Print {
    my $str = shift;
    printf STDERR "$str\n", @_;
}

sub Warn {
    my $str = shift;
    printf STDERR "WARNING: $str\n", @_;
}
