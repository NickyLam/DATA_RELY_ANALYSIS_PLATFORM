/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_pcp_group_def
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
create table ${iol_schema}.ncbs_rb_pcp_group_def_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_pcp_group_def
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_pcp_group_def_op purge;
drop table ${iol_schema}.ncbs_rb_pcp_group_def_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_pcp_group_def_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_pcp_group_def where 0=1;

create table ${iol_schema}.ncbs_rb_pcp_group_def_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_pcp_group_def where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_pcp_group_def_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,acct_group_status -- 账户组状态
            ,both_part_nature -- 收支属性
            ,charge_way -- 收费方式
            ,company -- 法人
            ,group_ccy -- 币种组
            ,group_name -- 账户组名称
            ,main_agreement_id -- 主协议协议号
            ,pcp_group_id -- 资金池账户组id
            ,upper_group_id -- 上级组id
            ,create_date -- 创建日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,auth_user_id -- 授权柜员
            ,charge_amt -- 收费金额
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_pcp_group_def_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,acct_group_status -- 账户组状态
            ,both_part_nature -- 收支属性
            ,charge_way -- 收费方式
            ,company -- 法人
            ,group_ccy -- 币种组
            ,group_name -- 账户组名称
            ,main_agreement_id -- 主协议协议号
            ,pcp_group_id -- 资金池账户组id
            ,upper_group_id -- 上级组id
            ,create_date -- 创建日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,auth_user_id -- 授权柜员
            ,charge_amt -- 收费金额
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.acct_group_status, o.acct_group_status) as acct_group_status -- 账户组状态
    ,nvl(n.both_part_nature, o.both_part_nature) as both_part_nature -- 收支属性
    ,nvl(n.charge_way, o.charge_way) as charge_way -- 收费方式
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.group_ccy, o.group_ccy) as group_ccy -- 币种组
    ,nvl(n.group_name, o.group_name) as group_name -- 账户组名称
    ,nvl(n.main_agreement_id, o.main_agreement_id) as main_agreement_id -- 主协议协议号
    ,nvl(n.pcp_group_id, o.pcp_group_id) as pcp_group_id -- 资金池账户组id
    ,nvl(n.upper_group_id, o.upper_group_id) as upper_group_id -- 上级组id
    ,nvl(n.create_date, o.create_date) as create_date -- 创建日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.auth_user_id, o.auth_user_id) as auth_user_id -- 授权柜员
    ,nvl(n.charge_amt, o.charge_amt) as charge_amt -- 收费金额
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,case when
            n.pcp_group_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pcp_group_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pcp_group_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_pcp_group_def_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_pcp_group_def where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pcp_group_id = n.pcp_group_id
where (
        o.pcp_group_id is null
    )
    or (
        n.pcp_group_id is null
    )
    or (
        o.acct_seq_no <> n.acct_seq_no
        or o.base_acct_no <> n.base_acct_no
        or o.client_no <> n.client_no
        or o.internal_key <> n.internal_key
        or o.prod_type <> n.prod_type
        or o.user_id <> n.user_id
        or o.acct_group_status <> n.acct_group_status
        or o.both_part_nature <> n.both_part_nature
        or o.charge_way <> n.charge_way
        or o.company <> n.company
        or o.group_ccy <> n.group_ccy
        or o.group_name <> n.group_name
        or o.main_agreement_id <> n.main_agreement_id
        or o.upper_group_id <> n.upper_group_id
        or o.create_date <> n.create_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.acct_ccy <> n.acct_ccy
        or o.auth_user_id <> n.auth_user_id
        or o.charge_amt <> n.charge_amt
        or o.tran_branch <> n.tran_branch
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_pcp_group_def_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,acct_group_status -- 账户组状态
            ,both_part_nature -- 收支属性
            ,charge_way -- 收费方式
            ,company -- 法人
            ,group_ccy -- 币种组
            ,group_name -- 账户组名称
            ,main_agreement_id -- 主协议协议号
            ,pcp_group_id -- 资金池账户组id
            ,upper_group_id -- 上级组id
            ,create_date -- 创建日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,auth_user_id -- 授权柜员
            ,charge_amt -- 收费金额
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_pcp_group_def_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,acct_group_status -- 账户组状态
            ,both_part_nature -- 收支属性
            ,charge_way -- 收费方式
            ,company -- 法人
            ,group_ccy -- 币种组
            ,group_name -- 账户组名称
            ,main_agreement_id -- 主协议协议号
            ,pcp_group_id -- 资金池账户组id
            ,upper_group_id -- 上级组id
            ,create_date -- 创建日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,auth_user_id -- 授权柜员
            ,charge_amt -- 收费金额
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_seq_no -- 账户子账号
    ,o.base_acct_no -- 交易账号/卡号
    ,o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.user_id -- 交易柜员编号
    ,o.acct_group_status -- 账户组状态
    ,o.both_part_nature -- 收支属性
    ,o.charge_way -- 收费方式
    ,o.company -- 法人
    ,o.group_ccy -- 币种组
    ,o.group_name -- 账户组名称
    ,o.main_agreement_id -- 主协议协议号
    ,o.pcp_group_id -- 资金池账户组id
    ,o.upper_group_id -- 上级组id
    ,o.create_date -- 创建日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.acct_ccy -- 账户币种
    ,o.auth_user_id -- 授权柜员
    ,o.charge_amt -- 收费金额
    ,o.tran_branch -- 核心交易机构编号
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
from ${iol_schema}.ncbs_rb_pcp_group_def_bk o
    left join ${iol_schema}.ncbs_rb_pcp_group_def_op n
        on
            o.pcp_group_id = n.pcp_group_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_pcp_group_def_cl d
        on
            o.pcp_group_id = d.pcp_group_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_pcp_group_def;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_pcp_group_def') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_pcp_group_def drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_pcp_group_def add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_pcp_group_def exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_pcp_group_def_cl;
alter table ${iol_schema}.ncbs_rb_pcp_group_def exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_pcp_group_def_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_pcp_group_def to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_pcp_group_def_op purge;
drop table ${iol_schema}.ncbs_rb_pcp_group_def_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_pcp_group_def_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_pcp_group_def',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
