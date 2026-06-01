: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_ref_rept_model_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_ref_rept_model.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select model_id
,row_id
,row_name
,cors_subj_id
,dsply_seq_no
,row_dimen_type
,row_attr
,col_1_def
,col_2_def
,col_3_def
,col_4_def
,std_val
,del_flg
,formu_explain_1
,formu_explain_2
,etl_dt
,job_cd from idl.icrm_ref_rept_model where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_ref_rept_model.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes