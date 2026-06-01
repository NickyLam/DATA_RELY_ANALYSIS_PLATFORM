: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_a02tcontracttranlist_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_a02tcontracttranlist_${batch_date}_i.dat
IF_mark:    I
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 FNTSEQNO
 ,CHNLID
 ,CHNLSEQNO
 ,THIRDSEQNO
 ,HOSTSEQNO
 ,TRNTYPE
 ,MAINCONTRACTNO
 ,CONTRACTNO
 ,CUSTNO
 ,ACCTNO
 ,TRNDT
 ,TRNTS
 ,TRNBRCNO
 ,TLRNO
 ,AUTHTLRNO
 ,FNTTRNCD
 ,DSTTRNCD
 ,TRNNAME
 ,TRNRESULT
 ,CHKFLAG
 ,PRTTIMES
 ,PRTWORKNO
 ,MEMO
 ,OPDATA

from ${idl_schema}.odss_a02tcontracttranlist
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_a02tcontracttranlist_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes