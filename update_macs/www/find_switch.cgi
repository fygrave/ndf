#!/usr/bin/perl
#will find right switch for host by IP-address
#svsoldatov, march, 3 2003


##use lib "/home/svs/svn/fwlogs/src/perllib";
use CGI;
use TNK::Defs;
use TNK::DBAccess;
use TNK::Switch::Switch;
use TNK::Utils;
use TNK::CGIx;
use TNK::UserAccess;

$SERVER = 'MSK-BBKSS:2433';
$USER = 'svs';

##configs & descriptions for DB ===============
my @DELETED = ('No','Yes');                  #=
my @MAC_FILEDS = ('deleted', 'itype');       #=
my @MAC_TYPES_DESCR = ('desktop', 'laptop'); #=
##=============================================

my $q = new CGI();
#my $q = new CGI("find=1&afind=1&mac2=00-11-85-10-48-D5");
print $q->header(-charset=>'windows-1251'), $q->start_html("Searching switch");

my $u = new TNK::UserAccess;
my $user = $ENV{"REMOTE_USER"};

my $what = $q->param('what');

if ($what eq 'find'){
	if ($q->param('afind')){ 
		#ACL
		unless($u->getUserAccess($user, 'MACs') =~ /R/){
			print "<h2><center>Access 'R' for user $user on 'MACs' is denied!!</center></h2>\n";
			return;
		}
		##$, = " "; ##DEBUG
		##print "Switches: ",(keys %TNK::Switch::Switch::SWITCHES),"<BR>\n"; ##DEBUG

		my $u = new TNK::Utils;
		my $d = new TNK::DBAccess();

		$d->connect2MSSQL($SERVER, $USER,  $TNK::Defs::SC_ETC.'/connect/security_svs');
		print "<H1>Find Switch</H1><HR>";
		
		my $sz_href_MAC = "<A HREF=\"/cgi-bin/find_sz.cgi?what=find\&info=MMAACC\&Find!=Find!\&what_to_find=Ищем по ресурсу\&OutFmt=Вывести в формате по умолчанию\&OrderBy=По убыванию даты вставки\">MMAACC</A>";
		if ($q->param('mac')){
			my @addr = split /\s+/, $q->param('mac');
			##print @addr,"\n";
			for my $item ( @addr) {
				next unless $item;
				my $sth;
				$uitem = uc $item;
				if ($q->param('ipmac') eq 'IP'){
					$sth = $d->execSQL("SELECT username,ip,mac,switch,port,vlan,firstseen,lastseen,deleted,itype ".
						" FROM MACS WHERE ip like '%$uitem%' ORDER BY lastseen DESC");
				}
				elsif ($q->param('ipmac') eq 'UserName'){
					$sth = $d->execSQL("SELECT username,ip,mac,switch,port,vlan,firstseen,lastseen,deleted,itype ".
						" FROM MACS WHERE UserName like '%$uitem%' ORDER BY lastseen DESC");
				}
				elsif ($q->param('ipmac') eq 'VLAN'){
					$sth = $d->execSQL("SELECT username,ip,mac,switch,port,vlan,firstseen,lastseen,deleted,itype ".
						" FROM MACS WHERE vlan = $uitem ORDER BY lastseen DESC");
				}
				else {
					my $ttt = $u->mac_dashed($uitem);
					$uitem = $ttt?$ttt:$uitem;

					$sth = $d->execSQL("SELECT username,ip,mac,switch,port,vlan,firstseen,lastseen,deleted,itype ".
						" FROM MACS WHERE mac like '%$uitem%' ORDER BY lastseen DESC");
				}
				print "<h3>Template '$item'</h3>\n";
			
				print "<TABLE BORDER=\"1\" CELLSPACING=\"0\"><TR><TH>UserName<TH>IP<TH>MAC<TH>Switch<TH>port<TH>VLAN"
					."<TH>First Seen<TH>Last Seen<TH>Deleted?<TH>Type<TH>History</TR>\n";
				while (my ($userName,$ip,$mac,$switch,$port,$vlan,$firstseen,$lastseen,$deleted,$itype) = $sth->fetchrow_array){
					my ($is_hist) = $d->execSELECT("SELECT count(*) FROM MACS_HISTORY WHERE mac='$mac'");
					my $sz_href_MAC1 = $sz_href_MAC;
					$sz_href_MAC1 =~ s/MMAACC/$mac/g;
					print "<TR><TD><A HREF=\"https://y..yourdomaoin.ru/nomenu/addetails.aspx?name=$userName\">$userName</A>\&nbsp;<TD>\&nbsp;$ip".
						"<TD>\&nbsp;$sz_href_MAC1".
						"<TD><A HREF=\"/cgi-bin/sh_switch_info.cgi?switch=$switch\">$switch</A><TD>".
						"<A HREF=\"/cgi-bin/sh_port_info.cgi?switch=$switch&port=$port\">\&nbsp;$port</A><TD>".
						"\&nbsp;$vlan<TD>\&nbsp;$firstseen".
						"<TD>\&nbsp;$lastseen<TD>".$DELETED[$deleted]."<TD>".$MAC_TYPES_DESCR[$itype]."<TD>\&nbsp;";
					print "<A HREF=\"/cgi-bin/find_switch.cgi?what=hisroty\&mac=$mac\">$is_hist items</A>" if $is_hist;
					print "</TR>\n";
				}
				print "</TABLE>\n<HR>\n";
			}
		}
		if ($q->param('switch')){
			my ($switch, $port) = ($q->param('switch'), $q->param('port'));
			my $cond = " switch like '%$switch%' ";
			$cond .= " AND port like '%$port%' " if $port;
			my $sth = $d->execSQL("SELECT username,ip,mac,switch,port,vlan,firstseen,lastseen,deleted,itype FROM MACS WHERE $cond ");

			print "<TABLE BORDER=\"1\" CELLSPACING=\"0\"><TR><TH>UserName<TH>IP<TH>MAC<TH>Switch<TH>port<TH>VLAN"
				."<TH>First Seen<TH>Last Seen<TH>Deleted?<TH>Type<TH>History</TR>\n";
			while (my ($userName,$ip,$mac,$switch,$port,$vlan,$firstseen,$lastseen,$deleted,$itype) = $sth->fetchrow_array){
				my ($is_hist) = $d->execSELECT("SELECT count(*) FROM MACS_HISTORY WHERE mac='$mac'");
				my $sz_href_MAC1 = $sz_href_MAC;
				$sz_href_MAC1 =~ s/MMAACC/$mac/g;
				print "<TR><TD>\&nbsp;$userName<TD>\&nbsp;$ip<TD>\&nbsp;$sz_href_MAC1".
					"<TD><A HREF=\"/cgi-bin/sh_switch_info.cgi?switch=$switch\">$switch</A><TD>".
					"\&nbsp;$port<TD>\&nbsp;$vlan<TD>\&nbsp;$firstseen".
					"<TD>\&nbsp;$lastseen<TD>".$DELETED[$deleted]."<TD>".$MAC_TYPES_DESCR[$itype]."<TD>\&nbsp;";
				print "<A HREF=\"/cgi-bin/find_switch.cgi?what=hisroty\&mac=$mac\">$is_hist items</A>" if $is_hist;
				print "</TR>\n";
			}
			print "</TABLE>\n<HR>\n";
		}
		##if ($q->param('mac2')){
		##	my @addr = split /\s+/, $q->param('mac2');
		##	my $vmps_server = "c6509-ac52.".$TNK::Switch::Switch::SWITCHESZONE; # SWITCHESZONE - from Switches.conf 
		##	my $sw = new TNK::Switch::Switch('',0);
		##	print "<p>Error while connecting to '$vmps_server'!!!</p><br>" unless $sw;
		##	$sw->connect2switch($vmps_server);
		##	print "<FONT SIZE=\"3\" FACE=\"Courier\" COLOR=\"Red\"><h2>VMPS domain server: $vmps_server</h2></FONT>\n";
		##
		##	for my $item ( @addr) {
		##		next unless $item;
		##		print "<P><FONT SIZE=\"3\" FACE=\"Courier\" COLOR=\"Blue\"><h3>$item</h3>\n";
		##		my $res = $sw->cmdScalar("sh vmps mac $item");
		##		$res =~ s/\n/<BR>/g;
		##		$res =~ s/ /\&nbsp;/g;
		##		print $res,"</FONT></P><hr>\n";
		##	}
		##		
		##}

		$d->disconnect();
	}
	else {
	        ##print $q->h1("<BLINK>Сервис работает неправильно!!!</BLINK>"),
	        print $q->h1("Find Switch"),
			$q->hr(),
	                $q->start_form(),"\n",
	                $q->submit(-name=>"afind", -value=>"Find!"),"\n",
        	        $q->reset("Clear"),"<BR>\n",
	                $q->p("Enter ", "\n",
			$q->radio_group(-name=>"ipmac", -values=>['UserName','IP', 'VLAN','MAC'], -default=>'MAC'), "\n"),
	                $q->textarea(-name=>"mac", -columns=>100, -rows=>10),"\n",
			"<P><B>OR</B></P>","\n",
			$q->p("Switch: ",
				$q->textfield(-name=>"switch", -size=>20),"\n",
				"Port: ",
				$q->textfield(-name=>"port", -size=>20),"\n",
			),"\n",
	                $q->br(),"\n",
			##"\n<br><b>OR</b><br>\n",
			##$q->p("Enter MACs (XX-XX-XX-XX-XX-XX) to check if it is in VMPS DB<br>\n",
			##	$q->textarea(-name=>"mac2", -columns=>100, -rows=>10),"\n",
			##),"\n",
	                $q->submit(-name=>"afind", -value=>"Find!"),"\n",
        	        $q->reset("Clear"),"\n",
			$q->hidden("what","find"),"\n",
        	        $q->endform(),"\n",
        	        $q->hr();
	}
}
elsif($what eq 'hisroty'){
	#ACL
	unless($u->getUserAccess($user, 'MACs') =~ /R/){
		print "<h2><center>Access 'R' for user $user on 'MACs' is denied!!</center></h2>\n";
		return;
	}
	##exit 0; ## BUG bug in MACs_HISTORY table
	
	my $mac = $q->param('mac');
	my $d = new TNK::DBAccess();
	my $cgix = new TNK::CGIx;
	
	$d->connect2MSSQL($SERVER, $USER,  $TNK::Defs::SC_ETC.'/connect/security_svs');
	print "<H1>History of '$mac' ...</H1><HR>\n";
	my $sth = $d->execSQL("SELECT username,ip,mac,switch,port,vlan,firstseen,lastseen,dtGenerated FROM MACS_HISTORY WHERE mac='$mac' ORDER BY lastseen DESC");
	
	$cgix->printTableSth($sth, ['UserName','IP','MAC','Switch','Port','VLAN','First Seen','Last Seen','Inserted']);
	
	$d->disconnect;

}
elsif($what eq 'update'){
	#ACL
	unless($u->getUserAccess($user, 'MACs') =~ /W/){
		print "<h2><center>Access 'W' for user $user on 'MACs' is denied!!</center></h2>\n";
		return;
	}
	my $macs = $q->param('macs');
	if($macs){
		my ($field, $fieldvalue) = ($q->param('field'),$q->param('fieldvalue'));
		my $d = new TNK::DBAccess();
		my $u = new TNK::Utils;
		$d->connect2MSSQL($SERVER, $USER,  $TNK::Defs::SC_ETC.'/connect/security_svs');
		##print "<I>'$SERVER' '$USER'</I><BR>\n";
		my @macs_ar = split /\s+/, $macs;
		foreach my $m (@macs_ar){
			my $mm = uc ($u->mac_dashed($m));
			unless ($mm){
				print "<FONT SIZE=\"3\" FACE=\"Courier\" COLOR=\"Red\"><h2>Error in MAC format for '$m'</h2></font>\n";
				exit 1;
			}
			print "<p>Update MAC '<B>$mm</B>' ($m): set $field = $fieldvalue</P>\n";
			$d->execDO("UPDATE MACS SET $field = $fieldvalue  WHERE mac='$mm'");
		}
		$d->disconnect;
	}
	else {
		 print $q->h1("Update MACs (set [some field] = smth.)"),$q->hr(),
		 	$q->start_form(),
			$q->popup_menu("field",\@MAC_FILEDS)," = \n",
			$q->textfield(-name=>'fieldvalue', -size=>20),"<BR>\n",
			$q->p("Enter MACs <br>\n", 
				$q->textarea(-name=>"macs", -columns=>100, -rows=>10)
			),"\n",
			$q->hidden("what","update"),
			$q->submit("Update!"),"\n",
			$q->reset("Clear"),"\n",
			$q->endform(),"\n",
			$q->hr(),"\n";
	}
}

print $q->end_html(),"\n";

