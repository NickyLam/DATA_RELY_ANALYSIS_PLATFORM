: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_core_basic_tran_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_core_basic_tran_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,t.tran_dt as tran_dt
,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,t.tran_tm as tran_tm
,replace(replace(t.tran_kind_cd,chr(13),''),chr(10),'') as tran_kind_cd
,replace(replace(t.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t.tran_chn_id,chr(13),''),chr(10),'') as tran_chn_id
,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t.termn_id,chr(13),''),chr(10),'') as termn_id
,replace(replace(t.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,replace(replace(t.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t.bal_chk_flg,chr(13),''),chr(10),'') as bal_chk_flg
,replace(replace(t.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t.ext_flow_num,chr(13),''),chr(10),'') as ext_flow_num
from ${iml_schema}.evt_core_basic_tran t
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6 ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_core_basic_tran_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes