: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_guar_bil_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_guar_bil_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.coll_id,chr(13),''),chr(10),'') as coll_id
,t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd
,replace(replace(t1.bil_num,chr(13),''),chr(10),'') as bil_num
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,t1.par_amt as par_amt
,t1.draw_dt as draw_dt
,t1.due_dt as due_dt
,replace(replace(t1.drawe_pty_name,chr(13),''),chr(10),'') as drawe_pty_name
,replace(replace(t1.drawe_org_org_cd,chr(13),''),chr(10),'') as drawe_org_org_cd
,replace(replace(t1.drawe_open_bk_num,chr(13),''),chr(10),'') as drawe_open_bk_num
,replace(replace(t1.drawe_open_bk_bnk_nm,chr(13),''),chr(10),'') as drawe_open_bk_bnk_nm
,replace(replace(t1.drawe_open_bk_acct_num,chr(13),''),chr(10),'') as drawe_open_bk_acct_num
,replace(replace(t1.payee_name,chr(13),''),chr(10),'') as payee_name
,replace(replace(t1.payee_open_bk_num,chr(13),''),chr(10),'') as payee_open_bk_num
,replace(replace(t1.payee_open_bk_bnk_nm,chr(13),''),chr(10),'') as payee_open_bk_bnk_nm
,replace(replace(t1.payee_acct_num,chr(13),''),chr(10),'') as payee_acct_num
,replace(replace(t1.acpt_row_typ_cd,chr(13),''),chr(10),'') as acpt_row_typ_cd
,replace(replace(t1.acpt_row_num,chr(13),''),chr(10),'') as acpt_row_num
,replace(replace(t1.acpt_row_bnk_nm,chr(13),''),chr(10),'') as acpt_row_bnk_nm
,t1.qry_chk_dt as qry_chk_dt
,replace(replace(t1.paper_flg,chr(13),''),chr(10),'') as paper_flg
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'AGT_GUAR_BIL_INFO_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_GUAR_BIL_INFO_H') as etl_task_name 
from ${idl_schema}.hdws_iml_agt_guar_bil_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_guar_bil_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes