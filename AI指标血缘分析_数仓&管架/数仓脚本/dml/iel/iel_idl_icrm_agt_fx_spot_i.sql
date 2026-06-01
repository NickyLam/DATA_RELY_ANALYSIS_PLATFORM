: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_agt_fx_spot_i
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_agt_fx_spot.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select agt_id
,lp_id
,bus_id
,dept_id
,org_id
,input_dt
,tran_dt
,value_dt
,curr_pairs_id
,bag_exch_rat
,brch_exch_rat
,cost_exch_rat
,fst_curr_cd
,secd_curr_cd
,fst_curr_tran_amt
,secd_curr_tran_amt
,tran_aim_cd
,cntpty_id
,cntpty_abbr
,tran_splt_type_cd
,tran_dir_cd
,tran_flow_num
,ctr_nt_status_cd
,bag_id
,tran_mode_cd
,tran_src_cd
,tran_site_cd
,clear_way_cd
,rela_tran_id
,portf_tran_id
,portf_id
,portf_name
,portf_type_name
,portf_status_cd
,portf_rela_tran_id
,clear_org_cd
,modif_rela_flow_num
,etl_dt
,job_cd 
,dealer_acct_num
,create_dt
,update_dt
,id_mark
from idl.icrm_agt_fx_spot 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_agt_fx_spot.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes