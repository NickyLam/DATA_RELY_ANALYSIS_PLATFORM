: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_temp_wyd_payment_sched_rep_three_f
CreateDate: 20251112
FileName:   ${iel_data_path}/icms_temp_wyd_payment_sched_rep_three.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.orgid,chr(13),''),chr(10),'') as orgid
,replace(replace(t1.loanno,chr(13),''),chr(10),'') as loanno
,replace(replace(t1.term,chr(13),''),chr(10),'') as term
,replace(replace(t1.paydate,chr(13),''),chr(10),'') as paydate
,replace(replace(t1.intedate,chr(13),''),chr(10),'') as intedate
,prepay
,prepayact
,payinterestamt
,payprincipalpenaltyamt
,payinterestpenaltyamt
,actualpayinterestamt
,actualpayprincipalpenaltyamt
,actualpayinterestpenaltyamt
,reginterestamat
,replace(replace(t1.finishflag,chr(13),''),chr(10),'') as finishflag
,replace(replace(t1.finishdate,chr(13),''),chr(10),'') as finishdate
,replace(replace(t1.pstype,chr(13),''),chr(10),'') as pstype
,waiveinterestamt
,waivepenaltyamt

from ${iol_schema}.icms_temp_wyd_payment_sched_rep_three t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_temp_wyd_payment_sched_rep_three.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
