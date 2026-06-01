/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_dc_stage_define
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
create table ${iol_schema}.ncbs_rb_dc_stage_define_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_dc_stage_define
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_dc_stage_define_op purge;
drop table ${iol_schema}.ncbs_rb_dc_stage_define_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_dc_stage_define_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_dc_stage_define where 0=1;

create table ${iol_schema}.ncbs_rb_dc_stage_define_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_dc_stage_define where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_dc_stage_define_cl(
            ccy -- 币种
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,auto_settle_flag -- 自动结清标志
            ,back_status -- 额度回收状态
            ,company -- 法人
            ,error_desc -- 错误描述
            ,int_calc_type -- 计息类型
            ,issue_year -- 发行年度
            ,operate_method -- 配额类型
            ,part_withdraw_num -- 部提次数
            ,pay_int_type -- 付息方式
            ,pre_withdraw_flag -- 是否允许提前支取
            ,ration_type -- 配售方式
            ,redemption_flag -- 是否可赎回
            ,reset_int_freq -- 利率重置频率
            ,sale_type -- 销售方式
            ,stage_code -- 期次代码
            ,stage_code_desc -- 期次描述
            ,stage_limit_class -- 额度扣减类型
            ,stage_prod_class -- 期次产品分类
            ,stage_status -- 期次状态
            ,transfer_flag -- 转账标志
            ,issue_end_date -- 发行终止日期
            ,issue_start_date -- 发行起始日期
            ,precontract_end_time -- 预约结束时间
            ,precontract_start_time -- 预约开始时间
            ,sale_end_time -- 止售时间
            ,sale_start_time -- 起售时间
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,distribute_limit -- 已分配额度
            ,get_int_freq -- 取息频率
            ,holding_limit -- 已占用额度
            ,leave_limit -- 剩余额度
            ,stage_max_amt -- 期次最大购买金额
            ,stage_min_amt -- 期次起存金额
            ,stage_remark -- 期次详细备注
            ,total_limit -- 总额度
            ,tran_branch -- 核心交易机构编号
            ,white_sell_flag -- 是否白名单发售
            ,issue_end_time -- 发行终止时间
            ,issue_start_time -- 发行起始时间
            ,allow_buy_way_cd -- 支持组合购买方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_dc_stage_define_op(
            ccy -- 币种
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,auto_settle_flag -- 自动结清标志
            ,back_status -- 额度回收状态
            ,company -- 法人
            ,error_desc -- 错误描述
            ,int_calc_type -- 计息类型
            ,issue_year -- 发行年度
            ,operate_method -- 配额类型
            ,part_withdraw_num -- 部提次数
            ,pay_int_type -- 付息方式
            ,pre_withdraw_flag -- 是否允许提前支取
            ,ration_type -- 配售方式
            ,redemption_flag -- 是否可赎回
            ,reset_int_freq -- 利率重置频率
            ,sale_type -- 销售方式
            ,stage_code -- 期次代码
            ,stage_code_desc -- 期次描述
            ,stage_limit_class -- 额度扣减类型
            ,stage_prod_class -- 期次产品分类
            ,stage_status -- 期次状态
            ,transfer_flag -- 转账标志
            ,issue_end_date -- 发行终止日期
            ,issue_start_date -- 发行起始日期
            ,precontract_end_time -- 预约结束时间
            ,precontract_start_time -- 预约开始时间
            ,sale_end_time -- 止售时间
            ,sale_start_time -- 起售时间
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,distribute_limit -- 已分配额度
            ,get_int_freq -- 取息频率
            ,holding_limit -- 已占用额度
            ,leave_limit -- 剩余额度
            ,stage_max_amt -- 期次最大购买金额
            ,stage_min_amt -- 期次起存金额
            ,stage_remark -- 期次详细备注
            ,total_limit -- 总额度
            ,tran_branch -- 核心交易机构编号
            ,white_sell_flag -- 是否白名单发售
            ,issue_end_time -- 发行终止时间
            ,issue_start_time -- 发行起始时间
            ,allow_buy_way_cd -- 支持组合购买方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.term, o.term) as term -- 存期
    ,nvl(n.term_type, o.term_type) as term_type -- 期限单位
    ,nvl(n.auto_settle_flag, o.auto_settle_flag) as auto_settle_flag -- 自动结清标志
    ,nvl(n.back_status, o.back_status) as back_status -- 额度回收状态
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.error_desc, o.error_desc) as error_desc -- 错误描述
    ,nvl(n.int_calc_type, o.int_calc_type) as int_calc_type -- 计息类型
    ,nvl(n.issue_year, o.issue_year) as issue_year -- 发行年度
    ,nvl(n.operate_method, o.operate_method) as operate_method -- 配额类型
    ,nvl(n.part_withdraw_num, o.part_withdraw_num) as part_withdraw_num -- 部提次数
    ,nvl(n.pay_int_type, o.pay_int_type) as pay_int_type -- 付息方式
    ,nvl(n.pre_withdraw_flag, o.pre_withdraw_flag) as pre_withdraw_flag -- 是否允许提前支取
    ,nvl(n.ration_type, o.ration_type) as ration_type -- 配售方式
    ,nvl(n.redemption_flag, o.redemption_flag) as redemption_flag -- 是否可赎回
    ,nvl(n.reset_int_freq, o.reset_int_freq) as reset_int_freq -- 利率重置频率
    ,nvl(n.sale_type, o.sale_type) as sale_type -- 销售方式
    ,nvl(n.stage_code, o.stage_code) as stage_code -- 期次代码
    ,nvl(n.stage_code_desc, o.stage_code_desc) as stage_code_desc -- 期次描述
    ,nvl(n.stage_limit_class, o.stage_limit_class) as stage_limit_class -- 额度扣减类型
    ,nvl(n.stage_prod_class, o.stage_prod_class) as stage_prod_class -- 期次产品分类
    ,nvl(n.stage_status, o.stage_status) as stage_status -- 期次状态
    ,nvl(n.transfer_flag, o.transfer_flag) as transfer_flag -- 转账标志
    ,nvl(n.issue_end_date, o.issue_end_date) as issue_end_date -- 发行终止日期
    ,nvl(n.issue_start_date, o.issue_start_date) as issue_start_date -- 发行起始日期
    ,nvl(n.precontract_end_time, o.precontract_end_time) as precontract_end_time -- 预约结束时间
    ,nvl(n.precontract_start_time, o.precontract_start_time) as precontract_start_time -- 预约开始时间
    ,nvl(n.sale_end_time, o.sale_end_time) as sale_end_time -- 止售时间
    ,nvl(n.sale_start_time, o.sale_start_time) as sale_start_time -- 起售时间
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.distribute_limit, o.distribute_limit) as distribute_limit -- 已分配额度
    ,nvl(n.get_int_freq, o.get_int_freq) as get_int_freq -- 取息频率
    ,nvl(n.holding_limit, o.holding_limit) as holding_limit -- 已占用额度
    ,nvl(n.leave_limit, o.leave_limit) as leave_limit -- 剩余额度
    ,nvl(n.stage_max_amt, o.stage_max_amt) as stage_max_amt -- 期次最大购买金额
    ,nvl(n.stage_min_amt, o.stage_min_amt) as stage_min_amt -- 期次起存金额
    ,nvl(n.stage_remark, o.stage_remark) as stage_remark -- 期次详细备注
    ,nvl(n.total_limit, o.total_limit) as total_limit -- 总额度
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.white_sell_flag, o.white_sell_flag) as white_sell_flag -- 是否白名单发售
    ,nvl(n.issue_end_time, o.issue_end_time) as issue_end_time -- 发行终止时间
    ,nvl(n.issue_start_time, o.issue_start_time) as issue_start_time -- 发行起始时间
    ,nvl(n.allow_buy_way_cd, o.allow_buy_way_cd) as allow_buy_way_cd -- 支持组合购买方式
    ,case when
            n.stage_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stage_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stage_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_dc_stage_define_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_dc_stage_define where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stage_code = n.stage_code
where (
        o.stage_code is null
    )
    or (
        n.stage_code is null
    )
    or (
        o.ccy <> n.ccy
        or o.prod_type <> n.prod_type
        or o.user_id <> n.user_id
        or o.term <> n.term
        or o.term_type <> n.term_type
        or o.auto_settle_flag <> n.auto_settle_flag
        or o.back_status <> n.back_status
        or o.company <> n.company
        or o.error_desc <> n.error_desc
        or o.int_calc_type <> n.int_calc_type
        or o.issue_year <> n.issue_year
        or o.operate_method <> n.operate_method
        or o.part_withdraw_num <> n.part_withdraw_num
        or o.pay_int_type <> n.pay_int_type
        or o.pre_withdraw_flag <> n.pre_withdraw_flag
        or o.ration_type <> n.ration_type
        or o.redemption_flag <> n.redemption_flag
        or o.reset_int_freq <> n.reset_int_freq
        or o.sale_type <> n.sale_type
        or o.stage_code_desc <> n.stage_code_desc
        or o.stage_limit_class <> n.stage_limit_class
        or o.stage_prod_class <> n.stage_prod_class
        or o.stage_status <> n.stage_status
        or o.transfer_flag <> n.transfer_flag
        or o.issue_end_date <> n.issue_end_date
        or o.issue_start_date <> n.issue_start_date
        or o.precontract_end_time <> n.precontract_end_time
        or o.precontract_start_time <> n.precontract_start_time
        or o.sale_end_time <> n.sale_end_time
        or o.sale_start_time <> n.sale_start_time
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.distribute_limit <> n.distribute_limit
        or o.get_int_freq <> n.get_int_freq
        or o.holding_limit <> n.holding_limit
        or o.leave_limit <> n.leave_limit
        or o.stage_max_amt <> n.stage_max_amt
        or o.stage_min_amt <> n.stage_min_amt
        or o.stage_remark <> n.stage_remark
        or o.total_limit <> n.total_limit
        or o.tran_branch <> n.tran_branch
        or o.white_sell_flag <> n.white_sell_flag
        or o.issue_end_time <> n.issue_end_time
        or o.issue_start_time <> n.issue_start_time
        or o.allow_buy_way_cd <> n.allow_buy_way_cd
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_dc_stage_define_cl(
            ccy -- 币种
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,auto_settle_flag -- 自动结清标志
            ,back_status -- 额度回收状态
            ,company -- 法人
            ,error_desc -- 错误描述
            ,int_calc_type -- 计息类型
            ,issue_year -- 发行年度
            ,operate_method -- 配额类型
            ,part_withdraw_num -- 部提次数
            ,pay_int_type -- 付息方式
            ,pre_withdraw_flag -- 是否允许提前支取
            ,ration_type -- 配售方式
            ,redemption_flag -- 是否可赎回
            ,reset_int_freq -- 利率重置频率
            ,sale_type -- 销售方式
            ,stage_code -- 期次代码
            ,stage_code_desc -- 期次描述
            ,stage_limit_class -- 额度扣减类型
            ,stage_prod_class -- 期次产品分类
            ,stage_status -- 期次状态
            ,transfer_flag -- 转账标志
            ,issue_end_date -- 发行终止日期
            ,issue_start_date -- 发行起始日期
            ,precontract_end_time -- 预约结束时间
            ,precontract_start_time -- 预约开始时间
            ,sale_end_time -- 止售时间
            ,sale_start_time -- 起售时间
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,distribute_limit -- 已分配额度
            ,get_int_freq -- 取息频率
            ,holding_limit -- 已占用额度
            ,leave_limit -- 剩余额度
            ,stage_max_amt -- 期次最大购买金额
            ,stage_min_amt -- 期次起存金额
            ,stage_remark -- 期次详细备注
            ,total_limit -- 总额度
            ,tran_branch -- 核心交易机构编号
            ,white_sell_flag -- 是否白名单发售
            ,issue_end_time -- 发行终止时间
            ,issue_start_time -- 发行起始时间
            ,allow_buy_way_cd -- 支持组合购买方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_dc_stage_define_op(
            ccy -- 币种
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,auto_settle_flag -- 自动结清标志
            ,back_status -- 额度回收状态
            ,company -- 法人
            ,error_desc -- 错误描述
            ,int_calc_type -- 计息类型
            ,issue_year -- 发行年度
            ,operate_method -- 配额类型
            ,part_withdraw_num -- 部提次数
            ,pay_int_type -- 付息方式
            ,pre_withdraw_flag -- 是否允许提前支取
            ,ration_type -- 配售方式
            ,redemption_flag -- 是否可赎回
            ,reset_int_freq -- 利率重置频率
            ,sale_type -- 销售方式
            ,stage_code -- 期次代码
            ,stage_code_desc -- 期次描述
            ,stage_limit_class -- 额度扣减类型
            ,stage_prod_class -- 期次产品分类
            ,stage_status -- 期次状态
            ,transfer_flag -- 转账标志
            ,issue_end_date -- 发行终止日期
            ,issue_start_date -- 发行起始日期
            ,precontract_end_time -- 预约结束时间
            ,precontract_start_time -- 预约开始时间
            ,sale_end_time -- 止售时间
            ,sale_start_time -- 起售时间
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,distribute_limit -- 已分配额度
            ,get_int_freq -- 取息频率
            ,holding_limit -- 已占用额度
            ,leave_limit -- 剩余额度
            ,stage_max_amt -- 期次最大购买金额
            ,stage_min_amt -- 期次起存金额
            ,stage_remark -- 期次详细备注
            ,total_limit -- 总额度
            ,tran_branch -- 核心交易机构编号
            ,white_sell_flag -- 是否白名单发售
            ,issue_end_time -- 发行终止时间
            ,issue_start_time -- 发行起始时间
            ,allow_buy_way_cd -- 支持组合购买方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ccy -- 币种
    ,o.prod_type -- 产品编号
    ,o.user_id -- 交易柜员编号
    ,o.term -- 存期
    ,o.term_type -- 期限单位
    ,o.auto_settle_flag -- 自动结清标志
    ,o.back_status -- 额度回收状态
    ,o.company -- 法人
    ,o.error_desc -- 错误描述
    ,o.int_calc_type -- 计息类型
    ,o.issue_year -- 发行年度
    ,o.operate_method -- 配额类型
    ,o.part_withdraw_num -- 部提次数
    ,o.pay_int_type -- 付息方式
    ,o.pre_withdraw_flag -- 是否允许提前支取
    ,o.ration_type -- 配售方式
    ,o.redemption_flag -- 是否可赎回
    ,o.reset_int_freq -- 利率重置频率
    ,o.sale_type -- 销售方式
    ,o.stage_code -- 期次代码
    ,o.stage_code_desc -- 期次描述
    ,o.stage_limit_class -- 额度扣减类型
    ,o.stage_prod_class -- 期次产品分类
    ,o.stage_status -- 期次状态
    ,o.transfer_flag -- 转账标志
    ,o.issue_end_date -- 发行终止日期
    ,o.issue_start_date -- 发行起始日期
    ,o.precontract_end_time -- 预约结束时间
    ,o.precontract_start_time -- 预约开始时间
    ,o.sale_end_time -- 止售时间
    ,o.sale_start_time -- 起售时间
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.distribute_limit -- 已分配额度
    ,o.get_int_freq -- 取息频率
    ,o.holding_limit -- 已占用额度
    ,o.leave_limit -- 剩余额度
    ,o.stage_max_amt -- 期次最大购买金额
    ,o.stage_min_amt -- 期次起存金额
    ,o.stage_remark -- 期次详细备注
    ,o.total_limit -- 总额度
    ,o.tran_branch -- 核心交易机构编号
    ,o.white_sell_flag -- 是否白名单发售
    ,o.issue_end_time -- 发行终止时间
    ,o.issue_start_time -- 发行起始时间
    ,o.allow_buy_way_cd -- 支持组合购买方式
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
from ${iol_schema}.ncbs_rb_dc_stage_define_bk o
    left join ${iol_schema}.ncbs_rb_dc_stage_define_op n
        on
            o.stage_code = n.stage_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_dc_stage_define_cl d
        on
            o.stage_code = d.stage_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_dc_stage_define;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_dc_stage_define') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_dc_stage_define drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_dc_stage_define add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_dc_stage_define exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_dc_stage_define_cl;
alter table ${iol_schema}.ncbs_rb_dc_stage_define exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_dc_stage_define_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_dc_stage_define to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_dc_stage_define_op purge;
drop table ${iol_schema}.ncbs_rb_dc_stage_define_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_dc_stage_define_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_dc_stage_define',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
