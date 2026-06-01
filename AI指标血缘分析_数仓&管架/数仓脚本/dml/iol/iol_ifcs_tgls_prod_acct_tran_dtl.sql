/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifcs_tgls_prod_acct_tran_dtl
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
drop table ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl_ex purge;
alter table ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl where 0=1;

insert /*+ append */ into ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl_ex(
    systid -- 系统代号
    ,trandt -- 交易日期
    ,bsnssq -- 全局流水
    ,transq -- 交易流水
    ,serino -- 序号
    ,tranbr -- 交易机构编号
    ,acctbr -- 账务机构编号
    ,prcscd -- 交易码
    ,prodcd -- 解析产品
    ,loanp1 -- 产品属性1
    ,loanp2 -- 产品属性2
    ,loanp3 -- 产品属性3
    ,loanp4 -- 产品属性4
    ,loanp5 -- 产品属性5
    ,loanp6 -- 产品属性6
    ,loanp7 -- 产品属性7
    ,loanp8 -- 产品属性8
    ,loanp9 -- 产品属性9
    ,loanpa -- 产品属性10
    ,evetdn -- 交易方向
    ,trprcd -- 金额类型
    ,crcycd -- 币种
    ,tranam -- 交易金额
    ,custcd -- 客户号
    ,acctno -- 协议编号
    ,assis0 -- 渠道
    ,assis1 -- 可售产品
    ,assis2 -- 辅助核算2
    ,assis3 -- 辅助核算3
    ,assis4 -- 辅助核算4
    ,assis5 -- 辅助核算5
    ,assis6 -- 辅助核算6
    ,assis7 -- 辅助核算7
    ,assis9 -- 辅助核算9
    ,datex0 -- 交易时间
    ,chrex0 -- 交易用户
    ,chrex1 -- 授权用户
    ,chrex2 -- 冲正标志
    ,chrex3 -- 冲抹原交易流水号
    ,datex1 -- 冲抹原交易日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    systid -- 系统代号
    ,trandt -- 交易日期
    ,bsnssq -- 全局流水
    ,transq -- 交易流水
    ,serino -- 序号
    ,tranbr -- 交易机构编号
    ,acctbr -- 账务机构编号
    ,prcscd -- 交易码
    ,prodcd -- 解析产品
    ,loanp1 -- 产品属性1
    ,loanp2 -- 产品属性2
    ,loanp3 -- 产品属性3
    ,loanp4 -- 产品属性4
    ,loanp5 -- 产品属性5
    ,loanp6 -- 产品属性6
    ,loanp7 -- 产品属性7
    ,loanp8 -- 产品属性8
    ,loanp9 -- 产品属性9
    ,loanpa -- 产品属性10
    ,evetdn -- 交易方向
    ,trprcd -- 金额类型
    ,crcycd -- 币种
    ,tranam -- 交易金额
    ,custcd -- 客户号
    ,acctno -- 协议编号
    ,assis0 -- 渠道
    ,assis1 -- 可售产品
    ,assis2 -- 辅助核算2
    ,assis3 -- 辅助核算3
    ,assis4 -- 辅助核算4
    ,assis5 -- 辅助核算5
    ,assis6 -- 辅助核算6
    ,assis7 -- 辅助核算7
    ,assis9 -- 辅助核算9
    ,datex0 -- 交易时间
    ,chrex0 -- 交易用户
    ,chrex1 -- 授权用户
    ,chrex2 -- 冲正标志
    ,chrex3 -- 冲抹原交易流水号
    ,datex1 -- 冲抹原交易日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ifcs_tgls_prod_acct_tran_dtl
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl exchange partition p_${batch_date} with table ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifcs_tgls_prod_acct_tran_dtl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);