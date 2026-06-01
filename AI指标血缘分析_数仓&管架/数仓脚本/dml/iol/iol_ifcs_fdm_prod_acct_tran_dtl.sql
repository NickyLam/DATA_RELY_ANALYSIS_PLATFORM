/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifcs_fdm_prod_acct_tran_dtl
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
drop table ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl_ex purge;
alter table ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl where 0=1;

insert /*+ append */ into ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl_ex(
    tran_type_cd -- 交易码
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,tran_dt -- 交易日期
    ,enter_acct_dt -- 入账日期
    ,agt_duty_center_id -- 协议责任中心编号
    ,tran_duty_center_id -- 交易责任中心编号
    ,tran_amt -- 交易金额
    ,data_src_cd -- 数据来源代码
    ,chn_typ_cd -- 渠道类型代码
    ,global_chn_seq_num -- 全局渠道流水号
    ,evt_id -- 事件编号
    ,agt_id -- 协议编号
    ,agt_bal -- 协议余额
    ,org_id -- 机构编号
    ,pty_typ_cd -- 客户类型代码
    ,reverse_flg -- 是否冲正
    ,reverse_evt_id -- 冲正事件编号
    ,bal_typ_cd -- 余额类型代码
    ,acct_categ_cd -- 会计类别代码
    ,debit_crdt_dir_cd -- 金额方向
    ,etl_dt_ora -- 数据日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tran_type_cd -- 交易码
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,tran_dt -- 交易日期
    ,enter_acct_dt -- 入账日期
    ,agt_duty_center_id -- 协议责任中心编号
    ,tran_duty_center_id -- 交易责任中心编号
    ,tran_amt -- 交易金额
    ,data_src_cd -- 数据来源代码
    ,chn_typ_cd -- 渠道类型代码
    ,global_chn_seq_num -- 全局渠道流水号
    ,evt_id -- 事件编号
    ,agt_id -- 协议编号
    ,agt_bal -- 协议余额
    ,org_id -- 机构编号
    ,pty_typ_cd -- 客户类型代码
    ,reverse_flg -- 是否冲正
    ,reverse_evt_id -- 冲正事件编号
    ,bal_typ_cd -- 余额类型代码
    ,acct_categ_cd -- 会计类别代码
    ,debit_crdt_dir_cd -- 金额方向
    ,etl_dt_ora -- 数据日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ifcs_fdm_prod_acct_tran_dtl
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl exchange partition p_${batch_date} with table ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifcs_fdm_prod_acct_tran_dtl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);