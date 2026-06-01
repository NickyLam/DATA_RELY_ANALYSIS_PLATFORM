/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ppps_t_merchant_info
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
create table ${iol_schema}.ppps_t_merchant_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ppps_t_merchant_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ppps_t_merchant_info_op purge;
drop table ${iol_schema}.ppps_t_merchant_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ppps_t_merchant_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ppps_t_merchant_info where 0=1;

create table ${iol_schema}.ppps_t_merchant_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ppps_t_merchant_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ppps_t_merchant_info_cl(
            sign_no -- 协议号
            ,payee_acct_no -- 收款账号
            ,payee_acct_name -- 申请企业名称
            ,intra_acct_no -- 内部账户
            ,intra_acct_name -- 内部账户户名
            ,branch_no -- 商户归属机构
            ,business_scope -- 经营范围
            ,legitimacy -- 是否符合经营范围
            ,business_license -- 营业执照号码
            ,active -- 启用状态
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,mer_type -- 商户类别
            ,pty_num -- 客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ppps_t_merchant_info_op(
            sign_no -- 协议号
            ,payee_acct_no -- 收款账号
            ,payee_acct_name -- 申请企业名称
            ,intra_acct_no -- 内部账户
            ,intra_acct_name -- 内部账户户名
            ,branch_no -- 商户归属机构
            ,business_scope -- 经营范围
            ,legitimacy -- 是否符合经营范围
            ,business_license -- 营业执照号码
            ,active -- 启用状态
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,mer_type -- 商户类别
            ,pty_num -- 客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sign_no, o.sign_no) as sign_no -- 协议号
    ,nvl(n.payee_acct_no, o.payee_acct_no) as payee_acct_no -- 收款账号
    ,nvl(n.payee_acct_name, o.payee_acct_name) as payee_acct_name -- 申请企业名称
    ,nvl(n.intra_acct_no, o.intra_acct_no) as intra_acct_no -- 内部账户
    ,nvl(n.intra_acct_name, o.intra_acct_name) as intra_acct_name -- 内部账户户名
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 商户归属机构
    ,nvl(n.business_scope, o.business_scope) as business_scope -- 经营范围
    ,nvl(n.legitimacy, o.legitimacy) as legitimacy -- 是否符合经营范围
    ,nvl(n.business_license, o.business_license) as business_license -- 营业执照号码
    ,nvl(n.active, o.active) as active -- 启用状态
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.mer_type, o.mer_type) as mer_type -- 商户类别
    ,nvl(n.pty_num, o.pty_num) as pty_num -- 客户号
    ,case when
            n.sign_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sign_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sign_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ppps_t_merchant_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ppps_t_merchant_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sign_no = n.sign_no
where (
        o.sign_no is null
    )
    or (
        n.sign_no is null
    )
    or (
        o.payee_acct_no <> n.payee_acct_no
        or o.payee_acct_name <> n.payee_acct_name
        or o.intra_acct_no <> n.intra_acct_no
        or o.intra_acct_name <> n.intra_acct_name
        or o.branch_no <> n.branch_no
        or o.business_scope <> n.business_scope
        or o.legitimacy <> n.legitimacy
        or o.business_license <> n.business_license
        or o.active <> n.active
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.mer_type <> n.mer_type
        or o.pty_num <> n.pty_num
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ppps_t_merchant_info_cl(
            sign_no -- 协议号
            ,payee_acct_no -- 收款账号
            ,payee_acct_name -- 申请企业名称
            ,intra_acct_no -- 内部账户
            ,intra_acct_name -- 内部账户户名
            ,branch_no -- 商户归属机构
            ,business_scope -- 经营范围
            ,legitimacy -- 是否符合经营范围
            ,business_license -- 营业执照号码
            ,active -- 启用状态
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,mer_type -- 商户类别
            ,pty_num -- 客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ppps_t_merchant_info_op(
            sign_no -- 协议号
            ,payee_acct_no -- 收款账号
            ,payee_acct_name -- 申请企业名称
            ,intra_acct_no -- 内部账户
            ,intra_acct_name -- 内部账户户名
            ,branch_no -- 商户归属机构
            ,business_scope -- 经营范围
            ,legitimacy -- 是否符合经营范围
            ,business_license -- 营业执照号码
            ,active -- 启用状态
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,mer_type -- 商户类别
            ,pty_num -- 客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sign_no -- 协议号
    ,o.payee_acct_no -- 收款账号
    ,o.payee_acct_name -- 申请企业名称
    ,o.intra_acct_no -- 内部账户
    ,o.intra_acct_name -- 内部账户户名
    ,o.branch_no -- 商户归属机构
    ,o.business_scope -- 经营范围
    ,o.legitimacy -- 是否符合经营范围
    ,o.business_license -- 营业执照号码
    ,o.active -- 启用状态
    ,o.create_time -- 创建时间
    ,o.update_time -- 更新时间
    ,o.mer_type -- 商户类别
    ,o.pty_num -- 客户号
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
from ${iol_schema}.ppps_t_merchant_info_bk o
    left join ${iol_schema}.ppps_t_merchant_info_op n
        on
            o.sign_no = n.sign_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ppps_t_merchant_info_cl d
        on
            o.sign_no = d.sign_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ppps_t_merchant_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ppps_t_merchant_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ppps_t_merchant_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ppps_t_merchant_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ppps_t_merchant_info exchange partition p_${batch_date} with table ${iol_schema}.ppps_t_merchant_info_cl;
alter table ${iol_schema}.ppps_t_merchant_info exchange partition p_20991231 with table ${iol_schema}.ppps_t_merchant_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ppps_t_merchant_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ppps_t_merchant_info_op purge;
drop table ${iol_schema}.ppps_t_merchant_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ppps_t_merchant_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ppps_t_merchant_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
