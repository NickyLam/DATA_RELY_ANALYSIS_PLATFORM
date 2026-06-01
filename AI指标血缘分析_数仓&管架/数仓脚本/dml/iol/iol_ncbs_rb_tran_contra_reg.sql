/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_tran_contra_reg
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
create table ${iol_schema}.ncbs_rb_tran_contra_reg_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_tran_contra_reg
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_tran_contra_reg_op purge;
drop table ${iol_schema}.ncbs_rb_tran_contra_reg_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_tran_contra_reg_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_tran_contra_reg where 0=1;

create table ${iol_schema}.ncbs_rb_tran_contra_reg_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_tran_contra_reg where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_tran_contra_reg_cl(
            seq_no -- 序号
            ,reference -- 交易参考号
            ,channel_seq_no -- 全局流水号
            ,sub_seq_no -- 系统子流水号
            ,oth_real_base_acct_no -- 真实交易对手账号
            ,oth_real_tran_name -- 真实交易对手名称
            ,contra_bank_code -- 交易对手行号
            ,tran_amt -- 交易金额
            ,oth_real_acct_seq_no -- 真实交易对手账户序号
            ,register_seq_no -- 补录子序号
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,source_module -- 源模块|源模块,RB-存款,CL-贷款,GL-总账,ALL-所有
            ,contra_bank_name -- 真实对手行名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_tran_contra_reg_op(
            seq_no -- 序号
            ,reference -- 交易参考号
            ,channel_seq_no -- 全局流水号
            ,sub_seq_no -- 系统子流水号
            ,oth_real_base_acct_no -- 真实交易对手账号
            ,oth_real_tran_name -- 真实交易对手名称
            ,contra_bank_code -- 交易对手行号
            ,tran_amt -- 交易金额
            ,oth_real_acct_seq_no -- 真实交易对手账户序号
            ,register_seq_no -- 补录子序号
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,source_module -- 源模块|源模块,RB-存款,CL-贷款,GL-总账,ALL-所有
            ,contra_bank_name -- 真实对手行名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.channel_seq_no, o.channel_seq_no) as channel_seq_no -- 全局流水号
    ,nvl(n.sub_seq_no, o.sub_seq_no) as sub_seq_no -- 系统子流水号
    ,nvl(n.oth_real_base_acct_no, o.oth_real_base_acct_no) as oth_real_base_acct_no -- 真实交易对手账号
    ,nvl(n.oth_real_tran_name, o.oth_real_tran_name) as oth_real_tran_name -- 真实交易对手名称
    ,nvl(n.contra_bank_code, o.contra_bank_code) as contra_bank_code -- 交易对手行号
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.oth_real_acct_seq_no, o.oth_real_acct_seq_no) as oth_real_acct_seq_no -- 真实交易对手账户序号
    ,nvl(n.register_seq_no, o.register_seq_no) as register_seq_no -- 补录子序号
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.source_module, o.source_module) as source_module -- 源模块|源模块,RB-存款,CL-贷款,GL-总账,ALL-所有
    ,nvl(n.contra_bank_name, o.contra_bank_name) as contra_bank_name -- 真实对手行名
    ,case when
            n.seq_no is null
            and n.reference is null
            and n.register_seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seq_no is null
            and n.reference is null
            and n.register_seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seq_no is null
            and n.reference is null
            and n.register_seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_tran_contra_reg_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_tran_contra_reg where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq_no = n.seq_no
            and o.reference = n.reference
            and o.register_seq_no = n.register_seq_no
where (
        o.seq_no is null
        and o.reference is null
        and o.register_seq_no is null
    )
    or (
        n.seq_no is null
        and n.reference is null
        and n.register_seq_no is null
    )
    or (
        o.channel_seq_no <> n.channel_seq_no
        or o.sub_seq_no <> n.sub_seq_no
        or o.oth_real_base_acct_no <> n.oth_real_base_acct_no
        or o.oth_real_tran_name <> n.oth_real_tran_name
        or o.contra_bank_code <> n.contra_bank_code
        or o.tran_amt <> n.tran_amt
        or o.oth_real_acct_seq_no <> n.oth_real_acct_seq_no
        or o.tran_timestamp <> n.tran_timestamp
        or o.company <> n.company
        or o.source_module <> n.source_module
        or o.contra_bank_name <> n.contra_bank_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_tran_contra_reg_cl(
            seq_no -- 序号
            ,reference -- 交易参考号
            ,channel_seq_no -- 全局流水号
            ,sub_seq_no -- 系统子流水号
            ,oth_real_base_acct_no -- 真实交易对手账号
            ,oth_real_tran_name -- 真实交易对手名称
            ,contra_bank_code -- 交易对手行号
            ,tran_amt -- 交易金额
            ,oth_real_acct_seq_no -- 真实交易对手账户序号
            ,register_seq_no -- 补录子序号
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,source_module -- 源模块|源模块,RB-存款,CL-贷款,GL-总账,ALL-所有
            ,contra_bank_name -- 真实对手行名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_tran_contra_reg_op(
            seq_no -- 序号
            ,reference -- 交易参考号
            ,channel_seq_no -- 全局流水号
            ,sub_seq_no -- 系统子流水号
            ,oth_real_base_acct_no -- 真实交易对手账号
            ,oth_real_tran_name -- 真实交易对手名称
            ,contra_bank_code -- 交易对手行号
            ,tran_amt -- 交易金额
            ,oth_real_acct_seq_no -- 真实交易对手账户序号
            ,register_seq_no -- 补录子序号
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,source_module -- 源模块|源模块,RB-存款,CL-贷款,GL-总账,ALL-所有
            ,contra_bank_name -- 真实对手行名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.seq_no -- 序号
    ,o.reference -- 交易参考号
    ,o.channel_seq_no -- 全局流水号
    ,o.sub_seq_no -- 系统子流水号
    ,o.oth_real_base_acct_no -- 真实交易对手账号
    ,o.oth_real_tran_name -- 真实交易对手名称
    ,o.contra_bank_code -- 交易对手行号
    ,o.tran_amt -- 交易金额
    ,o.oth_real_acct_seq_no -- 真实交易对手账户序号
    ,o.register_seq_no -- 补录子序号
    ,o.tran_timestamp -- 交易时间戳
    ,o.company -- 法人
    ,o.source_module -- 源模块|源模块,RB-存款,CL-贷款,GL-总账,ALL-所有
    ,o.contra_bank_name -- 真实对手行名
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
from ${iol_schema}.ncbs_rb_tran_contra_reg_bk o
    left join ${iol_schema}.ncbs_rb_tran_contra_reg_op n
        on
            o.seq_no = n.seq_no
            and o.reference = n.reference
            and o.register_seq_no = n.register_seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_tran_contra_reg_cl d
        on
            o.seq_no = d.seq_no
            and o.reference = d.reference
            and o.register_seq_no = d.register_seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_tran_contra_reg;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_tran_contra_reg') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_tran_contra_reg drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_tran_contra_reg add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_tran_contra_reg exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_tran_contra_reg_cl;
alter table ${iol_schema}.ncbs_rb_tran_contra_reg exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_tran_contra_reg_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_tran_contra_reg to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_tran_contra_reg_op purge;
drop table ${iol_schema}.ncbs_rb_tran_contra_reg_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_tran_contra_reg_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_tran_contra_reg',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
