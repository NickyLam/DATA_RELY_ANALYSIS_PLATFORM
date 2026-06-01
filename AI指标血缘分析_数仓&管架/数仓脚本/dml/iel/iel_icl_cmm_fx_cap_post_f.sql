: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_fx_cap_post_f
CreateDate: 20240425
FileName:   ${iel_data_path}/cmm_fx_cap_post.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bal_id,chr(13),''),chr(10),'') as bal_id
,replace(replace(t1.entry_org_id,chr(13),''),chr(10),'') as entry_org_id
,replace(replace(t1.tran_acct_b_id,chr(13),''),chr(10),'') as tran_acct_b_id
,replace(replace(t1.asset_type_name,chr(13),''),chr(10),'') as asset_type_name
,replace(replace(t1.bus_cate_name,chr(13),''),chr(10),'') as bus_cate_name
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,replace(replace(t1.main_asset_id,chr(13),''),chr(10),'') as main_asset_id
,replace(replace(t1.minor_asset_id,chr(13),''),chr(10),'') as minor_asset_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,stl_dt
,hold_pos
,hold_fac_val
,net_price_cost
,int_adj_amt
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
,currt_bal
,happ_amt
,replace(replace(t1.int_recvbl_subj_id,chr(13),''),chr(10),'') as int_recvbl_subj_id
,replace(replace(t1.int_income_subj_id,chr(13),''),chr(10),'') as int_income_subj_id
,replace(replace(t1.bal_dtl_id,chr(13),''),chr(10),'') as bal_dtl_id
,replace(replace(t1.int_adj_subj_id,chr(13),''),chr(10),'') as int_adj_subj_id
,replace(replace(t1.evha_val_chag_subj_id,chr(13),''),chr(10),'') as evha_val_chag_subj_id
,replace(replace(t1.amort_prft_subj_id,chr(13),''),chr(10),'') as amort_prft_subj_id
,replace(replace(t1.evha_val_chag_pl_subj_id,chr(13),''),chr(10),'') as evha_val_chag_pl_subj_id
,replace(replace(t1.spd_prft_subj_id,chr(13),''),chr(10),'') as spd_prft_subj_id

from ${icl_schema}.cmm_fx_cap_post t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_fx_cap_post.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
