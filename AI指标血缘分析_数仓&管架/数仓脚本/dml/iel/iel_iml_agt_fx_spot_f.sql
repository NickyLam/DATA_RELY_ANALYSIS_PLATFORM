: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_fx_spot_f
CreateDate: 20230525
FileName:   ${iel_data_path}/agt_fx_spot.f.${batch_date}.dat
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
,value_dt
,replace(replace(t1.curr_pairs_id,chr(13),''),chr(10),'') as curr_pairs_id
,bag_exch_rat
,brch_exch_rat
,cost_exch_rat
,replace(replace(t1.fst_curr_cd,chr(13),''),chr(10),'') as fst_curr_cd
,replace(replace(t1.secd_curr_cd,chr(13),''),chr(10),'') as secd_curr_cd
,fst_curr_tran_amt
,secd_curr_tran_amt
,replace(replace(t1.tran_aim_cd,chr(13),''),chr(10),'') as tran_aim_cd
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t1.cntpty_abbr,chr(13),''),chr(10),'') as cntpty_abbr
,replace(replace(t1.tran_splt_type_cd,chr(13),''),chr(10),'') as tran_splt_type_cd
,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'') as tran_dir_cd
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.ctr_nt_status_cd,chr(13),''),chr(10),'') as ctr_nt_status_cd
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
,replace(replace(t1.portf_status_cd,chr(13),''),chr(10),'') as portf_status_cd
,replace(replace(t1.portf_rela_tran_id,chr(13),''),chr(10),'') as portf_rela_tran_id
,replace(replace(t1.clear_org_cd,chr(13),''),chr(10),'') as clear_org_cd
,replace(replace(t1.modif_rela_flow_num,chr(13),''),chr(10),'') as modif_rela_flow_num
,create_dt
,update_dt
,replace(replace(t1.dealer_acct_num,chr(13),''),chr(10),'') as dealer_acct_num

from ${iml_schema}.agt_fx_spot t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_fx_spot.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
