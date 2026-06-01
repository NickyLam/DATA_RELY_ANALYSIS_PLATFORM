: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_trust_day_sell_h_i
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_trust_day_sell_h.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.ta_cd,chr(13),''),chr(10),'') as ta_cd
,t.issue_dt as issue_dt
,t.prod_size as prod_size
,t.lot as lot
,t.td_add_lot as td_add_lot
,t.td_decrs_lot as td_decrs_lot
,t.prod_nv as prod_nv
,t.prod_fac_val as prod_fac_val
,t.aual_yld as aual_yld
,t.prod_prft as prod_prft
,t.ten_thous_corp_prft as ten_thous_corp_prft
,replace(replace(t.prft_assign_flg,chr(13),''),chr(10),'') as prft_assign_flg
,replace(replace(t.tran_flg,chr(13),''),chr(10),'') as tran_flg
,replace(replace(t.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t.ld_prod_status_cd,chr(13),''),chr(10),'') as ld_prod_status_cd
,t.prod_acm_nv as prod_acm_nv
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.prd_trust_day_sell_h t
where t.start_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_trust_day_sell_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes