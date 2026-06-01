/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_settle_card_real
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
create table ${iol_schema}.ncbs_rb_settle_card_real_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_settle_card_real
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_settle_card_real_op purge;
drop table ${iol_schema}.ncbs_rb_settle_card_real_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_settle_card_real_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_settle_card_real where 0=1;

create table ${iol_schema}.ncbs_rb_settle_card_real_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_settle_card_real where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_settle_card_real_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,all_dra_ind -- 通兑标志
            ,auto_collect_flag -- 联动扣款标志
            ,card_tran_flag -- 卡片是否停用标志
            ,card_tranform_flag -- 卡内互转标识
            ,collect_no -- 归集顺序号
            ,collect_order -- 自动归集顺序
            ,company -- 法人
            ,cret_trans_flag -- 可存款
            ,debt_trans_flag -- 可转出
            ,default_flag -- 是否默认账号
            ,is_cash_trans -- 可取现
            ,main_card_flag -- 主卡标识
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,card_prod_type -- 卡产品类型
            ,main_card_no -- 主卡卡号
            ,tran_branch -- 核心交易机构编号
            ,inc_exp_flag -- 以收定支标识，单位结算卡限额用
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_settle_card_real_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,all_dra_ind -- 通兑标志
            ,auto_collect_flag -- 联动扣款标志
            ,card_tran_flag -- 卡片是否停用标志
            ,card_tranform_flag -- 卡内互转标识
            ,collect_no -- 归集顺序号
            ,collect_order -- 自动归集顺序
            ,company -- 法人
            ,cret_trans_flag -- 可存款
            ,debt_trans_flag -- 可转出
            ,default_flag -- 是否默认账号
            ,is_cash_trans -- 可取现
            ,main_card_flag -- 主卡标识
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,card_prod_type -- 卡产品类型
            ,main_card_no -- 主卡卡号
            ,tran_branch -- 核心交易机构编号
            ,inc_exp_flag -- 以收定支标识，单位结算卡限额用
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.all_dra_ind, o.all_dra_ind) as all_dra_ind -- 通兑标志
    ,nvl(n.auto_collect_flag, o.auto_collect_flag) as auto_collect_flag -- 联动扣款标志
    ,nvl(n.card_tran_flag, o.card_tran_flag) as card_tran_flag -- 卡片是否停用标志
    ,nvl(n.card_tranform_flag, o.card_tranform_flag) as card_tranform_flag -- 卡内互转标识
    ,nvl(n.collect_no, o.collect_no) as collect_no -- 归集顺序号
    ,nvl(n.collect_order, o.collect_order) as collect_order -- 自动归集顺序
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.cret_trans_flag, o.cret_trans_flag) as cret_trans_flag -- 可存款
    ,nvl(n.debt_trans_flag, o.debt_trans_flag) as debt_trans_flag -- 可转出
    ,nvl(n.default_flag, o.default_flag) as default_flag -- 是否默认账号
    ,nvl(n.is_cash_trans, o.is_cash_trans) as is_cash_trans -- 可取现
    ,nvl(n.main_card_flag, o.main_card_flag) as main_card_flag -- 主卡标识
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.card_prod_type, o.card_prod_type) as card_prod_type -- 卡产品类型
    ,nvl(n.main_card_no, o.main_card_no) as main_card_no -- 主卡卡号
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.inc_exp_flag, o.inc_exp_flag) as inc_exp_flag -- 以收定支标识，单位结算卡限额用
    ,case when
            n.acct_seq_no is null
            and n.base_acct_no is null
            and n.card_no is null
            and n.prod_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.acct_seq_no is null
            and n.base_acct_no is null
            and n.card_no is null
            and n.prod_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.acct_seq_no is null
            and n.base_acct_no is null
            and n.card_no is null
            and n.prod_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_settle_card_real_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_settle_card_real where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.acct_seq_no = n.acct_seq_no
            and o.base_acct_no = n.base_acct_no
            and o.card_no = n.card_no
            and o.prod_type = n.prod_type
