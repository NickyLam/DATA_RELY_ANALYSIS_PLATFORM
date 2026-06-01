/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_loan_settle_default
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
create table ${iol_schema}.ncbs_cl_loan_settle_default_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_loan_settle_default
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_loan_settle_default_op purge;
drop table ${iol_schema}.ncbs_cl_loan_settle_default_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_loan_settle_default_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_loan_settle_default where 0=1;

create table ${iol_schema}.ncbs_cl_loan_settle_default_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_loan_settle_default where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_loan_settle_default_cl(
            amt_type -- 金额类型
            ,client_no -- 客户编号
            ,tran_type -- 交易类型
            ,user_id -- 交易柜员编号
            ,auto_blocking -- 自动锁定标志
            ,company -- 法人
            ,event_type -- 事件类型
            ,pay_rec_ind -- 收付款标志
            ,priority -- 优先级
            ,settle_acct_class -- 结算账户分类
            ,settle_bank_flag -- 资金转移账户银行标识
            ,settle_method -- 结算方法
            ,settle_mobile_phone -- 绑定账户手机号码
            ,settle_no -- 结算编号
            ,settle_weight -- 结算权重
            ,settle_xrate_id -- 结算汇兑方式
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_name -- 结算账户户名
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_amt -- 结算金额
            ,settle_bank_name -- 清算账号开户行行名
            ,settle_base_acct_no -- 结算账号
            ,settle_branch -- 清算机构
            ,settle_ccy -- 结算币种
            ,settle_client -- 结算客户号
            ,settle_prod_type -- 结算账户产品类型
            ,settle_xrate -- 结算汇率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_loan_settle_default_op(
            amt_type -- 金额类型
            ,client_no -- 客户编号
            ,tran_type -- 交易类型
            ,user_id -- 交易柜员编号
            ,auto_blocking -- 自动锁定标志
            ,company -- 法人
            ,event_type -- 事件类型
            ,pay_rec_ind -- 收付款标志
            ,priority -- 优先级
            ,settle_acct_class -- 结算账户分类
            ,settle_bank_flag -- 资金转移账户银行标识
            ,settle_method -- 结算方法
            ,settle_mobile_phone -- 绑定账户手机号码
            ,settle_no -- 结算编号
            ,settle_weight -- 结算权重
            ,settle_xrate_id -- 结算汇兑方式
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_name -- 结算账户户名
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_amt -- 结算金额
            ,settle_bank_name -- 清算账号开户行行名
            ,settle_base_acct_no -- 结算账号
            ,settle_branch -- 清算机构
            ,settle_ccy -- 结算币种
            ,settle_client -- 结算客户号
            ,settle_prod_type -- 结算账户产品类型
            ,settle_xrate -- 结算汇率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.amt_type, o.amt_type) as amt_type -- 金额类型
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.tran_type, o.tran_type) as tran_type -- 交易类型
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.auto_blocking, o.auto_blocking) as auto_blocking -- 自动锁定标志
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.event_type, o.event_type) as event_type -- 事件类型
    ,nvl(n.pay_rec_ind, o.pay_rec_ind) as pay_rec_ind -- 收付款标志
    ,nvl(n.priority, o.priority) as priority -- 优先级
    ,nvl(n.settle_acct_class, o.settle_acct_class) as settle_acct_class -- 结算账户分类
    ,nvl(n.settle_bank_flag, o.settle_bank_flag) as settle_bank_flag -- 资金转移账户银行标识
    ,nvl(n.settle_method, o.settle_method) as settle_method -- 结算方法
    ,nvl(n.settle_mobile_phone, o.settle_mobile_phone) as settle_mobile_phone -- 绑定账户手机号码
    ,nvl(n.settle_no, o.settle_no) as settle_no -- 结算编号
    ,nvl(n.settle_weight, o.settle_weight) as settle_weight -- 结算权重
    ,nvl(n.settle_xrate_id, o.settle_xrate_id) as settle_xrate_id -- 结算汇兑方式
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.last_change_user_id, o.last_change_user_id) as last_change_user_id -- 最后修改柜员
    ,nvl(n.loan_no, o.loan_no) as loan_no -- 贷款号
    ,nvl(n.settle_acct_ccy, o.settle_acct_ccy) as settle_acct_ccy -- 结算账户币种
    ,nvl(n.settle_acct_name, o.settle_acct_name) as settle_acct_name -- 结算账户户名
    ,nvl(n.settle_acct_seq_no, o.settle_acct_seq_no) as settle_acct_seq_no -- 结算账户序号
    ,nvl(n.settle_amt, o.settle_amt) as settle_amt -- 结算金额
    ,nvl(n.settle_bank_name, o.settle_bank_name) as settle_bank_name -- 清算账号开户行行名
    ,nvl(n.settle_base_acct_no, o.settle_base_acct_no) as settle_base_acct_no -- 结算账号
    ,nvl(n.settle_branch, o.settle_branch) as settle_branch -- 清算机构
    ,nvl(n.settle_ccy, o.settle_ccy) as settle_ccy -- 结算币种
    ,nvl(n.settle_client, o.settle_client) as settle_client -- 结算客户号
    ,nvl(n.settle_prod_type, o.settle_prod_type) as settle_prod_type -- 结算账户产品类型
    ,nvl(n.settle_xrate, o.settle_xrate) as settle_xrate -- 结算汇率
    ,case when
            n.settle_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.settle_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.settle_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_loan_settle_default_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_loan_settle_default where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.settle_no = n.settle_no
