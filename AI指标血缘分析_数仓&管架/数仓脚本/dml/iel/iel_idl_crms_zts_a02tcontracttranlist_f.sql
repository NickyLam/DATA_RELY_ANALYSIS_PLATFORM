: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_zts_a02tcontracttranlist_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ZTS_A02TCONTRACTTRANLIST_${batch_date}_INC.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
fntseqno
,chnlid
,chnlseqno
,thirdseqno
,hostseqno
,trntype
,maincontractno
,contractno
,custno
,acctno
,trndt
,trnts
,trnbrcno
,tlrno
,authtlrno
,fnttrncd
,dsttrncd
,trnname
,trnresult
,chkflag
,prttimes
,prtworkno
,memo
,opdata
from idl.crms_zts_a02tcontracttranlist
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/ZTS_A02TCONTRACTTRANLIST_${batch_date}_INC.dat" \
        charset=zhs16gbk
        safe=yes