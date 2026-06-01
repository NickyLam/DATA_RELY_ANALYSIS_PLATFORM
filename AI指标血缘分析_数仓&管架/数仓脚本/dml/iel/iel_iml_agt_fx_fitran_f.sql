: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_fx_fitran_f
CreateDate: 20230525
FileName:   ${iel_data_path}/agt_fx_fitran.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,input_dt
,tran_dt
,fitran_dt
,replace(replace(t1.cannib_type_cd,chr(13),''),chr(10),'') as cannib_type_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,tran_amt
,replace(replace(t1.tran_aim_cd,chr(13),''),chr(10),'') as tran_aim_cd
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,replace(replace(t1.bag_flow_num,chr(13),''),chr(10),'') as bag_flow_num
,replace(replace(t1.ctr_nt_status_cd,chr(13),''),chr(10),'') as ctr_nt_status_cd
,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'') as tran_dir_cd
,replace(replace(t1.bag_id,chr(13),''),chr(10),'') as bag_id
,replace(replace(t1.tran_mode_cd,chr(13),''),chr(10),'') as tran_mode_cd
,replace(replace(t1.tran_src_cd,chr(13),''),chr(10),'') as tran_src_cd
,replace(replace(t1.tran_site_cd,chr(13),''),chr(10),'') as tran_site_cd
,replace(replace(t1.clear_way_cd,chr(13),''),chr(10),'') as clear_way_cd
,replace(replace(t1.rela_tran_id,chr(13),''),chr(10),'') as rela_tran_id
,replace(replace(t1.portf_tran_id,chr(13),''),chr(10),'') as portf_tran_id
,replace(replace(t1.portf_id,chr(13),''),chr(10),'') as portf_id
,replace(replace(t1.portf_name,chr(13),''),chr(10),'') as portf_name
,replace(replace(t1.portf_type_name,chr(13),''),chr(10),'') as portf_type_name
,replace(replace(t1.inv_port_status_cd,chr(13),''),chr(10),'') as inv_port_status_cd
,replace(replace(t1.portf_rela_tran_id,chr(13),''),chr(10),'') as portf_rela_tran_id
,replace(replace(t1.amt_type_cd,chr(13),''),chr(10),'') as amt_type_cd
,replace(replace(t1.stl_status_cd,chr(13),''),chr(10),'') as stl_status_cd
,replace(replace(t1.r_bk_acct_id,chr(13),''),chr(10),'') as r_bk_acct_id
,replace(replace(t1.p_bk_acct_id,chr(13),''),chr(10),'') as p_bk_acct_id
,create_dt
,update_dt

from ${iml_schema}.agt_fx_fitran t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_fx_fitran.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
