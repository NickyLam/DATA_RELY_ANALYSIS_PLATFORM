: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_imp_fin_bus_info_f
CreateDate: 20260226
FileName:   ${iel_data_path}/cmm_imp_fin_bus_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.trust_name,chr(13),''),chr(10),'') as trust_name
,replace(replace(t1.fin_acct_id,chr(13),''),chr(10),'') as fin_acct_id
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'') as oper_org_id
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.fin_status_cd,chr(13),''),chr(10),'') as fin_status_cd
,trust_create_dt
,trust_open_dt
,trust_exp_dt
,trust_effect_dt
,trust_revo_dt
,actl_repay_dt
,negot_days
,actl_negot_days
,replace(replace(t1.ovdue_flg,chr(13),''),chr(10),'') as ovdue_flg
,exec_int_rat
,ovdue_int_rat
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
,replace(replace(t1.int_set_way_cd,chr(13),''),chr(10),'') as int_set_way_cd
,replace(replace(t1.int_rat_adj_ped_cd,chr(13),''),chr(10),'') as int_rat_adj_ped_cd
,payfan_int_amt
,payfan_pnlt_int_rat
,payfan_comm_fee_amt
,ths_tm_pay_amt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,paybl_pric_bal
,td_int_expns
,replace(replace(t1.era_pay_bank_cust_id,chr(13),''),chr(10),'') as era_pay_bank_cust_id
,replace(replace(t1.era_pay_bank_cust_name,chr(13),''),chr(10),'') as era_pay_bank_cust_name
,currt_int_amt

from ${icl_schema}.cmm_imp_fin_bus_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_imp_fin_bus_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
