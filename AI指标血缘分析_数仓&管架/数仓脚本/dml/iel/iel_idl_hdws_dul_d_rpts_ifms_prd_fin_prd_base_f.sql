: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_ifms_prd_fin_prd_base_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_ifms_prd_fin_prd_base.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.fin_prd_id,chr(13),''),chr(10),'') as fin_prd_id
,t1.etl_dt as etl_dt
,t1.last_update_dt as last_update_dt
,replace(replace(t1.prd_name,chr(13),''),chr(10),'') as prd_name
,t1.prd_estab_dt as prd_estab_dt
,t1.prd_start_dt as prd_start_dt
,t1.prd_pause_sale_dt as prd_pause_sale_dt
,t1.prd_terminate_dt as prd_terminate_dt
,t1.prd_int_start_dt as prd_int_start_dt
,t1.ipo_stdt as ipo_stdt
,t1.ipo_end_dt as ipo_end_dt
,t1.income_due_day as income_due_day
,replace(replace(t1.prd_appl_ccy_cd,chr(13),''),chr(10),'') as prd_appl_ccy_cd
,replace(replace(t1.appl_pty_typ_cd,chr(13),''),chr(10),'') as appl_pty_typ_cd
,replace(replace(t1.appl_pty_crdt_rat_typ_cd,chr(13),''),chr(10),'') as appl_pty_crdt_rat_typ_cd
,replace(replace(t1.appl_pty_crdt_rat_resu_cd,chr(13),''),chr(10),'') as appl_pty_crdt_rat_resu_cd
,replace(replace(t1.appl_corp_pty_corp_size_cd,chr(13),''),chr(10),'') as appl_corp_pty_corp_size_cd
,t1.long_contr_term as long_contr_term
,t1.sht_contr_term as sht_contr_term
,t1.max_contr_amt as max_contr_amt
,t1.min_contr_amt as min_contr_amt
,t1.prd_schd_size as prd_schd_size
,replace(replace(t1.prft_fea_cd,chr(13),''),chr(10),'') as prft_fea_cd
,replace(replace(t1.liqdt_mode_cd,chr(13),''),chr(10),'') as liqdt_mode_cd
,t1.prd_term as prd_term
,replace(replace(t1.issue_ccy,chr(13),''),chr(10),'') as issue_ccy
,t1.annu_return_rate as annu_return_rate
,t1.expt_yld as expt_yld
,t1.actl_yld as actl_yld
,replace(replace(t1.risk_rank_cd,chr(13),''),chr(10),'') as risk_rank_cd
,replace(replace(t1.divi_mode_cd,chr(13),''),chr(10),'') as divi_mode_cd
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,t1.etl_task_name as etl_task_name
,replace(replace(t1.fin_prd_templ_cd,chr(13),''),chr(10),'') as fin_prd_templ_cd
,replace(replace(t1.templ_comm,chr(13),''),chr(10),'') as templ_comm
from ${idl_schema}.hdws_dul_d_rpts_ifms_prd_fin_prd_base t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_ifms_prd_fin_prd_base.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes