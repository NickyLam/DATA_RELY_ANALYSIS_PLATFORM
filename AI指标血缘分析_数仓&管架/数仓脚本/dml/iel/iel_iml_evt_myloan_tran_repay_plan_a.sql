: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_myloan_tran_repay_plan_a
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_myloan_tran_repay_plan.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
      ,replace(replace(evt_id,chr(13),''),chr(10),'') as evt_id
      ,lp_id
      ,replace(replace(cont_id,chr(13),''),chr(10),'') as cont_id
      ,pd_num
      ,asset_tran_bus_dt
      ,asset_tran_tran_tm
      ,replace(replace(asset_tran_bus_flow_num,chr(13),''),chr(10),'') as asset_tran_bus_flow_num
      ,replace(replace(cap_flow_num,chr(13),''),chr(10),'') as cap_flow_num
      ,inst_start_dt
      ,inst_end_dt
      ,pric_bal
      ,int_bal
      ,ovdue_pric_pnlt_bal
      ,ovdue_int_pnlt_bal
      ,tran_type_cd
      ,tran_way_cd
      ,tran_amt
      ,asset_bal_diff_amt
      ,inst_status_cd
      ,acru_non_idf_cd
      ,wrt_off_flg
      ,replace(replace(asset_tran_cntpty_org_id,chr(13),''),chr(10),'') as asset_tran_cntpty_org_id
      ,dist_cd
  from iml.evt_myloan_tran_repay_plan
 where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_myloan_tran_repay_plan.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes