/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_tran_def
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
create table ${iol_schema}.ncbs_cl_tran_def_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_tran_def
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_tran_def_op purge;
drop table ${iol_schema}.ncbs_cl_tran_def_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_tran_def_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_tran_def where 0=1;

create table ${iol_schema}.ncbs_cl_tran_def_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_tran_def where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_tran_def_cl(
            tran_type -- 交易类型
            ,availbal_calc_type -- 可用余额计算类型
            ,bal_type_priority -- 余额类型次序
            ,balance_flag -- 余额标志
            ,cash_tran_flag -- 现金交易
            ,company -- 法人
            ,correct_flag -- 更正交易
            ,cr_dr_maint_ind -- 借贷标识
            ,is_init_param -- 是否出厂参数
            ,multi_rvs_tran_type_flag -- 多种冲正方式标志
            ,oth_tran_type -- 对方交易类型
            ,print_tran_desc -- 凭证打印交易描述
            ,program_id_group -- 交易类型与交易界面对应关系
            ,recalc_acct_stop_pay_flag -- 重新计算余额止付标志
            ,recalc_res_amt_flag -- 重新计算限制金额标志
            ,res_priority -- 冻结级别
            ,reversal_tran_flag -- 冲正交易标志
            ,reversal_tran_type -- 冲正交易类型
            ,source_type -- 渠道编号
            ,tran_class -- 交易分类
            ,tran_type_desc -- 交易类型描述
            ,libra_op_time -- libra执行次数
            ,tran_timestamp -- 交易时间戳
            ,upd_tailbox_flag -- 尾箱更新标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_tran_def_op(
            tran_type -- 交易类型
            ,availbal_calc_type -- 可用余额计算类型
            ,bal_type_priority -- 余额类型次序
            ,balance_flag -- 余额标志
            ,cash_tran_flag -- 现金交易
            ,company -- 法人
            ,correct_flag -- 更正交易
            ,cr_dr_maint_ind -- 借贷标识
            ,is_init_param -- 是否出厂参数
            ,multi_rvs_tran_type_flag -- 多种冲正方式标志
            ,oth_tran_type -- 对方交易类型
            ,print_tran_desc -- 凭证打印交易描述
            ,program_id_group -- 交易类型与交易界面对应关系
            ,recalc_acct_stop_pay_flag -- 重新计算余额止付标志
            ,recalc_res_amt_flag -- 重新计算限制金额标志
            ,res_priority -- 冻结级别
            ,reversal_tran_flag -- 冲正交易标志
            ,reversal_tran_type -- 冲正交易类型
            ,source_type -- 渠道编号
            ,tran_class -- 交易分类
            ,tran_type_desc -- 交易类型描述
            ,libra_op_time -- libra执行次数
            ,tran_timestamp -- 交易时间戳
            ,upd_tailbox_flag -- 尾箱更新标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tran_type, o.tran_type) as tran_type -- 交易类型
    ,nvl(n.availbal_calc_type, o.availbal_calc_type) as availbal_calc_type -- 可用余额计算类型
    ,nvl(n.bal_type_priority, o.bal_type_priority) as bal_type_priority -- 余额类型次序
    ,nvl(n.balance_flag, o.balance_flag) as balance_flag -- 余额标志
    ,nvl(n.cash_tran_flag, o.cash_tran_flag) as cash_tran_flag -- 现金交易
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.correct_flag, o.correct_flag) as correct_flag -- 更正交易
    ,nvl(n.cr_dr_maint_ind, o.cr_dr_maint_ind) as cr_dr_maint_ind -- 借贷标识
    ,nvl(n.is_init_param, o.is_init_param) as is_init_param -- 是否出厂参数
    ,nvl(n.multi_rvs_tran_type_flag, o.multi_rvs_tran_type_flag) as multi_rvs_tran_type_flag -- 多种冲正方式标志
    ,nvl(n.oth_tran_type, o.oth_tran_type) as oth_tran_type -- 对方交易类型
    ,nvl(n.print_tran_desc, o.print_tran_desc) as print_tran_desc -- 凭证打印交易描述
    ,nvl(n.program_id_group, o.program_id_group) as program_id_group -- 交易类型与交易界面对应关系
    ,nvl(n.recalc_acct_stop_pay_flag, o.recalc_acct_stop_pay_flag) as recalc_acct_stop_pay_flag -- 重新计算余额止付标志
    ,nvl(n.recalc_res_amt_flag, o.recalc_res_amt_flag) as recalc_res_amt_flag -- 重新计算限制金额标志
    ,nvl(n.res_priority, o.res_priority) as res_priority -- 冻结级别
    ,nvl(n.reversal_tran_flag, o.reversal_tran_flag) as reversal_tran_flag -- 冲正交易标志
    ,nvl(n.reversal_tran_type, o.reversal_tran_type) as reversal_tran_type -- 冲正交易类型
    ,nvl(n.source_type, o.source_type) as source_type -- 渠道编号
    ,nvl(n.tran_class, o.tran_class) as tran_class -- 交易分类
    ,nvl(n.tran_type_desc, o.tran_type_desc) as tran_type_desc -- 交易类型描述
    ,nvl(n.libra_op_time, o.libra_op_time) as libra_op_time -- libra执行次数
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.upd_tailbox_flag, o.upd_tailbox_flag) as upd_tailbox_flag -- 尾箱更新标志
    ,case when
            n.tran_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tran_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tran_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_tran_def_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_tran_def where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.tran_type = n.tran_type
where (
        o.tran_type is null
    )
    or (
        n.tran_type is null
    )
    or (
        o.availbal_calc_type <> n.availbal_calc_type
        or o.bal_type_priority <> n.bal_type_priority
        or o.balance_flag <> n.balance_flag
        or o.cash_tran_flag <> n.cash_tran_flag
        or o.company <> n.company
        or o.correct_flag <> n.correct_flag
        or o.cr_dr_maint_ind <> n.cr_dr_maint_ind
        or o.is_init_param <> n.is_init_param
        or o.multi_rvs_tran_type_flag <> n.multi_rvs_tran_type_flag
        or o.oth_tran_type <> n.oth_tran_type
        or o.print_tran_desc <> n.print_tran_desc
        or o.program_id_group <> n.program_id_group
        or o.recalc_acct_stop_pay_flag <> n.recalc_acct_stop_pay_flag
        or o.recalc_res_amt_flag <> n.recalc_res_amt_flag
        or o.res_priority <> n.res_priority
        or o.reversal_tran_flag <> n.reversal_tran_flag
        or o.reversal_tran_type <> n.reversal_tran_type
        or o.source_type <> n.source_type
        or o.tran_class <> n.tran_class
        or o.tran_type_desc <> n.tran_type_desc
        or o.libra_op_time <> n.libra_op_time
        or o.tran_timestamp <> n.tran_timestamp
        or o.upd_tailbox_flag <> n.upd_tailbox_flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_tran_def_cl(
            tran_type -- 交易类型
            ,availbal_calc_type -- 可用余额计算类型
            ,bal_type_priority -- 余额类型次序
            ,balance_flag -- 余额标志
            ,cash_tran_flag -- 现金交易
            ,company -- 法人
            ,correct_flag -- 更正交易
            ,cr_dr_maint_ind -- 借贷标识
            ,is_init_param -- 是否出厂参数
            ,multi_rvs_tran_type_flag -- 多种冲正方式标志
            ,oth_tran_type -- 对方交易类型
            ,print_tran_desc -- 凭证打印交易描述
            ,program_id_group -- 交易类型与交易界面对应关系
            ,recalc_acct_stop_pay_flag -- 重新计算余额止付标志
            ,recalc_res_amt_flag -- 重新计算限制金额标志
            ,res_priority -- 冻结级别
            ,reversal_tran_flag -- 冲正交易标志
            ,reversal_tran_type -- 冲正交易类型
            ,source_type -- 渠道编号
            ,tran_class -- 交易分类
            ,tran_type_desc -- 交易类型描述
            ,libra_op_time -- libra执行次数
            ,tran_timestamp -- 交易时间戳
            ,upd_tailbox_flag -- 尾箱更新标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_tran_def_op(
            tran_type -- 交易类型
            ,availbal_calc_type -- 可用余额计算类型
            ,bal_type_priority -- 余额类型次序
            ,balance_flag -- 余额标志
            ,cash_tran_flag -- 现金交易
            ,company -- 法人
            ,correct_flag -- 更正交易
            ,cr_dr_maint_ind -- 借贷标识
            ,is_init_param -- 是否出厂参数
            ,multi_rvs_tran_type_flag -- 多种冲正方式标志
            ,oth_tran_type -- 对方交易类型
            ,print_tran_desc -- 凭证打印交易描述
            ,program_id_group -- 交易类型与交易界面对应关系
            ,recalc_acct_stop_pay_flag -- 重新计算余额止付标志
            ,recalc_res_amt_flag -- 重新计算限制金额标志
            ,res_priority -- 冻结级别
            ,reversal_tran_flag -- 冲正交易标志
            ,reversal_tran_type -- 冲正交易类型
            ,source_type -- 渠道编号
            ,tran_class -- 交易分类
            ,tran_type_desc -- 交易类型描述
            ,libra_op_time -- libra执行次数
            ,tran_timestamp -- 交易时间戳
            ,upd_tailbox_flag -- 尾箱更新标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tran_type -- 交易类型
    ,o.availbal_calc_type -- 可用余额计算类型
    ,o.bal_type_priority -- 余额类型次序
    ,o.balance_flag -- 余额标志
    ,o.cash_tran_flag -- 现金交易
    ,o.company -- 法人
    ,o.correct_flag -- 更正交易
    ,o.cr_dr_maint_ind -- 借贷标识
    ,o.is_init_param -- 是否出厂参数
    ,o.multi_rvs_tran_type_flag -- 多种冲正方式标志
    ,o.oth_tran_type -- 对方交易类型
    ,o.print_tran_desc -- 凭证打印交易描述
    ,o.program_id_group -- 交易类型与交易界面对应关系
    ,o.recalc_acct_stop_pay_flag -- 重新计算余额止付标志
    ,o.recalc_res_amt_flag -- 重新计算限制金额标志
    ,o.res_priority -- 冻结级别
    ,o.reversal_tran_flag -- 冲正交易标志
    ,o.reversal_tran_type -- 冲正交易类型
    ,o.source_type -- 渠道编号
    ,o.tran_class -- 交易分类
    ,o.tran_type_desc -- 交易类型描述
    ,o.libra_op_time -- libra执行次数
    ,o.tran_timestamp -- 交易时间戳
    ,o.upd_tailbox_flag -- 尾箱更新标志
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
from ${iol_schema}.ncbs_cl_tran_def_bk o
    left join ${iol_schema}.ncbs_cl_tran_def_op n
        on
            o.tran_type = n.tran_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_tran_def_cl d
        on
            o.tran_type = d.tran_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_tran_def;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_tran_def') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_tran_def drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_tran_def add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_tran_def exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_tran_def_cl;
alter table ${iol_schema}.ncbs_cl_tran_def exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_tran_def_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_tran_def to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_tran_def_op purge;
drop table ${iol_schema}.ncbs_cl_tran_def_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_tran_def_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_tran_def',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
