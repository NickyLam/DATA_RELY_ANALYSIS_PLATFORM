/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_batch_rec
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.ncbs_cl_batch_rec_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_batch_rec
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_batch_rec_op purge;
drop table ${iol_schema}.ncbs_cl_batch_rec_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_batch_rec_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_batch_rec where 0=1;

create table ${iol_schema}.ncbs_cl_batch_rec_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_batch_rec where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_batch_rec_cl(
            amt_type -- 金额类型
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,dd_no -- 发放号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,acct_class -- 账户等级
            ,auto_blocking -- 自动锁定标志
            ,bank_in_out -- 是否行内行外
            ,batch_rec_status -- 批量扣款状态
            ,batch_seq_no -- 批次明细序号
            ,company -- 法人
            ,invoice_tran_no -- 通知单号
            ,priority -- 优先级
            ,rec_amt_ctrl -- 扣款方式
            ,rec_status -- 回收处理状态
            ,rec_type -- 扣款类型
            ,restraint_seq_no -- 冻结编号
            ,settle_acct_class -- 结算账户分类
            ,settle_bank -- 结算行号
            ,settle_weight -- 结算权重
            ,stage_no -- 期次
            ,last_change_date -- 最后修改日期
            ,maturity_date -- 到期日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,paid_amt -- 已还金额
            ,rec_amt -- 回收金额(指回收的本金)
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_name -- 结算账户户名
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_amt -- 结算金额
            ,settle_base_acct_no -- 结算账号
            ,settle_client -- 结算客户号
            ,settle_prod_type -- 结算账户产品类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_batch_rec_op(
            amt_type -- 金额类型
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,dd_no -- 发放号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,acct_class -- 账户等级
            ,auto_blocking -- 自动锁定标志
            ,bank_in_out -- 是否行内行外
            ,batch_rec_status -- 批量扣款状态
            ,batch_seq_no -- 批次明细序号
            ,company -- 法人
            ,invoice_tran_no -- 通知单号
            ,priority -- 优先级
            ,rec_amt_ctrl -- 扣款方式
            ,rec_status -- 回收处理状态
            ,rec_type -- 扣款类型
            ,restraint_seq_no -- 冻结编号
            ,settle_acct_class -- 结算账户分类
            ,settle_bank -- 结算行号
            ,settle_weight -- 结算权重
            ,stage_no -- 期次
            ,last_change_date -- 最后修改日期
            ,maturity_date -- 到期日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,paid_amt -- 已还金额
            ,rec_amt -- 回收金额(指回收的本金)
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_name -- 结算账户户名
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_amt -- 结算金额
            ,settle_base_acct_no -- 结算账号
            ,settle_client -- 结算客户号
            ,settle_prod_type -- 结算账户产品类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.amt_type, o.amt_type) as amt_type -- 金额类型
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.dd_no, o.dd_no) as dd_no -- 发放号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.acct_class, o.acct_class) as acct_class -- 账户等级
    ,nvl(n.auto_blocking, o.auto_blocking) as auto_blocking -- 自动锁定标志
    ,nvl(n.bank_in_out, o.bank_in_out) as bank_in_out -- 是否行内行外
    ,nvl(n.batch_rec_status, o.batch_rec_status) as batch_rec_status -- 批量扣款状态
    ,nvl(n.batch_seq_no, o.batch_seq_no) as batch_seq_no -- 批次明细序号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.invoice_tran_no, o.invoice_tran_no) as invoice_tran_no -- 通知单号
    ,nvl(n.priority, o.priority) as priority -- 优先级
    ,nvl(n.rec_amt_ctrl, o.rec_amt_ctrl) as rec_amt_ctrl -- 扣款方式
    ,nvl(n.rec_status, o.rec_status) as rec_status -- 回收处理状态
    ,nvl(n.rec_type, o.rec_type) as rec_type -- 扣款类型
    ,nvl(n.restraint_seq_no, o.restraint_seq_no) as restraint_seq_no -- 冻结编号
    ,nvl(n.settle_acct_class, o.settle_acct_class) as settle_acct_class -- 结算账户分类
    ,nvl(n.settle_bank, o.settle_bank) as settle_bank -- 结算行号
    ,nvl(n.settle_weight, o.settle_weight) as settle_weight -- 结算权重
    ,nvl(n.stage_no, o.stage_no) as stage_no -- 期次
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期日期
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.last_change_user_id, o.last_change_user_id) as last_change_user_id -- 最后修改柜员
    ,nvl(n.loan_no, o.loan_no) as loan_no -- 贷款号
    ,nvl(n.paid_amt, o.paid_amt) as paid_amt -- 已还金额
    ,nvl(n.rec_amt, o.rec_amt) as rec_amt -- 回收金额(指回收的本金)
    ,nvl(n.settle_acct_ccy, o.settle_acct_ccy) as settle_acct_ccy -- 结算账户币种
    ,nvl(n.settle_acct_name, o.settle_acct_name) as settle_acct_name -- 结算账户户名
    ,nvl(n.settle_acct_seq_no, o.settle_acct_seq_no) as settle_acct_seq_no -- 结算账户序号
    ,nvl(n.settle_amt, o.settle_amt) as settle_amt -- 结算金额
    ,nvl(n.settle_base_acct_no, o.settle_base_acct_no) as settle_base_acct_no -- 结算账号
    ,nvl(n.settle_client, o.settle_client) as settle_client -- 结算客户号
    ,nvl(n.settle_prod_type, o.settle_prod_type) as settle_prod_type -- 结算账户产品类型
    ,case when
            n.batch_seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.batch_seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.batch_seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_batch_rec_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_batch_rec where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.batch_seq_no = n.batch_seq_no
