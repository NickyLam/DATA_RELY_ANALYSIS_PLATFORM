: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_cap_ib_lend_f
CreateDate: 20230525
FileName:   ${iel_data_path}/agt_cap_ib_lend.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.bus_table_name,chr(13),''),chr(10),'') as bus_table_name
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.tran_id,chr(13),''),chr(10),'') as tran_id
,fst_tran_dt
,fst_dlvy_dt
,exp_dlvy_dt
,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'') as tran_dir_cd
,ib_lend_int_rat
,fst_stl_amt
,exp_stl_amt
,fst_fee
,fst_tax
,fst_comm
,acru_int
,replace(replace(t1.portf_id,chr(13),''),chr(10),'') as portf_id
,replace(replace(t1.portf_name,chr(13),''),chr(10),'') as portf_name
,replace(replace(t1.acct_b_id,chr(13),''),chr(10),'') as acct_b_id
,replace(replace(t1.acct_b_name,chr(13),''),chr(10),'') as acct_b_name
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t1.dealer_id,chr(13),''),chr(10),'') as dealer_id
,replace(replace(t1.dealer_name,chr(13),''),chr(10),'') as dealer_name
,replace(replace(t1.bag_id,chr(13),''),chr(10),'') as bag_id
,replace(replace(t1.cfets_tran_flg,chr(13),''),chr(10),'') as cfets_tran_flg
,ib_lend_days
,replace(replace(t1.init_bus_id,chr(13),''),chr(10),'') as init_bus_id
,replace(replace(t1.tran_cate_cd,chr(13),''),chr(10),'') as tran_cate_cd
,replace(replace(t1.repo_id,chr(13),''),chr(10),'') as repo_id
,acpt_pay_cfm_modif_tm
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,create_dt
,update_dt

from ${iml_schema}.agt_cap_ib_lend t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_cap_ib_lend.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
