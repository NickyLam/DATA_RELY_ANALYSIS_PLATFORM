/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_ban_inside_account
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
create table ${iol_schema}.fams_ban_inside_account_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_ban_inside_account;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_ban_inside_account_op purge;
drop table ${iol_schema}.fams_ban_inside_account_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_ban_inside_account_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_ban_inside_account where 0=1;

create table ${iol_schema}.fams_ban_inside_account_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_ban_inside_account where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_ban_inside_account_cl(
            prodcode -- 产品代码
            ,orgcode -- 机构号
            ,subject -- 科目号
            ,acct_no -- 内部户
            ,acct_name -- 内部户名称
            ,acct_type -- 账户类型: 01产品; 02资产
            ,saletarget -- 销售对象: 01个人; 02对公; 03同业
            ,effectflag -- 有效状态: 01有效; 02无效
            ,match_type -- 匹配方式: 01自动匹; 02固定
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_ban_inside_account_op(
            prodcode -- 产品代码
            ,orgcode -- 机构号
            ,subject -- 科目号
            ,acct_no -- 内部户
            ,acct_name -- 内部户名称
            ,acct_type -- 账户类型: 01产品; 02资产
            ,saletarget -- 销售对象: 01个人; 02对公; 03同业
            ,effectflag -- 有效状态: 01有效; 02无效
            ,match_type -- 匹配方式: 01自动匹; 02固定
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prodcode, o.prodcode) as prodcode -- 产品代码
    ,nvl(n.orgcode, o.orgcode) as orgcode -- 机构号
    ,nvl(n.subject, o.subject) as subject -- 科目号
    ,nvl(n.acct_no, o.acct_no) as acct_no -- 内部户
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 内部户名称
    ,nvl(n.acct_type, o.acct_type) as acct_type -- 账户类型: 01产品; 02资产
    ,nvl(n.saletarget, o.saletarget) as saletarget -- 销售对象: 01个人; 02对公; 03同业
    ,nvl(n.effectflag, o.effectflag) as effectflag -- 有效状态: 01有效; 02无效
    ,nvl(n.match_type, o.match_type) as match_type -- 匹配方式: 01自动匹; 02固定
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,case when
            n.prodcode is null
            and n.orgcode is null
            and n.subject is null
            and n.effectflag is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prodcode is null
            and n.orgcode is null
            and n.subject is null
            and n.effectflag is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prodcode is null
            and n.orgcode is null
            and n.subject is null
            and n.effectflag is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_ban_inside_account_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_ban_inside_account where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.prodcode = n.prodcode
            and o.orgcode = n.orgcode
            and o.subject = n.subject
            and o.effectflag = n.effectflag
where (
        o.prodcode is null
        and o.orgcode is null
        and o.subject is null
        and o.effectflag is null
    )
    or (
        n.prodcode is null
        and n.orgcode is null
        and n.subject is null
        and n.effectflag is null
    )
    or (
        o.acct_no <> n.acct_no
        or o.acct_name <> n.acct_name
        or o.acct_type <> n.acct_type
        or o.saletarget <> n.saletarget
        or o.match_type <> n.match_type
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_ban_inside_account_cl(
            prodcode -- 产品代码
            ,orgcode -- 机构号
            ,subject -- 科目号
            ,acct_no -- 内部户
            ,acct_name -- 内部户名称
            ,acct_type -- 账户类型: 01产品; 02资产
            ,saletarget -- 销售对象: 01个人; 02对公; 03同业
            ,effectflag -- 有效状态: 01有效; 02无效
            ,match_type -- 匹配方式: 01自动匹; 02固定
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_ban_inside_account_op(
            prodcode -- 产品代码
            ,orgcode -- 机构号
            ,subject -- 科目号
            ,acct_no -- 内部户
            ,acct_name -- 内部户名称
            ,acct_type -- 账户类型: 01产品; 02资产
            ,saletarget -- 销售对象: 01个人; 02对公; 03同业
            ,effectflag -- 有效状态: 01有效; 02无效
            ,match_type -- 匹配方式: 01自动匹; 02固定
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prodcode -- 产品代码
    ,o.orgcode -- 机构号
    ,o.subject -- 科目号
    ,o.acct_no -- 内部户
    ,o.acct_name -- 内部户名称
    ,o.acct_type -- 账户类型: 01产品; 02资产
    ,o.saletarget -- 销售对象: 01个人; 02对公; 03同业
    ,o.effectflag -- 有效状态: 01有效; 02无效
    ,o.match_type -- 匹配方式: 01自动匹; 02固定
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.fams_ban_inside_account_bk o
    left join ${iol_schema}.fams_ban_inside_account_op n
        on
            o.prodcode = n.prodcode
            and o.orgcode = n.orgcode
            and o.subject = n.subject
            and o.effectflag = n.effectflag
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_ban_inside_account_cl d
        on
            o.prodcode = d.prodcode
            and o.orgcode = d.orgcode
            and o.subject = d.subject
            and o.effectflag = d.effectflag
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.fams_ban_inside_account;

-- 4.2 exchange partition
alter table ${iol_schema}.fams_ban_inside_account exchange partition p_19000101 with table ${iol_schema}.fams_ban_inside_account_cl;
alter table ${iol_schema}.fams_ban_inside_account exchange partition p_20991231 with table ${iol_schema}.fams_ban_inside_account_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_ban_inside_account to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_ban_inside_account_op purge;
drop table ${iol_schema}.fams_ban_inside_account_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_ban_inside_account_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_ban_inside_account',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
