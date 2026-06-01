: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_ir_tzbl_hkje_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_ir_tzbl_hkje.f.${batch_date}.dat
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
    ,t.var0201 as var0201
    ,t.var0202 as var0202
    ,t.var0203 as var0203
    ,t.var0204 as var0204
    ,t.var0205 as var0205
    ,t.var0206 as var0206
    ,t.var0207 as var0207
    ,t.var0208 as var0208
    ,t.var0209 as var0209
    ,t.var0210 as var0210
    ,t.var0211 as var0211
    ,t.var0212 as var0212
    ,t.var0213 as var0213
    ,t.var0214 as var0214
    ,t.var0215 as var0215
    ,t.var0216 as var0216
    ,t.var0217 as var0217
    ,t.var0218 as var0218
    ,t.var0219 as var0219
from iol.rcds_ir_tzbl_hkje t    
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_ir_tzbl_hkje.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes