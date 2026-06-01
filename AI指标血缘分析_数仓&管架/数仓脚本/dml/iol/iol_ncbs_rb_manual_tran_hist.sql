/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_manual_tran_hist
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
create table ${iol_schema}.ncbs_rb_manual_tran_hist_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_manual_tran_hist
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_manual_tran_hist_op purge;
drop table ${iol_schema}.ncbs_rb_manual_tran_hist_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_manual_tran_hist_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_manual_tran_hist where 0=1;

create table ${iol_schema}.ncbs_rb_manual_tran_hist_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_manual_tran_hist where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_manual_tran_hist_cl(
            business_unit -- 账套
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,gl_code -- 科目代码
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,bank_seq_no -- 银行交易序号
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,cr_dr_ind -- 借贷标志
            ,gl_seq_no -- 总账序号
            ,manual_status -- 记账状态
            ,narrative -- 摘要
            ,reversal -- 是否冲正标志
            ,seq_no -- 序号
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,post_date -- 入账日期
            ,tran_timestamp -- 交易时间戳
            ,value_date -- 记账日期
            ,gl_branch -- 总账机构
            ,gl_ccy -- 总账币种
            ,gl_client_no -- 总账客户号
            ,gl_profit_center -- 总账利润中心
            ,tran_amt -- 交易金额
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_manual_tran_hist_op(
            business_unit -- 账套
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,gl_code -- 科目代码
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,bank_seq_no -- 银行交易序号
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,cr_dr_ind -- 借贷标志
            ,gl_seq_no -- 总账序号
            ,manual_status -- 记账状态
            ,narrative -- 摘要
            ,reversal -- 是否冲正标志
            ,seq_no -- 序号
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,post_date -- 入账日期
            ,tran_timestamp -- 交易时间戳
            ,value_date -- 记账日期
            ,gl_branch -- 总账机构
            ,gl_ccy -- 总账币种
            ,gl_client_no -- 总账客户号
            ,gl_profit_center -- 总账利润中心
            ,tran_amt -- 交易金额
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.business_unit, o.business_unit) as business_unit -- 账套
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.gl_code, o.gl_code) as gl_code -- 科目代码
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.bank_seq_no, o.bank_seq_no) as bank_seq_no -- 银行交易序号
    ,nvl(n.channel_seq_no, o.channel_seq_no) as channel_seq_no -- 全局流水号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.cr_dr_ind, o.cr_dr_ind) as cr_dr_ind -- 借贷标志
    ,nvl(n.gl_seq_no, o.gl_seq_no) as gl_seq_no -- 总账序号
    ,nvl(n.manual_status, o.manual_status) as manual_status -- 记账状态
    ,nvl(n.narrative, o.narrative) as narrative -- 摘要
    ,nvl(n.reversal, o.reversal) as reversal -- 是否冲正标志
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.source_module, o.source_module) as source_module -- 源模块
    ,nvl(n.source_type, o.source_type) as source_type -- 渠道编号
    ,nvl(n.post_date, o.post_date) as post_date -- 入账日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.value_date, o.value_date) as value_date -- 记账日期
    ,nvl(n.gl_branch, o.gl_branch) as gl_branch -- 总账机构
    ,nvl(n.gl_ccy, o.gl_ccy) as gl_ccy -- 总账币种
    ,nvl(n.gl_client_no, o.gl_client_no) as gl_client_no -- 总账客户号
    ,nvl(n.gl_profit_center, o.gl_profit_center) as gl_profit_center -- 总账利润中心
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,case when
            n.seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_manual_tran_hist_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_manual_tran_hist where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq_no = n.seq_no
