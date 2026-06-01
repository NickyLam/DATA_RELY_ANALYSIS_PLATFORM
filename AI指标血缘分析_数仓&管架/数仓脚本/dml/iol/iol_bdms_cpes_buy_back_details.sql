/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_buy_back_details
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
create table ${iol_schema}.bdms_cpes_buy_back_details_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_buy_back_details
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_buy_back_details_op purge;
drop table ${iol_schema}.bdms_cpes_buy_back_details_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_buy_back_details_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_buy_back_details where 0=1;

create table ${iol_schema}.bdms_cpes_buy_back_details_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_buy_back_details where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_buy_back_details_cl(
            id -- ID
            ,contract_id -- 批次表ID
            ,draft_id -- 票据ID
            ,valid_flag -- 有效标识 0 无效 1 有效
            ,draft_amount -- 票据金额
            ,buy_back_pay_interest -- 赎回应付利息
            ,buy_back_amount -- 赎回金额
            ,deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,draft_number -- 票据(包)号
            ,cd_range -- 子票区间
            ,buss_flag -- 业务类型： 01 申请 02 签收
            ,brh_no -- 本方机构号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_buy_back_details_op(
            id -- ID
            ,contract_id -- 批次表ID
            ,draft_id -- 票据ID
            ,valid_flag -- 有效标识 0 无效 1 有效
            ,draft_amount -- 票据金额
            ,buy_back_pay_interest -- 赎回应付利息
            ,buy_back_amount -- 赎回金额
            ,deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,draft_number -- 票据(包)号
            ,cd_range -- 子票区间
            ,buss_flag -- 业务类型： 01 申请 02 签收
            ,brh_no -- 本方机构号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.contract_id, o.contract_id) as contract_id -- 批次表ID
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 票据ID
    ,nvl(n.valid_flag, o.valid_flag) as valid_flag -- 有效标识 0 无效 1 有效
    ,nvl(n.draft_amount, o.draft_amount) as draft_amount -- 票据金额
    ,nvl(n.buy_back_pay_interest, o.buy_back_pay_interest) as buy_back_pay_interest -- 赎回应付利息
    ,nvl(n.buy_back_amount, o.buy_back_amount) as buy_back_amount -- 赎回金额
    ,nvl(n.deal_status, o.deal_status) as deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作人
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票据(包)号
    ,nvl(n.cd_range, o.cd_range) as cd_range -- 子票区间
    ,nvl(n.buss_flag, o.buss_flag) as buss_flag -- 业务类型： 01 申请 02 签收
    ,nvl(n.brh_no, o.brh_no) as brh_no -- 本方机构号
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
from (select * from ${iol_schema}.bdms_cpes_buy_back_details_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_buy_back_details where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.contract_id <> n.contract_id
        or o.draft_id <> n.draft_id
        or o.valid_flag <> n.valid_flag
        or o.draft_amount <> n.draft_amount
        or o.buy_back_pay_interest <> n.buy_back_pay_interest
        or o.buy_back_amount <> n.buy_back_amount
        or o.deal_status <> n.deal_status
        or o.account_status <> n.account_status
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.draft_number <> n.draft_number
        or o.cd_range <> n.cd_range
        or o.buss_flag <> n.buss_flag
        or o.brh_no <> n.brh_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_buy_back_details_cl(
            id -- ID
            ,contract_id -- 批次表ID
            ,draft_id -- 票据ID
            ,valid_flag -- 有效标识 0 无效 1 有效
            ,draft_amount -- 票据金额
            ,buy_back_pay_interest -- 赎回应付利息
            ,buy_back_amount -- 赎回金额
            ,deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,draft_number -- 票据(包)号
            ,cd_range -- 子票区间
            ,buss_flag -- 业务类型： 01 申请 02 签收
            ,brh_no -- 本方机构号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_buy_back_details_op(
            id -- ID
            ,contract_id -- 批次表ID
            ,draft_id -- 票据ID
            ,valid_flag -- 有效标识 0 无效 1 有效
            ,draft_amount -- 票据金额
            ,buy_back_pay_interest -- 赎回应付利息
            ,buy_back_amount -- 赎回金额
            ,deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,draft_number -- 票据(包)号
            ,cd_range -- 子票区间
            ,buss_flag -- 业务类型： 01 申请 02 签收
            ,brh_no -- 本方机构号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.contract_id -- 批次表ID
    ,o.draft_id -- 票据ID
    ,o.valid_flag -- 有效标识 0 无效 1 有效
    ,o.draft_amount -- 票据金额
    ,o.buy_back_pay_interest -- 赎回应付利息
    ,o.buy_back_amount -- 赎回金额
    ,o.deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
    ,o.account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,o.last_upd_opr -- 最后操作人
    ,o.last_upd_time -- 最后修改时间
    ,o.draft_number -- 票据(包)号
    ,o.cd_range -- 子票区间
    ,o.buss_flag -- 业务类型： 01 申请 02 签收
    ,o.brh_no -- 本方机构号
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
from ${iol_schema}.bdms_cpes_buy_back_details_bk o
    left join ${iol_schema}.bdms_cpes_buy_back_details_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_buy_back_details_cl d
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
--truncate table ${iol_schema}.bdms_cpes_buy_back_details;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_cpes_buy_back_details') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_cpes_buy_back_details drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_cpes_buy_back_details add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_cpes_buy_back_details exchange partition p_${batch_date} with table ${iol_schema}.bdms_cpes_buy_back_details_cl;
alter table ${iol_schema}.bdms_cpes_buy_back_details exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_buy_back_details_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_buy_back_details to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_buy_back_details_op purge;
drop table ${iol_schema}.bdms_cpes_buy_back_details_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_buy_back_details_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_buy_back_details',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
