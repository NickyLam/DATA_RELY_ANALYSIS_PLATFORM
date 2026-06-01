/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_transfer_detail_attach
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
create table ${iol_schema}.ncbs_cl_transfer_detail_attach_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_transfer_detail_attach
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_transfer_detail_attach_op purge;
drop table ${iol_schema}.ncbs_cl_transfer_detail_attach_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_transfer_detail_attach_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_transfer_detail_attach where 0=1;

create table ${iol_schema}.ncbs_cl_transfer_detail_attach_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_transfer_detail_attach where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_transfer_detail_attach_cl(
            client_no -- 客户编号
            ,dd_no -- 发放号
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,tran_timestamp -- 交易时间戳
            ,float_amount -- 折溢价总额
            ,float_int -- 折溢价利息
            ,float_pri -- 折溢价本金
            ,loan_no -- 贷款号
            ,pack_int -- 起算日应计利息
            ,pack_intp -- 起算日应收利息
            ,pack_odi -- 起算日应计复利
            ,pack_odip -- 起算日应收复利
            ,pack_odp -- 起算日应计罚息
            ,pack_odpp -- 起算日应收罚息
            ,pack_out_int -- 起算日表外应计利息
            ,pack_out_intp -- 起算日表外应收利息
            ,pack_out_odi -- 起算日表外应计复利
            ,pack_out_odip -- 起算日表外应收复利
            ,pack_out_odp -- 起算日表外应计罚息
            ,pack_out_odpp -- 起算日表外应收罚息
            ,pack_pri -- 起算日本金
            ,settle_amt -- 结算金额
            ,asset_detail_seq_no -- 资产包合同明细序号
            ,asset_contract_seq_no -- 资产包合同序号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_transfer_detail_attach_op(
            client_no -- 客户编号
            ,dd_no -- 发放号
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,tran_timestamp -- 交易时间戳
            ,float_amount -- 折溢价总额
            ,float_int -- 折溢价利息
            ,float_pri -- 折溢价本金
            ,loan_no -- 贷款号
            ,pack_int -- 起算日应计利息
            ,pack_intp -- 起算日应收利息
            ,pack_odi -- 起算日应计复利
            ,pack_odip -- 起算日应收复利
            ,pack_odp -- 起算日应计罚息
            ,pack_odpp -- 起算日应收罚息
            ,pack_out_int -- 起算日表外应计利息
            ,pack_out_intp -- 起算日表外应收利息
            ,pack_out_odi -- 起算日表外应计复利
            ,pack_out_odip -- 起算日表外应收复利
            ,pack_out_odp -- 起算日表外应计罚息
            ,pack_out_odpp -- 起算日表外应收罚息
            ,pack_pri -- 起算日本金
            ,settle_amt -- 结算金额
            ,asset_detail_seq_no -- 资产包合同明细序号
            ,asset_contract_seq_no -- 资产包合同序号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.dd_no, o.dd_no) as dd_no -- 发放号
    ,nvl(n.cmisloan_no, o.cmisloan_no) as cmisloan_no -- 客户借据编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.float_amount, o.float_amount) as float_amount -- 折溢价总额
    ,nvl(n.float_int, o.float_int) as float_int -- 折溢价利息
    ,nvl(n.float_pri, o.float_pri) as float_pri -- 折溢价本金
    ,nvl(n.loan_no, o.loan_no) as loan_no -- 贷款号
    ,nvl(n.pack_int, o.pack_int) as pack_int -- 起算日应计利息
    ,nvl(n.pack_intp, o.pack_intp) as pack_intp -- 起算日应收利息
    ,nvl(n.pack_odi, o.pack_odi) as pack_odi -- 起算日应计复利
    ,nvl(n.pack_odip, o.pack_odip) as pack_odip -- 起算日应收复利
    ,nvl(n.pack_odp, o.pack_odp) as pack_odp -- 起算日应计罚息
    ,nvl(n.pack_odpp, o.pack_odpp) as pack_odpp -- 起算日应收罚息
    ,nvl(n.pack_out_int, o.pack_out_int) as pack_out_int -- 起算日表外应计利息
    ,nvl(n.pack_out_intp, o.pack_out_intp) as pack_out_intp -- 起算日表外应收利息
    ,nvl(n.pack_out_odi, o.pack_out_odi) as pack_out_odi -- 起算日表外应计复利
    ,nvl(n.pack_out_odip, o.pack_out_odip) as pack_out_odip -- 起算日表外应收复利
    ,nvl(n.pack_out_odp, o.pack_out_odp) as pack_out_odp -- 起算日表外应计罚息
    ,nvl(n.pack_out_odpp, o.pack_out_odpp) as pack_out_odpp -- 起算日表外应收罚息
    ,nvl(n.pack_pri, o.pack_pri) as pack_pri -- 起算日本金
    ,nvl(n.settle_amt, o.settle_amt) as settle_amt -- 结算金额
    ,nvl(n.asset_detail_seq_no, o.asset_detail_seq_no) as asset_detail_seq_no -- 资产包合同明细序号
    ,nvl(n.asset_contract_seq_no, o.asset_contract_seq_no) as asset_contract_seq_no -- 资产包合同序号
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
from (select * from ${iol_schema}.ncbs_cl_transfer_detail_attach_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_transfer_detail_attach where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.asset_detail_seq_no = n.asset_detail_seq_no
where (
        o.asset_detail_seq_no is null
    )
    or (
        n.asset_detail_seq_no is null
    )
    or (
        o.client_no <> n.client_no
        or o.dd_no <> n.dd_no
        or o.cmisloan_no <> n.cmisloan_no
        or o.company <> n.company
        or o.tran_timestamp <> n.tran_timestamp
        or o.float_amount <> n.float_amount
        or o.float_int <> n.float_int
        or o.float_pri <> n.float_pri
        or o.loan_no <> n.loan_no
        or o.pack_int <> n.pack_int
        or o.pack_intp <> n.pack_intp
        or o.pack_odi <> n.pack_odi
        or o.pack_odip <> n.pack_odip
        or o.pack_odp <> n.pack_odp
        or o.pack_odpp <> n.pack_odpp
        or o.pack_out_int <> n.pack_out_int
        or o.pack_out_intp <> n.pack_out_intp
        or o.pack_out_odi <> n.pack_out_odi
        or o.pack_out_odip <> n.pack_out_odip
        or o.pack_out_odp <> n.pack_out_odp
        or o.pack_out_odpp <> n.pack_out_odpp
        or o.pack_pri <> n.pack_pri
        or o.settle_amt <> n.settle_amt
        or o.asset_contract_seq_no <> n.asset_contract_seq_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_transfer_detail_attach_cl(
            client_no -- 客户编号
            ,dd_no -- 发放号
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,tran_timestamp -- 交易时间戳
            ,float_amount -- 折溢价总额
            ,float_int -- 折溢价利息
            ,float_pri -- 折溢价本金
            ,loan_no -- 贷款号
            ,pack_int -- 起算日应计利息
            ,pack_intp -- 起算日应收利息
            ,pack_odi -- 起算日应计复利
            ,pack_odip -- 起算日应收复利
            ,pack_odp -- 起算日应计罚息
            ,pack_odpp -- 起算日应收罚息
            ,pack_out_int -- 起算日表外应计利息
            ,pack_out_intp -- 起算日表外应收利息
            ,pack_out_odi -- 起算日表外应计复利
            ,pack_out_odip -- 起算日表外应收复利
            ,pack_out_odp -- 起算日表外应计罚息
            ,pack_out_odpp -- 起算日表外应收罚息
            ,pack_pri -- 起算日本金
            ,settle_amt -- 结算金额
            ,asset_detail_seq_no -- 资产包合同明细序号
            ,asset_contract_seq_no -- 资产包合同序号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_transfer_detail_attach_op(
            client_no -- 客户编号
            ,dd_no -- 发放号
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,tran_timestamp -- 交易时间戳
            ,float_amount -- 折溢价总额
            ,float_int -- 折溢价利息
            ,float_pri -- 折溢价本金
            ,loan_no -- 贷款号
            ,pack_int -- 起算日应计利息
            ,pack_intp -- 起算日应收利息
            ,pack_odi -- 起算日应计复利
            ,pack_odip -- 起算日应收复利
            ,pack_odp -- 起算日应计罚息
            ,pack_odpp -- 起算日应收罚息
            ,pack_out_int -- 起算日表外应计利息
            ,pack_out_intp -- 起算日表外应收利息
            ,pack_out_odi -- 起算日表外应计复利
            ,pack_out_odip -- 起算日表外应收复利
            ,pack_out_odp -- 起算日表外应计罚息
            ,pack_out_odpp -- 起算日表外应收罚息
            ,pack_pri -- 起算日本金
            ,settle_amt -- 结算金额
            ,asset_detail_seq_no -- 资产包合同明细序号
            ,asset_contract_seq_no -- 资产包合同序号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.dd_no -- 发放号
    ,o.cmisloan_no -- 客户借据编号
    ,o.company -- 法人
    ,o.tran_timestamp -- 交易时间戳
    ,o.float_amount -- 折溢价总额
    ,o.float_int -- 折溢价利息
    ,o.float_pri -- 折溢价本金
    ,o.loan_no -- 贷款号
    ,o.pack_int -- 起算日应计利息
    ,o.pack_intp -- 起算日应收利息
    ,o.pack_odi -- 起算日应计复利
    ,o.pack_odip -- 起算日应收复利
    ,o.pack_odp -- 起算日应计罚息
    ,o.pack_odpp -- 起算日应收罚息
    ,o.pack_out_int -- 起算日表外应计利息
    ,o.pack_out_intp -- 起算日表外应收利息
    ,o.pack_out_odi -- 起算日表外应计复利
    ,o.pack_out_odip -- 起算日表外应收复利
    ,o.pack_out_odp -- 起算日表外应计罚息
    ,o.pack_out_odpp -- 起算日表外应收罚息
    ,o.pack_pri -- 起算日本金
    ,o.settle_amt -- 结算金额
    ,o.asset_detail_seq_no -- 资产包合同明细序号
    ,o.asset_contract_seq_no -- 资产包合同序号
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
from ${iol_schema}.ncbs_cl_transfer_detail_attach_bk o
    left join ${iol_schema}.ncbs_cl_transfer_detail_attach_op n
        on
            o.asset_detail_seq_no = n.asset_detail_seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_transfer_detail_attach_cl d
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
--truncate table ${iol_schema}.ncbs_cl_transfer_detail_attach;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_transfer_detail_attach') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_transfer_detail_attach drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_transfer_detail_attach add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_transfer_detail_attach exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_transfer_detail_attach_cl;
alter table ${iol_schema}.ncbs_cl_transfer_detail_attach exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_transfer_detail_attach_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_transfer_detail_attach to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_transfer_detail_attach_op purge;
drop table ${iol_schema}.ncbs_cl_transfer_detail_attach_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_transfer_detail_attach_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_transfer_detail_attach',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
