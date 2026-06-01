/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_gl_write_off_account
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
create table ${iol_schema}.ncbs_rb_gl_write_off_account_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_gl_write_off_account
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_gl_write_off_account_op purge;
drop table ${iol_schema}.ncbs_rb_gl_write_off_account_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_gl_write_off_account_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_gl_write_off_account where 0=1;

create table ${iol_schema}.ncbs_rb_gl_write_off_account_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_gl_write_off_account where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_gl_write_off_account_cl(
            base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,reference -- 交易参考号
            ,tran_type -- 交易类型
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,narrative -- 摘要
            ,write_off_seq_no -- 销账序号
            ,write_off_status -- 销账状态
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,auth_user_id -- 授权柜员
            ,hang_bal -- 挂账余额
            ,oth_acct_name -- 对方账户名称
            ,oth_base_acct_no -- 对方账号/卡号
            ,oth_branch -- 对方账户开户机构
            ,tran_branch -- 核心交易机构编号
            ,write_off_amt -- 销账金额
            ,hang_seq_no -- 挂账序列号
            ,hang_deal_type -- 挂销账资金的来源和去向
            ,sub_hang_seq_no -- 追加挂账子序号
            ,hang_write_off_time -- 挂销账时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_gl_write_off_account_op(
            base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,reference -- 交易参考号
            ,tran_type -- 交易类型
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,narrative -- 摘要
            ,write_off_seq_no -- 销账序号
            ,write_off_status -- 销账状态
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,auth_user_id -- 授权柜员
            ,hang_bal -- 挂账余额
            ,oth_acct_name -- 对方账户名称
            ,oth_base_acct_no -- 对方账号/卡号
            ,oth_branch -- 对方账户开户机构
            ,tran_branch -- 核心交易机构编号
            ,write_off_amt -- 销账金额
            ,hang_seq_no -- 挂账序列号
            ,hang_deal_type -- 挂销账资金的来源和去向
            ,sub_hang_seq_no -- 追加挂账子序号
            ,hang_write_off_time -- 挂销账时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.tran_type, o.tran_type) as tran_type -- 交易类型
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.narrative, o.narrative) as narrative -- 摘要
    ,nvl(n.write_off_seq_no, o.write_off_seq_no) as write_off_seq_no -- 销账序号
    ,nvl(n.write_off_status, o.write_off_status) as write_off_status -- 销账状态
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.auth_user_id, o.auth_user_id) as auth_user_id -- 授权柜员
    ,nvl(n.hang_bal, o.hang_bal) as hang_bal -- 挂账余额
    ,nvl(n.oth_acct_name, o.oth_acct_name) as oth_acct_name -- 对方账户名称
    ,nvl(n.oth_base_acct_no, o.oth_base_acct_no) as oth_base_acct_no -- 对方账号/卡号
    ,nvl(n.oth_branch, o.oth_branch) as oth_branch -- 对方账户开户机构
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.write_off_amt, o.write_off_amt) as write_off_amt -- 销账金额
    ,nvl(n.hang_seq_no, o.hang_seq_no) as hang_seq_no -- 挂账序列号
    ,nvl(n.hang_deal_type, o.hang_deal_type) as hang_deal_type -- 挂销账资金的来源和去向
    ,nvl(n.sub_hang_seq_no, o.sub_hang_seq_no) as sub_hang_seq_no -- 追加挂账子序号
    ,nvl(n.hang_write_off_time, o.hang_write_off_time) as hang_write_off_time -- 挂销账时间
    ,case when
            n.write_off_seq_no is null
            and n.hang_seq_no is null
            and n.sub_hang_seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.write_off_seq_no is null
            and n.hang_seq_no is null
            and n.sub_hang_seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.write_off_seq_no is null
            and n.hang_seq_no is null
            and n.sub_hang_seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_gl_write_off_account_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_gl_write_off_account where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.write_off_seq_no = n.write_off_seq_no
            and o.hang_seq_no = n.hang_seq_no
            and o.sub_hang_seq_no = n.sub_hang_seq_no
