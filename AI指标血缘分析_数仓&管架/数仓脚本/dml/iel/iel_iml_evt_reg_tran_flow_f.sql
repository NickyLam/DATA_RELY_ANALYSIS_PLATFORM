: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_reg_tran_flow_f
CreateDate: 20230606
FileName:   ${iel_data_path}/evt_reg_tran_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.time_dep_rcpt_num,chr(13),''),chr(10),'') as time_dep_rcpt_num
,replace(replace(t1.revs_tran_seq_num,chr(13),''),chr(10),'') as revs_tran_seq_num
,replace(replace(t1.tran_seq_num,chr(13),''),chr(10),'') as tran_seq_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,acct_base_int_rat
,acct_open_acct_dt
,tran_dt
,acct_exp_dt
,replace(replace(t1.vouch_type_cd,chr(13),''),chr(10),'') as vouch_type_cd
,replace(replace(t1.loss_id,chr(13),''),chr(10),'') as loss_id
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.redt_seq_num,chr(13),''),chr(10),'') as redt_seq_num
,tax
,wdraw_amt
,tran_happ_pric
,actl_pric_amt
,tot_int_amt
,int_adj_add_amt
,provi_day_int_adj
,net_int
,float_point
,wdraw_int_rat
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
,replace(replace(t1.exp_advise_flg,chr(13),''),chr(10),'') as exp_advise_flg
,advise_dep_tenor
,pric_int_redt_cnt
,replace(replace(t1.deduct_type_cd,chr(13),''),chr(10),'') as deduct_type_cd
,replace(replace(t1.tran_scene_descb,chr(13),''),chr(10),'') as tran_scene_descb
,conti_dep_term_cnt
,replace(replace(t1.allow_add_pric_flg,chr(13),''),chr(10),'') as allow_add_pric_flg
,replace(replace(t1.redt_way_type_cd,chr(13),''),chr(10),'') as redt_way_type_cd
,dep_term_tenor
,replace(replace(t1.redt_type_cd,chr(13),''),chr(10),'') as redt_type_cd
,replace(replace(t1.part_pric_redt_flg,chr(13),''),chr(10),'') as part_pric_redt_flg
,pric_redt_cnt
,replace(replace(t1.tran_valid_flg,chr(13),''),chr(10),'') as tran_valid_flg
,tran_tm
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id

from ${iml_schema}.evt_reg_tran_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_reg_tran_flow.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
