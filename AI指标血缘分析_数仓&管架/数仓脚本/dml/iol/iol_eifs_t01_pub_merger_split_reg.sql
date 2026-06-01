/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t01_pub_merger_split_reg
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
create table ${iol_schema}.eifs_t01_pub_merger_split_reg_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.eifs_t01_pub_merger_split_reg
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t01_pub_merger_split_reg_op purge;
drop table ${iol_schema}.eifs_t01_pub_merger_split_reg_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t01_pub_merger_split_reg_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t01_pub_merger_split_reg where 0=1;

create table ${iol_schema}.eifs_t01_pub_merger_split_reg_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t01_pub_merger_split_reg where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t01_pub_merger_split_reg_cl(
            exchange_id -- 修改编号
            ,left_party_id -- 保留方party_id
            ,left_cust_no -- 保留方客户号
            ,left_blg_org -- 保留方归属机构
            ,left_cust_name -- 保留方客户名称
            ,left_cert_type -- 保留方证件类型
            ,left_cert_no -- 保留方证件号码
            ,merged_party_id -- 被归并方party_id
            ,merged_cust_no -- 被归并方客户号
            ,merged_blg_org -- 被归并客户归属机构
            ,merged_cust_name -- 被归并方客户名称
            ,merged_cert_type -- 被归并方证件类型
            ,merged_cert_no -- 被归并方证件号码
            ,merged_state -- 归并状态
            ,merged_date -- 归并日期
            ,merged_org -- 归并机构
            ,merged_te -- 归并柜员
            ,split_date -- 拆分日期
            ,split_org -- 拆分机构
            ,split_te -- 拆分柜员
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t01_pub_merger_split_reg_op(
            exchange_id -- 修改编号
            ,left_party_id -- 保留方party_id
            ,left_cust_no -- 保留方客户号
            ,left_blg_org -- 保留方归属机构
            ,left_cust_name -- 保留方客户名称
            ,left_cert_type -- 保留方证件类型
            ,left_cert_no -- 保留方证件号码
            ,merged_party_id -- 被归并方party_id
            ,merged_cust_no -- 被归并方客户号
            ,merged_blg_org -- 被归并客户归属机构
            ,merged_cust_name -- 被归并方客户名称
            ,merged_cert_type -- 被归并方证件类型
            ,merged_cert_no -- 被归并方证件号码
            ,merged_state -- 归并状态
            ,merged_date -- 归并日期
            ,merged_org -- 归并机构
            ,merged_te -- 归并柜员
            ,split_date -- 拆分日期
            ,split_org -- 拆分机构
            ,split_te -- 拆分柜员
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.exchange_id, o.exchange_id) as exchange_id -- 修改编号
    ,nvl(n.left_party_id, o.left_party_id) as left_party_id -- 保留方party_id
    ,nvl(n.left_cust_no, o.left_cust_no) as left_cust_no -- 保留方客户号
    ,nvl(n.left_blg_org, o.left_blg_org) as left_blg_org -- 保留方归属机构
    ,nvl(n.left_cust_name, o.left_cust_name) as left_cust_name -- 保留方客户名称
    ,nvl(n.left_cert_type, o.left_cert_type) as left_cert_type -- 保留方证件类型
    ,nvl(n.left_cert_no, o.left_cert_no) as left_cert_no -- 保留方证件号码
    ,nvl(n.merged_party_id, o.merged_party_id) as merged_party_id -- 被归并方party_id
    ,nvl(n.merged_cust_no, o.merged_cust_no) as merged_cust_no -- 被归并方客户号
    ,nvl(n.merged_blg_org, o.merged_blg_org) as merged_blg_org -- 被归并客户归属机构
    ,nvl(n.merged_cust_name, o.merged_cust_name) as merged_cust_name -- 被归并方客户名称
    ,nvl(n.merged_cert_type, o.merged_cert_type) as merged_cert_type -- 被归并方证件类型
    ,nvl(n.merged_cert_no, o.merged_cert_no) as merged_cert_no -- 被归并方证件号码
    ,nvl(n.merged_state, o.merged_state) as merged_state -- 归并状态
    ,nvl(n.merged_date, o.merged_date) as merged_date -- 归并日期
    ,nvl(n.merged_org, o.merged_org) as merged_org -- 归并机构
    ,nvl(n.merged_te, o.merged_te) as merged_te -- 归并柜员
    ,nvl(n.split_date, o.split_date) as split_date -- 拆分日期
    ,nvl(n.split_org, o.split_org) as split_org -- 拆分机构
    ,nvl(n.split_te, o.split_te) as split_te -- 拆分柜员
    ,nvl(n.create_te, o.create_te) as create_te -- 创建柜员
    ,nvl(n.create_org, o.create_org) as create_org -- 创建机构号
    ,nvl(n.init_system_id, o.init_system_id) as init_system_id -- 创建渠道
    ,nvl(n.init_created_ts, o.init_created_ts) as init_created_ts -- 源系统创建时间
    ,nvl(n.created_ts, o.created_ts) as created_ts -- 进入ecif的时间
    ,nvl(n.updated_ts, o.updated_ts) as updated_ts -- 在ecif中失效的时间
    ,nvl(n.last_updated_te, o.last_updated_te) as last_updated_te -- 最新更新柜员
    ,nvl(n.last_updated_org, o.last_updated_org) as last_updated_org -- 最新更新机构号
    ,nvl(n.last_system_id, o.last_system_id) as last_system_id -- 最新更新渠道
    ,nvl(n.last_updated_ts, o.last_updated_ts) as last_updated_ts -- 最新更新时间
    ,nvl(n.src_sys_num, o.src_sys_num) as src_sys_num -- 来源系统编号
    ,nvl(n.last_updated_src_sys_num, o.last_updated_src_sys_num) as last_updated_src_sys_num -- 最新更新源系统编号
    ,case when
            n.exchange_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.exchange_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.exchange_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.eifs_t01_pub_merger_split_reg_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.eifs_t01_pub_merger_split_reg where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.exchange_id = n.exchange_id
where (
        o.exchange_id is null
    )
    or (
        n.exchange_id is null
    )
    or (
        o.left_party_id <> n.left_party_id
        or o.left_cust_no <> n.left_cust_no
        or o.left_blg_org <> n.left_blg_org
        or o.left_cust_name <> n.left_cust_name
        or o.left_cert_type <> n.left_cert_type
        or o.left_cert_no <> n.left_cert_no
        or o.merged_party_id <> n.merged_party_id
        or o.merged_cust_no <> n.merged_cust_no
        or o.merged_blg_org <> n.merged_blg_org
        or o.merged_cust_name <> n.merged_cust_name
        or o.merged_cert_type <> n.merged_cert_type
        or o.merged_cert_no <> n.merged_cert_no
        or o.merged_state <> n.merged_state
        or o.merged_date <> n.merged_date
        or o.merged_org <> n.merged_org
        or o.merged_te <> n.merged_te
        or o.split_date <> n.split_date
        or o.split_org <> n.split_org
        or o.split_te <> n.split_te
        or o.create_te <> n.create_te
        or o.create_org <> n.create_org
        or o.init_system_id <> n.init_system_id
        or o.init_created_ts <> n.init_created_ts
        or o.created_ts <> n.created_ts
        or o.updated_ts <> n.updated_ts
        or o.last_updated_te <> n.last_updated_te
        or o.last_updated_org <> n.last_updated_org
        or o.last_system_id <> n.last_system_id
        or o.last_updated_ts <> n.last_updated_ts
        or o.src_sys_num <> n.src_sys_num
        or o.last_updated_src_sys_num <> n.last_updated_src_sys_num
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t01_pub_merger_split_reg_cl(
            exchange_id -- 修改编号
            ,left_party_id -- 保留方party_id
            ,left_cust_no -- 保留方客户号
            ,left_blg_org -- 保留方归属机构
            ,left_cust_name -- 保留方客户名称
            ,left_cert_type -- 保留方证件类型
            ,left_cert_no -- 保留方证件号码
            ,merged_party_id -- 被归并方party_id
            ,merged_cust_no -- 被归并方客户号
            ,merged_blg_org -- 被归并客户归属机构
            ,merged_cust_name -- 被归并方客户名称
            ,merged_cert_type -- 被归并方证件类型
            ,merged_cert_no -- 被归并方证件号码
            ,merged_state -- 归并状态
            ,merged_date -- 归并日期
            ,merged_org -- 归并机构
            ,merged_te -- 归并柜员
            ,split_date -- 拆分日期
            ,split_org -- 拆分机构
            ,split_te -- 拆分柜员
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t01_pub_merger_split_reg_op(
            exchange_id -- 修改编号
            ,left_party_id -- 保留方party_id
            ,left_cust_no -- 保留方客户号
            ,left_blg_org -- 保留方归属机构
            ,left_cust_name -- 保留方客户名称
            ,left_cert_type -- 保留方证件类型
            ,left_cert_no -- 保留方证件号码
            ,merged_party_id -- 被归并方party_id
            ,merged_cust_no -- 被归并方客户号
            ,merged_blg_org -- 被归并客户归属机构
            ,merged_cust_name -- 被归并方客户名称
            ,merged_cert_type -- 被归并方证件类型
            ,merged_cert_no -- 被归并方证件号码
            ,merged_state -- 归并状态
            ,merged_date -- 归并日期
            ,merged_org -- 归并机构
            ,merged_te -- 归并柜员
            ,split_date -- 拆分日期
            ,split_org -- 拆分机构
            ,split_te -- 拆分柜员
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.exchange_id -- 修改编号
    ,o.left_party_id -- 保留方party_id
    ,o.left_cust_no -- 保留方客户号
    ,o.left_blg_org -- 保留方归属机构
    ,o.left_cust_name -- 保留方客户名称
    ,o.left_cert_type -- 保留方证件类型
    ,o.left_cert_no -- 保留方证件号码
    ,o.merged_party_id -- 被归并方party_id
    ,o.merged_cust_no -- 被归并方客户号
    ,o.merged_blg_org -- 被归并客户归属机构
    ,o.merged_cust_name -- 被归并方客户名称
    ,o.merged_cert_type -- 被归并方证件类型
    ,o.merged_cert_no -- 被归并方证件号码
    ,o.merged_state -- 归并状态
    ,o.merged_date -- 归并日期
    ,o.merged_org -- 归并机构
    ,o.merged_te -- 归并柜员
    ,o.split_date -- 拆分日期
    ,o.split_org -- 拆分机构
    ,o.split_te -- 拆分柜员
    ,o.create_te -- 创建柜员
    ,o.create_org -- 创建机构号
    ,o.init_system_id -- 创建渠道
    ,o.init_created_ts -- 源系统创建时间
    ,o.created_ts -- 进入ecif的时间
    ,o.updated_ts -- 在ecif中失效的时间
    ,o.last_updated_te -- 最新更新柜员
    ,o.last_updated_org -- 最新更新机构号
    ,o.last_system_id -- 最新更新渠道
    ,o.last_updated_ts -- 最新更新时间
    ,o.src_sys_num -- 来源系统编号
    ,o.last_updated_src_sys_num -- 最新更新源系统编号
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
from ${iol_schema}.eifs_t01_pub_merger_split_reg_bk o
    left join ${iol_schema}.eifs_t01_pub_merger_split_reg_op n
        on
            o.exchange_id = n.exchange_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.eifs_t01_pub_merger_split_reg_cl d
        on
            o.exchange_id = d.exchange_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.eifs_t01_pub_merger_split_reg;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('eifs_t01_pub_merger_split_reg') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.eifs_t01_pub_merger_split_reg drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.eifs_t01_pub_merger_split_reg add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.eifs_t01_pub_merger_split_reg exchange partition p_${batch_date} with table ${iol_schema}.eifs_t01_pub_merger_split_reg_cl;
alter table ${iol_schema}.eifs_t01_pub_merger_split_reg exchange partition p_20991231 with table ${iol_schema}.eifs_t01_pub_merger_split_reg_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.eifs_t01_pub_merger_split_reg to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t01_pub_merger_split_reg_op purge;
drop table ${iol_schema}.eifs_t01_pub_merger_split_reg_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.eifs_t01_pub_merger_split_reg_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'eifs_t01_pub_merger_split_reg',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
