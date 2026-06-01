/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_myhb_repay_plan
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
drop table ${iol_schema}.icms_myhb_repay_plan_ex purge;
alter table ${iol_schema}.icms_myhb_repay_plan add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_myhb_repay_plan;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_myhb_repay_plan_ex nologging
compress
as
select * from ${iol_schema}.icms_myhb_repay_plan where 0=1;

insert /*+ append */ into ${iol_schema}.icms_myhb_repay_plan_ex(
    contractno -- 花呗平台贷款合约号
    ,fundseqno -- 放款资金流水号
    ,termno -- 期次号
    ,prinovddate -- 本金转逾期日期
    ,beginprin -- 应还本金
    ,regioncode -- 行政区划代码
    ,accruedstatus -- 应计非应计标识，应计0，非应计1
    ,writeoff -- 核销标识，已核销为Y，否则为N
    ,prinbal -- 本金余额
    ,settledate -- 会计日期
    ,ovdintpnltbal -- 逾期利息罚息余额
    ,status -- 分期状态
    ,cleardate -- 结清日期
    ,migtflag -- 迁移标志：crsrcrilcupl
    ,intovddate -- 利息转逾期日期
    ,prinovddays -- 本金逾期天数
    ,beginint -- 应还利息
    ,creditcode -- 额度类型
    ,prinamt -- 本金金额
    ,enddate -- 分期结束日期
    ,ovdprinpnltbal -- 逾期本金罚息余额
    ,contracttype -- 借据类型
    ,intovddays -- 利息逾期天数
    ,internaltransfertag -- 内部结转标识
    ,startdate -- 分期开始日期
    ,intbal -- 利息余额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    contractno -- 花呗平台贷款合约号
    ,fundseqno -- 放款资金流水号
    ,termno -- 期次号
    ,prinovddate -- 本金转逾期日期
    ,beginprin -- 应还本金
    ,regioncode -- 行政区划代码
    ,accruedstatus -- 应计非应计标识，应计0，非应计1
    ,writeoff -- 核销标识，已核销为Y，否则为N
    ,prinbal -- 本金余额
    ,settledate -- 会计日期
    ,ovdintpnltbal -- 逾期利息罚息余额
    ,status -- 分期状态
    ,cleardate -- 结清日期
    ,migtflag -- 迁移标志：crsrcrilcupl
    ,intovddate -- 利息转逾期日期
    ,prinovddays -- 本金逾期天数
    ,beginint -- 应还利息
    ,creditcode -- 额度类型
    ,prinamt -- 本金金额
    ,enddate -- 分期结束日期
    ,ovdprinpnltbal -- 逾期本金罚息余额
    ,contracttype -- 借据类型
    ,intovddays -- 利息逾期天数
    ,internaltransfertag -- 内部结转标识
    ,startdate -- 分期开始日期
    ,intbal -- 利息余额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_myhb_repay_plan
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_myhb_repay_plan exchange partition p_${batch_date} with table ${iol_schema}.icms_myhb_repay_plan_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_myhb_repay_plan to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_myhb_repay_plan_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_myhb_repay_plan',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);