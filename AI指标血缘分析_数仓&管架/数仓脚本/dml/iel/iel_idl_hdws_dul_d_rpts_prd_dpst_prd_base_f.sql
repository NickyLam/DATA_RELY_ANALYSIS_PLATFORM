: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_prd_dpst_prd_base_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_prd_dpst_prd_base.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,t1.etl_dt as etl_dt
,replace(replace(t1.dpst_prd_id,chr(13),''),chr(10),'') as dpst_prd_id
,replace(replace(t1.dpst_prd_name,chr(13),''),chr(10),'') as dpst_prd_name
,t1.prd_start_dt as prd_start_dt
,t1.prd_terminate_dt as prd_terminate_dt
,t1.prd_int_start_dt as prd_int_start_dt
,t1.prd_due_dt as prd_due_dt
,t1.prd_cash_dt as prd_cash_dt
,t1.ipo_start_dt as ipo_start_dt
,t1.ipo_end_dt as ipo_end_dt
,replace(replace(t1.prd_appl_ccy_cd,chr(13),''),chr(10),'') as prd_appl_ccy_cd
,replace(replace(t1.appl_pty_typ_cd,chr(13),''),chr(10),'') as appl_pty_typ_cd
,t1.prd_schd_size as prd_schd_size
,t1.min_contr_amt as min_contr_amt
,t1.min_chg_amt as min_chg_amt
,t1.prd_rate as prd_rate
,replace(replace(t1.rate_base_typ_cd,chr(13),''),chr(10),'') as rate_base_typ_cd
,replace(replace(t1.rate_adj_peri_cd,chr(13),''),chr(10),'') as rate_adj_peri_cd
,replace(replace(t1.float_rate_flg,chr(13),''),chr(10),'') as float_rate_flg
,replace(replace(t1.float_mode_cd,chr(13),''),chr(10),'') as float_mode_cd
,replace(replace(t1.float_dir_cd,chr(13),''),chr(10),'') as float_dir_cd
,t1.float_val as float_val
,replace(replace(t1.peri_typ_cd,chr(13),''),chr(10),'') as peri_typ_cd
,replace(replace(t1.int_base_cd,chr(13),''),chr(10),'') as int_base_cd
,replace(replace(t1.stl_mode_cd,chr(13),''),chr(10),'') as stl_mode_cd
,replace(replace(t1.allow_rede_flg,chr(13),''),chr(10),'') as allow_rede_flg
,replace(replace(t1.allow_tfr_flg,chr(13),''),chr(10),'') as allow_tfr_flg
,replace(replace(t1.allow_impa_flg,chr(13),''),chr(10),'') as allow_impa_flg
,replace(replace(t1.allow_cmpnt_drw_flg,chr(13),''),chr(10),'') as allow_cmpnt_drw_flg
,replace(replace(t1.allow_adv_drw_flg,chr(13),''),chr(10),'') as allow_adv_drw_flg
,replace(replace(t1.adv_drw_rate_cd,chr(13),''),chr(10),'') as adv_drw_rate_cd
,t1.adv_drw_cnt as adv_drw_cnt
,replace(replace(t1.sale_chn,chr(13),''),chr(10),'') as sale_chn
,replace(replace(t1.sale_range,chr(13),''),chr(10),'') as sale_range
,replace(replace(t1.sale_org_whitl,chr(13),''),chr(10),'') as sale_org_whitl
,replace(replace(t1.sale_pty_whitl,chr(13),''),chr(10),'') as sale_pty_whitl
,t1.rate_base_val as rate_base_val
from ${idl_schema}.hdws_dul_d_rpts_prd_dpst_prd_base t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_prd_dpst_prd_base.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes