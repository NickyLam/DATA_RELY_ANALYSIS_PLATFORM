: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_eifs_customer_supplement_info_pub_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_eifs_customer_supplement_info_pub.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select custno
,lncdpw
,lncdtg
,lncddt
,lncdst
,lcditg
,lcdidt
,lcdrdt
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
,ishtch
,stckam
,isgrup
,gropid
,isgrmo
,ctylev
,waylv5
,etpcht
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
,salmon
,sizehy
,isbank
,banksz
,xwqyid
,jjzzxs
,jjbmlx
,caccno
,econtp
,teleno
,vocamx
,psrntg
,lwctna
,lwidno
,cptnnm
,vocatp
,rgstad
,regidt
,regiad
,operar
,custlv
,statlv
,jonttg
,doubtp
,tttrib
,ttrema
,risklv
,datatp
,roletp
,isincu
,iscred
,credid
,credln
,last_updated_stamp
,last_updated_tx_stamp
,created_stamp
,created_tx_stamp
,bankno
,banklv
,bktpid
,jjdl
,start_dt
,end_dt
,id_mark
,etl_timestamp from idl.aml_eifs_customer_supplement_info_pub where start_dt<=to_date('${batch_date}','yyyymmdd') and end_dt>to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_eifs_customer_supplement_info_pub.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes