/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a0n_hx_subject_flow
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
drop table ${iol_schema}.mpcs_a0n_hx_subject_flow_ex purge;
alter table ${iol_schema}.mpcs_a0n_hx_subject_flow add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a0n_hx_subject_flow truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a0n_hx_subject_flow_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0n_hx_subject_flow where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a0n_hx_subject_flow_ex(
    sourst -- 系统代号
    ,bsnssq -- 全局流水号
    ,sourdt -- 源系统日期
    ,soursq -- 源系统流水号
    ,vchrsq -- 传票序号
    ,itemcd -- 科目编号
    ,acctbr -- 账务机构编号
    ,tranbr -- 交易机构编号
    ,crcycd -- 币种
    ,prcscd -- 交易码
    ,tranam -- 交易金额
    ,amntcd -- 借贷方向
    ,smrytx -- 摘要
    ,custcd -- 客户号
    ,assis8 -- 产品
    ,acctno -- 协议编号
    ,assis0 -- 辅助核算0
    ,assis1 -- 辅助核算1
    ,assis2 -- 辅助核算2
    ,assis3 -- 辅助核算3
    ,assis4 -- 辅助核算4
    ,assis5 -- 辅助核算5
    ,assis6 -- 辅助核算6
    ,assis7 -- 辅助核算7
    ,prducd -- 辅助核算8
    ,assis9 -- 辅助核算9
    ,datex0 -- 交易时间
    ,chrex0 -- 交易用户
    ,chrex1 -- 授权用户
    ,chrex3 -- 冲抹原交易流水号
    ,taxam -- 税额
    ,chrex4 -- 冲抹标记
    ,cbsflag -- 是否核心记账  1-是 0-否
    ,inneracct -- 核心记账内部户
    ,status -- 核心记账状态 0-未记账  1-记账成功 2-异常
    ,transeq -- 核心记账交易流水
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    sourst -- 系统代号
    ,bsnssq -- 全局流水号
    ,sourdt -- 源系统日期
    ,soursq -- 源系统流水号
    ,vchrsq -- 传票序号
    ,itemcd -- 科目编号
    ,acctbr -- 账务机构编号
    ,tranbr -- 交易机构编号
    ,crcycd -- 币种
    ,prcscd -- 交易码
    ,tranam -- 交易金额
    ,amntcd -- 借贷方向
    ,smrytx -- 摘要
    ,custcd -- 客户号
    ,assis8 -- 产品
    ,acctno -- 协议编号
    ,assis0 -- 辅助核算0
    ,assis1 -- 辅助核算1
    ,assis2 -- 辅助核算2
    ,assis3 -- 辅助核算3
    ,assis4 -- 辅助核算4
    ,assis5 -- 辅助核算5
    ,assis6 -- 辅助核算6
    ,assis7 -- 辅助核算7
    ,prducd -- 辅助核算8
    ,assis9 -- 辅助核算9
    ,datex0 -- 交易时间
    ,chrex0 -- 交易用户
    ,chrex1 -- 授权用户
    ,chrex3 -- 冲抹原交易流水号
    ,taxam -- 税额
    ,chrex4 -- 冲抹标记
    ,cbsflag -- 是否核心记账  1-是 0-否
    ,inneracct -- 核心记账内部户
    ,status -- 核心记账状态 0-未记账  1-记账成功 2-异常
    ,transeq -- 核心记账交易流水
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a0n_hx_subject_flow
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a0n_hx_subject_flow exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a0n_hx_subject_flow_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a0n_hx_subject_flow to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a0n_hx_subject_flow_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a0n_hx_subject_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);