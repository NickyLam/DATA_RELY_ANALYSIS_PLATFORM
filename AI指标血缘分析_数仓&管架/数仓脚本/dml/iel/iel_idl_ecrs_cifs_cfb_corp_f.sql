: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ecrs_cifs_cfb_corp_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ecrs_cifs_cfb_corp_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
custno
,psrntg
,lwctna
,lwidno
,cptnnm
,vocatp
,orgacd
,orgatp
,orgaed
,rdtdmk
,orgast
,corpid
,corppr
,corptp
,cpmntp
,sizeid
,rgstad
,establ
,regidt
,regicy
,regiam
,regiad
,stafnm
,dealsp
,operar
,psarow
,baseno
,baseac
,bsbkno
,bsbkna
,bsopdt
,bsapdt
,rlcpcy
,rlcpam
,lncdno
,lncdpw
,lncdtg
,lncddt
,lncdst
,lcditg
,lcdidt
,lcdrdt
,locatx
,lotxdt
,lotxed
,lotxog
,natitx
,natxdt
,natxed
,natxog
,upcrna
,uprgcy
,uprgam
,upcrps
,upidtp
,upidno
,upopno
,upcpcd
,upcped
,retxtg
,txdpid
,iscuim
,isexim
,ishtch
,iscmkt
,ispart
,stckam
,isgrup
,gropid
,isgrmo
,remark
,ctylev
,waylv5
,etpcht
,ntlycd
,cuslv3
,custp3
,lmtway
,rpmltp
,retinm
,unvrnm
,isdrec
,provce
,inoutp
,worang
,supeor
,buldmy
,budgtp
,orgown
,cdradt
,prfd01
,prfd02
,prfd03
,prfd04
,prfd05
,csumon
,summon
,salmon
,sizehy
,isbank
,banksz
,xwqyid
,dgkhlx
,jjzzxs
,jjbmlx
,caccno
,econtp
,scjydz
,teleno
,regitp
,regino
,vocamx
from idl.ecrs_cifs_cfb_corp
where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/ecrs_cifs_cfb_corp_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes