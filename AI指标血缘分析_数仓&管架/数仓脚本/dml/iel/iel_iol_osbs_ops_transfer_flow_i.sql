: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_osbs_ops_transfer_flow_i
CreateDate: 20180529
FileName:   ${iel_data_path}/osbs_ops_transfer_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.otf_trade_flowno,chr(13),''),chr(10),'') as otf_trade_flowno
    ,replace(replace(t.otf_tran_seqno,chr(13),''),chr(10),'') as otf_tran_seqno
    ,replace(replace(t.otf_global_seqno,chr(13),''),chr(10),'') as otf_global_seqno
    ,replace(replace(t.otf_transcode,chr(13),''),chr(10),'') as otf_transcode
    ,replace(replace(t.otf_transdate,chr(13),''),chr(10),'') as otf_transdate
    ,replace(replace(t.otf_payeraccountnumber,chr(13),''),chr(10),'') as otf_payeraccountnumber
    ,replace(replace(t.otf_payeraccountname,chr(13),''),chr(10),'') as otf_payeraccountname
    ,replace(replace(t.otf_payeraccounttype,chr(13),''),chr(10),'') as otf_payeraccounttype
    ,replace(replace(t.otf_payerpartyid,chr(13),''),chr(10),'') as otf_payerpartyid
    ,replace(replace(t.otf_payeeaccountnumber,chr(13),''),chr(10),'') as otf_payeeaccountnumber
    ,replace(replace(t.otf_payeeaccountname,chr(13),''),chr(10),'') as otf_payeeaccountname
    ,replace(replace(t.otf_payeeaccounttype,chr(13),''),chr(10),'') as otf_payeeaccounttype
    ,replace(replace(t.otf_currency,chr(13),''),chr(10),'') as otf_currency
    ,t.otf_amount as otf_amount
    ,t.otf_fee as otf_fee
    ,replace(replace(t.otf_rcvbankid,chr(13),''),chr(10),'') as otf_rcvbankid
    ,replace(replace(t.otf_rcvbankname,chr(13),''),chr(10),'') as otf_rcvbankname
    ,replace(replace(t.otf_rcvbankbranch,chr(13),''),chr(10),'') as otf_rcvbankbranch
    ,replace(replace(t.otf_rcvbankbranchname,chr(13),''),chr(10),'') as otf_rcvbankbranchname
    ,replace(replace(t.otf_provincecode,chr(13),''),chr(10),'') as otf_provincecode
    ,replace(replace(t.otf_provincename,chr(13),''),chr(10),'') as otf_provincename
    ,replace(replace(t.otf_citycode,chr(13),''),chr(10),'') as otf_citycode
    ,replace(replace(t.otf_cityname,chr(13),''),chr(10),'') as otf_cityname
    ,replace(replace(t.otf_rcvmobile,chr(13),''),chr(10),'') as otf_rcvmobile
    ,replace(replace(t.otf_rcvsms,chr(13),''),chr(10),'') as otf_rcvsms
    ,replace(replace(t.otf_transuse,chr(13),''),chr(10),'') as otf_transuse
    ,replace(replace(t.otf_securitytype,chr(13),''),chr(10),'') as otf_securitytype
    ,replace(replace(t.otf_limitattribute,chr(13),''),chr(10),'') as otf_limitattribute
    ,replace(replace(t.otf_optype,chr(13),''),chr(10),'') as otf_optype
    ,replace(replace(t.otf_pathid,chr(13),''),chr(10),'') as otf_pathid
    ,replace(replace(t.otf_msgtemplate,chr(13),''),chr(10),'') as otf_msgtemplate
    ,replace(replace(t.otf_isnextday,chr(13),''),chr(10),'') as otf_isnextday
    ,replace(replace(t.otf_transpaycode,chr(13),''),chr(10),'') as otf_transpaycode
    ,replace(replace(t.otf_savercv,chr(13),''),chr(10),'') as otf_savercv
    ,replace(replace(t.otf_routeid,chr(13),''),chr(10),'') as otf_routeid
    ,replace(replace(t.otf_routename,chr(13),''),chr(10),'') as otf_routename
    ,replace(replace(t.otf_transfermobile,chr(13),''),chr(10),'') as otf_transfermobile
    ,replace(replace(t.otf_sysflag,chr(13),''),chr(10),'') as otf_sysflag
    ,replace(replace(t.otf_transtype,chr(13),''),chr(10),'') as otf_transtype
    ,replace(replace(t.otf_orderid,chr(13),''),chr(10),'') as otf_orderid
from iol.osbs_ops_transfer_flow t
  where t.otf_transdate = '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/osbs_ops_transfer_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes