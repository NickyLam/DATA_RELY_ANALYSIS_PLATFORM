/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_transfer_contract
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
create table ${iol_schema}.ncbs_cl_transfer_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_transfer_contract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_transfer_contract_op purge;
drop table ${iol_schema}.ncbs_cl_transfer_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_transfer_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_transfer_contract where 0=1;

create table ${iol_schema}.ncbs_cl_transfer_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_transfer_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_transfer_contract_cl(
            ccy -- 币种
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,appr_flag -- 复核标志
            ,company -- 法人
            ,narrative -- 摘要
            ,last_change_date -- 最后修改日期
            ,pack_date -- 资产证券化封包日期
            ,redeem_date -- 资产赎回日期
            ,redeem_int_date -- 赎回起息日期
            ,sale_date -- 重空出票日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,appr_user_id -- 复核柜员
            ,tran_branch -- 核心交易机构编号
            ,profit_loss_calc_method -- 损益计算方式
            ,amortized_int -- 已摊销利息
            ,asset_transfer_type -- 资产包转让类型
            ,asset_contract_id -- 资产证券化资产包编号
            ,asset_contract_type -- 资产包合同类型
            ,asset_contract_no -- 资产包合同号
            ,sale_tran_timestamp -- 发行交易时间戳
            ,asset_int_flag -- 资产证券化利息拆分标识
            ,sale_cancel_date -- 资产发行撤销日期
            ,asset_contract_amt -- 资产包金额
            ,pack_tran_timestamp -- 封包交易时间戳
            ,sale_float_amount -- 发行折溢价
            ,asset_contract_status -- 资产包合同状态
            ,asset_contract_name -- 资产证券化资产包名称
            ,asset_odi_flag -- 资产证券化复利转出标识
            ,asset_odp_flag -- 资产证券化罚息转出标识
            ,pack_cancel_date -- 撤包日期
            ,asset_contract_seq_no -- 资产包合同序号
            ,redeem_float_amount -- 赎回折溢价
            ,is_bad -- 资产证券化合同表
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_transfer_contract_op(
            ccy -- 币种
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,appr_flag -- 复核标志
            ,company -- 法人
            ,narrative -- 摘要
            ,last_change_date -- 最后修改日期
            ,pack_date -- 资产证券化封包日期
            ,redeem_date -- 资产赎回日期
            ,redeem_int_date -- 赎回起息日期
            ,sale_date -- 重空出票日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,appr_user_id -- 复核柜员
            ,tran_branch -- 核心交易机构编号
            ,profit_loss_calc_method -- 损益计算方式
            ,amortized_int -- 已摊销利息
            ,asset_transfer_type -- 资产包转让类型
            ,asset_contract_id -- 资产证券化资产包编号
            ,asset_contract_type -- 资产包合同类型
            ,asset_contract_no -- 资产包合同号
            ,sale_tran_timestamp -- 发行交易时间戳
            ,asset_int_flag -- 资产证券化利息拆分标识
            ,sale_cancel_date -- 资产发行撤销日期
            ,asset_contract_amt -- 资产包金额
            ,pack_tran_timestamp -- 封包交易时间戳
            ,sale_float_amount -- 发行折溢价
            ,asset_contract_status -- 资产包合同状态
            ,asset_contract_name -- 资产证券化资产包名称
            ,asset_odi_flag -- 资产证券化复利转出标识
            ,asset_odp_flag -- 资产证券化罚息转出标识
            ,pack_cancel_date -- 撤包日期
            ,asset_contract_seq_no -- 资产包合同序号
            ,redeem_float_amount -- 赎回折溢价
            ,is_bad -- 资产证券化合同表
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.appr_flag, o.appr_flag) as appr_flag -- 复核标志
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.narrative, o.narrative) as narrative -- 摘要
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.pack_date, o.pack_date) as pack_date -- 资产证券化封包日期
    ,nvl(n.redeem_date, o.redeem_date) as redeem_date -- 资产赎回日期
    ,nvl(n.redeem_int_date, o.redeem_int_date) as redeem_int_date -- 赎回起息日期
    ,nvl(n.sale_date, o.sale_date) as sale_date -- 重空出票日期
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.appr_user_id, o.appr_user_id) as appr_user_id -- 复核柜员
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.profit_loss_calc_method, o.profit_loss_calc_method) as profit_loss_calc_method -- 损益计算方式
    ,nvl(n.amortized_int, o.amortized_int) as amortized_int -- 已摊销利息
    ,nvl(n.asset_transfer_type, o.asset_transfer_type) as asset_transfer_type -- 资产包转让类型
    ,nvl(n.asset_contract_id, o.asset_contract_id) as asset_contract_id -- 资产证券化资产包编号
    ,nvl(n.asset_contract_type, o.asset_contract_type) as asset_contract_type -- 资产包合同类型
    ,nvl(n.asset_contract_no, o.asset_contract_no) as asset_contract_no -- 资产包合同号
    ,nvl(n.sale_tran_timestamp, o.sale_tran_timestamp) as sale_tran_timestamp -- 发行交易时间戳
    ,nvl(n.asset_int_flag, o.asset_int_flag) as asset_int_flag -- 资产证券化利息拆分标识
    ,nvl(n.sale_cancel_date, o.sale_cancel_date) as sale_cancel_date -- 资产发行撤销日期
    ,nvl(n.asset_contract_amt, o.asset_contract_amt) as asset_contract_amt -- 资产包金额
    ,nvl(n.pack_tran_timestamp, o.pack_tran_timestamp) as pack_tran_timestamp -- 封包交易时间戳
    ,nvl(n.sale_float_amount, o.sale_float_amount) as sale_float_amount -- 发行折溢价
    ,nvl(n.asset_contract_status, o.asset_contract_status) as asset_contract_status -- 资产包合同状态
    ,nvl(n.asset_contract_name, o.asset_contract_name) as asset_contract_name -- 资产证券化资产包名称
    ,nvl(n.asset_odi_flag, o.asset_odi_flag) as asset_odi_flag -- 资产证券化复利转出标识
    ,nvl(n.asset_odp_flag, o.asset_odp_flag) as asset_odp_flag -- 资产证券化罚息转出标识
    ,nvl(n.pack_cancel_date, o.pack_cancel_date) as pack_cancel_date -- 撤包日期
    ,nvl(n.asset_contract_seq_no, o.asset_contract_seq_no) as asset_contract_seq_no -- 资产包合同序号
    ,nvl(n.redeem_float_amount, o.redeem_float_amount) as redeem_float_amount -- 赎回折溢价
    ,nvl(n.is_bad, o.is_bad) as is_bad -- 资产证券化合同表
    ,case when
            n.asset_contract_seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.asset_contract_seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.asset_contract_seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_transfer_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_transfer_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.asset_contract_seq_no = n.asset_contract_seq_no
