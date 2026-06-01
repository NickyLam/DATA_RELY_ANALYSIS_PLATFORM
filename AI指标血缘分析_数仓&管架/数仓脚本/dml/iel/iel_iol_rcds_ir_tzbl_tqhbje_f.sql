: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_ir_tzbl_tqhbje_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_ir_tzbl_tqhbje.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.key_id,chr(13),''),chr(10),'') as key_id
    ,replace(replace(t.loan_no,chr(13),''),chr(10),'') as loan_no
    ,replace(replace(t.data_dt,chr(13),''),chr(10),'') as data_dt
    ,replace(replace(t.loan_biz_type_cd,chr(13),''),chr(10),'') as loan_biz_type_cd
    ,t.var0601 as var0601
    ,t.var0602 as var0602
    ,t.var0603 as var0603
    ,t.var0604 as var0604
    ,t.var0605 as var0605
    ,t.var0606 as var0606
    ,t.var0607 as var0607
    ,t.var0608 as var0608
    ,t.var0609 as var0609
    ,t.var0610 as var0610
    ,t.var0611 as var0611
from iol.rcds_ir_tzbl_tqhbje t    
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_ir_tzbl_tqhbje.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes