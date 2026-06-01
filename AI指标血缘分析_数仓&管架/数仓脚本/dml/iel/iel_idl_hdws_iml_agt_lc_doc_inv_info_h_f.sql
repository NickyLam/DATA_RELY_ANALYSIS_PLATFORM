: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_lc_doc_inv_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_lc_doc_inv_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
NVL2(t1.data_src_cd,'AGT_LC_DOC_INV_INFO_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_LC_DOC_INV_INFO_H') as etl_task_name 
,t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.inc_form_ref,chr(13),''),chr(10),'') as inc_form_ref
,replace(replace(t1.lc_id,chr(13),''),chr(10),'') as lc_id
,replace(replace(t1.loan_dbill_id,chr(13),''),chr(10),'') as loan_dbill_id
,t1.inc_sng_day_dt as inc_sng_day_dt
,replace(replace(t1.comm_inv_type_cd,chr(13),''),chr(10),'') as comm_inv_type_cd
,replace(replace(t1.comm_invo_num,chr(13),''),chr(10),'') as comm_invo_num
,replace(replace(t1.comm_inv_ccy_cd,chr(13),''),chr(10),'') as comm_inv_ccy_cd
,t1.comm_inv_amt as comm_inv_amt
from ${idl_schema}.hdws_iml_agt_lc_doc_inv_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_lc_doc_inv_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes