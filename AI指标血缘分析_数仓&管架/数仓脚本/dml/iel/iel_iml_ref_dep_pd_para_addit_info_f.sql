: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_dep_pd_para_addit_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_dep_pd_para_addit_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.pd_cd,chr(13),''),chr(10),'') as pd_cd
,t1.min_chg_amt as min_chg_amt
,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd
,replace(replace(t1.core_tran_teller_id,chr(13),''),chr(10),'') as core_tran_teller_id
,replace(replace(t1.dom_flg,chr(13),''),chr(10),'') as dom_flg
,replace(replace(t1.transf_flg,chr(13),''),chr(10),'') as transf_flg
,t1.value_dt as value_dt
,t1.exp_dt as exp_dt
,t1.aval_lmt as aval_lmt
,t1.min_retnd_amt as min_retnd_amt
,t1.exec_int_rat as exec_int_rat
,t1.float_ratio as float_ratio
,t1.redem_int_rat as redem_int_rat
,replace(replace(t1.sellbl_chn_id,chr(13),''),chr(10),'') as sellbl_chn_id
,replace(replace(t1.redem_int_rat_type_cd,chr(13),''),chr(10),'') as redem_int_rat_type_cd
,t1.tran_in_fee as tran_in_fee
,replace(replace(t1.allow_cap_src_inside_acct_flg,chr(13),''),chr(10),'') as allow_cap_src_inside_acct_flg
,replace(replace(t1.redem_int_rat_idf,chr(13),''),chr(10),'') as redem_int_rat_idf
,replace(replace(t1.value_idf_cd,chr(13),''),chr(10),'') as value_idf_cd
,replace(replace(t1.spec_col_int_flg,chr(13),''),chr(10),'') as spec_col_int_flg
,t1.init_apot_redem_dt as init_apot_redem_dt
,t1.tran_out_fee as tran_out_fee
,replace(replace(t1.tran_out_fee_type_cd,chr(13),''),chr(10),'') as tran_out_fee_type_cd
,replace(replace(t1.sell_org_id,chr(13),''),chr(10),'') as sell_org_id
,t1.sig_min_wdraw_amt as sig_min_wdraw_amt
,replace(replace(t1.tran_in_fee_type_cd,chr(13),''),chr(10),'') as tran_in_fee_type_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.stl_acct_type_cd,chr(13),''),chr(10),'') as stl_acct_type_cd
,t1.float_int_rat as float_int_rat
,t1.sig_subscr_max_amt as sig_subscr_max_amt
from ${iml_schema}.ref_dep_pd_para_addit_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_dep_pd_para_addit_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes