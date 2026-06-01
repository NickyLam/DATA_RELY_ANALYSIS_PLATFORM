/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbsharedtlfund
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
create table ${iol_schema}.ifms_tbsharedtlfund_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbsharedtlfund
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbsharedtlfund_op purge;
drop table ${iol_schema}.ifms_tbsharedtlfund_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbsharedtlfund_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbsharedtlfund where 0=1;

create table ${iol_schema}.ifms_tbsharedtlfund_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbsharedtlfund where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbsharedtlfund_cl(
            comp_date -- 下发日期
            ,in_client_no -- 内部客户号
            ,ta_code -- TA代码
            ,asset_acc -- 理财账户
            ,bank_no -- 银行编号
            ,client_no -- 客户号
            ,bank_acc -- 银行账号
            ,ta_client -- TA账号
            ,prd_code -- 产品代码
            ,vol -- 产品份额
            ,frozen_vol -- 冻结份额
            ,long_frozen_vol -- 长期冻结份额
            ,group_vol -- 组合投资份额
            ,pre_red_date -- 上一可赎回日期
            ,ta_vol -- TA端总份额
            ,ta_available_vol -- TA端可用份额
            ,ta_frozen_vol -- TA端冻结份额
            ,detail_flag -- 明细标志 1
            ,allow_red_date -- 可赎回日期
            ,seller_code -- 销售商代码
            ,branch_no -- 网点代码
            ,serial_no -- 申请流水号
            ,cfm_date -- 确认日期
            ,cfm_no -- 确认流水号
            ,tot_back_fee -- 交易后端收费总额
            ,share_class -- 收费类别
            ,account_status -- 账户状态
            ,register_date -- 份额注册日期
            ,unmonetary_income -- 货币基金未付收益金额
            ,unmonetary_flag -- 货币基金未付收益金额正付
            ,source_flag -- 份额来源 0认购所得 1申购所得 2分红再投所得 3产品转换 4 非交易过户 5-转托管 6-强行调整 7-客户赎回 8 强制赎回 9-对账调整
            ,div_mode -- 默认分红方式 0红利再投 1-现金分红 2-利得现金增值再投资 3-增值现金利得再投资 4-部分再投资 5-赠送
            ,guaranteed_amount -- 剩余保本金额
            ,int1 -- 整型备用1
            ,int2 -- 整型备用2
            ,amt1 -- 金额1
            ,amt2 -- 金额2
            ,reserve1 -- 备用1
            ,reserve2 -- 备用2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbsharedtlfund_op(
            comp_date -- 下发日期
            ,in_client_no -- 内部客户号
            ,ta_code -- TA代码
            ,asset_acc -- 理财账户
            ,bank_no -- 银行编号
            ,client_no -- 客户号
            ,bank_acc -- 银行账号
            ,ta_client -- TA账号
            ,prd_code -- 产品代码
            ,vol -- 产品份额
            ,frozen_vol -- 冻结份额
            ,long_frozen_vol -- 长期冻结份额
            ,group_vol -- 组合投资份额
            ,pre_red_date -- 上一可赎回日期
            ,ta_vol -- TA端总份额
            ,ta_available_vol -- TA端可用份额
            ,ta_frozen_vol -- TA端冻结份额
            ,detail_flag -- 明细标志 1
            ,allow_red_date -- 可赎回日期
            ,seller_code -- 销售商代码
            ,branch_no -- 网点代码
            ,serial_no -- 申请流水号
            ,cfm_date -- 确认日期
            ,cfm_no -- 确认流水号
            ,tot_back_fee -- 交易后端收费总额
            ,share_class -- 收费类别
            ,account_status -- 账户状态
            ,register_date -- 份额注册日期
            ,unmonetary_income -- 货币基金未付收益金额
            ,unmonetary_flag -- 货币基金未付收益金额正付
            ,source_flag -- 份额来源 0认购所得 1申购所得 2分红再投所得 3产品转换 4 非交易过户 5-转托管 6-强行调整 7-客户赎回 8 强制赎回 9-对账调整
            ,div_mode -- 默认分红方式 0红利再投 1-现金分红 2-利得现金增值再投资 3-增值现金利得再投资 4-部分再投资 5-赠送
            ,guaranteed_amount -- 剩余保本金额
            ,int1 -- 整型备用1
            ,int2 -- 整型备用2
            ,amt1 -- 金额1
            ,amt2 -- 金额2
            ,reserve1 -- 备用1
            ,reserve2 -- 备用2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.comp_date, o.comp_date) as comp_date -- 下发日期
    ,nvl(n.in_client_no, o.in_client_no) as in_client_no -- 内部客户号
    ,nvl(n.ta_code, o.ta_code) as ta_code -- TA代码
    ,nvl(n.asset_acc, o.asset_acc) as asset_acc -- 理财账户
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 银行编号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户号
    ,nvl(n.bank_acc, o.bank_acc) as bank_acc -- 银行账号
    ,nvl(n.ta_client, o.ta_client) as ta_client -- TA账号
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 产品代码
    ,nvl(n.vol, o.vol) as vol -- 产品份额
    ,nvl(n.frozen_vol, o.frozen_vol) as frozen_vol -- 冻结份额
    ,nvl(n.long_frozen_vol, o.long_frozen_vol) as long_frozen_vol -- 长期冻结份额
    ,nvl(n.group_vol, o.group_vol) as group_vol -- 组合投资份额
    ,nvl(n.pre_red_date, o.pre_red_date) as pre_red_date -- 上一可赎回日期
    ,nvl(n.ta_vol, o.ta_vol) as ta_vol -- TA端总份额
    ,nvl(n.ta_available_vol, o.ta_available_vol) as ta_available_vol -- TA端可用份额
    ,nvl(n.ta_frozen_vol, o.ta_frozen_vol) as ta_frozen_vol -- TA端冻结份额
    ,nvl(n.detail_flag, o.detail_flag) as detail_flag -- 明细标志 1
    ,nvl(n.allow_red_date, o.allow_red_date) as allow_red_date -- 可赎回日期
    ,nvl(n.seller_code, o.seller_code) as seller_code -- 销售商代码
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 网点代码
    ,nvl(n.serial_no, o.serial_no) as serial_no -- 申请流水号
    ,nvl(n.cfm_date, o.cfm_date) as cfm_date -- 确认日期
    ,nvl(n.cfm_no, o.cfm_no) as cfm_no -- 确认流水号
    ,nvl(n.tot_back_fee, o.tot_back_fee) as tot_back_fee -- 交易后端收费总额
    ,nvl(n.share_class, o.share_class) as share_class -- 收费类别
    ,nvl(n.account_status, o.account_status) as account_status -- 账户状态
    ,nvl(n.register_date, o.register_date) as register_date -- 份额注册日期
    ,nvl(n.unmonetary_income, o.unmonetary_income) as unmonetary_income -- 货币基金未付收益金额
    ,nvl(n.unmonetary_flag, o.unmonetary_flag) as unmonetary_flag -- 货币基金未付收益金额正付
    ,nvl(n.source_flag, o.source_flag) as source_flag -- 份额来源 0认购所得 1申购所得 2分红再投所得 3产品转换 4 非交易过户 5-转托管 6-强行调整 7-客户赎回 8 强制赎回 9-对账调整
    ,nvl(n.div_mode, o.div_mode) as div_mode -- 默认分红方式 0红利再投 1-现金分红 2-利得现金增值再投资 3-增值现金利得再投资 4-部分再投资 5-赠送
    ,nvl(n.guaranteed_amount, o.guaranteed_amount) as guaranteed_amount -- 剩余保本金额
    ,nvl(n.int1, o.int1) as int1 -- 整型备用1
    ,nvl(n.int2, o.int2) as int2 -- 整型备用2
    ,nvl(n.amt1, o.amt1) as amt1 -- 金额1
    ,nvl(n.amt2, o.amt2) as amt2 -- 金额2
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备用1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备用2
    ,case when
            n.ta_client is null
            and n.prd_code is null
            and n.cfm_date is null
            and n.cfm_no is null
            and n.register_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ta_client is null
            and n.prd_code is null
            and n.cfm_date is null
            and n.cfm_no is null
            and n.register_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ta_client is null
            and n.prd_code is null
            and n.cfm_date is null
            and n.cfm_no is null
            and n.register_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbsharedtlfund_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbsharedtlfund where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ta_client = n.ta_client
            and o.prd_code = n.prd_code
            and o.cfm_date = n.cfm_date
            and o.cfm_no = n.cfm_no
            and o.register_date = n.register_date
where (
        o.ta_client is null
        and o.prd_code is null
        and o.cfm_date is null
        and o.cfm_no is null
        and o.register_date is null
    )
    or (
        n.ta_client is null
        and n.prd_code is null
        and n.cfm_date is null
        and n.cfm_no is null
        and n.register_date is null
    )
    or (
        o.comp_date <> n.comp_date
        or o.in_client_no <> n.in_client_no
        or o.ta_code <> n.ta_code
        or o.asset_acc <> n.asset_acc
        or o.bank_no <> n.bank_no
        or o.client_no <> n.client_no
        or o.bank_acc <> n.bank_acc
        or o.vol <> n.vol
        or o.frozen_vol <> n.frozen_vol
        or o.long_frozen_vol <> n.long_frozen_vol
        or o.group_vol <> n.group_vol
        or o.pre_red_date <> n.pre_red_date
        or o.ta_vol <> n.ta_vol
        or o.ta_available_vol <> n.ta_available_vol
        or o.ta_frozen_vol <> n.ta_frozen_vol
        or o.detail_flag <> n.detail_flag
        or o.allow_red_date <> n.allow_red_date
        or o.seller_code <> n.seller_code
        or o.branch_no <> n.branch_no
        or o.serial_no <> n.serial_no
        or o.tot_back_fee <> n.tot_back_fee
        or o.share_class <> n.share_class
        or o.account_status <> n.account_status
        or o.unmonetary_income <> n.unmonetary_income
        or o.unmonetary_flag <> n.unmonetary_flag
        or o.source_flag <> n.source_flag
        or o.div_mode <> n.div_mode
        or o.guaranteed_amount <> n.guaranteed_amount
        or o.int1 <> n.int1
        or o.int2 <> n.int2
        or o.amt1 <> n.amt1
        or o.amt2 <> n.amt2
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbsharedtlfund_cl(
            comp_date -- 下发日期
            ,in_client_no -- 内部客户号
            ,ta_code -- TA代码
            ,asset_acc -- 理财账户
            ,bank_no -- 银行编号
            ,client_no -- 客户号
            ,bank_acc -- 银行账号
            ,ta_client -- TA账号
            ,prd_code -- 产品代码
            ,vol -- 产品份额
            ,frozen_vol -- 冻结份额
            ,long_frozen_vol -- 长期冻结份额
            ,group_vol -- 组合投资份额
            ,pre_red_date -- 上一可赎回日期
            ,ta_vol -- TA端总份额
            ,ta_available_vol -- TA端可用份额
            ,ta_frozen_vol -- TA端冻结份额
            ,detail_flag -- 明细标志 1
            ,allow_red_date -- 可赎回日期
            ,seller_code -- 销售商代码
            ,branch_no -- 网点代码
            ,serial_no -- 申请流水号
            ,cfm_date -- 确认日期
            ,cfm_no -- 确认流水号
            ,tot_back_fee -- 交易后端收费总额
            ,share_class -- 收费类别
            ,account_status -- 账户状态
            ,register_date -- 份额注册日期
            ,unmonetary_income -- 货币基金未付收益金额
            ,unmonetary_flag -- 货币基金未付收益金额正付
            ,source_flag -- 份额来源 0认购所得 1申购所得 2分红再投所得 3产品转换 4 非交易过户 5-转托管 6-强行调整 7-客户赎回 8 强制赎回 9-对账调整
            ,div_mode -- 默认分红方式 0红利再投 1-现金分红 2-利得现金增值再投资 3-增值现金利得再投资 4-部分再投资 5-赠送
            ,guaranteed_amount -- 剩余保本金额
            ,int1 -- 整型备用1
            ,int2 -- 整型备用2
            ,amt1 -- 金额1
            ,amt2 -- 金额2
            ,reserve1 -- 备用1
            ,reserve2 -- 备用2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbsharedtlfund_op(
            comp_date -- 下发日期
            ,in_client_no -- 内部客户号
            ,ta_code -- TA代码
            ,asset_acc -- 理财账户
            ,bank_no -- 银行编号
            ,client_no -- 客户号
            ,bank_acc -- 银行账号
            ,ta_client -- TA账号
            ,prd_code -- 产品代码
            ,vol -- 产品份额
            ,frozen_vol -- 冻结份额
            ,long_frozen_vol -- 长期冻结份额
            ,group_vol -- 组合投资份额
            ,pre_red_date -- 上一可赎回日期
            ,ta_vol -- TA端总份额
            ,ta_available_vol -- TA端可用份额
            ,ta_frozen_vol -- TA端冻结份额
            ,detail_flag -- 明细标志 1
            ,allow_red_date -- 可赎回日期
            ,seller_code -- 销售商代码
            ,branch_no -- 网点代码
            ,serial_no -- 申请流水号
            ,cfm_date -- 确认日期
            ,cfm_no -- 确认流水号
            ,tot_back_fee -- 交易后端收费总额
            ,share_class -- 收费类别
            ,account_status -- 账户状态
            ,register_date -- 份额注册日期
            ,unmonetary_income -- 货币基金未付收益金额
            ,unmonetary_flag -- 货币基金未付收益金额正付
            ,source_flag -- 份额来源 0认购所得 1申购所得 2分红再投所得 3产品转换 4 非交易过户 5-转托管 6-强行调整 7-客户赎回 8 强制赎回 9-对账调整
            ,div_mode -- 默认分红方式 0红利再投 1-现金分红 2-利得现金增值再投资 3-增值现金利得再投资 4-部分再投资 5-赠送
            ,guaranteed_amount -- 剩余保本金额
            ,int1 -- 整型备用1
            ,int2 -- 整型备用2
            ,amt1 -- 金额1
            ,amt2 -- 金额2
            ,reserve1 -- 备用1
            ,reserve2 -- 备用2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.comp_date -- 下发日期
    ,o.in_client_no -- 内部客户号
    ,o.ta_code -- TA代码
    ,o.asset_acc -- 理财账户
    ,o.bank_no -- 银行编号
    ,o.client_no -- 客户号
    ,o.bank_acc -- 银行账号
    ,o.ta_client -- TA账号
    ,o.prd_code -- 产品代码
    ,o.vol -- 产品份额
    ,o.frozen_vol -- 冻结份额
    ,o.long_frozen_vol -- 长期冻结份额
    ,o.group_vol -- 组合投资份额
    ,o.pre_red_date -- 上一可赎回日期
    ,o.ta_vol -- TA端总份额
    ,o.ta_available_vol -- TA端可用份额
    ,o.ta_frozen_vol -- TA端冻结份额
    ,o.detail_flag -- 明细标志 1
    ,o.allow_red_date -- 可赎回日期
    ,o.seller_code -- 销售商代码
    ,o.branch_no -- 网点代码
    ,o.serial_no -- 申请流水号
    ,o.cfm_date -- 确认日期
    ,o.cfm_no -- 确认流水号
    ,o.tot_back_fee -- 交易后端收费总额
    ,o.share_class -- 收费类别
    ,o.account_status -- 账户状态
    ,o.register_date -- 份额注册日期
    ,o.unmonetary_income -- 货币基金未付收益金额
    ,o.unmonetary_flag -- 货币基金未付收益金额正付
    ,o.source_flag -- 份额来源 0认购所得 1申购所得 2分红再投所得 3产品转换 4 非交易过户 5-转托管 6-强行调整 7-客户赎回 8 强制赎回 9-对账调整
    ,o.div_mode -- 默认分红方式 0红利再投 1-现金分红 2-利得现金增值再投资 3-增值现金利得再投资 4-部分再投资 5-赠送
    ,o.guaranteed_amount -- 剩余保本金额
    ,o.int1 -- 整型备用1
    ,o.int2 -- 整型备用2
    ,o.amt1 -- 金额1
    ,o.amt2 -- 金额2
    ,o.reserve1 -- 备用1
    ,o.reserve2 -- 备用2
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
from ${iol_schema}.ifms_tbsharedtlfund_bk o
    left join ${iol_schema}.ifms_tbsharedtlfund_op n
        on
            o.ta_client = n.ta_client
            and o.prd_code = n.prd_code
            and o.cfm_date = n.cfm_date
            and o.cfm_no = n.cfm_no
            and o.register_date = n.register_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbsharedtlfund_cl d
        on
            o.ta_client = d.ta_client
            and o.prd_code = d.prd_code
            and o.cfm_date = d.cfm_date
            and o.cfm_no = d.cfm_no
            and o.register_date = d.register_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ifms_tbsharedtlfund;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ifms_tbsharedtlfund') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ifms_tbsharedtlfund drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ifms_tbsharedtlfund add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ifms_tbsharedtlfund exchange partition p_${batch_date} with table ${iol_schema}.ifms_tbsharedtlfund_cl;
alter table ${iol_schema}.ifms_tbsharedtlfund exchange partition p_20991231 with table ${iol_schema}.ifms_tbsharedtlfund_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbsharedtlfund to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbsharedtlfund_op purge;
drop table ${iol_schema}.ifms_tbsharedtlfund_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbsharedtlfund_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbsharedtlfund',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
