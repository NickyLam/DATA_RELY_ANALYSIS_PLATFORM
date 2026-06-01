: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_f_evt_dp_kdl_bill_i
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_f_evt_dp_kdl_bill_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select trandt
,billsq
,transq
,acctbr
,acctid
,acctno
,subsac
,trantp
,amntcd
,crcycd
,tranam
,tranbl
,tranbr
,smrycd
,toacct
,tosbac
,toacna
,cheqtp
,cheqno
,cqtpid
,bkusid
,ckbkus
,corrtg
,dscrtx
,timstp from idl.pirs_f_evt_dp_kdl_bill where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_f_evt_dp_kdl_bill_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes