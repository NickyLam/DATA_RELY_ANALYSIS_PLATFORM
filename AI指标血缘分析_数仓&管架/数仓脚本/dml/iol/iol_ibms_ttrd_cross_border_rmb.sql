/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_cross_border_rmb
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
create table ${iol_schema}.ibms_ttrd_cross_border_rmb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_cross_border_rmb
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_cross_border_rmb_op purge;
drop table ${iol_schema}.ibms_ttrd_cross_border_rmb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_cross_border_rmb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_cross_border_rmb where 0=1;

create table ${iol_schema}.ibms_ttrd_cross_border_rmb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_cross_border_rmb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_cross_border_rmb_cl(
            accid -- 账户代码
            ,accname -- 账户名称
            ,exhacc -- 交易所账户（账号）
            ,customer_id -- 客户（交易对手）编码
            ,customer_name -- 客户（交易对手）名称
            ,start_date -- 开始日
            ,mtr_date -- 到期日
            ,interest_acc_mode -- 结息周期
            ,early_end_date -- 提前结束日
            ,is_agree_amount_fixed -- 约定金额是否固定，0：是，1：否
            ,agree_amount -- 约定金额
            ,agree_amount_rate -- 约定金额利率
            ,agree_current_rate -- 约定活期利率
            ,agree_break_contract_rate -- 约定违约利率
            ,contract_no -- 合约号
            ,id -- 唯一标识
            ,is_delete -- 是否删除
            ,first_payment_date -- 首次付息日
            ,break_info_flag -- 是否有违约条款
            ,gear_prod_flag -- 是否支持靠档模式
            ,agree_freq -- 约期结息频率
            ,end_date -- 协议结束日
            ,remark -- 备注
            ,is_monthly_mode -- 是否月均模式
            ,stride_month_rate -- 跨月利率
            ,not_stride_month_rate -- 不跨月利率
            ,stride_month_remark -- 跨月说明
            ,not_stride_month_remark -- 不跨月说明
            ,near_rate_json -- 靠档利率JSON(按余额)
            ,multy_mode -- 多档模式
            ,core_status -- 核心状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_cross_border_rmb_op(
            accid -- 账户代码
            ,accname -- 账户名称
            ,exhacc -- 交易所账户（账号）
            ,customer_id -- 客户（交易对手）编码
            ,customer_name -- 客户（交易对手）名称
            ,start_date -- 开始日
            ,mtr_date -- 到期日
            ,interest_acc_mode -- 结息周期
            ,early_end_date -- 提前结束日
            ,is_agree_amount_fixed -- 约定金额是否固定，0：是，1：否
            ,agree_amount -- 约定金额
            ,agree_amount_rate -- 约定金额利率
            ,agree_current_rate -- 约定活期利率
            ,agree_break_contract_rate -- 约定违约利率
            ,contract_no -- 合约号
            ,id -- 唯一标识
            ,is_delete -- 是否删除
            ,first_payment_date -- 首次付息日
            ,break_info_flag -- 是否有违约条款
            ,gear_prod_flag -- 是否支持靠档模式
            ,agree_freq -- 约期结息频率
            ,end_date -- 协议结束日
            ,remark -- 备注
            ,is_monthly_mode -- 是否月均模式
            ,stride_month_rate -- 跨月利率
            ,not_stride_month_rate -- 不跨月利率
            ,stride_month_remark -- 跨月说明
            ,not_stride_month_remark -- 不跨月说明
            ,near_rate_json -- 靠档利率JSON(按余额)
            ,multy_mode -- 多档模式
            ,core_status -- 核心状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.accid, o.accid) as accid -- 账户代码
    ,nvl(n.accname, o.accname) as accname -- 账户名称
    ,nvl(n.exhacc, o.exhacc) as exhacc -- 交易所账户（账号）
    ,nvl(n.customer_id, o.customer_id) as customer_id -- 客户（交易对手）编码
    ,nvl(n.customer_name, o.customer_name) as customer_name -- 客户（交易对手）名称
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日
    ,nvl(n.mtr_date, o.mtr_date) as mtr_date -- 到期日
    ,nvl(n.interest_acc_mode, o.interest_acc_mode) as interest_acc_mode -- 结息周期
    ,nvl(n.early_end_date, o.early_end_date) as early_end_date -- 提前结束日
    ,nvl(n.is_agree_amount_fixed, o.is_agree_amount_fixed) as is_agree_amount_fixed -- 约定金额是否固定，0：是，1：否
    ,nvl(n.agree_amount, o.agree_amount) as agree_amount -- 约定金额
    ,nvl(n.agree_amount_rate, o.agree_amount_rate) as agree_amount_rate -- 约定金额利率
    ,nvl(n.agree_current_rate, o.agree_current_rate) as agree_current_rate -- 约定活期利率
    ,nvl(n.agree_break_contract_rate, o.agree_break_contract_rate) as agree_break_contract_rate -- 约定违约利率
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 合约号
    ,nvl(n.id, o.id) as id -- 唯一标识
    ,nvl(n.is_delete, o.is_delete) as is_delete -- 是否删除
    ,nvl(n.first_payment_date, o.first_payment_date) as first_payment_date -- 首次付息日
    ,nvl(n.break_info_flag, o.break_info_flag) as break_info_flag -- 是否有违约条款
    ,nvl(n.gear_prod_flag, o.gear_prod_flag) as gear_prod_flag -- 是否支持靠档模式
    ,nvl(n.agree_freq, o.agree_freq) as agree_freq -- 约期结息频率
    ,nvl(n.end_date, o.end_date) as end_date -- 协议结束日
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.is_monthly_mode, o.is_monthly_mode) as is_monthly_mode -- 是否月均模式
    ,nvl(n.stride_month_rate, o.stride_month_rate) as stride_month_rate -- 跨月利率
    ,nvl(n.not_stride_month_rate, o.not_stride_month_rate) as not_stride_month_rate -- 不跨月利率
    ,nvl(n.stride_month_remark, o.stride_month_remark) as stride_month_remark -- 跨月说明
    ,nvl(n.not_stride_month_remark, o.not_stride_month_remark) as not_stride_month_remark -- 不跨月说明
    ,nvl(n.near_rate_json, o.near_rate_json) as near_rate_json -- 靠档利率JSON(按余额)
    ,nvl(n.multy_mode, o.multy_mode) as multy_mode -- 多档模式
    ,nvl(n.core_status, o.core_status) as core_status -- 核心状态
    ,case when
            n.accid is null
            and n.start_date is null
            and n.mtr_date is null
            and n.is_agree_amount_fixed is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.accid is null
            and n.start_date is null
            and n.mtr_date is null
            and n.is_agree_amount_fixed is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.accid is null
            and n.start_date is null
            and n.mtr_date is null
            and n.is_agree_amount_fixed is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_cross_border_rmb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_cross_border_rmb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.accid = n.accid
            and o.start_date = n.start_date
            and o.mtr_date = n.mtr_date
            and o.is_agree_amount_fixed = n.is_agree_amount_fixed
where (
        o.accid is null
        and o.start_date is null
        and o.mtr_date is null
        and o.is_agree_amount_fixed is null
    )
    or (
        n.accid is null
        and n.start_date is null
        and n.mtr_date is null
        and n.is_agree_amount_fixed is null
    )
    or (
        o.accname <> n.accname
        or o.exhacc <> n.exhacc
        or o.customer_id <> n.customer_id
        or o.customer_name <> n.customer_name
        or o.interest_acc_mode <> n.interest_acc_mode
        or o.early_end_date <> n.early_end_date
        or o.agree_amount <> n.agree_amount
        or o.agree_amount_rate <> n.agree_amount_rate
        or o.agree_current_rate <> n.agree_current_rate
        or o.agree_break_contract_rate <> n.agree_break_contract_rate
        or o.contract_no <> n.contract_no
        or o.id <> n.id
        or o.is_delete <> n.is_delete
        or o.first_payment_date <> n.first_payment_date
        or o.break_info_flag <> n.break_info_flag
        or o.gear_prod_flag <> n.gear_prod_flag
        or o.agree_freq <> n.agree_freq
        or o.end_date <> n.end_date
        or o.remark <> n.remark
        or o.is_monthly_mode <> n.is_monthly_mode
        or o.stride_month_rate <> n.stride_month_rate
        or o.not_stride_month_rate <> n.not_stride_month_rate
        or o.stride_month_remark <> n.stride_month_remark
        or o.not_stride_month_remark <> n.not_stride_month_remark
        or o.near_rate_json <> n.near_rate_json
        or o.multy_mode <> n.multy_mode
        or o.core_status <> n.core_status
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_cross_border_rmb_cl(
            accid -- 账户代码
            ,accname -- 账户名称
            ,exhacc -- 交易所账户（账号）
            ,customer_id -- 客户（交易对手）编码
            ,customer_name -- 客户（交易对手）名称
            ,start_date -- 开始日
            ,mtr_date -- 到期日
            ,interest_acc_mode -- 结息周期
            ,early_end_date -- 提前结束日
            ,is_agree_amount_fixed -- 约定金额是否固定，0：是，1：否
            ,agree_amount -- 约定金额
            ,agree_amount_rate -- 约定金额利率
            ,agree_current_rate -- 约定活期利率
            ,agree_break_contract_rate -- 约定违约利率
            ,contract_no -- 合约号
            ,id -- 唯一标识
            ,is_delete -- 是否删除
            ,first_payment_date -- 首次付息日
            ,break_info_flag -- 是否有违约条款
            ,gear_prod_flag -- 是否支持靠档模式
            ,agree_freq -- 约期结息频率
            ,end_date -- 协议结束日
            ,remark -- 备注
            ,is_monthly_mode -- 是否月均模式
            ,stride_month_rate -- 跨月利率
            ,not_stride_month_rate -- 不跨月利率
            ,stride_month_remark -- 跨月说明
            ,not_stride_month_remark -- 不跨月说明
            ,near_rate_json -- 靠档利率JSON(按余额)
            ,multy_mode -- 多档模式
            ,core_status -- 核心状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_cross_border_rmb_op(
            accid -- 账户代码
            ,accname -- 账户名称
            ,exhacc -- 交易所账户（账号）
            ,customer_id -- 客户（交易对手）编码
            ,customer_name -- 客户（交易对手）名称
            ,start_date -- 开始日
            ,mtr_date -- 到期日
            ,interest_acc_mode -- 结息周期
            ,early_end_date -- 提前结束日
            ,is_agree_amount_fixed -- 约定金额是否固定，0：是，1：否
            ,agree_amount -- 约定金额
            ,agree_amount_rate -- 约定金额利率
            ,agree_current_rate -- 约定活期利率
            ,agree_break_contract_rate -- 约定违约利率
            ,contract_no -- 合约号
            ,id -- 唯一标识
            ,is_delete -- 是否删除
            ,first_payment_date -- 首次付息日
            ,break_info_flag -- 是否有违约条款
            ,gear_prod_flag -- 是否支持靠档模式
            ,agree_freq -- 约期结息频率
            ,end_date -- 协议结束日
            ,remark -- 备注
            ,is_monthly_mode -- 是否月均模式
            ,stride_month_rate -- 跨月利率
            ,not_stride_month_rate -- 不跨月利率
            ,stride_month_remark -- 跨月说明
            ,not_stride_month_remark -- 不跨月说明
            ,near_rate_json -- 靠档利率JSON(按余额)
            ,multy_mode -- 多档模式
            ,core_status -- 核心状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.accid -- 账户代码
    ,o.accname -- 账户名称
    ,o.exhacc -- 交易所账户（账号）
    ,o.customer_id -- 客户（交易对手）编码
    ,o.customer_name -- 客户（交易对手）名称
    ,o.start_date -- 开始日
    ,o.mtr_date -- 到期日
    ,o.interest_acc_mode -- 结息周期
    ,o.early_end_date -- 提前结束日
    ,o.is_agree_amount_fixed -- 约定金额是否固定，0：是，1：否
    ,o.agree_amount -- 约定金额
    ,o.agree_amount_rate -- 约定金额利率
    ,o.agree_current_rate -- 约定活期利率
    ,o.agree_break_contract_rate -- 约定违约利率
    ,o.contract_no -- 合约号
    ,o.id -- 唯一标识
    ,o.is_delete -- 是否删除
    ,o.first_payment_date -- 首次付息日
    ,o.break_info_flag -- 是否有违约条款
    ,o.gear_prod_flag -- 是否支持靠档模式
    ,o.agree_freq -- 约期结息频率
    ,o.end_date -- 协议结束日
    ,o.remark -- 备注
    ,o.is_monthly_mode -- 是否月均模式
    ,o.stride_month_rate -- 跨月利率
    ,o.not_stride_month_rate -- 不跨月利率
    ,o.stride_month_remark -- 跨月说明
    ,o.not_stride_month_remark -- 不跨月说明
    ,o.near_rate_json -- 靠档利率JSON(按余额)
    ,o.multy_mode -- 多档模式
    ,o.core_status -- 核心状态
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
from ${iol_schema}.ibms_ttrd_cross_border_rmb_bk o
    left join ${iol_schema}.ibms_ttrd_cross_border_rmb_op n
        on
            o.accid = n.accid
            and o.start_date = n.start_date
            and o.mtr_date = n.mtr_date
            and o.is_agree_amount_fixed = n.is_agree_amount_fixed
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_cross_border_rmb_cl d
        on
            o.accid = d.accid
            and o.start_date = d.start_date
            and o.mtr_date = d.mtr_date
            and o.is_agree_amount_fixed = d.is_agree_amount_fixed
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_ttrd_cross_border_rmb;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_cross_border_rmb') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_cross_border_rmb drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_cross_border_rmb add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_cross_border_rmb exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_cross_border_rmb_cl;
alter table ${iol_schema}.ibms_ttrd_cross_border_rmb exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_cross_border_rmb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_cross_border_rmb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_cross_border_rmb_op purge;
drop table ${iol_schema}.ibms_ttrd_cross_border_rmb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_cross_border_rmb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_cross_border_rmb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
