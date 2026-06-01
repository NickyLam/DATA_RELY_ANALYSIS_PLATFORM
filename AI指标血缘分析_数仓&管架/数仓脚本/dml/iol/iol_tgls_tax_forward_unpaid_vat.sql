/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_tax_forward_unpaid_vat
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
drop table ${iol_schema}.tgls_tax_forward_unpaid_vat_ex purge;
alter table ${iol_schema}.tgls_tax_forward_unpaid_vat add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.tgls_tax_forward_unpaid_vat truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.tgls_tax_forward_unpaid_vat_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_tax_forward_unpaid_vat where 0=1;

insert /*+ append */ into ${iol_schema}.tgls_tax_forward_unpaid_vat_ex(
    stacid -- 账套标记
    ,sourdt -- 增值税结转会计日期
    ,prcscd -- 处理码
    ,soursq -- 会计分录流水号
    ,transt -- 附加税入账处理状态(0未入账1开始处理2产生明细3产生分录9处理失败)
    ,acctbr -- 机构编号
    ,sourst -- 来源系统编号
    ,crcycd -- 币种
    ,itemcd -- 科目编号
    ,tranam_dr -- 发生额借方汇总
    ,tranam_cr -- 发生额贷方汇总
    ,creation_date -- 创建日期
    ,last_updated_date -- 最后修改日期
    ,transq -- 处理批次号
    ,errflag -- 错误代码(0或空为成功1为出错)
    ,errmsg -- 错误描述
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    stacid -- 账套标记
    ,sourdt -- 增值税结转会计日期
    ,prcscd -- 处理码
    ,soursq -- 会计分录流水号
    ,transt -- 附加税入账处理状态(0未入账1开始处理2产生明细3产生分录9处理失败)
    ,acctbr -- 机构编号
    ,sourst -- 来源系统编号
    ,crcycd -- 币种
    ,itemcd -- 科目编号
    ,tranam_dr -- 发生额借方汇总
    ,tranam_cr -- 发生额贷方汇总
    ,creation_date -- 创建日期
    ,last_updated_date -- 最后修改日期
    ,transq -- 处理批次号
    ,errflag -- 错误代码(0或空为成功1为出错)
    ,errmsg -- 错误描述
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tgls_tax_forward_unpaid_vat
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tgls_tax_forward_unpaid_vat exchange partition p_${batch_date} with table ${iol_schema}.tgls_tax_forward_unpaid_vat_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_tax_forward_unpaid_vat to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tgls_tax_forward_unpaid_vat_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_tax_forward_unpaid_vat',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);