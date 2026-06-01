/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_bail_paragraph_details
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
create table ${iol_schema}.bdps_bail_paragraph_details_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdps_bail_paragraph_details;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_bail_paragraph_details_op purge;
drop table ${iol_schema}.bdps_bail_paragraph_details_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_bail_paragraph_details_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_bail_paragraph_details where 0=1;

create table ${iol_schema}.bdps_bail_paragraph_details_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_bail_paragraph_details where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_bail_paragraph_details_cl(
            id -- 
            ,contract_no -- 合同号
            ,loan_appno -- 借据号
            ,draft_key -- 票据唯一标识
            ,draft_number -- 票据号码
            ,back_time -- 备款时间
            ,bail_account -- 保证金账号
            ,bail_sub_no -- 客户保证金子编号
            ,bail_amount -- 保证金余额
            ,coneal_nbr -- 止付流水
            ,unfreeze_nbr -- 解付流水
            ,pool_type -- 票据池类型 1-票据池 2-资产池
            ,status -- 备款状态 1-成功  2-失败  （以借据为单位时可不填）
            ,remarks -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_bail_paragraph_details_op(
            id -- 
            ,contract_no -- 合同号
            ,loan_appno -- 借据号
            ,draft_key -- 票据唯一标识
            ,draft_number -- 票据号码
            ,back_time -- 备款时间
            ,bail_account -- 保证金账号
            ,bail_sub_no -- 客户保证金子编号
            ,bail_amount -- 保证金余额
            ,coneal_nbr -- 止付流水
            ,unfreeze_nbr -- 解付流水
            ,pool_type -- 票据池类型 1-票据池 2-资产池
            ,status -- 备款状态 1-成功  2-失败  （以借据为单位时可不填）
            ,remarks -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 合同号
    ,nvl(n.loan_appno, o.loan_appno) as loan_appno -- 借据号
    ,nvl(n.draft_key, o.draft_key) as draft_key -- 票据唯一标识
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票据号码
    ,nvl(n.back_time, o.back_time) as back_time -- 备款时间
    ,nvl(n.bail_account, o.bail_account) as bail_account -- 保证金账号
    ,nvl(n.bail_sub_no, o.bail_sub_no) as bail_sub_no -- 客户保证金子编号
    ,nvl(n.bail_amount, o.bail_amount) as bail_amount -- 保证金余额
    ,nvl(n.coneal_nbr, o.coneal_nbr) as coneal_nbr -- 止付流水
    ,nvl(n.unfreeze_nbr, o.unfreeze_nbr) as unfreeze_nbr -- 解付流水
    ,nvl(n.pool_type, o.pool_type) as pool_type -- 票据池类型 1-票据池 2-资产池
    ,nvl(n.status, o.status) as status -- 备款状态 1-成功  2-失败  （以借据为单位时可不填）
    ,nvl(n.remarks, o.remarks) as remarks -- 备注
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdps_bail_paragraph_details_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdps_bail_paragraph_details where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.contract_no <> n.contract_no
        or o.loan_appno <> n.loan_appno
        or o.draft_key <> n.draft_key
        or o.draft_number <> n.draft_number
        or o.back_time <> n.back_time
        or o.bail_account <> n.bail_account
        or o.bail_sub_no <> n.bail_sub_no
        or o.bail_amount <> n.bail_amount
        or o.coneal_nbr <> n.coneal_nbr
        or o.unfreeze_nbr <> n.unfreeze_nbr
        or o.pool_type <> n.pool_type
        or o.status <> n.status
        or o.remarks <> n.remarks
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_bail_paragraph_details_cl(
            id -- 
            ,contract_no -- 合同号
            ,loan_appno -- 借据号
            ,draft_key -- 票据唯一标识
            ,draft_number -- 票据号码
            ,back_time -- 备款时间
            ,bail_account -- 保证金账号
            ,bail_sub_no -- 客户保证金子编号
            ,bail_amount -- 保证金余额
            ,coneal_nbr -- 止付流水
            ,unfreeze_nbr -- 解付流水
            ,pool_type -- 票据池类型 1-票据池 2-资产池
            ,status -- 备款状态 1-成功  2-失败  （以借据为单位时可不填）
            ,remarks -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_bail_paragraph_details_op(
            id -- 
            ,contract_no -- 合同号
            ,loan_appno -- 借据号
            ,draft_key -- 票据唯一标识
            ,draft_number -- 票据号码
            ,back_time -- 备款时间
            ,bail_account -- 保证金账号
            ,bail_sub_no -- 客户保证金子编号
            ,bail_amount -- 保证金余额
            ,coneal_nbr -- 止付流水
            ,unfreeze_nbr -- 解付流水
            ,pool_type -- 票据池类型 1-票据池 2-资产池
            ,status -- 备款状态 1-成功  2-失败  （以借据为单位时可不填）
            ,remarks -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.contract_no -- 合同号
    ,o.loan_appno -- 借据号
    ,o.draft_key -- 票据唯一标识
    ,o.draft_number -- 票据号码
    ,o.back_time -- 备款时间
    ,o.bail_account -- 保证金账号
    ,o.bail_sub_no -- 客户保证金子编号
    ,o.bail_amount -- 保证金余额
    ,o.coneal_nbr -- 止付流水
    ,o.unfreeze_nbr -- 解付流水
    ,o.pool_type -- 票据池类型 1-票据池 2-资产池
    ,o.status -- 备款状态 1-成功  2-失败  （以借据为单位时可不填）
    ,o.remarks -- 备注
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdps_bail_paragraph_details_bk o
    left join ${iol_schema}.bdps_bail_paragraph_details_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdps_bail_paragraph_details_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.bdps_bail_paragraph_details;

-- 4.2 exchange partition
alter table ${iol_schema}.bdps_bail_paragraph_details exchange partition p_19000101 with table ${iol_schema}.bdps_bail_paragraph_details_cl;
alter table ${iol_schema}.bdps_bail_paragraph_details exchange partition p_20991231 with table ${iol_schema}.bdps_bail_paragraph_details_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdps_bail_paragraph_details to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_bail_paragraph_details_op purge;
drop table ${iol_schema}.bdps_bail_paragraph_details_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdps_bail_paragraph_details_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdps_bail_paragraph_details',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
