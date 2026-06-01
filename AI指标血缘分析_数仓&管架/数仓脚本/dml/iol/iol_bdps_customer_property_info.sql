/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_customer_property_info
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
create table ${iol_schema}.bdps_customer_property_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdps_customer_property_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_customer_property_info_op purge;
drop table ${iol_schema}.bdps_customer_property_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_customer_property_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_customer_property_info where 0=1;

create table ${iol_schema}.bdps_customer_property_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_customer_property_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_customer_property_info_cl(
            id -- 
            ,property_type -- 资产种类 1-理财产品
            ,property_id -- 资产ID
            ,property_name -- 资产名
            ,property_amount -- 金额
            ,owner_cust_id -- 所属客户ID
            ,effective_date -- 生效日
            ,maturity_date -- 到期日
            ,status -- 资产状态 99-无效 52-已结清 92-资产池入池 93-资产池出池
            ,tmp_status -- 处理中状态  00-处理结束 11-质押处理中 12-解除质押处理中
            ,property_source -- 系统简称
            ,channel_source -- 系统简称
            ,last_upd_oper_id -- 最后更新操作员
            ,last_upd_time -- 最后更新时间
            ,remark -- 备注
            ,branch_id -- 机构ID
            ,property_no -- 资产编号
            ,ebank_cancel_id -- 交易门户出池任务ID
            ,ebank_apply_id -- EBANK_APPLY_ID  交易门户入池申请任务ID
            ,bank_account -- 银行账号
            ,auto_flag -- 自动入池
            ,blip_seq -- 影像流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_customer_property_info_op(
            id -- 
            ,property_type -- 资产种类 1-理财产品
            ,property_id -- 资产ID
            ,property_name -- 资产名
            ,property_amount -- 金额
            ,owner_cust_id -- 所属客户ID
            ,effective_date -- 生效日
            ,maturity_date -- 到期日
            ,status -- 资产状态 99-无效 52-已结清 92-资产池入池 93-资产池出池
            ,tmp_status -- 处理中状态  00-处理结束 11-质押处理中 12-解除质押处理中
            ,property_source -- 系统简称
            ,channel_source -- 系统简称
            ,last_upd_oper_id -- 最后更新操作员
            ,last_upd_time -- 最后更新时间
            ,remark -- 备注
            ,branch_id -- 机构ID
            ,property_no -- 资产编号
            ,ebank_cancel_id -- 交易门户出池任务ID
            ,ebank_apply_id -- EBANK_APPLY_ID  交易门户入池申请任务ID
            ,bank_account -- 银行账号
            ,auto_flag -- 自动入池
            ,blip_seq -- 影像流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.property_type, o.property_type) as property_type -- 资产种类 1-理财产品
    ,nvl(n.property_id, o.property_id) as property_id -- 资产ID
    ,nvl(n.property_name, o.property_name) as property_name -- 资产名
    ,nvl(n.property_amount, o.property_amount) as property_amount -- 金额
    ,nvl(n.owner_cust_id, o.owner_cust_id) as owner_cust_id -- 所属客户ID
    ,nvl(n.effective_date, o.effective_date) as effective_date -- 生效日
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期日
    ,nvl(n.status, o.status) as status -- 资产状态 99-无效 52-已结清 92-资产池入池 93-资产池出池
    ,nvl(n.tmp_status, o.tmp_status) as tmp_status -- 处理中状态  00-处理结束 11-质押处理中 12-解除质押处理中
    ,nvl(n.property_source, o.property_source) as property_source -- 系统简称
    ,nvl(n.channel_source, o.channel_source) as channel_source -- 系统简称
    ,nvl(n.last_upd_oper_id, o.last_upd_oper_id) as last_upd_oper_id -- 最后更新操作员
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后更新时间
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.branch_id, o.branch_id) as branch_id -- 机构ID
    ,nvl(n.property_no, o.property_no) as property_no -- 资产编号
    ,nvl(n.ebank_cancel_id, o.ebank_cancel_id) as ebank_cancel_id -- 交易门户出池任务ID
    ,nvl(n.ebank_apply_id, o.ebank_apply_id) as ebank_apply_id -- EBANK_APPLY_ID  交易门户入池申请任务ID
    ,nvl(n.bank_account, o.bank_account) as bank_account -- 银行账号
    ,nvl(n.auto_flag, o.auto_flag) as auto_flag -- 自动入池
    ,nvl(n.blip_seq, o.blip_seq) as blip_seq -- 影像流水号
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
from (select * from ${iol_schema}.bdps_customer_property_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdps_customer_property_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.property_type <> n.property_type
        or o.property_id <> n.property_id
        or o.property_name <> n.property_name
        or o.property_amount <> n.property_amount
        or o.owner_cust_id <> n.owner_cust_id
        or o.effective_date <> n.effective_date
        or o.maturity_date <> n.maturity_date
        or o.status <> n.status
        or o.tmp_status <> n.tmp_status
        or o.property_source <> n.property_source
        or o.channel_source <> n.channel_source
        or o.last_upd_oper_id <> n.last_upd_oper_id
        or o.last_upd_time <> n.last_upd_time
        or o.remark <> n.remark
        or o.branch_id <> n.branch_id
        or o.property_no <> n.property_no
        or o.ebank_cancel_id <> n.ebank_cancel_id
        or o.ebank_apply_id <> n.ebank_apply_id
        or o.bank_account <> n.bank_account
        or o.auto_flag <> n.auto_flag
        or o.blip_seq <> n.blip_seq
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_customer_property_info_cl(
            id -- 
            ,property_type -- 资产种类 1-理财产品
            ,property_id -- 资产ID
            ,property_name -- 资产名
            ,property_amount -- 金额
            ,owner_cust_id -- 所属客户ID
            ,effective_date -- 生效日
            ,maturity_date -- 到期日
            ,status -- 资产状态 99-无效 52-已结清 92-资产池入池 93-资产池出池
            ,tmp_status -- 处理中状态  00-处理结束 11-质押处理中 12-解除质押处理中
            ,property_source -- 系统简称
            ,channel_source -- 系统简称
            ,last_upd_oper_id -- 最后更新操作员
            ,last_upd_time -- 最后更新时间
            ,remark -- 备注
            ,branch_id -- 机构ID
            ,property_no -- 资产编号
            ,ebank_cancel_id -- 交易门户出池任务ID
            ,ebank_apply_id -- EBANK_APPLY_ID  交易门户入池申请任务ID
            ,bank_account -- 银行账号
            ,auto_flag -- 自动入池
            ,blip_seq -- 影像流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_customer_property_info_op(
            id -- 
            ,property_type -- 资产种类 1-理财产品
            ,property_id -- 资产ID
            ,property_name -- 资产名
            ,property_amount -- 金额
            ,owner_cust_id -- 所属客户ID
            ,effective_date -- 生效日
            ,maturity_date -- 到期日
            ,status -- 资产状态 99-无效 52-已结清 92-资产池入池 93-资产池出池
            ,tmp_status -- 处理中状态  00-处理结束 11-质押处理中 12-解除质押处理中
            ,property_source -- 系统简称
            ,channel_source -- 系统简称
            ,last_upd_oper_id -- 最后更新操作员
            ,last_upd_time -- 最后更新时间
            ,remark -- 备注
            ,branch_id -- 机构ID
            ,property_no -- 资产编号
            ,ebank_cancel_id -- 交易门户出池任务ID
            ,ebank_apply_id -- EBANK_APPLY_ID  交易门户入池申请任务ID
            ,bank_account -- 银行账号
            ,auto_flag -- 自动入池
            ,blip_seq -- 影像流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.property_type -- 资产种类 1-理财产品
    ,o.property_id -- 资产ID
    ,o.property_name -- 资产名
    ,o.property_amount -- 金额
    ,o.owner_cust_id -- 所属客户ID
    ,o.effective_date -- 生效日
    ,o.maturity_date -- 到期日
    ,o.status -- 资产状态 99-无效 52-已结清 92-资产池入池 93-资产池出池
    ,o.tmp_status -- 处理中状态  00-处理结束 11-质押处理中 12-解除质押处理中
    ,o.property_source -- 系统简称
    ,o.channel_source -- 系统简称
    ,o.last_upd_oper_id -- 最后更新操作员
    ,o.last_upd_time -- 最后更新时间
    ,o.remark -- 备注
    ,o.branch_id -- 机构ID
    ,o.property_no -- 资产编号
    ,o.ebank_cancel_id -- 交易门户出池任务ID
    ,o.ebank_apply_id -- EBANK_APPLY_ID  交易门户入池申请任务ID
    ,o.bank_account -- 银行账号
    ,o.auto_flag -- 自动入池
    ,o.blip_seq -- 影像流水号
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
from ${iol_schema}.bdps_customer_property_info_bk o
    left join ${iol_schema}.bdps_customer_property_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdps_customer_property_info_cl d
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
--truncate table ${iol_schema}.bdps_customer_property_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdps_customer_property_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdps_customer_property_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdps_customer_property_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdps_customer_property_info exchange partition p_${batch_date} with table ${iol_schema}.bdps_customer_property_info_cl;
alter table ${iol_schema}.bdps_customer_property_info exchange partition p_20991231 with table ${iol_schema}.bdps_customer_property_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdps_customer_property_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_customer_property_info_op purge;
drop table ${iol_schema}.bdps_customer_property_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdps_customer_property_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdps_customer_property_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
