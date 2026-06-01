: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_gzfh_lnb_lncf_f
CreateDate: 20180529
FileName:   ${iel_data_path}/gzfh_lnb_lncf_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select lncfno
,acctid
,lncfna
,brchno
,prodcd
,dtitcd
,loancn
,dpacno
,inpyac
,cmitac
,cmdpac
,loantp
,crcntp
,coacid
,termcd
,disbdt
,disbsq
,matudt
,prlntg
,unprdt
,crcycd
,initam
,clcptg
,clintg
,rmcode
,rpcode
,lnrttp
,floart
,npflrt
,inrtdt
,nxindt
,cntrir
,ovduir
,retnfs
,ipcode
,nxipdt
,vlsldt
,azcode
,nxisdt
,torptm
,currtm
,eppyam
,inddrt
,idmudt
,closdt
,clossq
,taxstg
,dscrtx
,cmsqno
,ovdudt
,wngpcd
,indstg
,hdintg
,hdindt
,hdinsq
,lncfst
,lslnst
,devltg
,cntrtp
,reinst
,retndt
,enpdtp
,enpdop
,enpdam
,lnppcd
,custmg
,feestp
,feesam
,isplan
,finatp
,lnustp
,cnsgam
,hxdlfg from  ${idl_schema}.gzfh_lnb_lncf where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/gzfh_lnb_lncf_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes