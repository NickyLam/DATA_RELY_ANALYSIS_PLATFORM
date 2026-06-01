/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_tax_accr_rept
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
drop table ${iol_schema}.tgls_tax_accr_rept_ex purge;
alter table ${iol_schema}.tgls_tax_accr_rept add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.tgls_tax_accr_rept truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.tgls_tax_accr_rept_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_tax_accr_rept where 0=1;

insert /*+ append */ into ${iol_schema}.tgls_tax_accr_rept_ex(
    stacid -- 账套
    ,deptcode -- 计提机构编号
    ,period -- 计提期间
    ,taxcode -- 税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）
    ,crcycd -- 币种代码
    ,taxdate -- 计提日期
    ,acctbr -- 记账机构编号
    ,accram -- 本期计提金额
    ,yacram -- 本年累计计提金额
    ,adjuam -- 本期调整金额
    ,lsblam -- 期初应缴纳金额
    ,apayam -- 本期应缴纳金额
    ,onblam -- 期末应缴纳金额
    ,ypayam -- 本期已缴纳金额
    ,yypaam -- 本年累计已缴纳金额
    ,markam -- 本期上划金额
    ,ymaram -- 本年累计上划金额
    ,vatxrt -- 税率
    ,sendsq -- 发送总账报文流水
    ,revesq -- 发送总账冲销流水
    ,status -- 计提状态（2-已冲销，3-已计提，4-计提出账失败，5-已计提出账，6-缴纳出账失败，7-已缴纳出账，8-发送核心失败，9-发送核心成功）
    ,isvchr -- 是否生成会计分录（0-未生成，1-已生成）
    ,commti -- 计提时间
    ,smrytx -- 备注
    ,startdate -- 结束日期
    ,enddate -- 开始日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    stacid -- 账套
    ,deptcode -- 计提机构编号
    ,period -- 计提期间
    ,taxcode -- 税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）
    ,crcycd -- 币种代码
    ,taxdate -- 计提日期
    ,acctbr -- 记账机构编号
    ,accram -- 本期计提金额
    ,yacram -- 本年累计计提金额
    ,adjuam -- 本期调整金额
    ,lsblam -- 期初应缴纳金额
    ,apayam -- 本期应缴纳金额
    ,onblam -- 期末应缴纳金额
    ,ypayam -- 本期已缴纳金额
    ,yypaam -- 本年累计已缴纳金额
    ,markam -- 本期上划金额
    ,ymaram -- 本年累计上划金额
    ,vatxrt -- 税率
    ,sendsq -- 发送总账报文流水
    ,revesq -- 发送总账冲销流水
    ,status -- 计提状态（2-已冲销，3-已计提，4-计提出账失败，5-已计提出账，6-缴纳出账失败，7-已缴纳出账，8-发送核心失败，9-发送核心成功）
    ,isvchr -- 是否生成会计分录（0-未生成，1-已生成）
    ,commti -- 计提时间
    ,smrytx -- 备注
    ,startdate -- 结束日期
    ,enddate -- 开始日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tgls_tax_accr_rept
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tgls_tax_accr_rept exchange partition p_${batch_date} with table ${iol_schema}.tgls_tax_accr_rept_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_tax_accr_rept to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tgls_tax_accr_rept_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_tax_accr_rept',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);