where (
        o.asset_contract_seq_no is null
    )
    or (
        n.asset_contract_seq_no is null
    )
    or (
        o.ccy <> n.ccy
        or o.prod_type <> n.prod_type
        or o.user_id <> n.user_id
        or o.appr_flag <> n.appr_flag
        or o.company <> n.company
        or o.narrative <> n.narrative
        or o.last_change_date <> n.last_change_date
        or o.pack_date <> n.pack_date
        or o.redeem_date <> n.redeem_date
        or o.redeem_int_date <> n.redeem_int_date
        or o.sale_date <> n.sale_date
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.appr_user_id <> n.appr_user_id
        or o.tran_branch <> n.tran_branch
        or o.profit_loss_calc_method <> n.profit_loss_calc_method
        or o.amortized_int <> n.amortized_int
        or o.asset_transfer_type <> n.asset_transfer_type
        or o.asset_contract_id <> n.asset_contract_id
        or o.asset_contract_type <> n.asset_contract_type
        or o.asset_contract_no <> n.asset_contract_no
        or o.sale_tran_timestamp <> n.sale_tran_timestamp
        or o.asset_int_flag <> n.asset_int_flag
        or o.sale_cancel_date <> n.sale_cancel_date
        or o.asset_contract_amt <> n.asset_contract_amt
        or o.pack_tran_timestamp <> n.pack_tran_timestamp
        or o.sale_float_amount <> n.sale_float_amount
        or o.asset_contract_status <> n.asset_contract_status
        or o.asset_contract_name <> n.asset_contract_name
        or o.asset_odi_flag <> n.asset_odi_flag
        or o.asset_odp_flag <> n.asset_odp_flag
        or o.pack_cancel_date <> n.pack_cancel_date
        or o.redeem_float_amount <> n.redeem_float_amount
        or o.is_bad <> n.is_bad
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_transfer_contract_cl(
            ccy -- 币种
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,appr_flag -- 复核标志
            ,company -- 法人
            ,narrative -- 摘要
            ,last_change_date -- 最后修改日期
            ,pack_date -- 资产证券化封包日期
            ,redeem_date -- 资产赎回日期
            ,redeem_int_date -- 赎回起息日期
            ,sale_date -- 重空出票日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,appr_user_id -- 复核柜员
            ,tran_branch -- 核心交易机构编号
            ,profit_loss_calc_method -- 损益计算方式
            ,amortized_int -- 已摊销利息
            ,asset_transfer_type -- 资产包转让类型
            ,asset_contract_id -- 资产证券化资产包编号
            ,asset_contract_type -- 资产包合同类型
            ,asset_contract_no -- 资产包合同号
            ,sale_tran_timestamp -- 发行交易时间戳
            ,asset_int_flag -- 资产证券化利息拆分标识
            ,sale_cancel_date -- 资产发行撤销日期
            ,asset_contract_amt -- 资产包金额
            ,pack_tran_timestamp -- 封包交易时间戳
            ,sale_float_amount -- 发行折溢价
            ,asset_contract_status -- 资产包合同状态
            ,asset_contract_name -- 资产证券化资产包名称
            ,asset_odi_flag -- 资产证券化复利转出标识
            ,asset_odp_flag -- 资产证券化罚息转出标识
            ,pack_cancel_date -- 撤包日期
            ,asset_contract_seq_no -- 资产包合同序号
            ,redeem_float_amount -- 赎回折溢价
            ,is_bad -- 资产证券化合同表
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_transfer_contract_op(
            ccy -- 币种
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,appr_flag -- 复核标志
            ,company -- 法人
            ,narrative -- 摘要
            ,last_change_date -- 最后修改日期
            ,pack_date -- 资产证券化封包日期
            ,redeem_date -- 资产赎回日期
            ,redeem_int_date -- 赎回起息日期
            ,sale_date -- 重空出票日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,appr_user_id -- 复核柜员
            ,tran_branch -- 核心交易机构编号
            ,profit_loss_calc_method -- 损益计算方式
            ,amortized_int -- 已摊销利息
            ,asset_transfer_type -- 资产包转让类型
            ,asset_contract_id -- 资产证券化资产包编号
            ,asset_contract_type -- 资产包合同类型
            ,asset_contract_no -- 资产包合同号
            ,sale_tran_timestamp -- 发行交易时间戳
            ,asset_int_flag -- 资产证券化利息拆分标识
            ,sale_cancel_date -- 资产发行撤销日期
            ,asset_contract_amt -- 资产包金额
            ,pack_tran_timestamp -- 封包交易时间戳
            ,sale_float_amount -- 发行折溢价
            ,asset_contract_status -- 资产包合同状态
            ,asset_contract_name -- 资产证券化资产包名称
            ,asset_odi_flag -- 资产证券化复利转出标识
            ,asset_odp_flag -- 资产证券化罚息转出标识
            ,pack_cancel_date -- 撤包日期
            ,asset_contract_seq_no -- 资产包合同序号
            ,redeem_float_amount -- 赎回折溢价
            ,is_bad -- 资产证券化合同表
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ccy -- 币种
    ,o.prod_type -- 产品编号
    ,o.user_id -- 交易柜员编号
    ,o.appr_flag -- 复核标志
    ,o.company -- 法人
    ,o.narrative -- 摘要
    ,o.last_change_date -- 最后修改日期
    ,o.pack_date -- 资产证券化封包日期
    ,o.redeem_date -- 资产赎回日期
    ,o.redeem_int_date -- 赎回起息日期
    ,o.sale_date -- 重空出票日期
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.appr_user_id -- 复核柜员
    ,o.tran_branch -- 核心交易机构编号
    ,o.profit_loss_calc_method -- 损益计算方式
    ,o.amortized_int -- 已摊销利息
    ,o.asset_transfer_type -- 资产包转让类型
    ,o.asset_contract_id -- 资产证券化资产包编号
    ,o.asset_contract_type -- 资产包合同类型
    ,o.asset_contract_no -- 资产包合同号
    ,o.sale_tran_timestamp -- 发行交易时间戳
    ,o.asset_int_flag -- 资产证券化利息拆分标识
    ,o.sale_cancel_date -- 资产发行撤销日期
    ,o.asset_contract_amt -- 资产包金额
    ,o.pack_tran_timestamp -- 封包交易时间戳
    ,o.sale_float_amount -- 发行折溢价
    ,o.asset_contract_status -- 资产包合同状态
    ,o.asset_contract_name -- 资产证券化资产包名称
    ,o.asset_odi_flag -- 资产证券化复利转出标识
    ,o.asset_odp_flag -- 资产证券化罚息转出标识
    ,o.pack_cancel_date -- 撤包日期
    ,o.asset_contract_seq_no -- 资产包合同序号
    ,o.redeem_float_amount -- 赎回折溢价
    ,o.is_bad -- 资产证券化合同表
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
from ${iol_schema}.ncbs_cl_transfer_contract_bk o
    left join ${iol_schema}.ncbs_cl_transfer_contract_op n
        on
            o.asset_contract_seq_no = n.asset_contract_seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_transfer_contract_cl d
        on
            o.asset_contract_seq_no = d.asset_contract_seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_transfer_contract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_transfer_contract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_transfer_contract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_transfer_contract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_transfer_contract exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_transfer_contract_cl;
alter table ${iol_schema}.ncbs_cl_transfer_contract exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_transfer_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_transfer_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_transfer_contract_op purge;
drop table ${iol_schema}.ncbs_cl_transfer_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_transfer_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_transfer_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
