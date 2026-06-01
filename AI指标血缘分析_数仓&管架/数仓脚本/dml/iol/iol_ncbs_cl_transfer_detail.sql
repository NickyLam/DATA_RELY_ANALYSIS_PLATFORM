/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_transfer_detail
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
create table ${iol_schema}.ncbs_cl_transfer_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_transfer_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_transfer_detail_op purge;
drop table ${iol_schema}.ncbs_cl_transfer_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_transfer_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_transfer_detail where 0=1;

create table ${iol_schema}.ncbs_cl_transfer_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_transfer_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_transfer_detail_cl(
            asset_acct_status -- 资产账户状态
            ,balance -- 余额
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,dd_no -- 发放号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,narrative -- 摘要
            ,sale_batch_no -- 发行批次号
            ,accounting_status -- 核算状态
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,loan_no -- 贷款号
            ,pack_reference -- 资产证券化封包流水号
            ,sale_reference -- 发行流水号
            ,sale_cancel_batch_no -- 发行撤销批次号
            ,amortized_int -- 已摊销利息
            ,circle_buy_flag -- 循环购买标志
            ,circle_buy_reference -- 循环购买流水号
            ,pack_cancel_batch_no -- 撤包批次号
            ,circle_buy_date -- 循环购买日期
            ,sale_float_amount -- 发行折溢价
            ,circle_buy_batch_no -- 循环购买批次号
            ,sale_cancel_reference -- 资产发行撤销交易参考号
            ,redeem_reference -- 赎回交易流水号
            ,pack_batch_no -- 封包批次号
            ,pack_cancel_reference -- 撤包交易流水号
            ,asset_detail_seq_no -- 资产包合同明细序号
            ,redeem_date -- 资产赎回日期
            ,redeem_batch_no -- 赎回批次号
            ,pack_tran_date -- 封包交易日期
            ,asset_contract_seq_no -- 资产包合同序号
            ,redeem_float_amount -- 赎回折溢价
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_transfer_detail_op(
            asset_acct_status -- 资产账户状态
            ,balance -- 余额
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,dd_no -- 发放号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,narrative -- 摘要
            ,sale_batch_no -- 发行批次号
            ,accounting_status -- 核算状态
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,loan_no -- 贷款号
            ,pack_reference -- 资产证券化封包流水号
            ,sale_reference -- 发行流水号
            ,sale_cancel_batch_no -- 发行撤销批次号
            ,amortized_int -- 已摊销利息
            ,circle_buy_flag -- 循环购买标志
            ,circle_buy_reference -- 循环购买流水号
            ,pack_cancel_batch_no -- 撤包批次号
            ,circle_buy_date -- 循环购买日期
            ,sale_float_amount -- 发行折溢价
            ,circle_buy_batch_no -- 循环购买批次号
            ,sale_cancel_reference -- 资产发行撤销交易参考号
            ,redeem_reference -- 赎回交易流水号
            ,pack_batch_no -- 封包批次号
            ,pack_cancel_reference -- 撤包交易流水号
            ,asset_detail_seq_no -- 资产包合同明细序号
            ,redeem_date -- 资产赎回日期
            ,redeem_batch_no -- 赎回批次号
            ,pack_tran_date -- 封包交易日期
            ,asset_contract_seq_no -- 资产包合同序号
            ,redeem_float_amount -- 赎回折溢价
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.asset_acct_status, o.asset_acct_status) as asset_acct_status -- 资产账户状态
    ,nvl(n.balance, o.balance) as balance -- 余额
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.dd_no, o.dd_no) as dd_no -- 发放号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.cmisloan_no, o.cmisloan_no) as cmisloan_no -- 客户借据编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.narrative, o.narrative) as narrative -- 摘要
    ,nvl(n.sale_batch_no, o.sale_batch_no) as sale_batch_no -- 发行批次号
    ,nvl(n.accounting_status, o.accounting_status) as accounting_status -- 核算状态
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.loan_no, o.loan_no) as loan_no -- 贷款号
    ,nvl(n.pack_reference, o.pack_reference) as pack_reference -- 资产证券化封包流水号
    ,nvl(n.sale_reference, o.sale_reference) as sale_reference -- 发行流水号
    ,nvl(n.sale_cancel_batch_no, o.sale_cancel_batch_no) as sale_cancel_batch_no -- 发行撤销批次号
    ,nvl(n.amortized_int, o.amortized_int) as amortized_int -- 已摊销利息
    ,nvl(n.circle_buy_flag, o.circle_buy_flag) as circle_buy_flag -- 循环购买标志
    ,nvl(n.circle_buy_reference, o.circle_buy_reference) as circle_buy_reference -- 循环购买流水号
    ,nvl(n.pack_cancel_batch_no, o.pack_cancel_batch_no) as pack_cancel_batch_no -- 撤包批次号
    ,nvl(n.circle_buy_date, o.circle_buy_date) as circle_buy_date -- 循环购买日期
    ,nvl(n.sale_float_amount, o.sale_float_amount) as sale_float_amount -- 发行折溢价
    ,nvl(n.circle_buy_batch_no, o.circle_buy_batch_no) as circle_buy_batch_no -- 循环购买批次号
    ,nvl(n.sale_cancel_reference, o.sale_cancel_reference) as sale_cancel_reference -- 资产发行撤销交易参考号
    ,nvl(n.redeem_reference, o.redeem_reference) as redeem_reference -- 赎回交易流水号
    ,nvl(n.pack_batch_no, o.pack_batch_no) as pack_batch_no -- 封包批次号
    ,nvl(n.pack_cancel_reference, o.pack_cancel_reference) as pack_cancel_reference -- 撤包交易流水号
    ,nvl(n.asset_detail_seq_no, o.asset_detail_seq_no) as asset_detail_seq_no -- 资产包合同明细序号
    ,nvl(n.redeem_date, o.redeem_date) as redeem_date -- 资产赎回日期
    ,nvl(n.redeem_batch_no, o.redeem_batch_no) as redeem_batch_no -- 赎回批次号
    ,nvl(n.pack_tran_date, o.pack_tran_date) as pack_tran_date -- 封包交易日期
    ,nvl(n.asset_contract_seq_no, o.asset_contract_seq_no) as asset_contract_seq_no -- 资产包合同序号
    ,nvl(n.redeem_float_amount, o.redeem_float_amount) as redeem_float_amount -- 赎回折溢价
    ,case when
            n.asset_detail_seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.asset_detail_seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.asset_detail_seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_transfer_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_transfer_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.asset_detail_seq_no = n.asset_detail_seq_no