where (
        o.settle_no is null
    )
    or (
        n.settle_no is null
    )
    or (
        o.amt_type <> n.amt_type
        or o.client_no <> n.client_no
        or o.tran_type <> n.tran_type
        or o.user_id <> n.user_id
        or o.auto_blocking <> n.auto_blocking
        or o.company <> n.company
        or o.event_type <> n.event_type
        or o.pay_rec_ind <> n.pay_rec_ind
        or o.priority <> n.priority
        or o.settle_acct_class <> n.settle_acct_class
        or o.settle_bank_flag <> n.settle_bank_flag
        or o.settle_method <> n.settle_method
        or o.settle_mobile_phone <> n.settle_mobile_phone
        or o.settle_weight <> n.settle_weight
        or o.settle_xrate_id <> n.settle_xrate_id
        or o.last_change_date <> n.last_change_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.last_change_user_id <> n.last_change_user_id
        or o.loan_no <> n.loan_no
        or o.settle_acct_ccy <> n.settle_acct_ccy
        or o.settle_acct_name <> n.settle_acct_name
        or o.settle_acct_seq_no <> n.settle_acct_seq_no
        or o.settle_amt <> n.settle_amt
        or o.settle_bank_name <> n.settle_bank_name
        or o.settle_base_acct_no <> n.settle_base_acct_no
        or o.settle_branch <> n.settle_branch
        or o.settle_ccy <> n.settle_ccy
        or o.settle_client <> n.settle_client
        or o.settle_prod_type <> n.settle_prod_type
        or o.settle_xrate <> n.settle_xrate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_loan_settle_default_cl(
            amt_type -- 金额类型
            ,client_no -- 客户编号
            ,tran_type -- 交易类型
            ,user_id -- 交易柜员编号
            ,auto_blocking -- 自动锁定标志
            ,company -- 法人
            ,event_type -- 事件类型
            ,pay_rec_ind -- 收付款标志
            ,priority -- 优先级
            ,settle_acct_class -- 结算账户分类
            ,settle_bank_flag -- 资金转移账户银行标识
            ,settle_method -- 结算方法
            ,settle_mobile_phone -- 绑定账户手机号码
            ,settle_no -- 结算编号
            ,settle_weight -- 结算权重
            ,settle_xrate_id -- 结算汇兑方式
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_name -- 结算账户户名
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_amt -- 结算金额
            ,settle_bank_name -- 清算账号开户行行名
            ,settle_base_acct_no -- 结算账号
            ,settle_branch -- 清算机构
            ,settle_ccy -- 结算币种
            ,settle_client -- 结算客户号
            ,settle_prod_type -- 结算账户产品类型
            ,settle_xrate -- 结算汇率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_loan_settle_default_op(
            amt_type -- 金额类型
            ,client_no -- 客户编号
            ,tran_type -- 交易类型
            ,user_id -- 交易柜员编号
            ,auto_blocking -- 自动锁定标志
            ,company -- 法人
            ,event_type -- 事件类型
            ,pay_rec_ind -- 收付款标志
            ,priority -- 优先级
            ,settle_acct_class -- 结算账户分类
            ,settle_bank_flag -- 资金转移账户银行标识
            ,settle_method -- 结算方法
            ,settle_mobile_phone -- 绑定账户手机号码
            ,settle_no -- 结算编号
            ,settle_weight -- 结算权重
            ,settle_xrate_id -- 结算汇兑方式
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_name -- 结算账户户名
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_amt -- 结算金额
            ,settle_bank_name -- 清算账号开户行行名
            ,settle_base_acct_no -- 结算账号
            ,settle_branch -- 清算机构
            ,settle_ccy -- 结算币种
            ,settle_client -- 结算客户号
            ,settle_prod_type -- 结算账户产品类型
            ,settle_xrate -- 结算汇率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.amt_type -- 金额类型
    ,o.client_no -- 客户编号
    ,o.tran_type -- 交易类型
    ,o.user_id -- 交易柜员编号
    ,o.auto_blocking -- 自动锁定标志
    ,o.company -- 法人
    ,o.event_type -- 事件类型
    ,o.pay_rec_ind -- 收付款标志
    ,o.priority -- 优先级
    ,o.settle_acct_class -- 结算账户分类
    ,o.settle_bank_flag -- 资金转移账户银行标识
    ,o.settle_method -- 结算方法
    ,o.settle_mobile_phone -- 绑定账户手机号码
    ,o.settle_no -- 结算编号
    ,o.settle_weight -- 结算权重
    ,o.settle_xrate_id -- 结算汇兑方式
    ,o.last_change_date -- 最后修改日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.last_change_user_id -- 最后修改柜员
    ,o.loan_no -- 贷款号
    ,o.settle_acct_ccy -- 结算账户币种
    ,o.settle_acct_name -- 结算账户户名
    ,o.settle_acct_seq_no -- 结算账户序号
    ,o.settle_amt -- 结算金额
    ,o.settle_bank_name -- 清算账号开户行行名
    ,o.settle_base_acct_no -- 结算账号
    ,o.settle_branch -- 清算机构
    ,o.settle_ccy -- 结算币种
    ,o.settle_client -- 结算客户号
    ,o.settle_prod_type -- 结算账户产品类型
    ,o.settle_xrate -- 结算汇率
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
from ${iol_schema}.ncbs_cl_loan_settle_default_bk o
    left join ${iol_schema}.ncbs_cl_loan_settle_default_op n
        on
            o.settle_no = n.settle_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_loan_settle_default_cl d
        on
            o.settle_no = d.settle_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_loan_settle_default;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_loan_settle_default') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_loan_settle_default drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_loan_settle_default add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_loan_settle_default exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_loan_settle_default_cl;
alter table ${iol_schema}.ncbs_cl_loan_settle_default exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_loan_settle_default_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_loan_settle_default to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_loan_settle_default_op purge;
drop table ${iol_schema}.ncbs_cl_loan_settle_default_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_loan_settle_default_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_loan_settle_default',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
