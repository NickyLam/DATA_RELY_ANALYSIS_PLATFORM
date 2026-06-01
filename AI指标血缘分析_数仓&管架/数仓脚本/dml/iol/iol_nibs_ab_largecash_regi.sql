/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nibs_ab_largecash_regi
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
drop table ${iol_schema}.nibs_ab_largecash_regi_ex purge;
alter table ${iol_schema}.nibs_ab_largecash_regi add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.nibs_ab_largecash_regi truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.nibs_ab_largecash_regi_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_ab_largecash_regi where 0=1;

insert /*+ append */ into ${iol_schema}.nibs_ab_largecash_regi_ex(
    tid -- 由柜员号+系统时间yyyymmddhhmmsssss+五位随机字母组成
    ,trantime -- 交易时间
    ,globalseqno -- 全局流水号
    ,coreseqno -- 核心流水
    ,acctna -- 户名
    ,acctno -- 卡号
    ,withdrawaluse -- 款型来源（取款用途）
    ,description -- 说明
    ,crcycd -- 币种
    ,tranam -- 交易金额
    ,trandate -- 交易日期
    ,updatedate -- 修改日期
    ,brchno -- 归属机构编号
    ,userid -- 交易柜员编号
    ,upuserid -- 修改柜员编号
    ,custtp -- 客户类型 1 个人客户 2 企业客户
    ,servtp -- 渠道编号
    ,resernumber -- 大额取现预约号
    ,inducategory -- 行业门类
    ,indubig -- 行业大类
    ,indumedium -- 行业中类
    ,indusmall -- 行业小类
    ,businesstype -- 业务类型（1-现金存款2-现金取款）
    ,savetoamsum -- 转存金额汇总
    ,spectp -- 账户类型
    ,agnttg -- 是否代办
    ,agidtp -- 代办人证件类型
    ,agidno -- 代办人证件号码
    ,agcuna -- 代办人名称
    ,transq -- 业务流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tid -- 由柜员号+系统时间yyyymmddhhmmsssss+五位随机字母组成
    ,trantime -- 交易时间
    ,globalseqno -- 全局流水号
    ,coreseqno -- 核心流水
    ,acctna -- 户名
    ,acctno -- 卡号
    ,withdrawaluse -- 款型来源（取款用途）
    ,description -- 说明
    ,crcycd -- 币种
    ,tranam -- 交易金额
    ,trandate -- 交易日期
    ,updatedate -- 修改日期
    ,brchno -- 归属机构编号
    ,userid -- 交易柜员编号
    ,upuserid -- 修改柜员编号
    ,custtp -- 客户类型 1 个人客户 2 企业客户
    ,servtp -- 渠道编号
    ,resernumber -- 大额取现预约号
    ,inducategory -- 行业门类
    ,indubig -- 行业大类
    ,indumedium -- 行业中类
    ,indusmall -- 行业小类
    ,businesstype -- 业务类型（1-现金存款2-现金取款）
    ,savetoamsum -- 转存金额汇总
    ,spectp -- 账户类型
    ,agnttg -- 是否代办
    ,agidtp -- 代办人证件类型
    ,agidno -- 代办人证件号码
    ,agcuna -- 代办人名称
    ,transq -- 业务流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.nibs_ab_largecash_regi
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.nibs_ab_largecash_regi exchange partition p_${batch_date} with table ${iol_schema}.nibs_ab_largecash_regi_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nibs_ab_largecash_regi to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.nibs_ab_largecash_regi_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nibs_ab_largecash_regi',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);