where (
        o.asset_detail_seq_no is null
    )
    or (
        n.asset_detail_seq_no is null
    )
    or (
        o.asset_acct_status <> n.asset_acct_status
        or o.balance <> n.balance
        or o.ccy <> n.ccy
        or o.client_no <> n.client_no
        or o.dd_no <> n.dd_no
        or o.internal_key <> n.internal_key
        or o.prod_type <> n.prod_type
        or o.cmisloan_no <> n.cmisloan_no
        or o.company <> n.company
        or o.narrative <> n.narrative
        or o.sale_batch_no <> n.sale_batch_no
        or o.accounting_status <> n.accounting_status
        or o.last_change_date <> n.last_change_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.loan_no <> n.loan_no
        or o.pack_reference <> n.pack_reference
        or o.sale_reference <> n.sale_reference
        or o.sale_cancel_batch_no <> n.sale_cancel_batch_no
        or o.amortized_int <> n.amortized_int
        or o.circle_buy_flag <> n.circle_buy_flag
        or o.circle_buy_reference <> n.circle_buy_reference
        or o.pack_cancel_batch_no <> n.pack_cancel_batch_no
        or o.circle_buy_date <> n.circle_buy_date
        or o.sale_float_amount <> n.sale_float_amount
        or o.circle_buy_batch_no <> n.circle_buy_batch_no
        or o.sale_cancel_reference <> n.sale_cancel_reference
        or o.redeem_reference <> n.redeem_reference
        or o.pack_batch_no <> n.pack_batch_no
        or o.pack_cancel_reference <> n.pack_cancel_reference
        or o.redeem_date <> n.redeem_date
        or o.redeem_batch_no <> n.redeem_batch_no
        or o.pack_tran_date <> n.pack_tran_date
        or o.asset_contract_seq_no <> n.asset_contract_seq_no
        or o.redeem_float_amount <> n.redeem_float_amount
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_transfer_detail_cl(
            asset_acct_status -- 资产账户状态
            ,balance -- 余额
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,dd_no -- 发放号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,narrative -- 摘要
            ,sale_batch_no -- 发行批次号
            ,accounting_status -- 核算状态
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,loan_no -- 贷款号
            ,pack_reference -- 资产证券化封包流水号
            ,sale_reference -- 发行流水号
            ,sale_cancel_batch_no -- 发行撤销批次号
            ,amortized_int -- 已摊销利息
            ,circle_buy_flag -- 循环购买标志
            ,circle_buy_reference -- 循环购买流水号
            ,pack_cancel_batch_no -- 撤包批次号
            ,circle_buy_date -- 循环购买日期
            ,sale_float_amount -- 发行折溢价
            ,circle_buy_batch_no -- 循环购买批次号
            ,sale_cancel_reference -- 资产发行撤销交易参考号
            ,redeem_reference -- 赎回交易流水号
            ,pack_batch_no -- 封包批次号
            ,pack_cancel_reference -- 撤包交易流水号
            ,asset_detail_seq_no -- 资产包合同明细序号
            ,redeem_date -- 资产赎回日期
            ,redeem_batch_no -- 赎回批次号
            ,pack_tran_date -- 封包交易日期
            ,asset_contract_seq_no -- 资产包合同序号
            ,redeem_float_amount -- 赎回折溢价
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_transfer_detail_op(
            asset_acct_status -- 资产账户状态
            ,balance -- 余额
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,dd_no -- 发放号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,narrative -- 摘要
            ,sale_batch_no -- 发行批次号
            ,accounting_status -- 核算状态
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,loan_no -- 贷款号
            ,pack_reference -- 资产证券化封包流水号
            ,sale_reference -- 发行流水号
            ,sale_cancel_batch_no -- 发行撤销批次号
            ,amortized_int -- 已摊销利息
            ,circle_buy_flag -- 循环购买标志
            ,circle_buy_reference -- 循环购买流水号
            ,pack_cancel_batch_no -- 撤包批次号
            ,circle_buy_date -- 循环购买日期
            ,sale_float_amount -- 发行折溢价
            ,circle_buy_batch_no -- 循环购买批次号
            ,sale_cancel_reference -- 资产发行撤销交易参考号
            ,redeem_reference -- 赎回交易流水号
            ,pack_batch_no -- 封包批次号
            ,pack_cancel_reference -- 撤包交易流水号
            ,asset_detail_seq_no -- 资产包合同明细序号
            ,redeem_date -- 资产赎回日期
            ,redeem_batch_no -- 赎回批次号
            ,pack_tran_date -- 封包交易日期
            ,asset_contract_seq_no -- 资产包合同序号
            ,redeem_float_amount -- 赎回折溢价
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.asset_acct_status -- 资产账户状态
    ,o.balance -- 余额
    ,o.ccy -- 币种
    ,o.client_no -- 客户编号
    ,o.dd_no -- 发放号
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.cmisloan_no -- 客户借据编号
    ,o.company -- 法人
    ,o.narrative -- 摘要
    ,o.sale_batch_no -- 发行批次号
    ,o.accounting_status -- 核算状态
    ,o.last_change_date -- 最后修改日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.loan_no -- 贷款号
    ,o.pack_reference -- 资产证券化封包流水号
    ,o.sale_reference -- 发行流水号
    ,o.sale_cancel_batch_no -- 发行撤销批次号
    ,o.amortized_int -- 已摊销利息
    ,o.circle_buy_flag -- 循环购买标志
    ,o.circle_buy_reference -- 循环购买流水号
    ,o.pack_cancel_batch_no -- 撤包批次号
    ,o.circle_buy_date -- 循环购买日期
    ,o.sale_float_amount -- 发行折溢价
    ,o.circle_buy_batch_no -- 循环购买批次号
    ,o.sale_cancel_reference -- 资产发行撤销交易参考号
    ,o.redeem_reference -- 赎回交易流水号
    ,o.pack_batch_no -- 封包批次号
    ,o.pack_cancel_reference -- 撤包交易流水号
    ,o.asset_detail_seq_no -- 资产包合同明细序号
    ,o.redeem_date -- 资产赎回日期
    ,o.redeem_batch_no -- 赎回批次号
    ,o.pack_tran_date -- 封包交易日期
    ,o.asset_contract_seq_no -- 资产包合同序号
    ,o.redeem_float_amount -- 赎回折溢价
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
from ${iol_schema}.ncbs_cl_transfer_detail_bk o
    left join ${iol_schema}.ncbs_cl_transfer_detail_op n
        on
            o.asset_detail_seq_no = n.asset_detail_seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_transfer_detail_cl d
        on
            o.asset_detail_seq_no = d.asset_detail_seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_transfer_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_transfer_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_transfer_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_transfer_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_transfer_detail exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_transfer_detail_cl;
alter table ${iol_schema}.ncbs_cl_transfer_detail exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_transfer_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_transfer_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_transfer_detail_op purge;
drop table ${iol_schema}.ncbs_cl_transfer_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_transfer_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_transfer_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