where (
        o.batch_seq_no is null
    )
    or (
        n.batch_seq_no is null
    )
    or (
        o.amt_type <> n.amt_type
        or o.ccy <> n.ccy
        or o.client_no <> n.client_no
        or o.dd_no <> n.dd_no
        or o.internal_key <> n.internal_key
        or o.prod_type <> n.prod_type
        or o.reference <> n.reference
        or o.user_id <> n.user_id
        or o.acct_class <> n.acct_class
        or o.auto_blocking <> n.auto_blocking
        or o.bank_in_out <> n.bank_in_out
        or o.batch_rec_status <> n.batch_rec_status
        or o.company <> n.company
        or o.invoice_tran_no <> n.invoice_tran_no
        or o.priority <> n.priority
        or o.rec_amt_ctrl <> n.rec_amt_ctrl
        or o.rec_status <> n.rec_status
        or o.rec_type <> n.rec_type
        or o.restraint_seq_no <> n.restraint_seq_no
        or o.settle_acct_class <> n.settle_acct_class
        or o.settle_bank <> n.settle_bank
        or o.settle_weight <> n.settle_weight
        or o.stage_no <> n.stage_no
        or o.last_change_date <> n.last_change_date
        or o.maturity_date <> n.maturity_date
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.last_change_user_id <> n.last_change_user_id
        or o.loan_no <> n.loan_no
        or o.paid_amt <> n.paid_amt
        or o.rec_amt <> n.rec_amt
        or o.settle_acct_ccy <> n.settle_acct_ccy
        or o.settle_acct_name <> n.settle_acct_name
        or o.settle_acct_seq_no <> n.settle_acct_seq_no
        or o.settle_amt <> n.settle_amt
        or o.settle_base_acct_no <> n.settle_base_acct_no
        or o.settle_client <> n.settle_client
        or o.settle_prod_type <> n.settle_prod_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_batch_rec_cl(
            amt_type -- 金额类型
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,dd_no -- 发放号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,acct_class -- 账户等级
            ,auto_blocking -- 自动锁定标志
            ,bank_in_out -- 是否行内行外
            ,batch_rec_status -- 批量扣款状态
            ,batch_seq_no -- 批次明细序号
            ,company -- 法人
            ,invoice_tran_no -- 通知单号
            ,priority -- 优先级
            ,rec_amt_ctrl -- 扣款方式
            ,rec_status -- 回收处理状态
            ,rec_type -- 扣款类型
            ,restraint_seq_no -- 冻结编号
            ,settle_acct_class -- 结算账户分类
            ,settle_bank -- 结算行号
            ,settle_weight -- 结算权重
            ,stage_no -- 期次
            ,last_change_date -- 最后修改日期
            ,maturity_date -- 到期日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,paid_amt -- 已还金额
            ,rec_amt -- 回收金额(指回收的本金)
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_name -- 结算账户户名
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_amt -- 结算金额
            ,settle_base_acct_no -- 结算账号
            ,settle_client -- 结算客户号
            ,settle_prod_type -- 结算账户产品类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_batch_rec_op(
            amt_type -- 金额类型
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,dd_no -- 发放号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,acct_class -- 账户等级
            ,auto_blocking -- 自动锁定标志
            ,bank_in_out -- 是否行内行外
            ,batch_rec_status -- 批量扣款状态
            ,batch_seq_no -- 批次明细序号
            ,company -- 法人
            ,invoice_tran_no -- 通知单号
            ,priority -- 优先级
            ,rec_amt_ctrl -- 扣款方式
            ,rec_status -- 回收处理状态
            ,rec_type -- 扣款类型
            ,restraint_seq_no -- 冻结编号
            ,settle_acct_class -- 结算账户分类
            ,settle_bank -- 结算行号
            ,settle_weight -- 结算权重
            ,stage_no -- 期次
            ,last_change_date -- 最后修改日期
            ,maturity_date -- 到期日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,paid_amt -- 已还金额
            ,rec_amt -- 回收金额(指回收的本金)
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_name -- 结算账户户名
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_amt -- 结算金额
            ,settle_base_acct_no -- 结算账号
            ,settle_client -- 结算客户号
            ,settle_prod_type -- 结算账户产品类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.amt_type -- 金额类型
    ,o.ccy -- 币种
    ,o.client_no -- 客户编号
    ,o.dd_no -- 发放号
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.reference -- 交易参考号
    ,o.user_id -- 交易柜员编号
    ,o.acct_class -- 账户等级
    ,o.auto_blocking -- 自动锁定标志
    ,o.bank_in_out -- 是否行内行外
    ,o.batch_rec_status -- 批量扣款状态
    ,o.batch_seq_no -- 批次明细序号
    ,o.company -- 法人
    ,o.invoice_tran_no -- 通知单号
    ,o.priority -- 优先级
    ,o.rec_amt_ctrl -- 扣款方式
    ,o.rec_status -- 回收处理状态
    ,o.rec_type -- 扣款类型
    ,o.restraint_seq_no -- 冻结编号
    ,o.settle_acct_class -- 结算账户分类
    ,o.settle_bank -- 结算行号
    ,o.settle_weight -- 结算权重
    ,o.stage_no -- 期次
    ,o.last_change_date -- 最后修改日期
    ,o.maturity_date -- 到期日期
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.last_change_user_id -- 最后修改柜员
    ,o.loan_no -- 贷款号
    ,o.paid_amt -- 已还金额
    ,o.rec_amt -- 回收金额(指回收的本金)
    ,o.settle_acct_ccy -- 结算账户币种
    ,o.settle_acct_name -- 结算账户户名
    ,o.settle_acct_seq_no -- 结算账户序号
    ,o.settle_amt -- 结算金额
    ,o.settle_base_acct_no -- 结算账号
    ,o.settle_client -- 结算客户号
    ,o.settle_prod_type -- 结算账户产品类型
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.ncbs_cl_batch_rec_bk o
    left join ${iol_schema}.ncbs_cl_batch_rec_op n
        on
            o.batch_seq_no = n.batch_seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_batch_rec_cl d
        on
            o.batch_seq_no = d.batch_seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_batch_rec;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_batch_rec') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_batch_rec drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_batch_rec add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_batch_rec exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_batch_rec_cl;
alter table ${iol_schema}.ncbs_cl_batch_rec exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_batch_rec_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_batch_rec to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_batch_rec_op purge;
drop table ${iol_schema}.ncbs_cl_batch_rec_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_batch_rec_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_batch_rec',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
