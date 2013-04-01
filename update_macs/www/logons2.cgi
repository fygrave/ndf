#!/usr/bin/perl
# operations with LogonActivity tables
# svsoldatov 24/05/2005 $

use TNK::Defs;
use TNK::DBAccess;
use TNK::CGIx;
use CGI;
use TNK::UserAccess;

my $q = new CGI();

my $user = $ENV{"REMOTE_USER"};
my $u = new TNK::UserAccess;

my @fields = ('TimeGenerated','UserName','SourceNetworkAddress','AuthenticationPackage');
##my @fields_r = ('UserName','SourceNetworkAddress','WorkstationName');
##my @req_def = ('UserName','SourceNetworkAddress');

print $q->header(-charset=>'windows-1251'), $q->start_html("Search Logons"), $q->h1("����� �� LogonActivity2"), 
	"<small>�� ������ LOGIN �������� �� ��������� ��������� ��������, ����� ������� ��� ���<br>\n",
	"�� ������ \"�������� � SIP...\" �������� �� �������� ����, ���� � ��� IE, �� ���������.<br>\n",
	"�� ������ IP ������� MAC � �������������� c6513-dc1 (��� ��������� ARP ������� ��������������, ����� ���������� <A HREF=\"/cgi-bin/find_dmz_mac.cgi\">����</A>)<br>",
	"�� ������ nslookup ����� ����������� ��������� IP (�������, ����� ���� ������ NetBIOS ���)</small>",$q->hr;

if ($q->param("find")){
	#ACL
	unless($u->getUserAccess($user, 'LOGONS') =~ /R/){
		print "<h2><center>Access for user $user on 'LOGONS' is denied!!</center></h2>\n";
		return;
	}
	
	my $d = new TNK::DBAccess();
	my $qx = new TNK::CGIx($q);
	
	my $row = $q->param("info");
	##my $what = $q->param("what_to_find");
	my $top = $q->param("top");
	unless ($top =~ /^\d+$/){
		print "<P><H3><center>���������� ����� ������ ���� ������!</p>\n";
		return;
	}
	my $from = $qx->getDate('from', 'YYYY-MM-DD HO:MI:SE');
	my $to = $qx->getDate('to', 'YYYY-MM-DD HO:MI:SE');
	my @items = split /\s+/, $row;
	push @items, '%' unless @items;
	
	my @conds = ();
	push @conds, " AND TimeGenerated >= '$from' " if $from;
	push @conds, " AND TimeGenerated <= '$to' " if $to;
	my $str_conds = join '', @conds;
	#print "\$str_conds '$str_conds'<br>\n";

	$d->connect2MSSQL('MSK-BBKSS:2433', 'svs', $TNK::Defs::SC_ETC.'/connect/security_svs');

	
	##my @turned_on = $q->param('req'); # required fields
	##my $required = '';
	##for (@turned_on){
	##	$required .= " AND LEN(RTRIM(LTRIM($_))) > 0 AND LEN(RTRIM(LTRIM($_))) <> '-' ";
	##}
	
	for my $info (@items){
  		chomp($nfo);
		my $field = 'UserName';
		if ($info =~ /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/){
			$field = 'SourceNetworkAddress';
		}
		my $sth = $d->execSQL("SELECT TOP $top ".join(',',@fields).
			" FROM LOGONACTIVITY2 ".
			" WHERE $field = '$info' $str_conds ".
			" order by TimeGenerated desc "
		);
		print "<h3>������ ������: '$info'</h3><p><small> ��� �������: $str_conds</small></p><br>\n";
		$qx->printTableSth($sth,\@fields,
			['',"<A HREF=\"https://y..yourdomaoin.ru/nomenu/addetails.aspx?name=USERLOGIN\">�������� � SIP...</A>\&nbsp;\&nbsp;<A HREF=\"/cgi-bin/find_sz.cgi?what=insert&GetLogins=1&adlogin=USERLOGIN\">",
				"<A HREF=\"/cgi-bin/nslookup.cgi?smth=SMTH\">nslookup</A>\&nbsp;\&nbsp;<A HREF=\"/cgi-bin/find_dmz_mac.cgi?mac=SMTH&routers=c6509-ac1.y.adm.yourdomaoin.ru&routers=c6509-ac2.y.adm.yourdomaoin.ru\">",
			],
			['',"</A>",
				"</A>",
			],
			['','USERLOGIN','SMTH',],
		);
	}

	$d->disconnect;
}
else {
	my $qx = new TNK::CGIx($q);
	my @cur_date = localtime(time);
	$cur_date[5] += 1900; #year
	$cur_date[4] += 1;    #mon
	
	print $q->start_form(),
	##	"��, ��� � ���� ����� � �� ������ �� IP - ��� ",$q->radio_group(-name=>"what_to_find", -values=>['UserName','WorkstationName'], -default=>'UserName'),"<br>\n",
	##	"� ���������� ������ ����������� �������������� ", $q->checkbox_group(-name=>'req', -values=>\@fields_r, -defaults=>\@req_def),"<br><br>\n",
		$q->textarea(-name=>"info",-columns=>80, -rows=>15),"\n",
		$q->br(), "\n";
	my @cur_date = localtime(time);
	$cur_date[5] += 1900; #year
	$cur_date[4] += 1;    #mon
	print "<P>������� �� ������:<br>\n";
	print "�\&nbsp;\&nbsp;: "; $qx->printDate([0,$cur_date[4],$cur_date[5],9,0,0],"from"); print "<br>\n";
	print "��: "; $qx->printDate([0,$cur_date[4],$cur_date[5],$cur_date[2],$cur_date[1],$cur_date[0]],"to"); print "<br>\n";
	print "<P>������� ��������� ", $q->textfield(-name=>'top', -value=>10, -size=>3)," �����<br><br>\n";
	print $q->submit(-name=>'find', -value=>"Find!"), "\n",
		$q->reset("Clear"),"\n";
	print $q->endform(),"\n",
		"\n";
}

print $q->hr, "<small>��� ������� � ��������� �� ������ ���������� �������� �� <a href=\"mailto:svsoldatov\@yourdomaoin.ru\">svsoldatov\@yourdomaoin.ru</a></small><br>\n", $q->end_html,"\n";