where (
        o.write_off_seq_no is null
        and o.hang_seq_no is null
        and o.sub_hang_seq_no is null
    )
    or (
        n.write_off_seq_no is null
        and n.hang_seq_no is null
        and n.sub_hang_seq_no is null
    )
    or (
        o.base_acct_no <> n.base_acct_no
        or o.ccy <> n.ccy
        or o.client_no <> n.client_no
        or o.reference <> n.reference
        or o.tran_type <> n.tran_type
        or o.user_id <> n.user_id
        or o.company <> n.company
        or o.narrative <> n.narrative
        or o.write_off_status <> n.write_off_status
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.auth_user_id <> n.auth_user_id
        or o.hang_bal <> n.hang_bal
        or o.oth_acct_name <> n.oth_acct_name
        or o.oth_base_acct_no <> n.oth_base_acct_no
        or o.oth_branch <> n.oth_branch
        or o.tran_branch <> n.tran_branch
        or o.write_off_amt <> n.write_off_amt
        or o.hang_deal_type <> n.hang_deal_type
        or o.hang_write_off_time <> n.hang_write_off_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_gl_write_off_account_cl(
            base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,reference -- 交易参考号
            ,tran_type -- 交易类型
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,narrative -- 摘要
            ,write_off_seq_no -- 销账序号
            ,write_off_status -- 销账状态
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,auth_user_id -- 授权柜员
            ,hang_bal -- 挂账余额
            ,oth_acct_name -- 对方账户名称
            ,oth_base_acct_no -- 对方账号/卡号
            ,oth_branch -- 对方账户开户机构
            ,tran_branch -- 核心交易机构编号
            ,write_off_amt -- 销账金额
            ,hang_seq_no -- 挂账序列号
            ,hang_deal_type -- 挂销账资金的来源和去向
            ,sub_hang_seq_no -- 追加挂账子序号
            ,hang_write_off_time -- 挂销账时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_gl_write_off_account_op(
            base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,reference -- 交易参考号
            ,tran_type -- 交易类型
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,narrative -- 摘要
            ,write_off_seq_no -- 销账序号
            ,write_off_status -- 销账状态
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,auth_user_id -- 授权柜员
            ,hang_bal -- 挂账余额
            ,oth_acct_name -- 对方账户名称
            ,oth_base_acct_no -- 对方账号/卡号
            ,oth_branch -- 对方账户开户机构
            ,tran_branch -- 核心交易机构编号
            ,write_off_amt -- 销账金额
            ,hang_seq_no -- 挂账序列号
            ,hang_deal_type -- 挂销账资金的来源和去向
            ,sub_hang_seq_no -- 追加挂账子序号
            ,hang_write_off_time -- 挂销账时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.base_acct_no -- 交易账号/卡号
    ,o.ccy -- 币种
    ,o.client_no -- 客户编号
    ,o.reference -- 交易参考号
    ,o.tran_type -- 交易类型
    ,o.user_id -- 交易柜员编号
    ,o.company -- 法人
    ,o.narrative -- 摘要
    ,o.write_off_seq_no -- 销账序号
    ,o.write_off_status -- 销账状态
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.auth_user_id -- 授权柜员
    ,o.hang_bal -- 挂账余额
    ,o.oth_acct_name -- 对方账户名称
    ,o.oth_base_acct_no -- 对方账号/卡号
    ,o.oth_branch -- 对方账户开户机构
    ,o.tran_branch -- 核心交易机构编号
    ,o.write_off_amt -- 销账金额
    ,o.hang_seq_no -- 挂账序列号
    ,o.hang_deal_type -- 挂销账资金的来源和去向
    ,o.sub_hang_seq_no -- 追加挂账子序号
    ,o.hang_write_off_time -- 挂销账时间
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
from ${iol_schema}.ncbs_rb_gl_write_off_account_bk o
    left join ${iol_schema}.ncbs_rb_gl_write_off_account_op n
        on
            o.write_off_seq_no = n.write_off_seq_no
            and o.hang_seq_no = n.hang_seq_no
            and o.sub_hang_seq_no = n.sub_hang_seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_gl_write_off_account_cl d
        on
            o.write_off_seq_no = d.write_off_seq_no
            and o.hang_seq_no = d.hang_seq_no
            and o.sub_hang_seq_no = d.sub_hang_seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_gl_write_off_account;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_gl_write_off_account') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_gl_write_off_account drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_gl_write_off_account add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_gl_write_off_account exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_gl_write_off_account_cl;
alter table ${iol_schema}.ncbs_rb_gl_write_off_account exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_gl_write_off_account_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_gl_write_off_account to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_gl_write_off_account_op purge;
drop table ${iol_schema}.ncbs_rb_gl_write_off_account_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_gl_write_off_account_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_gl_write_off_account',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
