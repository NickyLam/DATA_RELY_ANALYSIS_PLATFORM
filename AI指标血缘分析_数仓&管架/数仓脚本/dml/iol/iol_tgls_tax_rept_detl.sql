/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_tax_rept_detl
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
drop table ${iol_schema}.tgls_tax_rept_detl_ex purge;
alter table ${iol_schema}.tgls_tax_rept_detl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.tgls_tax_rept_detl truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.tgls_tax_rept_detl_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_tax_rept_detl where 0=1;

insert /*+ append */ into ${iol_schema}.tgls_tax_rept_detl_ex(
    stacid -- 账套
    ,deptcdbf -- 上划前机构编号
    ,period -- 计提序号
    ,taxcode -- 税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）
    ,deptcdaf -- 上划后机构编号
    ,crcycd -- 币种代码
    ,markam -- 本期上划金额
    ,ymaram -- 本年累计上划金额
    ,vatxrt -- 税率
    ,startdate -- 开始日期
    ,enddate -- 结束日期
    ,status -- 上划状态（0-未冲销，1-已冲销）
    ,soursq -- 源系统流水
    ,markam_beq -- 本期上划本位币金额
    ,ymaram_beq -- 本年累计上划本位币金额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    stacid -- 账套
    ,deptcdbf -- 上划前机构编号
    ,period -- 计提序号
    ,taxcode -- 税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）
    ,deptcdaf -- 上划后机构编号
    ,crcycd -- 币种代码
    ,markam -- 本期上划金额
    ,ymaram -- 本年累计上划金额
    ,vatxrt -- 税率
    ,startdate -- 开始日期
    ,enddate -- 结束日期
    ,status -- 上划状态（0-未冲销，1-已冲销）
    ,soursq -- 源系统流水
    ,markam_beq -- 本期上划本位币金额
    ,ymaram_beq -- 本年累计上划本位币金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tgls_tax_rept_detl
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tgls_tax_rept_detl exchange partition p_${batch_date} with table ${iol_schema}.tgls_tax_rept_detl_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_tax_rept_detl to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tgls_tax_rept_detl_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_tax_rept_detl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);