: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_dep_int_rat_info_h_f
CreateDate: 20231008
FileName:   ${iel_data_path}/agt_dep_int_rat_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.int_rat_apv_form_id,chr(13),''),chr(10),'') as int_rat_apv_form_id
,replace(replace(t1.init_apv_form_id,chr(13),''),chr(10),'') as init_apv_form_id
,replace(replace(t1.add_agt_flg_cd,chr(13),''),chr(10),'') as add_agt_flg_cd
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.int_rat_apv_appl_cate_cd,chr(13),''),chr(10),'') as int_rat_apv_appl_cate_cd
,replace(replace(t1.int_rat_agt_status_cd,chr(13),''),chr(10),'') as int_rat_agt_status_cd
,replace(replace(t1.int_rat_apv_form_dep_breed_cd,chr(13),''),chr(10),'') as int_rat_apv_form_dep_breed_cd
,replace(replace(t1.new_acct_num_flg,chr(13),''),chr(10),'') as new_acct_num_flg
,int_rat_agt_tenor
,replace(replace(t1.int_rat_agt_tenor_corp_cd,chr(13),''),chr(10),'') as int_rat_agt_tenor_corp_cd
,dep_tenor
,replace(replace(t1.dep_tenor_corp_cd,chr(13),''),chr(10),'') as dep_tenor_corp_cd
,base_rat
,float_ratio
,exec_int_rat
,replace(replace(t1.rs_descb,chr(13),''),chr(10),'') as rs_descb
,agt_effect_dt
,agt_invalid_dt
,replace(replace(t1.hxb_crdt_cust_flg,chr(13),''),chr(10),'') as hxb_crdt_cust_flg
,appl_pric_amt_uplmi
,int_rat_prefr_effect_dt
,int_rat_prefr_invalid_dt
,final_modif_dt

from ${iml_schema}.agt_dep_int_rat_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_dep_int_rat_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
