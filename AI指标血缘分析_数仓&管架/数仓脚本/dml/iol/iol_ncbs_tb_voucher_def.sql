/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_tb_voucher_def
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
create table ${iol_schema}.ncbs_tb_voucher_def_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_tb_voucher_def
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_voucher_def_op purge;
drop table ${iol_schema}.ncbs_tb_voucher_def_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_voucher_def_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_voucher_def where 0=1;

create table ${iol_schema}.ncbs_tb_voucher_def_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_voucher_def where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_voucher_def_cl(
            doc_type -- 凭证类型
            ,profit_center -- 利润中心
            ,user_id -- 交易柜员编号
            ,allow_cheque_denom_flag -- 有价单证是否固定面额标志
            ,allow_distr_flag -- 允许调拨标志
            ,branch_restraint_flag -- 是否限制机构使用
            ,company -- 法人
            ,deposit_type -- 存款类型
            ,doc_class -- 存款凭证种类
            ,doc_type_desc -- 凭证类型描述
            ,have_number -- 是否有号
            ,in_contral -- 总行入库标志
            ,is_cash_cheque -- 是否现金支票标记
            ,is_cheque_book -- 是否支票标记
            ,other_bank_flag -- 他行标记
            ,prefix_req -- 前缀标志
            ,sale_flag -- 出售类凭证标志
            ,tc_denom_group -- 有价单证固定面额组
            ,use_by_order_flag -- 是否按顺序使用
            ,voucher_approve_status -- 批准状态
            ,voucher_bill_ind -- 凭证票据标识
            ,voucher_length -- 凭证号长度
            ,effect_date -- 产品生效日期
            ,expire_date -- 失效日期
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,appr_user_id -- 复核柜员
            ,commission_vou_lost_days -- 代办人口挂天数
            ,last_change_user_id -- 最后修改柜员
            ,vou_lost_days -- 口挂天数
            ,vou_lost_reissue_days -- 挂失补发天数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_voucher_def_op(
            doc_type -- 凭证类型
            ,profit_center -- 利润中心
            ,user_id -- 交易柜员编号
            ,allow_cheque_denom_flag -- 有价单证是否固定面额标志
            ,allow_distr_flag -- 允许调拨标志
            ,branch_restraint_flag -- 是否限制机构使用
            ,company -- 法人
            ,deposit_type -- 存款类型
            ,doc_class -- 存款凭证种类
            ,doc_type_desc -- 凭证类型描述
            ,have_number -- 是否有号
            ,in_contral -- 总行入库标志
            ,is_cash_cheque -- 是否现金支票标记
            ,is_cheque_book -- 是否支票标记
            ,other_bank_flag -- 他行标记
            ,prefix_req -- 前缀标志
            ,sale_flag -- 出售类凭证标志
            ,tc_denom_group -- 有价单证固定面额组
            ,use_by_order_flag -- 是否按顺序使用
            ,voucher_approve_status -- 批准状态
            ,voucher_bill_ind -- 凭证票据标识
            ,voucher_length -- 凭证号长度
            ,effect_date -- 产品生效日期
            ,expire_date -- 失效日期
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,appr_user_id -- 复核柜员
            ,commission_vou_lost_days -- 代办人口挂天数
            ,last_change_user_id -- 最后修改柜员
            ,vou_lost_days -- 口挂天数
            ,vou_lost_reissue_days -- 挂失补发天数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.doc_type, o.doc_type) as doc_type -- 凭证类型
    ,nvl(n.profit_center, o.profit_center) as profit_center -- 利润中心
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.allow_cheque_denom_flag, o.allow_cheque_denom_flag) as allow_cheque_denom_flag -- 有价单证是否固定面额标志
    ,nvl(n.allow_distr_flag, o.allow_distr_flag) as allow_distr_flag -- 允许调拨标志
    ,nvl(n.branch_restraint_flag, o.branch_restraint_flag) as branch_restraint_flag -- 是否限制机构使用
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.deposit_type, o.deposit_type) as deposit_type -- 存款类型
    ,nvl(n.doc_class, o.doc_class) as doc_class -- 存款凭证种类
    ,nvl(n.doc_type_desc, o.doc_type_desc) as doc_type_desc -- 凭证类型描述
    ,nvl(n.have_number, o.have_number) as have_number -- 是否有号
    ,nvl(n.in_contral, o.in_contral) as in_contral -- 总行入库标志
    ,nvl(n.is_cash_cheque, o.is_cash_cheque) as is_cash_cheque -- 是否现金支票标记
    ,nvl(n.is_cheque_book, o.is_cheque_book) as is_cheque_book -- 是否支票标记
    ,nvl(n.other_bank_flag, o.other_bank_flag) as other_bank_flag -- 他行标记
    ,nvl(n.prefix_req, o.prefix_req) as prefix_req -- 前缀标志
    ,nvl(n.sale_flag, o.sale_flag) as sale_flag -- 出售类凭证标志
    ,nvl(n.tc_denom_group, o.tc_denom_group) as tc_denom_group -- 有价单证固定面额组
    ,nvl(n.use_by_order_flag, o.use_by_order_flag) as use_by_order_flag -- 是否按顺序使用
    ,nvl(n.voucher_approve_status, o.voucher_approve_status) as voucher_approve_status -- 批准状态
    ,nvl(n.voucher_bill_ind, o.voucher_bill_ind) as voucher_bill_ind -- 凭证票据标识
    ,nvl(n.voucher_length, o.voucher_length) as voucher_length -- 凭证号长度
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 产品生效日期
    ,nvl(n.expire_date, o.expire_date) as expire_date -- 失效日期
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.appr_user_id, o.appr_user_id) as appr_user_id -- 复核柜员
    ,nvl(n.commission_vou_lost_days, o.commission_vou_lost_days) as commission_vou_lost_days -- 代办人口挂天数
    ,nvl(n.last_change_user_id, o.last_change_user_id) as last_change_user_id -- 最后修改柜员
    ,nvl(n.vou_lost_days, o.vou_lost_days) as vou_lost_days -- 口挂天数
    ,nvl(n.vou_lost_reissue_days, o.vou_lost_reissue_days) as vou_lost_reissue_days -- 挂失补发天数
    ,case when
            n.doc_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.doc_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.doc_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_tb_voucher_def_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_tb_voucher_def where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.doc_type = n.doc_type
where (
        o.doc_type is null
    )
    or (
        n.doc_type is null
    )
    or (
        o.profit_center <> n.profit_center
        or o.user_id <> n.user_id
        or o.allow_cheque_denom_flag <> n.allow_cheque_denom_flag
        or o.allow_distr_flag <> n.allow_distr_flag
        or o.branch_restraint_flag <> n.branch_restraint_flag
        or o.company <> n.company
        or o.deposit_type <> n.deposit_type
        or o.doc_class <> n.doc_class
        or o.doc_type_desc <> n.doc_type_desc
        or o.have_number <> n.have_number
        or o.in_contral <> n.in_contral
        or o.is_cash_cheque <> n.is_cash_cheque
        or o.is_cheque_book <> n.is_cheque_book
        or o.other_bank_flag <> n.other_bank_flag
        or o.prefix_req <> n.prefix_req
        or o.sale_flag <> n.sale_flag
        or o.tc_denom_group <> n.tc_denom_group
        or o.use_by_order_flag <> n.use_by_order_flag
        or o.voucher_approve_status <> n.voucher_approve_status
        or o.voucher_bill_ind <> n.voucher_bill_ind
        or o.voucher_length <> n.voucher_length
        or o.effect_date <> n.effect_date
        or o.expire_date <> n.expire_date
        or o.last_change_date <> n.last_change_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.appr_user_id <> n.appr_user_id
        or o.commission_vou_lost_days <> n.commission_vou_lost_days
        or o.last_change_user_id <> n.last_change_user_id
        or o.vou_lost_days <> n.vou_lost_days
        or o.vou_lost_reissue_days <> n.vou_lost_reissue_days
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_voucher_def_cl(
            doc_type -- 凭证类型
            ,profit_center -- 利润中心
            ,user_id -- 交易柜员编号
            ,allow_cheque_denom_flag -- 有价单证是否固定面额标志
            ,allow_distr_flag -- 允许调拨标志
            ,branch_restraint_flag -- 是否限制机构使用
            ,company -- 法人
            ,deposit_type -- 存款类型
            ,doc_class -- 存款凭证种类
            ,doc_type_desc -- 凭证类型描述
            ,have_number -- 是否有号
            ,in_contral -- 总行入库标志
            ,is_cash_cheque -- 是否现金支票标记
            ,is_cheque_book -- 是否支票标记
            ,other_bank_flag -- 他行标记
            ,prefix_req -- 前缀标志
            ,sale_flag -- 出售类凭证标志
            ,tc_denom_group -- 有价单证固定面额组
            ,use_by_order_flag -- 是否按顺序使用
            ,voucher_approve_status -- 批准状态
            ,voucher_bill_ind -- 凭证票据标识
            ,voucher_length -- 凭证号长度
            ,effect_date -- 产品生效日期
            ,expire_date -- 失效日期
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,appr_user_id -- 复核柜员
            ,commission_vou_lost_days -- 代办人口挂天数
            ,last_change_user_id -- 最后修改柜员
            ,vou_lost_days -- 口挂天数
            ,vou_lost_reissue_days -- 挂失补发天数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_voucher_def_op(
            doc_type -- 凭证类型
            ,profit_center -- 利润中心
            ,user_id -- 交易柜员编号
            ,allow_cheque_denom_flag -- 有价单证是否固定面额标志
            ,allow_distr_flag -- 允许调拨标志
            ,branch_restraint_flag -- 是否限制机构使用
            ,company -- 法人
            ,deposit_type -- 存款类型
            ,doc_class -- 存款凭证种类
            ,doc_type_desc -- 凭证类型描述
            ,have_number -- 是否有号
            ,in_contral -- 总行入库标志
            ,is_cash_cheque -- 是否现金支票标记
            ,is_cheque_book -- 是否支票标记
            ,other_bank_flag -- 他行标记
            ,prefix_req -- 前缀标志
            ,sale_flag -- 出售类凭证标志
            ,tc_denom_group -- 有价单证固定面额组
            ,use_by_order_flag -- 是否按顺序使用
            ,voucher_approve_status -- 批准状态
            ,voucher_bill_ind -- 凭证票据标识
            ,voucher_length -- 凭证号长度
            ,effect_date -- 产品生效日期
            ,expire_date -- 失效日期
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,appr_user_id -- 复核柜员
            ,commission_vou_lost_days -- 代办人口挂天数
            ,last_change_user_id -- 最后修改柜员
            ,vou_lost_days -- 口挂天数
            ,vou_lost_reissue_days -- 挂失补发天数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.doc_type -- 凭证类型
    ,o.profit_center -- 利润中心
    ,o.user_id -- 交易柜员编号
    ,o.allow_cheque_denom_flag -- 有价单证是否固定面额标志
    ,o.allow_distr_flag -- 允许调拨标志
    ,o.branch_restraint_flag -- 是否限制机构使用
    ,o.company -- 法人
    ,o.deposit_type -- 存款类型
    ,o.doc_class -- 存款凭证种类
    ,o.doc_type_desc -- 凭证类型描述
    ,o.have_number -- 是否有号
    ,o.in_contral -- 总行入库标志
    ,o.is_cash_cheque -- 是否现金支票标记
    ,o.is_cheque_book -- 是否支票标记
    ,o.other_bank_flag -- 他行标记
    ,o.prefix_req -- 前缀标志
    ,o.sale_flag -- 出售类凭证标志
    ,o.tc_denom_group -- 有价单证固定面额组
    ,o.use_by_order_flag -- 是否按顺序使用
    ,o.voucher_approve_status -- 批准状态
    ,o.voucher_bill_ind -- 凭证票据标识
    ,o.voucher_length -- 凭证号长度
    ,o.effect_date -- 产品生效日期
    ,o.expire_date -- 失效日期
    ,o.last_change_date -- 最后修改日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.appr_user_id -- 复核柜员
    ,o.commission_vou_lost_days -- 代办人口挂天数
    ,o.last_change_user_id -- 最后修改柜员
    ,o.vou_lost_days -- 口挂天数
    ,o.vou_lost_reissue_days -- 挂失补发天数
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
from ${iol_schema}.ncbs_tb_voucher_def_bk o
    left join ${iol_schema}.ncbs_tb_voucher_def_op n
        on
            o.doc_type = n.doc_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_tb_voucher_def_cl d
        on
            o.doc_type = d.doc_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_tb_voucher_def;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_tb_voucher_def') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_tb_voucher_def drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_tb_voucher_def add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_tb_voucher_def exchange partition p_${batch_date} with table ${iol_schema}.ncbs_tb_voucher_def_cl;
alter table ${iol_schema}.ncbs_tb_voucher_def exchange partition p_20991231 with table ${iol_schema}.ncbs_tb_voucher_def_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_tb_voucher_def to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_voucher_def_op purge;
drop table ${iol_schema}.ncbs_tb_voucher_def_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_tb_voucher_def_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_tb_voucher_def',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