where (
        o.acct_seq_no is null
        and o.base_acct_no is null
        and o.card_no is null
        and o.prod_type is null
    )
    or (
        n.acct_seq_no is null
        and n.base_acct_no is null
        and n.card_no is null
        and n.prod_type is null
    )
    or (
        o.client_no <> n.client_no
        or o.user_id <> n.user_id
        or o.all_dra_ind <> n.all_dra_ind
        or o.auto_collect_flag <> n.auto_collect_flag
        or o.card_tran_flag <> n.card_tran_flag
        or o.card_tranform_flag <> n.card_tranform_flag
        or o.collect_no <> n.collect_no
        or o.collect_order <> n.collect_order
        or o.company <> n.company
        or o.cret_trans_flag <> n.cret_trans_flag
        or o.debt_trans_flag <> n.debt_trans_flag
        or o.default_flag <> n.default_flag
        or o.is_cash_trans <> n.is_cash_trans
        or o.main_card_flag <> n.main_card_flag
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.acct_ccy <> n.acct_ccy
        or o.card_prod_type <> n.card_prod_type
        or o.main_card_no <> n.main_card_no
        or o.tran_branch <> n.tran_branch
        or o.inc_exp_flag <> n.inc_exp_flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_settle_card_real_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,all_dra_ind -- 通兑标志
            ,auto_collect_flag -- 联动扣款标志
            ,card_tran_flag -- 卡片是否停用标志
            ,card_tranform_flag -- 卡内互转标识
            ,collect_no -- 归集顺序号
            ,collect_order -- 自动归集顺序
            ,company -- 法人
            ,cret_trans_flag -- 可存款
            ,debt_trans_flag -- 可转出
            ,default_flag -- 是否默认账号
            ,is_cash_trans -- 可取现
            ,main_card_flag -- 主卡标识
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,card_prod_type -- 卡产品类型
            ,main_card_no -- 主卡卡号
            ,tran_branch -- 核心交易机构编号
            ,inc_exp_flag -- 以收定支标识，单位结算卡限额用
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_settle_card_real_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,all_dra_ind -- 通兑标志
            ,auto_collect_flag -- 联动扣款标志
            ,card_tran_flag -- 卡片是否停用标志
            ,card_tranform_flag -- 卡内互转标识
            ,collect_no -- 归集顺序号
            ,collect_order -- 自动归集顺序
            ,company -- 法人
            ,cret_trans_flag -- 可存款
            ,debt_trans_flag -- 可转出
            ,default_flag -- 是否默认账号
            ,is_cash_trans -- 可取现
            ,main_card_flag -- 主卡标识
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,card_prod_type -- 卡产品类型
            ,main_card_no -- 主卡卡号
            ,tran_branch -- 核心交易机构编号
            ,inc_exp_flag -- 以收定支标识，单位结算卡限额用
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_seq_no -- 账户子账号
    ,o.base_acct_no -- 交易账号/卡号
    ,o.card_no -- 卡号
    ,o.client_no -- 客户编号
    ,o.prod_type -- 产品编号
    ,o.user_id -- 交易柜员编号
    ,o.all_dra_ind -- 通兑标志
    ,o.auto_collect_flag -- 联动扣款标志
    ,o.card_tran_flag -- 卡片是否停用标志
    ,o.card_tranform_flag -- 卡内互转标识
    ,o.collect_no -- 归集顺序号
    ,o.collect_order -- 自动归集顺序
    ,o.company -- 法人
    ,o.cret_trans_flag -- 可存款
    ,o.debt_trans_flag -- 可转出
    ,o.default_flag -- 是否默认账号
    ,o.is_cash_trans -- 可取现
    ,o.main_card_flag -- 主卡标识
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.acct_ccy -- 账户币种
    ,o.card_prod_type -- 卡产品类型
    ,o.main_card_no -- 主卡卡号
    ,o.tran_branch -- 核心交易机构编号
    ,o.inc_exp_flag -- 以收定支标识，单位结算卡限额用
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
from ${iol_schema}.ncbs_rb_settle_card_real_bk o
    left join ${iol_schema}.ncbs_rb_settle_card_real_op n
        on
            o.acct_seq_no = n.acct_seq_no
            and o.base_acct_no = n.base_acct_no
            and o.card_no = n.card_no
            and o.prod_type = n.prod_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_settle_card_real_cl d
        on
            o.acct_seq_no = d.acct_seq_no
            and o.base_acct_no = d.base_acct_no
            and o.card_no = d.card_no
            and o.prod_type = d.prod_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_settle_card_real;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_settle_card_real') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_settle_card_real drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_settle_card_real add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_settle_card_real exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_settle_card_real_cl;
alter table ${iol_schema}.ncbs_rb_settle_card_real exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_settle_card_real_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_settle_card_real to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_settle_card_real_op purge;
drop table ${iol_schema}.ncbs_rb_settle_card_real_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_settle_card_real_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_settle_card_real',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
