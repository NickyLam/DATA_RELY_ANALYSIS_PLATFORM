: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icps_afa_jzck_deduction_i
CreateDate: 20240802
FileName:   ${iel_data_path}/icps_afa_jzck_deduction.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.productcode,chr(13),''),chr(10),'') as productcode
,replace(replace(t1.workdate,chr(13),''),chr(10),'') as workdate
,replace(replace(t1.agentserialno,chr(13),''),chr(10),'') as agentserialno
,replace(replace(t1.worktime,chr(13),''),chr(10),'') as worktime
,replace(replace(t1.reqbatno,chr(13),''),chr(10),'') as reqbatno
,replace(replace(t1.taskid,chr(13),''),chr(10),'') as taskid
,replace(replace(t1.accno,chr(13),''),chr(10),'') as accno
,replace(replace(t1.subaccno,chr(13),''),chr(10),'') as subaccno
,replace(replace(t1.amonut,chr(13),''),chr(10),'') as amonut
,replace(replace(t1.accnoname,chr(13),''),chr(10),'') as accnoname
,replace(replace(t1.idtype,chr(13),''),chr(10),'') as idtype
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.yyaccno,chr(13),''),chr(10),'') as yyaccno
,replace(replace(t1.zxkaccnoname,chr(13),''),chr(10),'') as zxkaccnoname
,replace(replace(t1.zxkbrnoname,chr(13),''),chr(10),'') as zxkbrnoname
,replace(replace(t1.zxkbrnocode,chr(13),''),chr(10),'') as zxkbrnocode
,replace(replace(t1.zxkaccno,chr(13),''),chr(10),'') as zxkaccno
,replace(replace(t1.zxfyname,chr(13),''),chr(10),'') as zxfyname
,replace(replace(t1.zxfycode,chr(13),''),chr(10),'') as zxfycode
,replace(replace(t1.cbfg,chr(13),''),chr(10),'') as cbfg
,replace(replace(t1.cbfgtel,chr(13),''),chr(10),'') as cbfgtel
,replace(replace(t1.cbfggzz,chr(13),''),chr(10),'') as cbfggzz
,replace(replace(t1.cbfggwz,chr(13),''),chr(10),'') as cbfggwz
,replace(replace(t1.tzs,chr(13),''),chr(10),'') as tzs
,replace(replace(t1.zxah,chr(13),''),chr(10),'') as zxah
,replace(replace(t1.remark1,chr(13),''),chr(10),'') as remark1
,replace(replace(t1.remark2,chr(13),''),chr(10),'') as remark2
,replace(replace(t1.remark3,chr(13),''),chr(10),'') as remark3
,replace(replace(t1.remark4,chr(13),''),chr(10),'') as remark4
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.zxkaccnotype,chr(13),''),chr(10),'') as zxkaccnotype
,replace(replace(t1.upddate,chr(13),''),chr(10),'') as upddate
,replace(replace(t1.updtime,chr(13),''),chr(10),'') as updtime
,replace(replace(t1.deducttype,chr(13),''),chr(10),'') as deducttype
,replace(replace(t1.origtaskid,chr(13),''),chr(10),'') as origtaskid
,replace(replace(t1.islock,chr(13),''),chr(10),'') as islock
,replace(replace(t1.unfreezedate,chr(13),''),chr(10),'') as unfreezedate
,replace(replace(t1.unfreezeserno,chr(13),''),chr(10),'') as unfreezeserno
,replace(replace(t1.unfreezestatus,chr(13),''),chr(10),'') as unfreezestatus
,replace(replace(t1.errorcode,chr(13),''),chr(10),'') as errorcode
,replace(replace(t1.errormsg,chr(13),''),chr(10),'') as errormsg
,replace(replace(t1.busiserno,chr(13),''),chr(10),'') as busiserno
,replace(replace(t1.hostdate,chr(13),''),chr(10),'') as hostdate
,replace(replace(t1.hostfreezeserial,chr(13),''),chr(10),'') as hostfreezeserial
,replace(replace(t1.globalseqno,chr(13),''),chr(10),'') as globalseqno
,replace(replace(t1.brno,chr(13),''),chr(10),'') as brno
,replace(replace(t1.tellerno,chr(13),''),chr(10),'') as tellerno
,replace(replace(t1.authorizer,chr(13),''),chr(10),'') as authorizer
,replace(replace(t1.hosttype,chr(13),''),chr(10),'') as hosttype
,replace(replace(t1.subchnl,chr(13),''),chr(10),'') as subchnl
,replace(replace(t1.iscbs,chr(13),''),chr(10),'') as iscbs
,replace(replace(t1.decramount,chr(13),''),chr(10),'') as decramount
,replace(replace(t1.accountopenbankcode,chr(13),''),chr(10),'') as accountopenbankcode
,replace(replace(t1.chnid,chr(13),''),chr(10),'') as chnid
,replace(replace(t1.busisysdate,chr(13),''),chr(10),'') as busisysdate
,replace(replace(t1.origfrozedamount,chr(13),''),chr(10),'') as origfrozedamount
,replace(replace(t1.accruacctno,chr(13),''),chr(10),'') as accruacctno
,replace(replace(t1.accruacctname,chr(13),''),chr(10),'') as accruacctname
,replace(replace(t1.deduprcp,chr(13),''),chr(10),'') as deduprcp
,replace(replace(t1.deduint,chr(13),''),chr(10),'') as deduint
,replace(replace(t1.enteraccttype,chr(13),''),chr(10),'') as enteraccttype
,replace(replace(t1.accruaccttype,chr(13),''),chr(10),'') as accruaccttype
,replace(replace(t1.isspecial,chr(13),''),chr(10),'') as isspecial

from ${iol_schema}.icps_afa_jzck_deduction t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icps_afa_jzck_deduction.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
