#!/usr/bin/perl -w
use warnings;
use strict;
use LWP::Simple;
use LWP;
use Date::Parse;
use Date::Format;

#
# A quick hack by Jacob Appelbaum <jacob@appelbaum.net>
# LWP suggestions by Leigh Honeywell
# This is Free Software (GPLv3)
# http://www.gnu.org/licenses/gpl-3.0.txt
#
#Contacted
# http://tor.askapache.com/ HTTP 403 Contacted 20091027
#
#CHANGELOG
#20091003 Code changes to elimiate the need for a trailing slash in addresses for script runtime
#20091004 Code changes to increase out of date tolerance to 48 hours
#20091028 Code changes to increase timout to 30 seconds (attempting to resolve "unknown" status'
#20091028 Code changes to change user agent of script

print "Creating LWP agent ($LWP::VERSION)...\n";
my $lua = LWP::UserAgent->new(
    keep_alive => 1,
    timeout => 30,
    agent => "Tor MirrorCheck Agent"
);

sub sanitize {
    my $taintedData = shift;
    my $cleanedData;
    my $whitelist = '-a-zA-Z0-9: +';

    # clean the data, return cleaned data
    $taintedData =~ s/[^$whitelist]//go;
    $cleanedData = $taintedData;

    return $cleanedData;
}

sub FetchDate {
    my $url = shift; # Base url for mirror
    my $trace = "/project/trace/www.torproject.org"; # Location of recent update info
    $url = "$url$trace";

    print "Fetching possible date from: $url\n";

    my $request = new HTTP::Request GET => "$url";
    my $result = $lua->request($request);
    my $code = $result->code();
    print "Result code $code\n";

    if ($result->is_success && $code eq "200"){
       my $taint = $result->content;
       my $content = sanitize($taint);
       if ($content) {

            my $date = str2time($content);

            if ($date) {
                print "We've fetched a date $date.\n";
                return $date;
            } else {
                print "We've haven't fetched a date.\n";
                return "Unknown";
            }

        } else {
            print "Unable to fetch date, empty content returned.\n";
            return "Unknown";
        }

    } else {
       print "Our request failed, we had no result.\n";
       return "Unknown";
    }

    return "Unknown";
}

