/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t05_pub_summary_sign
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
create table ${iol_schema}.eifs_t05_pub_summary_sign_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.eifs_t05_pub_summary_sign
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t05_pub_summary_sign_op purge;
drop table ${iol_schema}.eifs_t05_pub_summary_sign_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t05_pub_summary_sign_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t05_pub_summary_sign where 0=1;

create table ${iol_schema}.eifs_t05_pub_summary_sign_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t05_pub_summary_sign where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t05_pub_summary_sign_cl(
            sign_contract_id -- 签约id
            ,party_id -- 参与人id
            ,agreement_id -- 签约编号
            ,product_id -- 产品标识
            ,agreement_type_id -- 签约类型
            ,agreement_date -- 协议日期
            ,from_date -- 开始日期
            ,thru_date -- 结束日期
            ,act_type -- 账号类型
            ,acct_num -- 账号
            ,sign_level -- 签约层级
            ,sign_status -- 签约状态
            ,phone_num -- 签约手机号
            ,prod_id -- 服务产品编号
            ,prod_serv_name -- 产品服务名称
            ,recmd_type -- 推荐类型
            ,recmd_num -- 推荐号码
            ,recmd_person_name -- 推荐人名称
            ,remark -- 备注
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
            ,open_date -- 签约日期
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t05_pub_summary_sign_op(
            sign_contract_id -- 签约id
            ,party_id -- 参与人id
            ,agreement_id -- 签约编号
            ,product_id -- 产品标识
            ,agreement_type_id -- 签约类型
            ,agreement_date -- 协议日期
            ,from_date -- 开始日期
            ,thru_date -- 结束日期
            ,act_type -- 账号类型
            ,acct_num -- 账号
            ,sign_level -- 签约层级
            ,sign_status -- 签约状态
            ,phone_num -- 签约手机号
            ,prod_id -- 服务产品编号
            ,prod_serv_name -- 产品服务名称
            ,recmd_type -- 推荐类型
            ,recmd_num -- 推荐号码
            ,recmd_person_name -- 推荐人名称
            ,remark -- 备注
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
            ,open_date -- 签约日期
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sign_contract_id, o.sign_contract_id) as sign_contract_id -- 签约id
    ,nvl(n.party_id, o.party_id) as party_id -- 参与人id
    ,nvl(n.agreement_id, o.agreement_id) as agreement_id -- 签约编号
    ,nvl(n.product_id, o.product_id) as product_id -- 产品标识
    ,nvl(n.agreement_type_id, o.agreement_type_id) as agreement_type_id -- 签约类型
    ,nvl(n.agreement_date, o.agreement_date) as agreement_date -- 协议日期
    ,nvl(n.from_date, o.from_date) as from_date -- 开始日期
    ,nvl(n.thru_date, o.thru_date) as thru_date -- 结束日期
    ,nvl(n.act_type, o.act_type) as act_type -- 账号类型
    ,nvl(n.acct_num, o.acct_num) as acct_num -- 账号
    ,nvl(n.sign_level, o.sign_level) as sign_level -- 签约层级
    ,nvl(n.sign_status, o.sign_status) as sign_status -- 签约状态
    ,nvl(n.phone_num, o.phone_num) as phone_num -- 签约手机号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 服务产品编号
    ,nvl(n.prod_serv_name, o.prod_serv_name) as prod_serv_name -- 产品服务名称
    ,nvl(n.recmd_type, o.recmd_type) as recmd_type -- 推荐类型
    ,nvl(n.recmd_num, o.recmd_num) as recmd_num -- 推荐号码
    ,nvl(n.recmd_person_name, o.recmd_person_name) as recmd_person_name -- 推荐人名称
    ,nvl(n.remark, o.remark) as remark -- 备注
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
    ,nvl(n.open_date, o.open_date) as open_date -- 签约日期
    ,nvl(n.src_sys_num, o.src_sys_num) as src_sys_num -- 来源系统编号
    ,nvl(n.last_updated_src_sys_num, o.last_updated_src_sys_num) as last_updated_src_sys_num -- 最新更新源系统编号
    ,case when
            n.sign_contract_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sign_contract_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sign_contract_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.eifs_t05_pub_summary_sign_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.eifs_t05_pub_summary_sign where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sign_contract_id = n.sign_contract_id
where (
        o.sign_contract_id is null
    )
    or (
        n.sign_contract_id is null
    )
    or (
        o.party_id <> n.party_id
        or o.agreement_id <> n.agreement_id
        or o.product_id <> n.product_id
        or o.agreement_type_id <> n.agreement_type_id
        or o.agreement_date <> n.agreement_date
        or o.from_date <> n.from_date
        or o.thru_date <> n.thru_date
        or o.act_type <> n.act_type
        or o.acct_num <> n.acct_num
        or o.sign_level <> n.sign_level
        or o.sign_status <> n.sign_status
        or o.phone_num <> n.phone_num
        or o.prod_id <> n.prod_id
        or o.prod_serv_name <> n.prod_serv_name
        or o.recmd_type <> n.recmd_type
        or o.recmd_num <> n.recmd_num
        or o.recmd_person_name <> n.recmd_person_name
        or o.remark <> n.remark
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
        or o.open_date <> n.open_date
        or o.src_sys_num <> n.src_sys_num
        or o.last_updated_src_sys_num <> n.last_updated_src_sys_num
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t05_pub_summary_sign_cl(
            sign_contract_id -- 签约id
            ,party_id -- 参与人id
            ,agreement_id -- 签约编号
            ,product_id -- 产品标识
            ,agreement_type_id -- 签约类型
            ,agreement_date -- 协议日期
            ,from_date -- 开始日期
            ,thru_date -- 结束日期
            ,act_type -- 账号类型
            ,acct_num -- 账号
            ,sign_level -- 签约层级
            ,sign_status -- 签约状态
            ,phone_num -- 签约手机号
            ,prod_id -- 服务产品编号
            ,prod_serv_name -- 产品服务名称
            ,recmd_type -- 推荐类型
            ,recmd_num -- 推荐号码
            ,recmd_person_name -- 推荐人名称
            ,remark -- 备注
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
            ,open_date -- 签约日期
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t05_pub_summary_sign_op(
            sign_contract_id -- 签约id
            ,party_id -- 参与人id
            ,agreement_id -- 签约编号
            ,product_id -- 产品标识
            ,agreement_type_id -- 签约类型
            ,agreement_date -- 协议日期
            ,from_date -- 开始日期
            ,thru_date -- 结束日期
            ,act_type -- 账号类型
            ,acct_num -- 账号
            ,sign_level -- 签约层级
            ,sign_status -- 签约状态
            ,phone_num -- 签约手机号
            ,prod_id -- 服务产品编号
            ,prod_serv_name -- 产品服务名称
            ,recmd_type -- 推荐类型
            ,recmd_num -- 推荐号码
            ,recmd_person_name -- 推荐人名称
            ,remark -- 备注
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
            ,open_date -- 签约日期
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sign_contract_id -- 签约id
    ,o.party_id -- 参与人id
    ,o.agreement_id -- 签约编号
    ,o.product_id -- 产品标识
    ,o.agreement_type_id -- 签约类型
    ,o.agreement_date -- 协议日期
    ,o.from_date -- 开始日期
    ,o.thru_date -- 结束日期
    ,o.act_type -- 账号类型
    ,o.acct_num -- 账号
    ,o.sign_level -- 签约层级
    ,o.sign_status -- 签约状态
    ,o.phone_num -- 签约手机号
    ,o.prod_id -- 服务产品编号
    ,o.prod_serv_name -- 产品服务名称
    ,o.recmd_type -- 推荐类型
    ,o.recmd_num -- 推荐号码
    ,o.recmd_person_name -- 推荐人名称
    ,o.remark -- 备注
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
    ,o.open_date -- 签约日期
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
from ${iol_schema}.eifs_t05_pub_summary_sign_bk o
    left join ${iol_schema}.eifs_t05_pub_summary_sign_op n
        on
            o.sign_contract_id = n.sign_contract_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.eifs_t05_pub_summary_sign_cl d
        on
            o.sign_contract_id = d.sign_contract_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.eifs_t05_pub_summary_sign;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('eifs_t05_pub_summary_sign') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.eifs_t05_pub_summary_sign drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.eifs_t05_pub_summary_sign add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.eifs_t05_pub_summary_sign exchange partition p_${batch_date} with table ${iol_schema}.eifs_t05_pub_summary_sign_cl;
alter table ${iol_schema}.eifs_t05_pub_summary_sign exchange partition p_20991231 with table ${iol_schema}.eifs_t05_pub_summary_sign_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.eifs_t05_pub_summary_sign to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t05_pub_summary_sign_op purge;
drop table ${iol_schema}.eifs_t05_pub_summary_sign_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.eifs_t05_pub_summary_sign_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'eifs_t05_pub_summary_sign',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
