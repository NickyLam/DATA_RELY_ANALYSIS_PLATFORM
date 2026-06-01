: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_myloan_repay_dtl_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_myloan_repay_dtl_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,t.repay_dt as repay_dt
,replace(replace(t.repay_flow_num,chr(13),''),chr(10),'') as repay_flow_num
,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t.repay_wdraw_odd_no,chr(13),''),chr(10),'') as repay_wdraw_odd_no
,t.rpbl_nomal_pric as rpbl_nomal_pric
,t.rpbl_ovdue_pric as rpbl_ovdue_pric
,t.rpbl_nomal_int as rpbl_nomal_int
,t.rpbl_ovdue_int as rpbl_ovdue_int
,t.rpbl_ovdue_pric_pnlt as rpbl_ovdue_pric_pnlt
,t.rpbl_ovdue_int_pnlt as rpbl_ovdue_int_pnlt
,t.rpbl_tot_amt as rpbl_tot_amt
,t.paid_nomal_pric as paid_nomal_pric
,t.paid_ovdue_pric as paid_ovdue_pric
,t.paid_nomal_int as paid_nomal_int
,t.paid_ovdue_int as paid_ovdue_int
,t.paid_ovdue_pric_pnlt as paid_ovdue_pric_pnlt
,t.paid_ovdue_int_pnlt as paid_ovdue_int_pnlt
,replace(replace(t.repay_type_cd,chr(13),''),chr(10),'') as repay_type_cd
,replace(replace(t.bf_repay_acru_flg,chr(13),''),chr(10),'') as bf_repay_acru_flg
from iml.evt_myloan_repay_dtl t
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6 and etl_dt >= to_date('${batch_date}', 'yyyymmdd') - 6 ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_myloan_repay_dtl_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes