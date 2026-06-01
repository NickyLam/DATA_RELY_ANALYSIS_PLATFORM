: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icps_afa_jzck_accounts_a1
CreateDate: 20241119
FileName:   ${iel_data_path}/icps_afa_jzck_accounts.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.productcode,chr(13),''),chr(10),'') as productcode
,replace(replace(t1.workdate,chr(13),''),chr(10),'') as workdate
,replace(replace(t1.agentserialno,chr(13),''),chr(10),'') as agentserialno
,replace(replace(t1.worktime,chr(13),''),chr(10),'') as worktime
,replace(replace(t1.txcode,chr(13),''),chr(10),'') as txcode
,replace(replace(t1.transserialnumber,chr(13),''),chr(10),'') as transserialnumber
,replace(replace(t1.applicationid,chr(13),''),chr(10),'') as applicationid
,replace(replace(t1.accountname,chr(13),''),chr(10),'') as accountname
,replace(replace(t1.cardnumber,chr(13),''),chr(10),'') as cardnumber
,replace(replace(t1.accountnumber,chr(13),''),chr(10),'') as accountnumber
,replace(replace(t1.depositbankbranch,chr(13),''),chr(10),'') as depositbankbranch
,replace(replace(t1.depositbankbranchcode,chr(13),''),chr(10),'') as depositbankbranchcode
,replace(replace(t1.accountopentime,chr(13),''),chr(10),'') as accountopentime
,replace(replace(t1.accountcancellationtime,chr(13),''),chr(10),'') as accountcancellationtime
,replace(replace(t1.accountcancellationbranch,chr(13),''),chr(10),'') as accountcancellationbranch
,replace(replace(t1.accounttype,chr(13),''),chr(10),'') as accounttype
,replace(replace(t1.accountstatus,chr(13),''),chr(10),'') as accountstatus
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,replace(replace(t1.cashremit,chr(13),''),chr(10),'') as cashremit
,replace(replace(t1.accountbalance,chr(13),''),chr(10),'') as accountbalance
,replace(replace(t1.availablebalance,chr(13),''),chr(10),'') as availablebalance
,replace(replace(t1.lasttransactiontime,chr(13),''),chr(10),'') as lasttransactiontime
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.remark1,chr(13),''),chr(10),'') as remark1
,replace(replace(t1.remark2,chr(13),''),chr(10),'') as remark2
,replace(replace(t1.remark3,chr(13),''),chr(10),'') as remark3
,replace(replace(t1.remark4,chr(13),''),chr(10),'') as remark4
,replace(replace(t1.accountserial,chr(13),''),chr(10),'') as accountserial
,replace(replace(t1.yxq,chr(13),''),chr(10),'') as yxq
,replace(replace(t1.glzjzh,chr(13),''),chr(10),'') as glzjzh
,replace(replace(t1.zhrmbye,chr(13),''),chr(10),'') as zhrmbye
,replace(replace(t1.syblrq,chr(13),''),chr(10),'') as syblrq
,replace(replace(t1.qywd,chr(13),''),chr(10),'') as qywd
,replace(replace(t1.syzzrq,chr(13),''),chr(10),'') as syzzrq
,replace(replace(t1.zhdj,chr(13),''),chr(10),'') as zhdj
,replace(replace(t1.zcwblx,chr(13),''),chr(10),'') as zcwblx
,replace(replace(t1.zhdlip,chr(13),''),chr(10),'') as zhdlip
,replace(replace(t1.zhdlsj,chr(13),''),chr(10),'') as zhdlsj
,replace(replace(t1.wyzhmc,chr(13),''),chr(10),'') as wyzhmc
,replace(replace(t1.bankname,chr(13),''),chr(10),'') as bankname
,replace(replace(t1.bankcode,chr(13),''),chr(10),'') as bankcode
,replace(replace(t1.khwdszd,chr(13),''),chr(10),'') as khwdszd
,replace(replace(t1.openbranchtel,chr(13),''),chr(10),'') as openbranchtel
,replace(replace(t1.yzbm,chr(13),''),chr(10),'') as yzbm
,replace(replace(t1.shortname,chr(13),''),chr(10),'') as shortname
,replace(replace(t1.txdz,chr(13),''),chr(10),'') as txdz
,replace(replace(t1.lxdh,chr(13),''),chr(10),'') as lxdh
,replace(replace(t1.xhwddm,chr(13),''),chr(10),'') as xhwddm
,replace(replace(t1.xhwdszd,chr(13),''),chr(10),'') as xhwdszd
,replace(replace(t1.bksj,chr(13),''),chr(10),'') as bksj
,replace(replace(t1.bkwd,chr(13),''),chr(10),'') as bkwd
,replace(replace(t1.bkwddm,chr(13),''),chr(10),'') as bkwddm
,replace(replace(t1.bkwdszd,chr(13),''),chr(10),'') as bkwdszd
,replace(replace(t1.idtype,chr(13),''),chr(10),'') as idtype
,replace(replace(t1.idno,chr(13),''),chr(10),'') as idno
,replace(replace(t1.isfro,chr(13),''),chr(10),'') as isfro
,replace(replace(t1.sftz,chr(13),''),chr(10),'') as sftz
,replace(replace(t1.datatype,chr(13),''),chr(10),'') as datatype
,replace(replace(t1.cardstatus,chr(13),''),chr(10),'') as cardstatus
,replace(replace(t1.upddate,chr(13),''),chr(10),'') as upddate
,replace(replace(t1.updtime,chr(13),''),chr(10),'') as updtime

from ${iol_schema}.icps_afa_jzck_accounts t1
where etl_dt between date'2024-01-01' and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icps_afa_jzck_accounts.a.${batch_date}.dat" \
        charset=utf8
        safe=yes
