/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_fee_amortize_agr
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
create table ${iol_schema}.ncbs_rb_fee_amortize_agr_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_fee_amortize_agr
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_fee_amortize_agr_op purge;
drop table ${iol_schema}.ncbs_rb_fee_amortize_agr_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_fee_amortize_agr_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_fee_amortize_agr where 0=1;

create table ${iol_schema}.ncbs_rb_fee_amortize_agr_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_fee_amortize_agr where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_fee_amortize_agr_cl(
            client_no -- 客户编号
            ,contract_no -- 合同编号
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,tran_type -- 交易类型
            ,user_id -- 交易柜员编号
            ,agreement_id -- 协议编号
            ,amortize_month -- 摊销月
            ,amortize_name -- 摊销名称
            ,amortize_status -- 摊销状态
            ,amortize_time_type -- 摊销时间类型
            ,amortize_total_cnt -- 摊销总次数
            ,amortized_cnt -- 已摊销次数
            ,bank_seq_no -- 银行交易序号
            ,batch_seq_no -- 批次明细序号
            ,busi_no -- 业务编码
            ,channel_seq_no -- 全局流水号
            ,charge_mode -- 收取标志
            ,company -- 法人
            ,fee_type -- 费率类型
            ,osd_seq_no -- 应收费用序号
            ,remain_amortize_cnt -- 剩余摊销次数
            ,reversal_flag -- 交易是否已冲正
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,effect_date -- 产品生效日期
            ,end_date -- 结束日期
            ,last_amortize_date -- 上一摊销日期
            ,next_amortize_date -- 下一摊销日期
            ,reversal_date -- 冲正日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,amortize_ccy -- 摊销币种
            ,amortize_day -- 摊销日
            ,amortize_period_type -- 摊销期限类型
            ,amortize_total_amt -- 摊销总金额
            ,amortized_amt -- 已摊销金额
            ,auth_user_id -- 授权柜员
            ,remain_amortize_amt -- 剩余摊销金额
            ,reversal_auth_user_id -- 冲正授权柜员
            ,reversal_branch -- 冲正机构
            ,reversal_user_id -- 冲正柜员
            ,tran_branch -- 核心交易机构编号
            ,reaccount_cd -- 对账代码
            ,bus_seq_no -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_fee_amortize_agr_op(
            client_no -- 客户编号
            ,contract_no -- 合同编号
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,tran_type -- 交易类型
            ,user_id -- 交易柜员编号
            ,agreement_id -- 协议编号
            ,amortize_month -- 摊销月
            ,amortize_name -- 摊销名称
            ,amortize_status -- 摊销状态
            ,amortize_time_type -- 摊销时间类型
            ,amortize_total_cnt -- 摊销总次数
            ,amortized_cnt -- 已摊销次数
            ,bank_seq_no -- 银行交易序号
            ,batch_seq_no -- 批次明细序号
            ,busi_no -- 业务编码
            ,channel_seq_no -- 全局流水号
            ,charge_mode -- 收取标志
            ,company -- 法人
            ,fee_type -- 费率类型
            ,osd_seq_no -- 应收费用序号
            ,remain_amortize_cnt -- 剩余摊销次数
            ,reversal_flag -- 交易是否已冲正
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,effect_date -- 产品生效日期
            ,end_date -- 结束日期
            ,last_amortize_date -- 上一摊销日期
            ,next_amortize_date -- 下一摊销日期
            ,reversal_date -- 冲正日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,amortize_ccy -- 摊销币种
            ,amortize_day -- 摊销日
            ,amortize_period_type -- 摊销期限类型
            ,amortize_total_amt -- 摊销总金额
            ,amortized_amt -- 已摊销金额
            ,auth_user_id -- 授权柜员
            ,remain_amortize_amt -- 剩余摊销金额
            ,reversal_auth_user_id -- 冲正授权柜员
            ,reversal_branch -- 冲正机构
            ,reversal_user_id -- 冲正柜员
            ,tran_branch -- 核心交易机构编号
            ,reaccount_cd -- 对账代码
            ,bus_seq_no -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 合同编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.tran_type, o.tran_type) as tran_type -- 交易类型
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.agreement_id, o.agreement_id) as agreement_id -- 协议编号
    ,nvl(n.amortize_month, o.amortize_month) as amortize_month -- 摊销月
    ,nvl(n.amortize_name, o.amortize_name) as amortize_name -- 摊销名称
    ,nvl(n.amortize_status, o.amortize_status) as amortize_status -- 摊销状态
    ,nvl(n.amortize_time_type, o.amortize_time_type) as amortize_time_type -- 摊销时间类型
    ,nvl(n.amortize_total_cnt, o.amortize_total_cnt) as amortize_total_cnt -- 摊销总次数
    ,nvl(n.amortized_cnt, o.amortized_cnt) as amortized_cnt -- 已摊销次数
    ,nvl(n.bank_seq_no, o.bank_seq_no) as bank_seq_no -- 银行交易序号
    ,nvl(n.batch_seq_no, o.batch_seq_no) as batch_seq_no -- 批次明细序号
    ,nvl(n.busi_no, o.busi_no) as busi_no -- 业务编码
    ,nvl(n.channel_seq_no, o.channel_seq_no) as channel_seq_no -- 全局流水号
    ,nvl(n.charge_mode, o.charge_mode) as charge_mode -- 收取标志
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 费率类型
    ,nvl(n.osd_seq_no, o.osd_seq_no) as osd_seq_no -- 应收费用序号
    ,nvl(n.remain_amortize_cnt, o.remain_amortize_cnt) as remain_amortize_cnt -- 剩余摊销次数
    ,nvl(n.reversal_flag, o.reversal_flag) as reversal_flag -- 交易是否已冲正
    ,nvl(n.source_module, o.source_module) as source_module -- 源模块
    ,nvl(n.source_type, o.source_type) as source_type -- 渠道编号
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 产品生效日期
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.last_amortize_date, o.last_amortize_date) as last_amortize_date -- 上一摊销日期
    ,nvl(n.next_amortize_date, o.next_amortize_date) as next_amortize_date -- 下一摊销日期
    ,nvl(n.reversal_date, o.reversal_date) as reversal_date -- 冲正日期
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.amortize_ccy, o.amortize_ccy) as amortize_ccy -- 摊销币种
    ,nvl(n.amortize_day, o.amortize_day) as amortize_day -- 摊销日
    ,nvl(n.amortize_period_type, o.amortize_period_type) as amortize_period_type -- 摊销期限类型
    ,nvl(n.amortize_total_amt, o.amortize_total_amt) as amortize_total_amt -- 摊销总金额
    ,nvl(n.amortized_amt, o.amortized_amt) as amortized_amt -- 已摊销金额
    ,nvl(n.auth_user_id, o.auth_user_id) as auth_user_id -- 授权柜员
    ,nvl(n.remain_amortize_amt, o.remain_amortize_amt) as remain_amortize_amt -- 剩余摊销金额
    ,nvl(n.reversal_auth_user_id, o.reversal_auth_user_id) as reversal_auth_user_id -- 冲正授权柜员
    ,nvl(n.reversal_branch, o.reversal_branch) as reversal_branch -- 冲正机构
    ,nvl(n.reversal_user_id, o.reversal_user_id) as reversal_user_id -- 冲正柜员
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.reaccount_cd, o.reaccount_cd) as reaccount_cd -- 对账代码
    ,nvl(n.bus_seq_no, o.bus_seq_no) as bus_seq_no -- 业务流水号
    ,case when
            n.agreement_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agreement_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agreement_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_fee_amortize_agr_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_fee_amortize_agr where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.agreement_id = n.agreement_id
