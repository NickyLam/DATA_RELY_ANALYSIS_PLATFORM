: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_temp_wyd_loan_trans_detail_rep_three_f
CreateDate: 20251112
FileName:   ${iel_data_path}/icms_temp_wyd_loan_trans_detail_rep_three.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.orgid,chr(13),''),chr(10),'') as orgid
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.oldtransserialno,chr(13),''),chr(10),'') as oldtransserialno
,replace(replace(t1.bizseq,chr(13),''),chr(10),'') as bizseq
,replace(replace(t1.txndate,chr(13),''),chr(10),'') as txndate
,replace(replace(t1.loanno,chr(13),''),chr(10),'') as loanno
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,replace(replace(t1.txncode,chr(13),''),chr(10),'') as txncode
,replace(replace(t1.txndesc,chr(13),''),chr(10),'') as txndesc
,postamt
,replace(replace(t1.txntime,chr(13),''),chr(10),'') as txntime
,replace(replace(t1.postdate,chr(13),''),chr(10),'') as postdate
,replace(replace(t1.youracctno,chr(13),''),chr(10),'') as youracctno
,replace(replace(t1.youracctname,chr(13),''),chr(10),'') as youracctname
,replace(replace(t1.yourbankid,chr(13),''),chr(10),'') as yourbankid
,replace(replace(t1.transflag,chr(13),''),chr(10),'') as transflag
,replace(replace(t1.payeeacct,chr(13),''),chr(10),'') as payeeacct
,replace(replace(t1.payeename,chr(13),''),chr(10),'') as payeename
,replace(replace(t1.payeebrno,chr(13),''),chr(10),'') as payeebrno
,replace(replace(t1.payeebrname,chr(13),''),chr(10),'') as payeebrname
,replace(replace(t1.settleid,chr(13),''),chr(10),'') as settleid
,replace(replace(t1.accttype,chr(13),''),chr(10),'') as accttype
,replace(replace(t1.capitaltransserialno,chr(13),''),chr(10),'') as capitaltransserialno

from ${iol_schema}.icms_temp_wyd_loan_trans_detail_rep_three t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_temp_wyd_loan_trans_detail_rep_three.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
