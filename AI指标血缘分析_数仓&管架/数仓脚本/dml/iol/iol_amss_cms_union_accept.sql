/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_cms_union_accept
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
create table ${iol_schema}.amss_cms_union_accept_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_cms_union_accept
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_cms_union_accept_op purge;
drop table ${iol_schema}.amss_cms_union_accept_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_cms_union_accept_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_cms_union_accept where 0=1;

create table ${iol_schema}.amss_cms_union_accept_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_cms_union_accept where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_cms_union_accept_cl(
            id -- 主键
            ,data_num -- 序号
            ,org_id -- 机构id
            ,org_name -- 机构名
            ,cust_num -- 客户号
            ,cust_account -- 账户
            ,cust_name -- 客户名称
            ,partner_name -- 联合合作商
            ,stat_cycle -- 统计周期
            ,stat_cycle_tra_money -- 统计周期内金额
            ,stat_cycle_tra_count -- 统计周期内笔数
            ,perk -- 联合补贴费用
            ,remark -- 备注
            ,create_user -- 创建用户
            ,create_emp -- 创建者
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,physics_flag -- 物理删除标识 1正常 2删除
            ,address -- 经营地址(省市区+详细地址)
            ,account_type -- 账户类型.账户类型：1企业,2个人
            ,term_count -- 终端数量
            ,partner_dt -- 合作开始时间(YYYY/mm/dd)
            ,is_rural -- 是否农村地区
			,account_num -- 账户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_cms_union_accept_op(
            id -- 主键
            ,data_num -- 序号
            ,org_id -- 机构id
            ,org_name -- 机构名
            ,cust_num -- 客户号
            ,cust_account -- 账户
            ,cust_name -- 客户名称
            ,partner_name -- 联合合作商
            ,stat_cycle -- 统计周期
            ,stat_cycle_tra_money -- 统计周期内金额
            ,stat_cycle_tra_count -- 统计周期内笔数
            ,perk -- 联合补贴费用
            ,remark -- 备注
            ,create_user -- 创建用户
            ,create_emp -- 创建者
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,physics_flag -- 物理删除标识 1正常 2删除
            ,address -- 经营地址(省市区+详细地址)
            ,account_type -- 账户类型.账户类型：1企业,2个人
            ,term_count -- 终端数量
            ,partner_dt -- 合作开始时间(YYYY/mm/dd)
            ,is_rural -- 是否农村地区
			,account_num -- 账户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键
    ,nvl(n.data_num, o.data_num) as data_num -- 序号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构id
    ,nvl(n.org_name, o.org_name) as org_name -- 机构名
    ,nvl(n.cust_num, o.cust_num) as cust_num -- 客户号
    ,nvl(n.cust_account, o.cust_account) as cust_account -- 账户
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.partner_name, o.partner_name) as partner_name -- 联合合作商
    ,nvl(n.stat_cycle, o.stat_cycle) as stat_cycle -- 统计周期
    ,nvl(n.stat_cycle_tra_money, o.stat_cycle_tra_money) as stat_cycle_tra_money -- 统计周期内金额
    ,nvl(n.stat_cycle_tra_count, o.stat_cycle_tra_count) as stat_cycle_tra_count -- 统计周期内笔数
    ,nvl(n.perk, o.perk) as perk -- 联合补贴费用
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.create_user, o.create_user) as create_user -- 创建用户
    ,nvl(n.create_emp, o.create_emp) as create_emp -- 创建者
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.physics_flag, o.physics_flag) as physics_flag -- 物理删除标识 1正常 2删除
    ,nvl(n.address, o.address) as address -- 经营地址(省市区+详细地址)
    ,nvl(n.account_type, o.account_type) as account_type -- 账户类型.账户类型：1企业,2个人
    ,nvl(n.term_count, o.term_count) as term_count -- 终端数量
    ,nvl(n.partner_dt, o.partner_dt) as partner_dt -- 合作开始时间(YYYY/mm/dd)
    ,nvl(n.is_rural, o.is_rural) as is_rural -- 是否农村地区
	,nvl(n.account_num, o.account_num) as account_num -- 账户
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
from (select * from ${iol_schema}.amss_cms_union_accept_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_cms_union_accept where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.data_num <> n.data_num
        or o.org_id <> n.org_id
        or o.org_name <> n.org_name
        or o.cust_num <> n.cust_num
        or o.cust_account <> n.cust_account
        or o.cust_name <> n.cust_name
        or o.partner_name <> n.partner_name
        or o.stat_cycle <> n.stat_cycle
        or o.stat_cycle_tra_money <> n.stat_cycle_tra_money
        or o.stat_cycle_tra_count <> n.stat_cycle_tra_count
        or o.perk <> n.perk
        or o.remark <> n.remark
        or o.create_user <> n.create_user
        or o.create_emp <> n.create_emp
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.physics_flag <> n.physics_flag
        or o.address <> n.address
        or o.account_type <> n.account_type
        or o.term_count <> n.term_count
        or o.partner_dt <> n.partner_dt
        or o.is_rural <> n.is_rural
		or o.account_num <> n.account_num
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_cms_union_accept_cl(
            id -- 主键
            ,data_num -- 序号
            ,org_id -- 机构id
            ,org_name -- 机构名
            ,cust_num -- 客户号
            ,cust_account -- 账户
            ,cust_name -- 客户名称
            ,partner_name -- 联合合作商
            ,stat_cycle -- 统计周期
            ,stat_cycle_tra_money -- 统计周期内金额
            ,stat_cycle_tra_count -- 统计周期内笔数
            ,perk -- 联合补贴费用
            ,remark -- 备注
            ,create_user -- 创建用户
            ,create_emp -- 创建者
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,physics_flag -- 物理删除标识 1正常 2删除
            ,address -- 经营地址(省市区+详细地址)
            ,account_type -- 账户类型.账户类型：1企业,2个人
            ,term_count -- 终端数量
            ,partner_dt -- 合作开始时间(YYYY/mm/dd)
            ,is_rural -- 是否农村地区
			,account_num
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_cms_union_accept_op(
            id -- 主键
            ,data_num -- 序号
            ,org_id -- 机构id
            ,org_name -- 机构名
            ,cust_num -- 客户号
            ,cust_account -- 账户
            ,cust_name -- 客户名称
            ,partner_name -- 联合合作商
            ,stat_cycle -- 统计周期
            ,stat_cycle_tra_money -- 统计周期内金额
            ,stat_cycle_tra_count -- 统计周期内笔数
            ,perk -- 联合补贴费用
            ,remark -- 备注
            ,create_user -- 创建用户
            ,create_emp -- 创建者
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,physics_flag -- 物理删除标识 1正常 2删除
            ,address -- 经营地址(省市区+详细地址)
            ,account_type -- 账户类型.账户类型：1企业,2个人
            ,term_count -- 终端数量
            ,partner_dt -- 合作开始时间(YYYY/mm/dd)
            ,is_rural -- 是否农村地区
			,account_num
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键
    ,o.data_num -- 序号
    ,o.org_id -- 机构id
    ,o.org_name -- 机构名
    ,o.cust_num -- 客户号
    ,o.cust_account -- 账户
    ,o.cust_name -- 客户名称
    ,o.partner_name -- 联合合作商
    ,o.stat_cycle -- 统计周期
    ,o.stat_cycle_tra_money -- 统计周期内金额
    ,o.stat_cycle_tra_count -- 统计周期内笔数
    ,o.perk -- 联合补贴费用
    ,o.remark -- 备注
    ,o.create_user -- 创建用户
    ,o.create_emp -- 创建者
    ,o.create_time -- 创建时间
    ,o.update_time -- 更新时间
    ,o.physics_flag -- 物理删除标识 1正常 2删除
    ,o.address -- 经营地址(省市区+详细地址)
    ,o.account_type -- 账户类型.账户类型：1企业,2个人
    ,o.term_count -- 终端数量
    ,o.partner_dt -- 合作开始时间(YYYY/mm/dd)
    ,o.is_rural -- 是否农村地区
	,o.account_num
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
from ${iol_schema}.amss_cms_union_accept_bk o
    left join ${iol_schema}.amss_cms_union_accept_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_cms_union_accept_cl d
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
--truncate table ${iol_schema}.amss_cms_union_accept;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_cms_union_accept') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_cms_union_accept drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_cms_union_accept add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_cms_union_accept exchange partition p_${batch_date} with table ${iol_schema}.amss_cms_union_accept_cl;
alter table ${iol_schema}.amss_cms_union_accept exchange partition p_20991231 with table ${iol_schema}.amss_cms_union_accept_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_cms_union_accept to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_cms_union_accept_op purge;
drop table ${iol_schema}.amss_cms_union_accept_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_cms_union_accept_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_cms_union_accept',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
