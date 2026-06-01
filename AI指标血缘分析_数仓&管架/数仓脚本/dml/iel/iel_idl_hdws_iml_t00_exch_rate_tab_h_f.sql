: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_t00_exch_rate_tab_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_t00_exch_rate_tab_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,replace(replace(t1.ccy_name,chr(13),''),chr(10),'') as ccy_name
,t1.convt_usd_exch_rate as convt_usd_exch_rate
,t1.convt_rmb_exch_rate as convt_rmb_exch_rate
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'T00_EXCH_RATE_TAB_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'T00_EXCH_RATE_TAB_H') as etl_task_name 
,t1.base_prc as base_prc
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,t1.etl_dt as etl_dt
,t1.mdl_prc as mdl_prc
from ${idl_schema}.hdws_iml_t00_exch_rate_tab t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_t00_exch_rate_tab_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes