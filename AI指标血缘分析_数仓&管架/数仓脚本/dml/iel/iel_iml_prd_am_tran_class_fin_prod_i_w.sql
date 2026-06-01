: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_am_tran_class_fin_prod_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_am_tran_class_fin_prod_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.fin_prod_id,chr(13),''),chr(10),'') as fin_prod_id 
,replace(replace(t1.brch_seq_num,chr(13),''),chr(10),'') as brch_seq_num 
,replace(replace(t1.prod_cate_cd,chr(13),''),chr(10),'') as prod_cate_cd 
,replace(replace(t1.prft_mode_cd,chr(13),''),chr(10),'') as prft_mode_cd 
,replace(replace(t1.brch_type_cd,chr(13),''),chr(10),'') as brch_type_cd 
,replace(replace(t1.pass_id,chr(13),''),chr(10),'') as pass_id 
,t1.nati_pric as nati_pric 
,replace(replace(t1.pric_curr_cd,chr(13),''),chr(10),'') as pric_curr_cd 
,t1.value_dt as value_dt 
,t1.exp_dt as exp_dt 
,t1.tenor_days as tenor_days 
,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd 
,t1.fix_int_rat as fix_int_rat 
,replace(replace(t1.float_int_rat_base_id,chr(13),''),chr(10),'') as float_int_rat_base_id 
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd 
,t1.exp_pric as exp_pric 
,t1.exp_int as exp_int 
,t1.exp_amt as exp_amt 
,replace(replace(t1.brkevn_flg,chr(13),''),chr(10),'') as brkevn_flg 
,replace(replace(t1.init_prod_id,chr(13),''),chr(10),'') as init_prod_id 
,replace(replace(t1.tran_site_cd,chr(13),''),chr(10),'') as tran_site_cd 
,replace(replace(t1.tran_caln_cd,chr(13),''),chr(10),'') as tran_caln_cd 
,replace(replace(t1.tenor_breed_cd,chr(13),''),chr(10),'') as tenor_breed_cd 
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id 
,t1.create_tm as create_tm 
,t1.update_tm as update_tm 
,t1.exp_corp_net_price as exp_corp_net_price 
,t1.exp_corp_int as exp_corp_int 
,t1.exp_corp_full_price as exp_corp_full_price 
,t1.exp_prft as exp_prft 
,replace(replace(t1.exp_stl_way_cd,chr(13),''),chr(10),'') as exp_stl_way_cd 
,t1.fst_dlvy_dt as fst_dlvy_dt 
,t1.exp_dlvy_dt as exp_dlvy_dt 
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id 
,t1.actl_poses_acct_days as actl_poses_acct_days 
,replace(replace(t1.pd_id,chr(13),''),chr(10),'') as pd_id 
,replace(replace(t1.cont_name,chr(13),''),chr(10),'') as cont_name 
,replace(replace(t1.rgst_trust_org_cd,chr(13),''),chr(10),'') as rgst_trust_org_cd 
,t1.col_cnt as col_cnt 
,replace(replace(t1.attach_claus,chr(13),''),chr(10),'') as attach_claus 
,replace(replace(t1.provi_pnlt_flg,chr(13),''),chr(10),'') as provi_pnlt_flg 
,replace(replace(t1.pnlt_provi_base,chr(13),''),chr(10),'') as pnlt_provi_base 
,t1.job_cd
from ${iml_schema}.prd_am_tran_class_fin_prod t1 
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6 ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_am_tran_class_fin_prod_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes