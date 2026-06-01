: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_cap_asset_bal_f
CreateDate: 20230525
FileName:   ${iel_data_path}/agt_cap_asset_bal.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,asset_bal_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.bus_table_name,chr(13),''),chr(10),'') as bus_table_name
,replace(replace(t1.bal_dtl_id,chr(13),''),chr(10),'') as bal_dtl_id
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.acct_b_id,chr(13),''),chr(10),'') as acct_b_id
,stl_dt
,replace(replace(t1.asset_type_name,chr(13),''),chr(10),'') as asset_type_name
,replace(replace(t1.bus_cate_name,chr(13),''),chr(10),'') as bus_cate_name
,replace(replace(t1.main_asset_id,chr(13),''),chr(10),'') as main_asset_id
,replace(replace(t1.minor_asset_id,chr(13),''),chr(10),'') as minor_asset_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,hold_pos
,hold_denom
,net_price_cost
,int_adj
,evha_val_chag
,int_cost
,full_price_cost
,impam_prep
,spd_prft
,amort_prft
,int_prft
,evha_val_chag_pl
,impam_loss
,tran_fee
,actl_int_rat
,value_dt
,exp_dt
,happ_amt
,replace(replace(t1.init_asset_bal_id,chr(13),''),chr(10),'') as init_asset_bal_id
,replace(replace(t1.strk_bal_flg,chr(13),''),chr(10),'') as strk_bal_flg
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,comm_fee_inco
,comm_fee_expns
,replace(replace(t1.pric_subj_id,chr(13),''),chr(10),'') as pric_subj_id
,replace(replace(t1.int_cost_subj_id,chr(13),''),chr(10),'') as int_cost_subj_id
,replace(replace(t1.int_adj_subj_id,chr(13),''),chr(10),'') as int_adj_subj_id
,replace(replace(t1.evha_val_chag_subj_id,chr(13),''),chr(10),'') as evha_val_chag_subj_id
,replace(replace(t1.int_income_subj_id,chr(13),''),chr(10),'') as int_income_subj_id
,replace(replace(t1.amort_prft_subj_id,chr(13),''),chr(10),'') as amort_prft_subj_id
,replace(replace(t1.evha_val_chag_pl_subj_id,chr(13),''),chr(10),'') as evha_val_chag_pl_subj_id
,replace(replace(t1.spd_prft_subj_id,chr(13),''),chr(10),'') as spd_prft_subj_id
,create_dt
,update_dt

from ${iml_schema}.agt_cap_asset_bal t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_cap_asset_bal.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
