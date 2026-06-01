/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_mybk_extend_detail_total_ef
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
drop table ${iol_schema}.icms_mybk_extend_detail_total_ef_ex purge;
alter table ${iol_schema}.icms_mybk_extend_detail_total_ef add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_mybk_extend_detail_total_ef truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_mybk_extend_detail_total_ef_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybk_extend_detail_total_ef where 0=1;

insert /*+ append */ into ${iol_schema}.icms_mybk_extend_detail_total_ef_ex(
    contractno -- 融资平台贷款合约号
    ,settledate -- 会计日期，格式：yyyy-MM-dd hh:mm:ss
    ,extendcode -- 0-调整转出，1-调整转入
    ,seqno -- 调整流水号
    ,termno -- 期次号
    ,startdate -- 分期开始日期，格式：yyyy-MM-dd hh:mm:ss
    ,enddate -- 分期结束日期，格式：yyyy-MM-dd hh:mm:ss
    ,prinamt -- 正常本金金额
    ,ovdprinamt -- 逾期本金金额
    ,intamt -- 正常利息金额
    ,ovdintamt -- 逾期利息金额
    ,ovdprinpnltamt -- 本金罚息金额
    ,ovdintpnltamt -- 利息罚息金额
    ,status -- 分期状态，正常NORMAL,逾期OVD,结清CLEAR
    ,accruedstatus -- 应计非应计标识，应计0，非应计1
    ,writeoff -- 核销标识，已核销为Y，否则为N
    ,bsntype -- 产品业务类型，具体值合作产品上线后才给出
    ,subiproleid -- 代表业务实际记账机构的iproleid，如不涉及多主体经营，该字段为空
    ,contracttype -- 借据类型
    ,batchdate -- 批次日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    contractno -- 融资平台贷款合约号
    ,settledate -- 会计日期，格式：yyyy-MM-dd hh:mm:ss
    ,extendcode -- 0-调整转出，1-调整转入
    ,seqno -- 调整流水号
    ,termno -- 期次号
    ,startdate -- 分期开始日期，格式：yyyy-MM-dd hh:mm:ss
    ,enddate -- 分期结束日期，格式：yyyy-MM-dd hh:mm:ss
    ,prinamt -- 正常本金金额
    ,ovdprinamt -- 逾期本金金额
    ,intamt -- 正常利息金额
    ,ovdintamt -- 逾期利息金额
    ,ovdprinpnltamt -- 本金罚息金额
    ,ovdintpnltamt -- 利息罚息金额
    ,status -- 分期状态，正常NORMAL,逾期OVD,结清CLEAR
    ,accruedstatus -- 应计非应计标识，应计0，非应计1
    ,writeoff -- 核销标识，已核销为Y，否则为N
    ,bsntype -- 产品业务类型，具体值合作产品上线后才给出
    ,subiproleid -- 代表业务实际记账机构的iproleid，如不涉及多主体经营，该字段为空
    ,contracttype -- 借据类型
    ,batchdate -- 批次日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_mybk_extend_detail_total_ef
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_mybk_extend_detail_total_ef exchange partition p_${batch_date} with table ${iol_schema}.icms_mybk_extend_detail_total_ef_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_mybk_extend_detail_total_ef to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_mybk_extend_detail_total_ef_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_mybk_extend_detail_total_ef',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);