: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_tps_margin_acct_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_tps_margin_acct_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id
,t.open_dt as open_dt
,replace(replace(t.broker_cd,chr(13),''),chr(10),'') as broker_cd
,replace(replace(t.secu_cap_acct_id,chr(13),''),chr(10),'') as secu_cap_acct_id
,t.asset_bal as asset_bal
,replace(replace(t.margin_status,chr(13),''),chr(10),'') as margin_status
,t.rgst_dt as rgst_dt
,replace(replace(t.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_tps_margin_acct_h t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_tps_margin_acct_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes