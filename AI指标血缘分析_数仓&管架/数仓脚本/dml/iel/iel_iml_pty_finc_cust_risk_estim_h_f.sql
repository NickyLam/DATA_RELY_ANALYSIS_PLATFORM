: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_finc_cust_risk_estim_h_f
CreateDate: 20211224
FileName:   ${iel_data_path}/pty_finc_cust_risk_estim_h.f.${batch_date}.dat
IF_mark:    f
Logs:
         sundexin
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.sorc_sys_cd,chr(13),''),chr(10),'') as sorc_sys_cd
,replace(replace(t.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t.party_rating_type_cd,chr(13),''),chr(10),'') as party_rating_type_cd
,replace(replace(t.rating_level_cd,chr(13),''),chr(10),'') as rating_level_cd
,t.estim_dt as estim_dt
,t.rating_effect_dt as rating_effect_dt
,t.rating_invalid_dt as rating_invalid_dt
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t.rating_chn_cd,chr(13),''),chr(10),'') as rating_chn_cd
,replace(replace(t.non_cnter_chn_buy_high_risk_prod_flg,chr(13),''),chr(10),'') as non_cnter_chn_buy_high_risk_prod_flg
from iml.pty_finc_cust_risk_estim_h t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')
    and t.job_cd in ('mpcsf1','trusf1','nfssf1','ifmsf1','irvsf1') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_finc_cust_risk_estim_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes