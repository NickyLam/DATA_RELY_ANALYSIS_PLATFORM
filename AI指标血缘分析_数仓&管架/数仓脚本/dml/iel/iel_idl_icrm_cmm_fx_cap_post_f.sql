: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_cmm_fx_cap_post_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_cmm_fx_cap_post.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,lp_id
,bal_id
,tran_acct_b_id
,asset_type_name
,bus_cate_name
,main_asset_id
,minor_asset_id
,subj_id
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
,happ_amt
,job_cd 
,entry_org_id
,asset_thd_cls_cd
,std_prod_id
,currt_bal
from idl.icrm_cmm_fx_cap_post 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_cmm_fx_cap_post.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes