: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_abs_amt_dtl_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_abs_amt_dtl_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.asset_amt_dtl_seq_num,chr(13),''),chr(10),'') as asset_amt_dtl_seq_num
,replace(replace(t1.asset_bag_cont_dtl_seq_num,chr(13),''),chr(10),'') as asset_bag_cont_dtl_seq_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.amt_type_cd,chr(13),''),chr(10),'') as amt_type_cd
,pkg_tran_day_tm_point_amt
,pkg_day_tm_point_amt
,final_modif_dt

from ${iml_schema}.agt_abs_amt_dtl_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_abs_amt_dtl_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
