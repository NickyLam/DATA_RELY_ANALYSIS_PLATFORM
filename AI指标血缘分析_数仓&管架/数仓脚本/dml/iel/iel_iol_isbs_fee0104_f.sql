: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_isbs_fee0104_f
CreateDate: 20240507
FileName:   ${iel_data_path}/isbs_fee0104.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.inr,chr(13),''),chr(10),'') as inr
,replace(replace(t1.trninr,chr(13),''),chr(10),'') as trninr
,credattim
,replace(replace(t1.seq,chr(13),''),chr(10),'') as seq
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.fee_type,chr(13),''),chr(10),'') as fee_type
,replace(replace(t1.fee_ccy,chr(13),''),chr(10),'') as fee_ccy
,fee_amt
,replace(replace(t1.fee_charge_method,chr(13),''),chr(10),'') as fee_charge_method
,replace(replace(t1.charge_mode,chr(13),''),chr(10),'') as charge_mode
,replace(replace(t1.charge_to_base_acct_no,chr(13),''),chr(10),'') as charge_to_base_acct_no
,replace(replace(t1.charge_to_acct_seq_no,chr(13),''),chr(10),'') as charge_to_acct_seq_no
,replace(replace(t1.withdrawal_type,chr(13),''),chr(10),'') as withdrawal_type
,replace(replace(t1.effect_date,chr(13),''),chr(10),'') as effect_date
,replace(replace(t1.amort_start,chr(13),''),chr(10),'') as amort_start
,replace(replace(t1.amort_end,chr(13),''),chr(10),'') as amort_end
,replace(replace(t1.feecod,chr(13),''),chr(10),'') as feecod
,replace(replace(t1.ownkey,chr(13),''),chr(10),'') as ownkey
,replace(replace(t1.othcli,chr(13),''),chr(10),'') as othcli

from ${iol_schema}.isbs_fee0104 t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/isbs_fee0104.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
