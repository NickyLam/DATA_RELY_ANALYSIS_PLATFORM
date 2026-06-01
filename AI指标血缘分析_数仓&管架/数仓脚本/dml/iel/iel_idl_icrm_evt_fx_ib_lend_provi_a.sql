: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_evt_fx_ib_lend_provi_a
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_evt_fx_ib_lend_provi.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select evt_id
,lp_id
,tran_flow_num
,dept_id
,org_id
,curr_cd
,tran_amt
,term_end_stl_amt
,ib_lend_int_rat
,tran_dt
,value_dt
,exp_dt
,int_rat_adj_way_cd
,tran_aim_cd
,cntpty_id
,int_accr_base_cd
,portf_id
,provi_dt
,provi_amt
,tran_dir_cd
,ib_lend_type_cd
,bag_id
,etl_dt
,job_cd from idl.icrm_evt_fx_ib_lend_provi where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_evt_fx_ib_lend_provi.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes