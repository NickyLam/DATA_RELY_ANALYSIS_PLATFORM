: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_scfs_scf_fnc_price_view_f
CreateDate: 20260122
FileName:   ${iel_data_path}/scfs_scf_fnc_price_view.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.out_acct_seq_num,chr(13),''),chr(10),'') as out_acct_seq_num
,replace(replace(t1.iou_id,chr(13),''),chr(10),'') as iou_id
,replace(replace(t1.pd_nm,chr(13),''),chr(10),'') as pd_nm
,replace(replace(t1.ctr_id,chr(13),''),chr(10),'') as ctr_id
,replace(replace(t1.fnc_jrnl_id,chr(13),''),chr(10),'') as fnc_jrnl_id
,replace(replace(t1.pric_ord_nbr,chr(13),''),chr(10),'') as pric_ord_nbr
,replace(replace(t1.credit_aggreement,chr(13),''),chr(10),'') as credit_aggreement
,replace(replace(t1.cst_nm,chr(13),''),chr(10),'') as cst_nm
,replace(replace(t1.core_entp_nm,chr(13),''),chr(10),'') as core_entp_nm
,ths_fnc_amt
,iou_amt
,replace(replace(t1.fnc_dt,chr(13),''),chr(10),'') as fnc_dt
,fnc_bg_dt
,fnc_ex_dt
,replace(replace(t1.pcs_st_cd_nm,chr(13),''),chr(10),'') as pcs_st_cd_nm
,replace(replace(t1.fns_st_cd_nm,chr(13),''),chr(10),'') as fns_st_cd_nm
,replace(replace(t1.is_used_ph,chr(13),''),chr(10),'') as is_used_ph

from ${iol_schema}.scfs_scf_fnc_price_view t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/scfs_scf_fnc_price_view.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
