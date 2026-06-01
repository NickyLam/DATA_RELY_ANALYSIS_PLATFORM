/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a22signvalidateinfo
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a22signvalidateinfo_ex purge;
alter table ${iol_schema}.mpcs_a22signvalidateinfo add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.mpcs_a22signvalidateinfo;

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a22signvalidateinfo_ex nologging
compress
as
select * from ${iol_schema}.mpcs_a22signvalidateinfo where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a22signvalidateinfo_ex(
    msgid -- 报文标识
    ,chnlid -- 交易渠道(01：支付宝02：柜台，03：网银，04：电话银行，05：自助终端，06：POS，07：批量交易，08：第三方,09:中台
    ,protocolid -- 协议号
    ,chnltime -- 渠道时间
    ,trntm -- 系统交易时间
    ,acctname -- 账号名称
    ,acctno -- 账号
    ,accttype -- 账户类型
    ,bankcardareacode -- 银行省市分行编码
    ,idtype -- 证件类型
    ,idno -- 证件号码
    ,mobile -- 手机号码
    ,custaddr -- 客户地址
    ,ischeckcertificateno -- 是否校验证件类型、证件号
    ,ischeckmobilephone -- 是否校验手机号
    ,ischeckaccountname -- 是否校验户名
    ,expirydate -- 有效期
    ,custstatus -- 客户状态(0:正常，1:冻结，2:销户，默认为"0")
    ,signtlrno -- 签约柜员
    ,authtlrno -- 授权柜员
    ,signbrc -- 签约网点
    ,trninlmtamt -- 
    ,daytrnlmtamt -- 
    ,thirdtrninlmtamt -- 
    ,daythirdtrnlmtamt -- 
    ,trngetlmtamt -- 
    ,daygetlmtamt -- 
    ,lastupdtlrno -- 最后更新柜员
    ,lastupddt -- 最后更新时间
    ,rmk1 -- 备注1
    ,rmk2 -- 备注2
    ,rmk3 -- 备注3
    ,coopcd -- 卡代码
    ,banktradetype -- 交易类型
    ,webplatfrom -- 网络交易平台
    ,payeemerchantname -- 商户名称
    ,shopname -- 店铺名
    ,merchantcode -- 商户编码
    ,payeeaccount -- 资金账号
    ,payeeinst -- 对方机构
    ,merchantmcc -- 商户类别编码
    ,isglobal -- 商户境内外标识
    ,national -- 国籍
    ,merchantwebinfo -- 网络地址
    ,terminaltype -- 支付终端
    ,bizno -- 商品订单号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    msgid -- 报文标识
    ,chnlid -- 交易渠道(01：支付宝02：柜台，03：网银，04：电话银行，05：自助终端，06：POS，07：批量交易，08：第三方,09:中台
    ,protocolid -- 协议号
    ,chnltime -- 渠道时间
    ,trntm -- 系统交易时间
    ,acctname -- 账号名称
    ,acctno -- 账号
    ,accttype -- 账户类型
    ,bankcardareacode -- 银行省市分行编码
    ,idtype -- 证件类型
    ,idno -- 证件号码
    ,mobile -- 手机号码
    ,custaddr -- 客户地址
    ,ischeckcertificateno -- 是否校验证件类型、证件号
    ,ischeckmobilephone -- 是否校验手机号
    ,ischeckaccountname -- 是否校验户名
    ,expirydate -- 有效期
    ,custstatus -- 客户状态(0:正常，1:冻结，2:销户，默认为"0")
    ,signtlrno -- 签约柜员
    ,authtlrno -- 授权柜员
    ,signbrc -- 签约网点
    ,trninlmtamt -- 
    ,daytrnlmtamt -- 
    ,thirdtrninlmtamt -- 
    ,daythirdtrnlmtamt -- 
    ,trngetlmtamt -- 
    ,daygetlmtamt -- 
    ,lastupdtlrno -- 最后更新柜员
    ,lastupddt -- 最后更新时间
    ,rmk1 -- 备注1
    ,rmk2 -- 备注2
    ,rmk3 -- 备注3
    ,coopcd -- 卡代码
    ,banktradetype -- 交易类型
    ,webplatfrom -- 网络交易平台
    ,payeemerchantname -- 商户名称
    ,shopname -- 店铺名
    ,merchantcode -- 商户编码
    ,payeeaccount -- 资金账号
    ,payeeinst -- 对方机构
    ,merchantmcc -- 商户类别编码
    ,isglobal -- 商户境内外标识
    ,national -- 国籍
    ,merchantwebinfo -- 网络地址
    ,terminaltype -- 支付终端
    ,bizno -- 商品订单号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a22signvalidateinfo
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a22signvalidateinfo exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a22signvalidateinfo_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a22signvalidateinfo to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a22signvalidateinfo_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a22signvalidateinfo',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);