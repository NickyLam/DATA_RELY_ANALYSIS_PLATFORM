: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_am_ib_lend_f
CreateDate: 20230602
FileName:   ${iel_data_path}/cmm_am_ib_lend.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.acct_set_id,chr(13),''),chr(10),'') as acct_set_id
,replace(replace(t1.am_prod_id,chr(13),''),chr(10),'') as am_prod_id
,replace(replace(t1.am_prod_name,chr(13),''),chr(10),'') as am_prod_name
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.am_prod_prft_type_cd,chr(13),''),chr(10),'') as am_prod_prft_type_cd
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.asset_name,chr(13),''),chr(10),'') as asset_name
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,replace(replace(t1.asset_type_cd,chr(13),''),chr(10),'') as asset_type_cd
,replace(replace(t1.indus_type_cd,chr(13),''),chr(10),'') as indus_type_cd
,replace(replace(t1.cntpty_type_id,chr(13),''),chr(10),'') as cntpty_type_id
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'') as tran_dir_cd
,tran_dt
,value_dt
,exp_dt
,exec_int_rat
,tenor
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,tran_amt
,exp_amt
,acru_int
,tran_fee
,tran_tax
,tran_comm
,currt_bal
,td_acru_int
,currt_acru_int
,replace(replace(t1.dealer_id,chr(13),''),chr(10),'') as dealer_id
,replace(replace(t1.cntpty_dealer_id,chr(13),''),chr(10),'') as cntpty_dealer_id
,replace(replace(t1.onl_tran_flg,chr(13),''),chr(10),'') as onl_tran_flg
,replace(replace(t1.bag_id,chr(13),''),chr(10),'') as bag_id
,replace(replace(t1.tran_id,chr(13),''),chr(10),'') as tran_id
,replace(replace(t1.crdt_out_acct_flow_num,chr(13),''),chr(10),'') as crdt_out_acct_flow_num

from ${icl_schema}.cmm_am_ib_lend t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_am_ib_lend.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