where (
        o.seq_no is null
    )
    or (
        n.seq_no is null
    )
    or (
        o.business_unit <> n.business_unit
        or o.ccy <> n.ccy
        or o.client_no <> n.client_no
        or o.gl_code <> n.gl_code
        or o.reference <> n.reference
        or o.user_id <> n.user_id
        or o.bank_seq_no <> n.bank_seq_no
        or o.channel_seq_no <> n.channel_seq_no
        or o.company <> n.company
        or o.cr_dr_ind <> n.cr_dr_ind
        or o.gl_seq_no <> n.gl_seq_no
        or o.manual_status <> n.manual_status
        or o.narrative <> n.narrative
        or o.reversal <> n.reversal
        or o.source_module <> n.source_module
        or o.source_type <> n.source_type
        or o.post_date <> n.post_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.value_date <> n.value_date
        or o.gl_branch <> n.gl_branch
        or o.gl_ccy <> n.gl_ccy
        or o.gl_client_no <> n.gl_client_no
        or o.gl_profit_center <> n.gl_profit_center
        or o.tran_amt <> n.tran_amt
        or o.tran_branch <> n.tran_branch
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_manual_tran_hist_cl(
            business_unit -- 账套
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,gl_code -- 科目代码
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,bank_seq_no -- 银行交易序号
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,cr_dr_ind -- 借贷标志
            ,gl_seq_no -- 总账序号
            ,manual_status -- 记账状态
            ,narrative -- 摘要
            ,reversal -- 是否冲正标志
            ,seq_no -- 序号
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,post_date -- 入账日期
            ,tran_timestamp -- 交易时间戳
            ,value_date -- 记账日期
            ,gl_branch -- 总账机构
            ,gl_ccy -- 总账币种
            ,gl_client_no -- 总账客户号
            ,gl_profit_center -- 总账利润中心
            ,tran_amt -- 交易金额
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_manual_tran_hist_op(
            business_unit -- 账套
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,gl_code -- 科目代码
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,bank_seq_no -- 银行交易序号
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,cr_dr_ind -- 借贷标志
            ,gl_seq_no -- 总账序号
            ,manual_status -- 记账状态
            ,narrative -- 摘要
            ,reversal -- 是否冲正标志
            ,seq_no -- 序号
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,post_date -- 入账日期
            ,tran_timestamp -- 交易时间戳
            ,value_date -- 记账日期
            ,gl_branch -- 总账机构
            ,gl_ccy -- 总账币种
            ,gl_client_no -- 总账客户号
            ,gl_profit_center -- 总账利润中心
            ,tran_amt -- 交易金额
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.business_unit -- 账套
    ,o.ccy -- 币种
    ,o.client_no -- 客户编号
    ,o.gl_code -- 科目代码
    ,o.reference -- 交易参考号
    ,o.user_id -- 交易柜员编号
    ,o.bank_seq_no -- 银行交易序号
    ,o.channel_seq_no -- 全局流水号
    ,o.company -- 法人
    ,o.cr_dr_ind -- 借贷标志
    ,o.gl_seq_no -- 总账序号
    ,o.manual_status -- 记账状态
    ,o.narrative -- 摘要
    ,o.reversal -- 是否冲正标志
    ,o.seq_no -- 序号
    ,o.source_module -- 源模块
    ,o.source_type -- 渠道编号
    ,o.post_date -- 入账日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.value_date -- 记账日期
    ,o.gl_branch -- 总账机构
    ,o.gl_ccy -- 总账币种
    ,o.gl_client_no -- 总账客户号
    ,o.gl_profit_center -- 总账利润中心
    ,o.tran_amt -- 交易金额
    ,o.tran_branch -- 核心交易机构编号
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
from ${iol_schema}.ncbs_rb_manual_tran_hist_bk o
    left join ${iol_schema}.ncbs_rb_manual_tran_hist_op n
        on
            o.seq_no = n.seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_manual_tran_hist_cl d
        on
            o.seq_no = d.seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_manual_tran_hist;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_manual_tran_hist') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_manual_tran_hist drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_manual_tran_hist add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_manual_tran_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_manual_tran_hist_cl;
alter table ${iol_schema}.ncbs_rb_manual_tran_hist exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_manual_tran_hist_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_manual_tran_hist to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_manual_tran_hist_op purge;
drop table ${iol_schema}.ncbs_rb_manual_tran_hist_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_manual_tran_hist_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_manual_tran_hist',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
