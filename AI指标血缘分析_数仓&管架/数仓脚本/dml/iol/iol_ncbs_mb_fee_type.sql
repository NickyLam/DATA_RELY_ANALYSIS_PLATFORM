/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_mb_fee_type
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
create table ${iol_schema}.ncbs_mb_fee_type_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_mb_fee_type
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_mb_fee_type_op purge;
drop table ${iol_schema}.ncbs_mb_fee_type_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_fee_type_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_mb_fee_type where 0=1;

create table ${iol_schema}.ncbs_mb_fee_type_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_mb_fee_type where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_mb_fee_type_cl(
            amortize_month -- 摊销月
            ,amortize_time_type -- 摊销时间类型
            ,bo_ind -- 日终/联机标志
            ,boundary_amt_id -- 缺口计算金额编码
            ,boundary_desc -- 缺口描述
            ,ccy_flag -- 收费币种标识
            ,company -- 法人
            ,convert_flag -- 折算标志
            ,disc_type -- 折扣类型
            ,fee_amt_id -- 费用计算金额编码
            ,fee_desc -- 费用类型描述
            ,fee_item -- 费用项目代码
            ,fee_mode -- 收费定价方式
            ,fee_type -- 费率类型
            ,prod_grp -- 产品组
            ,profit_allot_flag -- 是否需要分润
            ,profit_amortize_flag -- 是否需要摊销
            ,tax_type -- 税种
            ,tran_timestamp -- 交易时间戳
            ,amortize_day -- 摊销日
            ,amortize_period_type -- 摊销期限类型
            ,mb_ccy_type -- 目标收费币种
            ,open_branch_percent -- 账户行比例
            ,tran_branch_percent -- 交易行比例,记录百分数
            ,accr_flag -- 是否需要计提
            ,fee_price_standard -- 
            ,fee_standard_discount_remark -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_mb_fee_type_op(
            amortize_month -- 摊销月
            ,amortize_time_type -- 摊销时间类型
            ,bo_ind -- 日终/联机标志
            ,boundary_amt_id -- 缺口计算金额编码
            ,boundary_desc -- 缺口描述
            ,ccy_flag -- 收费币种标识
            ,company -- 法人
            ,convert_flag -- 折算标志
            ,disc_type -- 折扣类型
            ,fee_amt_id -- 费用计算金额编码
            ,fee_desc -- 费用类型描述
            ,fee_item -- 费用项目代码
            ,fee_mode -- 收费定价方式
            ,fee_type -- 费率类型
            ,prod_grp -- 产品组
            ,profit_allot_flag -- 是否需要分润
            ,profit_amortize_flag -- 是否需要摊销
            ,tax_type -- 税种
            ,tran_timestamp -- 交易时间戳
            ,amortize_day -- 摊销日
            ,amortize_period_type -- 摊销期限类型
            ,mb_ccy_type -- 目标收费币种
            ,open_branch_percent -- 账户行比例
            ,tran_branch_percent -- 交易行比例,记录百分数
            ,accr_flag -- 是否需要计提
            ,fee_price_standard -- 
            ,fee_standard_discount_remark -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.amortize_month, o.amortize_month) as amortize_month -- 摊销月
    ,nvl(n.amortize_time_type, o.amortize_time_type) as amortize_time_type -- 摊销时间类型
    ,nvl(n.bo_ind, o.bo_ind) as bo_ind -- 日终/联机标志
    ,nvl(n.boundary_amt_id, o.boundary_amt_id) as boundary_amt_id -- 缺口计算金额编码
    ,nvl(n.boundary_desc, o.boundary_desc) as boundary_desc -- 缺口描述
    ,nvl(n.ccy_flag, o.ccy_flag) as ccy_flag -- 收费币种标识
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.convert_flag, o.convert_flag) as convert_flag -- 折算标志
    ,nvl(n.disc_type, o.disc_type) as disc_type -- 折扣类型
    ,nvl(n.fee_amt_id, o.fee_amt_id) as fee_amt_id -- 费用计算金额编码
    ,nvl(n.fee_desc, o.fee_desc) as fee_desc -- 费用类型描述
    ,nvl(n.fee_item, o.fee_item) as fee_item -- 费用项目代码
    ,nvl(n.fee_mode, o.fee_mode) as fee_mode -- 收费定价方式
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 费率类型
    ,nvl(n.prod_grp, o.prod_grp) as prod_grp -- 产品组
    ,nvl(n.profit_allot_flag, o.profit_allot_flag) as profit_allot_flag -- 是否需要分润
    ,nvl(n.profit_amortize_flag, o.profit_amortize_flag) as profit_amortize_flag -- 是否需要摊销
    ,nvl(n.tax_type, o.tax_type) as tax_type -- 税种
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.amortize_day, o.amortize_day) as amortize_day -- 摊销日
    ,nvl(n.amortize_period_type, o.amortize_period_type) as amortize_period_type -- 摊销期限类型
    ,nvl(n.mb_ccy_type, o.mb_ccy_type) as mb_ccy_type -- 目标收费币种
    ,nvl(n.open_branch_percent, o.open_branch_percent) as open_branch_percent -- 账户行比例
    ,nvl(n.tran_branch_percent, o.tran_branch_percent) as tran_branch_percent -- 交易行比例,记录百分数
    ,nvl(n.accr_flag, o.accr_flag) as accr_flag -- 是否需要计提
    ,nvl(n.fee_price_standard, o.fee_price_standard) as fee_price_standard -- 
    ,nvl(n.fee_standard_discount_remark, o.fee_standard_discount_remark) as fee_standard_discount_remark -- 
    ,case when
            n.fee_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.fee_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.fee_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_mb_fee_type_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_mb_fee_type where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.fee_type = n.fee_type
where (
        o.fee_type is null
    )
    or (
        n.fee_type is null
    )
    or (
        o.amortize_month <> n.amortize_month
        or o.amortize_time_type <> n.amortize_time_type
        or o.bo_ind <> n.bo_ind
        or o.boundary_amt_id <> n.boundary_amt_id
        or o.boundary_desc <> n.boundary_desc
        or o.ccy_flag <> n.ccy_flag
        or o.company <> n.company
        or o.convert_flag <> n.convert_flag
        or o.disc_type <> n.disc_type
        or o.fee_amt_id <> n.fee_amt_id
        or o.fee_desc <> n.fee_desc
        or o.fee_item <> n.fee_item
        or o.fee_mode <> n.fee_mode
        or o.prod_grp <> n.prod_grp
        or o.profit_allot_flag <> n.profit_allot_flag
        or o.profit_amortize_flag <> n.profit_amortize_flag
        or o.tax_type <> n.tax_type
        or o.tran_timestamp <> n.tran_timestamp
        or o.amortize_day <> n.amortize_day
        or o.amortize_period_type <> n.amortize_period_type
        or o.mb_ccy_type <> n.mb_ccy_type
        or o.open_branch_percent <> n.open_branch_percent
        or o.tran_branch_percent <> n.tran_branch_percent
        or o.accr_flag <> n.accr_flag
        or o.fee_price_standard <> n.fee_price_standard
        or o.fee_standard_discount_remark <> n.fee_standard_discount_remark
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_mb_fee_type_cl(
            amortize_month -- 摊销月
            ,amortize_time_type -- 摊销时间类型
            ,bo_ind -- 日终/联机标志
            ,boundary_amt_id -- 缺口计算金额编码
            ,boundary_desc -- 缺口描述
            ,ccy_flag -- 收费币种标识
            ,company -- 法人
            ,convert_flag -- 折算标志
            ,disc_type -- 折扣类型
            ,fee_amt_id -- 费用计算金额编码
            ,fee_desc -- 费用类型描述
            ,fee_item -- 费用项目代码
            ,fee_mode -- 收费定价方式
            ,fee_type -- 费率类型
            ,prod_grp -- 产品组
            ,profit_allot_flag -- 是否需要分润
            ,profit_amortize_flag -- 是否需要摊销
            ,tax_type -- 税种
            ,tran_timestamp -- 交易时间戳
            ,amortize_day -- 摊销日
            ,amortize_period_type -- 摊销期限类型
            ,mb_ccy_type -- 目标收费币种
            ,open_branch_percent -- 账户行比例
            ,tran_branch_percent -- 交易行比例,记录百分数
            ,accr_flag -- 是否需要计提
            ,fee_price_standard -- 
            ,fee_standard_discount_remark -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_mb_fee_type_op(
            amortize_month -- 摊销月
            ,amortize_time_type -- 摊销时间类型
            ,bo_ind -- 日终/联机标志
            ,boundary_amt_id -- 缺口计算金额编码
            ,boundary_desc -- 缺口描述
            ,ccy_flag -- 收费币种标识
            ,company -- 法人
            ,convert_flag -- 折算标志
            ,disc_type -- 折扣类型
            ,fee_amt_id -- 费用计算金额编码
            ,fee_desc -- 费用类型描述
            ,fee_item -- 费用项目代码
            ,fee_mode -- 收费定价方式
            ,fee_type -- 费率类型
            ,prod_grp -- 产品组
            ,profit_allot_flag -- 是否需要分润
            ,profit_amortize_flag -- 是否需要摊销
            ,tax_type -- 税种
            ,tran_timestamp -- 交易时间戳
            ,amortize_day -- 摊销日
            ,amortize_period_type -- 摊销期限类型
            ,mb_ccy_type -- 目标收费币种
            ,open_branch_percent -- 账户行比例
            ,tran_branch_percent -- 交易行比例,记录百分数
            ,accr_flag -- 是否需要计提
            ,fee_price_standard -- 
            ,fee_standard_discount_remark -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.amortize_month -- 摊销月
    ,o.amortize_time_type -- 摊销时间类型
    ,o.bo_ind -- 日终/联机标志
    ,o.boundary_amt_id -- 缺口计算金额编码
    ,o.boundary_desc -- 缺口描述
    ,o.ccy_flag -- 收费币种标识
    ,o.company -- 法人
    ,o.convert_flag -- 折算标志
    ,o.disc_type -- 折扣类型
    ,o.fee_amt_id -- 费用计算金额编码
    ,o.fee_desc -- 费用类型描述
    ,o.fee_item -- 费用项目代码
    ,o.fee_mode -- 收费定价方式
    ,o.fee_type -- 费率类型
    ,o.prod_grp -- 产品组
    ,o.profit_allot_flag -- 是否需要分润
    ,o.profit_amortize_flag -- 是否需要摊销
    ,o.tax_type -- 税种
    ,o.tran_timestamp -- 交易时间戳
    ,o.amortize_day -- 摊销日
    ,o.amortize_period_type -- 摊销期限类型
    ,o.mb_ccy_type -- 目标收费币种
    ,o.open_branch_percent -- 账户行比例
    ,o.tran_branch_percent -- 交易行比例,记录百分数
    ,o.accr_flag -- 是否需要计提
    ,o.fee_price_standard -- 
    ,o.fee_standard_discount_remark -- 
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
from ${iol_schema}.ncbs_mb_fee_type_bk o
    left join ${iol_schema}.ncbs_mb_fee_type_op n
        on
            o.fee_type = n.fee_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_mb_fee_type_cl d
        on
            o.fee_type = d.fee_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_mb_fee_type;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_mb_fee_type') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_mb_fee_type drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_mb_fee_type add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_mb_fee_type exchange partition p_${batch_date} with table ${iol_schema}.ncbs_mb_fee_type_cl;
alter table ${iol_schema}.ncbs_mb_fee_type exchange partition p_20991231 with table ${iol_schema}.ncbs_mb_fee_type_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_mb_fee_type to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_mb_fee_type_op purge;
drop table ${iol_schema}.ncbs_mb_fee_type_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_mb_fee_type_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_mb_fee_type',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
