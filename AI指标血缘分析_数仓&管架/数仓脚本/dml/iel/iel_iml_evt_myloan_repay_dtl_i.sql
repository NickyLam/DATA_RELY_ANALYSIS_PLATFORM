: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_myloan_repay_dtl_i
CreateDate: 20230423
FileName:   ${iel_data_path}/evt_myloan_repay_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,repay_dt
,replace(replace(t1.repay_flow_num,chr(13),''),chr(10),'') as repay_flow_num
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.repay_wdraw_odd_no,chr(13),''),chr(10),'') as repay_wdraw_odd_no
,rpbl_nomal_pric
,rpbl_ovdue_pric
,rpbl_nomal_int
,rpbl_ovdue_int
,rpbl_ovdue_pric_pnlt
,rpbl_ovdue_int_pnlt
,rpbl_tot_amt
,paid_nomal_pric
,paid_ovdue_pric
,paid_nomal_int
,paid_ovdue_int
,paid_ovdue_pric_pnlt
,paid_ovdue_int_pnlt
,replace(replace(t1.repay_type_cd,chr(13),''),chr(10),'') as repay_type_cd
,replace(replace(t1.bf_repay_acru_flg,chr(13),''),chr(10),'') as bf_repay_acru_flg
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name

from ${iml_schema}.evt_myloan_repay_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd')-1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_myloan_repay_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
