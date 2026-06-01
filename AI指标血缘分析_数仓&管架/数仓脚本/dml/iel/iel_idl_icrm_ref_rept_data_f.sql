: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_ref_rept_data_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_ref_rept_data.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select rept_id
,row_id
,row_name
,cors_subj_id
,dsply_seq_no
,row_dimen_type
,row_attr
,col_1_val
,col_2_val
,col_3_val
,col_4_val
,std_val
,etl_dt
,job_cd from idl.icrm_ref_rept_data where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_ref_rept_data.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes