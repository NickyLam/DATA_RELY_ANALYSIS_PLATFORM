/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_batch_settle
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
drop table ${iol_schema}.ncbs_cl_batch_settle_ex purge;
alter table ${iol_schema}.ncbs_cl_batch_settle add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_cl_batch_settle truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_cl_batch_settle_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_batch_settle where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_cl_batch_settle_ex(
    amt_type -- 金额类型
    ,branch -- 机构编号
    ,ccy -- 币种
    ,client_no -- 客户编号
    ,dd_no -- 发放号
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,remark -- 备注
    ,tran_type -- 交易类型
    ,amt_ctl -- 金额控制标志
    ,auto_blocking -- 自动锁定标志
    ,batch_no -- 批次号
    ,batch_seq_no -- 批次明细序号
    ,company -- 法人
    ,diff_amt -- 差错金额
    ,event_type -- 事件类型
    ,group_id -- 流程组id
    ,invoice_tran_no -- 通知单号
    ,order_no -- 预约编号
    ,oth_settle_method -- 对手账户结算方式
    ,priority -- 优先级
    ,reserve1 -- 预留字段1
    ,reserve2 -- 预留字段2
    ,restraint_seq_no -- 冻结编号
    ,settle_acct_class -- 结算账户分类
    ,settle_method -- 结算方法
    ,settle_no -- 结算编号
    ,settle_type -- 结算方式
    ,stage_no -- 期次
    ,status -- 状态
    ,tran_status -- 冲补抹标志
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,diff_settle_amt -- 差额结算金额
    ,loan_no -- 贷款号
    ,oppo_acct_no -- 行外对手账号
    ,oppo_bank_code -- 行外对手账户行号
    ,oppo_bank_name -- 行外对手账户行名
    ,oth_settle_acct_ccy -- 对手结算账户币种
    ,oth_settle_acct_name -- 对手结算账户户名
    ,oth_settle_acct_seq_no -- 对手结算账户序号
    ,oth_settle_acct_type -- 对手账户结算账户类型
    ,oth_settle_base_acct_no -- 对手结算账号
    ,oth_settle_client -- 对手结算客户号
    ,oth_settle_prod_type -- 对手结算账户产品类型
    ,settle_acct_ccy -- 结算账户币种
    ,settle_acct_name -- 结算账户户名
    ,settle_acct_seq_no -- 结算账户序号
    ,settle_amt -- 结算金额
    ,settle_base_acct_no -- 结算账号
    ,settle_client -- 结算客户号
    ,settle_prod_type -- 结算账户产品类型
    ,tran_amt -- 交易金额
    ,loan_class -- 贷款类别|贷款类别 C-普通贷款,O-法人透支,R-存贷一体卡
    ,acct_res_operate_type -- 账户限制操作类型|账户限制操作类型|01-新增,02-修改,03-解限,04-追加,05-部分解限,06-续冻
    ,cmisloan_no -- 借据号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    amt_type -- 金额类型
    ,branch -- 机构编号
    ,ccy -- 币种
    ,client_no -- 客户编号
    ,dd_no -- 发放号
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,remark -- 备注
    ,tran_type -- 交易类型
    ,amt_ctl -- 金额控制标志
    ,auto_blocking -- 自动锁定标志
    ,batch_no -- 批次号
    ,batch_seq_no -- 批次明细序号
    ,company -- 法人
    ,diff_amt -- 差错金额
    ,event_type -- 事件类型
    ,group_id -- 流程组id
    ,invoice_tran_no -- 通知单号
    ,order_no -- 预约编号
    ,oth_settle_method -- 对手账户结算方式
    ,priority -- 优先级
    ,reserve1 -- 预留字段1
    ,reserve2 -- 预留字段2
    ,restraint_seq_no -- 冻结编号
    ,settle_acct_class -- 结算账户分类
    ,settle_method -- 结算方法
    ,settle_no -- 结算编号
    ,settle_type -- 结算方式
    ,stage_no -- 期次
    ,status -- 状态
    ,tran_status -- 冲补抹标志
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,diff_settle_amt -- 差额结算金额
    ,loan_no -- 贷款号
    ,oppo_acct_no -- 行外对手账号
    ,oppo_bank_code -- 行外对手账户行号
    ,oppo_bank_name -- 行外对手账户行名
    ,oth_settle_acct_ccy -- 对手结算账户币种
    ,oth_settle_acct_name -- 对手结算账户户名
    ,oth_settle_acct_seq_no -- 对手结算账户序号
    ,oth_settle_acct_type -- 对手账户结算账户类型
    ,oth_settle_base_acct_no -- 对手结算账号
    ,oth_settle_client -- 对手结算客户号
    ,oth_settle_prod_type -- 对手结算账户产品类型
    ,settle_acct_ccy -- 结算账户币种
    ,settle_acct_name -- 结算账户户名
    ,settle_acct_seq_no -- 结算账户序号
    ,settle_amt -- 结算金额
    ,settle_base_acct_no -- 结算账号
    ,settle_client -- 结算客户号
    ,settle_prod_type -- 结算账户产品类型
    ,tran_amt -- 交易金额
    ,loan_class -- 贷款类别|贷款类别 C-普通贷款,O-法人透支,R-存贷一体卡
    ,acct_res_operate_type -- 账户限制操作类型|账户限制操作类型|01-新增,02-修改,03-解限,04-追加,05-部分解限,06-续冻
    ,cmisloan_no -- 借据号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_cl_batch_settle
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_cl_batch_settle exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_batch_settle_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_batch_settle to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_cl_batch_settle_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_batch_settle',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);