where (
        o.agreement_id is null
    )
    or (
        n.agreement_id is null
    )
    or (
        o.client_no <> n.client_no
        or o.contract_no <> n.contract_no
        or o.internal_key <> n.internal_key
        or o.reference <> n.reference
        or o.tran_type <> n.tran_type
        or o.user_id <> n.user_id
        or o.amortize_month <> n.amortize_month
        or o.amortize_name <> n.amortize_name
        or o.amortize_status <> n.amortize_status
        or o.amortize_time_type <> n.amortize_time_type
        or o.amortize_total_cnt <> n.amortize_total_cnt
        or o.amortized_cnt <> n.amortized_cnt
        or o.bank_seq_no <> n.bank_seq_no
        or o.batch_seq_no <> n.batch_seq_no
        or o.busi_no <> n.busi_no
        or o.channel_seq_no <> n.channel_seq_no
        or o.charge_mode <> n.charge_mode
        or o.company <> n.company
        or o.fee_type <> n.fee_type
        or o.osd_seq_no <> n.osd_seq_no
        or o.remain_amortize_cnt <> n.remain_amortize_cnt
        or o.reversal_flag <> n.reversal_flag
        or o.source_module <> n.source_module
        or o.source_type <> n.source_type
        or o.effect_date <> n.effect_date
        or o.end_date <> n.end_date
        or o.last_amortize_date <> n.last_amortize_date
        or o.next_amortize_date <> n.next_amortize_date
        or o.reversal_date <> n.reversal_date
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.amortize_ccy <> n.amortize_ccy
        or o.amortize_day <> n.amortize_day
        or o.amortize_period_type <> n.amortize_period_type
        or o.amortize_total_amt <> n.amortize_total_amt
        or o.amortized_amt <> n.amortized_amt
        or o.auth_user_id <> n.auth_user_id
        or o.remain_amortize_amt <> n.remain_amortize_amt
        or o.reversal_auth_user_id <> n.reversal_auth_user_id
        or o.reversal_branch <> n.reversal_branch
        or o.reversal_user_id <> n.reversal_user_id
        or o.tran_branch <> n.tran_branch
        or o.reaccount_cd <> n.reaccount_cd
        or o.bus_seq_no <> n.bus_seq_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_fee_amortize_agr_cl(
            client_no -- 客户编号
            ,contract_no -- 合同编号
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,tran_type -- 交易类型
            ,user_id -- 交易柜员编号
            ,agreement_id -- 协议编号
            ,amortize_month -- 摊销月
            ,amortize_name -- 摊销名称
            ,amortize_status -- 摊销状态
            ,amortize_time_type -- 摊销时间类型
            ,amortize_total_cnt -- 摊销总次数
            ,amortized_cnt -- 已摊销次数
            ,bank_seq_no -- 银行交易序号
            ,batch_seq_no -- 批次明细序号
            ,busi_no -- 业务编码
            ,channel_seq_no -- 全局流水号
            ,charge_mode -- 收取标志
            ,company -- 法人
            ,fee_type -- 费率类型
            ,osd_seq_no -- 应收费用序号
            ,remain_amortize_cnt -- 剩余摊销次数
            ,reversal_flag -- 交易是否已冲正
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,effect_date -- 产品生效日期
            ,end_date -- 结束日期
            ,last_amortize_date -- 上一摊销日期
            ,next_amortize_date -- 下一摊销日期
            ,reversal_date -- 冲正日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,amortize_ccy -- 摊销币种
            ,amortize_day -- 摊销日
            ,amortize_period_type -- 摊销期限类型
            ,amortize_total_amt -- 摊销总金额
            ,amortized_amt -- 已摊销金额
            ,auth_user_id -- 授权柜员
            ,remain_amortize_amt -- 剩余摊销金额
            ,reversal_auth_user_id -- 冲正授权柜员
            ,reversal_branch -- 冲正机构
            ,reversal_user_id -- 冲正柜员
            ,tran_branch -- 核心交易机构编号
            ,reaccount_cd -- 对账代码
            ,bus_seq_no -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_fee_amortize_agr_op(
            client_no -- 客户编号
            ,contract_no -- 合同编号
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,tran_type -- 交易类型
            ,user_id -- 交易柜员编号
            ,agreement_id -- 协议编号
            ,amortize_month -- 摊销月
            ,amortize_name -- 摊销名称
            ,amortize_status -- 摊销状态
            ,amortize_time_type -- 摊销时间类型
            ,amortize_total_cnt -- 摊销总次数
            ,amortized_cnt -- 已摊销次数
            ,bank_seq_no -- 银行交易序号
            ,batch_seq_no -- 批次明细序号
            ,busi_no -- 业务编码
            ,channel_seq_no -- 全局流水号
            ,charge_mode -- 收取标志
            ,company -- 法人
            ,fee_type -- 费率类型
            ,osd_seq_no -- 应收费用序号
            ,remain_amortize_cnt -- 剩余摊销次数
            ,reversal_flag -- 交易是否已冲正
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,effect_date -- 产品生效日期
            ,end_date -- 结束日期
            ,last_amortize_date -- 上一摊销日期
            ,next_amortize_date -- 下一摊销日期
            ,reversal_date -- 冲正日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,amortize_ccy -- 摊销币种
            ,amortize_day -- 摊销日
            ,amortize_period_type -- 摊销期限类型
            ,amortize_total_amt -- 摊销总金额
            ,amortized_amt -- 已摊销金额
            ,auth_user_id -- 授权柜员
            ,remain_amortize_amt -- 剩余摊销金额
            ,reversal_auth_user_id -- 冲正授权柜员
            ,reversal_branch -- 冲正机构
            ,reversal_user_id -- 冲正柜员
            ,tran_branch -- 核心交易机构编号
            ,reaccount_cd -- 对账代码
            ,bus_seq_no -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.contract_no -- 合同编号
    ,o.internal_key -- 账户内部键值
    ,o.reference -- 交易参考号
    ,o.tran_type -- 交易类型
    ,o.user_id -- 交易柜员编号
    ,o.agreement_id -- 协议编号
    ,o.amortize_month -- 摊销月
    ,o.amortize_name -- 摊销名称
    ,o.amortize_status -- 摊销状态
    ,o.amortize_time_type -- 摊销时间类型
    ,o.amortize_total_cnt -- 摊销总次数
    ,o.amortized_cnt -- 已摊销次数
    ,o.bank_seq_no -- 银行交易序号
    ,o.batch_seq_no -- 批次明细序号
    ,o.busi_no -- 业务编码
    ,o.channel_seq_no -- 全局流水号
    ,o.charge_mode -- 收取标志
    ,o.company -- 法人
    ,o.fee_type -- 费率类型
    ,o.osd_seq_no -- 应收费用序号
    ,o.remain_amortize_cnt -- 剩余摊销次数
    ,o.reversal_flag -- 交易是否已冲正
    ,o.source_module -- 源模块
    ,o.source_type -- 渠道编号
    ,o.effect_date -- 产品生效日期
    ,o.end_date -- 结束日期
    ,o.last_amortize_date -- 上一摊销日期
    ,o.next_amortize_date -- 下一摊销日期
    ,o.reversal_date -- 冲正日期
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.amortize_ccy -- 摊销币种
    ,o.amortize_day -- 摊销日
    ,o.amortize_period_type -- 摊销期限类型
    ,o.amortize_total_amt -- 摊销总金额
    ,o.amortized_amt -- 已摊销金额
    ,o.auth_user_id -- 授权柜员
    ,o.remain_amortize_amt -- 剩余摊销金额
    ,o.reversal_auth_user_id -- 冲正授权柜员
    ,o.reversal_branch -- 冲正机构
    ,o.reversal_user_id -- 冲正柜员
    ,o.tran_branch -- 核心交易机构编号
    ,o.reaccount_cd -- 对账代码
    ,o.bus_seq_no -- 业务流水号
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
from ${iol_schema}.ncbs_rb_fee_amortize_agr_bk o
    left join ${iol_schema}.ncbs_rb_fee_amortize_agr_op n
        on
            o.agreement_id = n.agreement_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_fee_amortize_agr_cl d
        on
            o.agreement_id = d.agreement_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_fee_amortize_agr;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_fee_amortize_agr') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_fee_amortize_agr drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_fee_amortize_agr add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_fee_amortize_agr exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_fee_amortize_agr_cl;
alter table ${iol_schema}.ncbs_rb_fee_amortize_agr exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_fee_amortize_agr_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_fee_amortize_agr to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_fee_amortize_agr_op purge;
drop table ${iol_schema}.ncbs_rb_fee_amortize_agr_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_fee_amortize_agr_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_fee_amortize_agr',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