# This is the list of all known Tor mirrors
# Add new mirrors to the bottom!
my %m = (

        mirror001 => {
            adminContact => "BarkerJr AT barkerjr DOT net",
            orgName => "BarkerJr",
            isoCC => "FR",
            subRegion => "",
            region => "FR",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://www.oignon.net/",
            httpsWebsiteMirror => "https://oignon.net/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://www.oignon.net/dist/",
            httpsDistMirror => "https://oignon.net/dist/",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
            updateDate => "Unknown",
        },

       mirror002 => {
            adminContact => "operator AT hermetix DOT org",
            orgName => "Hermetix",
            isoCC => "CA",
            subRegion => "QC",
            region => "North America",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.hermetix.org/",
            rsyncWebsiteMirror => "",
            httpDistMirror => "",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror003 => {
            adminContact => "",
            orgName => "Boinc",
            isoCC => "CH",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.boinc.ch/",
            ftpWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            httpDistMirror => "http://tor.boinc.ch/dist/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror005 => {
            adminContact => "citizen428 AT gmail DOT com",
            orgName => "Bbs",
            isoCC => "DE",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.blingblingsquad.net/",
            ftpWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            httpDistMirror => "",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror006 => {
            adminContact => "doc DOT kuehn AT nexgo DOT de",
            orgName => " spacecowboy ",
            isoCC => " ",
            subRegion => "",
            region => "DE",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor-proxy.de/tor-mirror/",
            httpsWebsiteMirror => "https://tor-proxy.de/tor-mirror/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor-proxy.de/tor-mirror/dist/",
            httpsDistMirror => "https://tor-proxy.de/tor-mirror/dist/",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
            updateDate => "Unknown",
        },

       mirror007 => {
            adminContact => "cm AT cybermirror DOT org",
            orgName => "Cybermirror",
            isoCC => "DE",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.cybermirror.org/",
            ftpWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            httpDistMirror => "http://tor.cybermirror.org/dist/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror008 => {
            adminContact => "contact AT algorithmus DOT com",
            orgName => "Spline",
            isoCC => "DE",
            subRegion => "FU",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "",
            ftpWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            httpDistMirror => "http://rem.spline.de/tor/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

	mirror009 => {
            adminContact => "BarkerJr AT barkerjr DOT net",
            orgName => "BarkerJr",
            isoCC => "US",
            subRegion => "",
            region => "US",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://www.torproject.us/",
            httpsWebsiteMirror => "https://www.torproject.us/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://www.torproject.us/dist/",
            httpsDistMirror => "https://www.torproject.us/dist/",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
            updateDate => "Unknown",
        },

	mirror010 => {
            adminContact => "",
            orgName => "zuola",
            isoCC => "CN",
            subRegion => "",
            region => "CN",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.zuo.la/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.zuo.la/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
            updateDate => "Unknown",
        },

       mirror011 => {
            adminContact => "info AT zentrum-der-gesundheit DOT de",
            orgName => "Zentrum der Gesundheit",
            isoCC => "DK",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.idnr.ws/",
            ftpWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            httpDistMirror => "http://tor.idnr.ws/dist/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror012 => {
            adminContact => "kurt AT miroir-francais DOT fr",
            orgName => "CRAN",
            isoCC => "FR",
            subRegion => "Ile de France",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "",
            rsyncWebsiteMirror => "rsync://miroir-francais.fr::tor",
            ftpWebsiteMirror => "ftp://miroir-francais.fr/pub/tor/",
            httpDistMirror => "http://tor.miroir-francais.fr/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror013 => {
            adminContact => "root AT amorphis DOT eu",
            orgName => "Amorphis",
            isoCC => "NL",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.amorphis.eu/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.amorphis.eu/dist/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror014 => {
            adminContact => "mirror AT bit DOT nl",
            orgName => "BIT BV",
            isoCC => "NL",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "ftp://ftp.bit.nl/mirror/tor/",
            httpDistMirror => "http://ftp.bit.nl/mirror/tor/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror015 => {
            adminContact => "webmaster AT ccc DOT de",
            orgName => "CCC",
            isoCC => "NL",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.ccc.de/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.ccc.de/dist/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror016 => {
            adminContact => "root AT kamagurka DOT org",
            orgName => "Kamagurka",
            isoCC => "NL",
            subRegion => "Haarlem",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.kamagurka.org/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.kamagurka.org/dist/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror018 => {
            adminContact => "evert AT meulie DOT net",
            orgName => "Meulie",
            isoCC => "NO",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.meulie.net/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror019 => {
            adminContact => "ghirai AT ghirai DOT com",
            orgName => "Ghirai",
            isoCC => "UK",
            subRegion => "London",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://www.ghirai.com/tor/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

	mirror020 => {
            adminContact => "",
            orgName => "ax",
            isoCC => "HU",
            subRegion => "",
            region => "HU",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.initrd.net/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
            updateDate => "Unknown",
        },

       mirror021 => {
	    adminContact => "hostmaster AT zombiewerks DOT com",
            orgName => "TheOnionRouter",
            isoCC => "US",
            subRegion => "New Jersey",
            region => "North America",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://www.theonionrouter.com/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://www.theonionrouter.com/dist/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror022 => {
            adminContact => "jeroen AT unfix DOT org",
            orgName => "Unfix",
            isoCC => "CH",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "True",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.unfix.org/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.unfix.org/dist/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror023 => {
            adminContact => "jeroen AT unfix DOT org",
            orgName => "Sixx",
            isoCC => "CH",
            subRegion => "",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "True",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://tor.sixxs.net/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.sixxs.net/dist/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

       mirror024 => {
            adminContact => "",
            orgName => "StrangeCharm",
            isoCC => "",
            subRegion => "",
            region => "FR",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://torproject.the-onion-router.net/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://torproject.the-onion-router.net/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        },

       mirror025 => {
            adminContact => "web2005a AT year2005a.wiretapped DOT net",
            orgName => "Wiretapped",
            isoCC => "AU",
            subRegion => "Sydney",
            region => "Oceania",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "ftp://ftp.mirrors.wiretapped.net/pub/security/cryptography/network/tor/",
            httpDistMirror => "http://www.mirrors.wiretapped.net/security/cryptography/network/tor/",
            rsyncDistMirror => "",
            updateDate => "Unknown",
        },

        mirror026 => {
            adminContact => "tormaster AT xpdm DOT us",
            orgName => "Xpdm",
            isoCC => "US",
            subRegion => "",
            region => "North America",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Unknown",
            httpWebsiteMirror => "http://torproj.xpdm.us/",
            httpsWebsiteMirror => "https://torproj.xpdm.us/",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://torproj.xpdm.us/dist/",
            httpsDistMirror => "https://torproj.xpdm.us/dist/",
            rsyncDistMirror => "",
            hiddenServiceMirror => "http://h3prhz46uktgm4tt.onion/",
            updateDate => "Unknown",
        },

        mirror027 => {
            adminContact => "",
            orgName => " cybervalley ",
            isoCC => " ",
            subRegion => "",
            region => " ",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://torproject.cybervalley.org/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
            updateDate => "Unknown",
        },

        mirror028 => {
            adminContact => "security AT hostoffice DOT hu",
            orgName => "Unknown",
            isoCC => "HU",
            subRegion => "Hungary",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.hu/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
            updateDate => "Unknown",
        },

        mirror029 => {
            adminContact => "",
            orgName => "Technica-03",
            isoCC => "UA",
            subRegion => "Ukraine",
            region => "Eastern Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://torua.reactor-xg.kiev.ua/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tordistua.reactor-xg.kiev.ua/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
            updateDate => "Unknown",
        },

	mirror030 => {
            adminContact => "",
            orgName => "chaos darmstadt",
            isoCC => "DE",
            subRegion => "Germany",
            region => "Europe",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://mirrors.chaos-darmstadt.de/tor-mirror/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://mirrors.chaos-darmstadt.de/tor-mirror/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
            updateDate => "Unknown",
        },

	mirror031 => {
            adminContact => "webmaster AT askapache DOT com",
            orgName => "AskApache",
            isoCC => "US",
            subRegion => "California",
            region => "US",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.askapache.com/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.askapache.com/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
            updateDate => "Unknown",
        },

	mirror032 => {
            adminContact => "",
            orgName => "I'm on the roof",
            isoCC => "US",
            subRegion => "",
            region => "US",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://mirror.imontheroof.com/tor-mirror/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://mirror.imontheroof.com/tor-mirror/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
            updateDate => "Unknown",
        },

	mirror033 => {
            adminContact => "",
            orgName => "bullog",
            isoCC => "CN",
            subRegion => "",
            region => "CN",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.bullog.org/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.bullog.org/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
            updateDate => "Unknown",
        },

	mirror034 => {
            adminContact => " mail AT benjamin-meier DOT info ",
            orgName => "beme it",
            isoCC => "DE",
            subRegion => "",
            region => "DE",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.beme-it.de/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "rsync://tor.beme-it.de/tor",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.beme-it.de/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "rsync://tor.beme-it.de/tor/dist",
            hiddenServiceMirror => "",
            updateDate => "Unknown",
        },

	mirror035 => {
            adminContact => "",
            orgName => "shizhao",
            isoCC => "CN",
            subRegion => "",
            region => "CN",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.shizhao.org/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.shizhao.org/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
            updateDate => "Unknown",
        },

	mirror036 => {
            adminContact => "",
            orgName => "ranyunfei",
            isoCC => "CN",
            subRegion => "",
            region => "CN",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.ranyunfei.com/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.ranyunfei.com/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
            updateDate => "Unknown",
        },

	mirror037 => {
            adminContact => "",
            orgName => "wuerkaixi",
            isoCC => "CN",
            subRegion => "",
            region => "CN",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.wuerkaixi.com/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.wuerkaixi.com/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
            updateDate => "Unknown",
        },

        mirror038 => {
            adminContact => "",
            orgName => "",
            isoCC => "IN",
            subRegion => "",
            region => "IN",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://www.torproject.org.in/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://www.torproject.org.in/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
            updateDate => "Unknown",
        },

        mirror039 => {
            adminContact => "",
            orgName => "",
            isoCC => "AT",
            subRegion => "",
            region => "LU",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.idnr.at/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.idnr.at/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        },

        mirror040 => {
            adminContact => "",
            orgName => "NIIF Institute",
            isoCC => "HU",
            subRegion => "",
            region => "HU",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://trak.tor.hu/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://trak.tor.hu/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        },

        mirror041 => {
            adminContact => "sina at accessnow.org",
            orgName => "Access",
            isoCC => "IR",
            subRegion => "",
            region => "IR",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "Yes",
            httpWebsiteMirror => "http://irani-tor.ath.cx/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://irani-tor.ath.cx/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        },

        mirror042 => {
            adminContact => "kovtalex at mail.ru",
            orgName => "",
            isoCC => "RU",
            subRegion => "",
            region => "RU",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://www.tor.myeveryday.ru/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://www.tor.myeveryday.ru/dist/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        },

        mirror043 => {
            adminContact => "",
            orgName => "",
            isoCC => "SE",
            subRegion => "",
            region => "SE",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://tor.homosu.net/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://tor.homosu.net/dist",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        },

        mirror044 => {
            adminContact => "margus.random at mail.ee",
            orgName => "CyberSIDE",
            isoCC => "#E",
            subRegion => "",
            region => "EE",
            ipv4 => "True",
            ipv6 => "False",
            loadBalanced => "No",
            httpWebsiteMirror => "http://cyberside.planet.ee/tor/",
            httpsWebsiteMirror => "",
            rsyncWebsiteMirror => "",
            ftpWebsiteMirror => "",
            httpDistMirror => "http://freedos.pri.ee/tor/",
            httpsDistMirror => "",
            rsyncDistMirror => "",
            hiddenServiceMirror => "",
        }

);

my $count = values %m;
print "We have a total of $count mirrors\n";
print "Fetching the last updated date for each mirror.\n";

my $tortime;
$tortime = FetchDate("http://www.torproject.org/");
# Adjust offical Tor time by out-of-date offset: number of days * seconds per day 
$tortime -= 1 * 172800; 
print "The official time for Tor is $tortime. \n";

foreach my $server ( keys %m ) {

    print "Attempting to fetch from $m{$server}{'orgName'}\n";

    if ($m{$server}{'httpWebsiteMirror'}) {
        print "Attempt to fetch via HTTP.\n";
        $m{$server}{"updateDate"} = FetchDate("$m{$server}{'httpWebsiteMirror'}");
    } elsif ($m{$server}{'httpsWebsiteMirror'}) {
        print "Attempt to fetch via HTTPS.\n";
        $m{$server}{"updateDate"} = FetchDate("$m{$server}{'httpsWebsiteMirror'}");
    } elsif ($m{$server}{'ftpWebsiteMirror'}) {
        print "Attempt to fetch via FTP.\n";
        $m{$server}{"updateDate"} = FetchDate("$m{$server}{'ftpWebsiteMirror'}");
    } else {
        print "We were unable to fetch or store anything. We still have the following: $m{$server}{'updateDate'}\n";
    }

    print "We fetched and stored the following: $m{$server}{'updateDate'}\n";

 }


print "We sorted the following mirrors by their date of last update: \n";
foreach my $server ( sort { $m{$b}{'updateDate'} <=> $m{$a}{'updateDate'}} keys %m ) {

     print "\n";
     print "Mirror $m{$server}{'orgName'}: \n";

     foreach my $attrib ( sort keys %{$m{$server}} ) {
        print "$attrib = $m{$server}{$attrib}";
        print "\n";
     };
}

my $outFile = "include/mirrors-table.wmi";
my $html;
open(OUT, "> $outFile") or die "Can't open $outFile: $!";

# Here's where we open a file and print some wml include goodness
# This is storted from last known recent update to unknown update times
foreach my $server ( sort { $m{$b}{'updateDate'} <=> $m{$a}{'updateDate'}} keys %m ) {

     my $time;
     if ( "$m{$server}{'updateDate'}" ne "Unknown") {
	  if ( $m{$server}{'updateDate'} > $tortime ) {
	    $time = "Up to date";
	  } else { $time = "Out of date"; }
     } else { $time = "Unknown"; }
print OUT <<"END";
     \n<tr>\n
         <td>$m{$server}{'isoCC'}</td>\n
         <td>$m{$server}{'orgName'}</td>\n
         <td>$time</td>\n
END

     my %prettyNames = (
                        httpWebsiteMirror => "http",
                        httpsWebsiteMirror => "https",
                        ftpWebsiteMirror => "ftp",
                        rsyncWebsiteMirror => "rsync",
                        httpDistMirror => "http",
                        httpsDistMirror => "https",
                        rsyncDistMirrors => "rsync", );

     foreach my $precious ( sort keys %prettyNames )
     {
        if ($m{$server}{"$precious"}) {
            print OUT "    <td><a href=\"" . $m{$server}{$precious} . "\">" .
                      "$prettyNames{$precious}</a></td>\n";
        } else { print OUT "    <td> - </td>\n"; }
     }

     print OUT "</tr>\n";
}

close(OUT);
