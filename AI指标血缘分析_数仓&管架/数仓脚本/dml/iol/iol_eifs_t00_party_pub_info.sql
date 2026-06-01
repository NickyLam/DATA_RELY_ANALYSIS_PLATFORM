/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t00_party_pub_info
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
create table ${iol_schema}.eifs_t00_party_pub_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.eifs_t00_party_pub_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t00_party_pub_info_op purge;
drop table ${iol_schema}.eifs_t00_party_pub_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t00_party_pub_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t00_party_pub_info where 0=1;

create table ${iol_schema}.eifs_t00_party_pub_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t00_party_pub_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t00_party_pub_info_cl(
            party_id -- 参与人id
            ,cust_type_cd -- 客户类型
            ,cust_name -- 客户名称
            ,cust_num -- 客户编号
            ,en_name -- 英文名称
            ,short_name -- 客户简称
            ,nation_cd -- 国籍
            ,dom_forgn_cd -- 境内外标志
            ,farmer_flag -- 是否农户
            ,tax_pay_ctzn_idnt -- 税收居民身份
            ,addr_dist_cd -- 行政区划代码
            ,info_completed_flag -- 信息完整性标志
            ,info_isnull_reason -- 信息项字段为空原因
            ,level_five_class_flag -- 五级分类标志
            ,level_five_class_dt -- 五级分类日期
            ,cust_open_dt -- 开客户日期
            ,agent_acct_open -- 代理开户类型
            ,cust_status_cd -- 客户状态
            ,close_dt -- 销户日期
            ,recommendation_type -- 推荐人类型
            ,recommendation_num -- 推荐人号码
            ,cust_mgr_num -- 客户经理编号
            ,cust_mgr_name -- 客户经理姓名
            ,mgmt_org_num -- 管理机构编号
            ,mgmt_team_num -- 管理团队编号
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
            ,cust_belong_org -- 客户归属机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t00_party_pub_info_op(
            party_id -- 参与人id
            ,cust_type_cd -- 客户类型
            ,cust_name -- 客户名称
            ,cust_num -- 客户编号
            ,en_name -- 英文名称
            ,short_name -- 客户简称
            ,nation_cd -- 国籍
            ,dom_forgn_cd -- 境内外标志
            ,farmer_flag -- 是否农户
            ,tax_pay_ctzn_idnt -- 税收居民身份
            ,addr_dist_cd -- 行政区划代码
            ,info_completed_flag -- 信息完整性标志
            ,info_isnull_reason -- 信息项字段为空原因
            ,level_five_class_flag -- 五级分类标志
            ,level_five_class_dt -- 五级分类日期
            ,cust_open_dt -- 开客户日期
            ,agent_acct_open -- 代理开户类型
            ,cust_status_cd -- 客户状态
            ,close_dt -- 销户日期
            ,recommendation_type -- 推荐人类型
            ,recommendation_num -- 推荐人号码
            ,cust_mgr_num -- 客户经理编号
            ,cust_mgr_name -- 客户经理姓名
            ,mgmt_org_num -- 管理机构编号
            ,mgmt_team_num -- 管理团队编号
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
            ,cust_belong_org -- 客户归属机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 参与人id
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cust_num, o.cust_num) as cust_num -- 客户编号
    ,nvl(n.en_name, o.en_name) as en_name -- 英文名称
    ,nvl(n.short_name, o.short_name) as short_name -- 客户简称
    ,nvl(n.nation_cd, o.nation_cd) as nation_cd -- 国籍
    ,nvl(n.dom_forgn_cd, o.dom_forgn_cd) as dom_forgn_cd -- 境内外标志
    ,nvl(n.farmer_flag, o.farmer_flag) as farmer_flag -- 是否农户
    ,nvl(n.tax_pay_ctzn_idnt, o.tax_pay_ctzn_idnt) as tax_pay_ctzn_idnt -- 税收居民身份
    ,nvl(n.addr_dist_cd, o.addr_dist_cd) as addr_dist_cd -- 行政区划代码
    ,nvl(n.info_completed_flag, o.info_completed_flag) as info_completed_flag -- 信息完整性标志
    ,nvl(n.info_isnull_reason, o.info_isnull_reason) as info_isnull_reason -- 信息项字段为空原因
    ,nvl(n.level_five_class_flag, o.level_five_class_flag) as level_five_class_flag -- 五级分类标志
    ,nvl(n.level_five_class_dt, o.level_five_class_dt) as level_five_class_dt -- 五级分类日期
    ,nvl(n.cust_open_dt, o.cust_open_dt) as cust_open_dt -- 开客户日期
    ,nvl(n.agent_acct_open, o.agent_acct_open) as agent_acct_open -- 代理开户类型
    ,nvl(n.cust_status_cd, o.cust_status_cd) as cust_status_cd -- 客户状态
    ,nvl(n.close_dt, o.close_dt) as close_dt -- 销户日期
    ,nvl(n.recommendation_type, o.recommendation_type) as recommendation_type -- 推荐人类型
    ,nvl(n.recommendation_num, o.recommendation_num) as recommendation_num -- 推荐人号码
    ,nvl(n.cust_mgr_num, o.cust_mgr_num) as cust_mgr_num -- 客户经理编号
    ,nvl(n.cust_mgr_name, o.cust_mgr_name) as cust_mgr_name -- 客户经理姓名
    ,nvl(n.mgmt_org_num, o.mgmt_org_num) as mgmt_org_num -- 管理机构编号
    ,nvl(n.mgmt_team_num, o.mgmt_team_num) as mgmt_team_num -- 管理团队编号
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
    ,nvl(n.cust_belong_org, o.cust_belong_org) as cust_belong_org -- 客户归属机构
    ,case when
            n.party_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.eifs_t00_party_pub_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.eifs_t00_party_pub_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.party_id = n.party_id
where (
        o.party_id is null
    )
    or (
        n.party_id is null
    )
    or (
        o.cust_type_cd <> n.cust_type_cd
        or o.cust_name <> n.cust_name
        or o.cust_num <> n.cust_num
        or o.en_name <> n.en_name
        or o.short_name <> n.short_name
        or o.nation_cd <> n.nation_cd
        or o.dom_forgn_cd <> n.dom_forgn_cd
        or o.farmer_flag <> n.farmer_flag
        or o.tax_pay_ctzn_idnt <> n.tax_pay_ctzn_idnt
        or o.addr_dist_cd <> n.addr_dist_cd
        or o.info_completed_flag <> n.info_completed_flag
        or o.info_isnull_reason <> n.info_isnull_reason
        or o.level_five_class_flag <> n.level_five_class_flag
        or o.level_five_class_dt <> n.level_five_class_dt
        or o.cust_open_dt <> n.cust_open_dt
        or o.agent_acct_open <> n.agent_acct_open
        or o.cust_status_cd <> n.cust_status_cd
        or o.close_dt <> n.close_dt
        or o.recommendation_type <> n.recommendation_type
        or o.recommendation_num <> n.recommendation_num
        or o.cust_mgr_num <> n.cust_mgr_num
        or o.cust_mgr_name <> n.cust_mgr_name
        or o.mgmt_org_num <> n.mgmt_org_num
        or o.mgmt_team_num <> n.mgmt_team_num
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
        or o.cust_belong_org <> n.cust_belong_org
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t00_party_pub_info_cl(
            party_id -- 参与人id
            ,cust_type_cd -- 客户类型
            ,cust_name -- 客户名称
            ,cust_num -- 客户编号
            ,en_name -- 英文名称
            ,short_name -- 客户简称
            ,nation_cd -- 国籍
            ,dom_forgn_cd -- 境内外标志
            ,farmer_flag -- 是否农户
            ,tax_pay_ctzn_idnt -- 税收居民身份
            ,addr_dist_cd -- 行政区划代码
            ,info_completed_flag -- 信息完整性标志
            ,info_isnull_reason -- 信息项字段为空原因
            ,level_five_class_flag -- 五级分类标志
            ,level_five_class_dt -- 五级分类日期
            ,cust_open_dt -- 开客户日期
            ,agent_acct_open -- 代理开户类型
            ,cust_status_cd -- 客户状态
            ,close_dt -- 销户日期
            ,recommendation_type -- 推荐人类型
            ,recommendation_num -- 推荐人号码
            ,cust_mgr_num -- 客户经理编号
            ,cust_mgr_name -- 客户经理姓名
            ,mgmt_org_num -- 管理机构编号
            ,mgmt_team_num -- 管理团队编号
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
            ,cust_belong_org -- 客户归属机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t00_party_pub_info_op(
            party_id -- 参与人id
            ,cust_type_cd -- 客户类型
            ,cust_name -- 客户名称
            ,cust_num -- 客户编号
            ,en_name -- 英文名称
            ,short_name -- 客户简称
            ,nation_cd -- 国籍
            ,dom_forgn_cd -- 境内外标志
            ,farmer_flag -- 是否农户
            ,tax_pay_ctzn_idnt -- 税收居民身份
            ,addr_dist_cd -- 行政区划代码
            ,info_completed_flag -- 信息完整性标志
            ,info_isnull_reason -- 信息项字段为空原因
            ,level_five_class_flag -- 五级分类标志
            ,level_five_class_dt -- 五级分类日期
            ,cust_open_dt -- 开客户日期
            ,agent_acct_open -- 代理开户类型
            ,cust_status_cd -- 客户状态
            ,close_dt -- 销户日期
            ,recommendation_type -- 推荐人类型
            ,recommendation_num -- 推荐人号码
            ,cust_mgr_num -- 客户经理编号
            ,cust_mgr_name -- 客户经理姓名
            ,mgmt_org_num -- 管理机构编号
            ,mgmt_team_num -- 管理团队编号
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
            ,cust_belong_org -- 客户归属机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 参与人id
    ,o.cust_type_cd -- 客户类型
    ,o.cust_name -- 客户名称
    ,o.cust_num -- 客户编号
    ,o.en_name -- 英文名称
    ,o.short_name -- 客户简称
    ,o.nation_cd -- 国籍
    ,o.dom_forgn_cd -- 境内外标志
    ,o.farmer_flag -- 是否农户
    ,o.tax_pay_ctzn_idnt -- 税收居民身份
    ,o.addr_dist_cd -- 行政区划代码
    ,o.info_completed_flag -- 信息完整性标志
    ,o.info_isnull_reason -- 信息项字段为空原因
    ,o.level_five_class_flag -- 五级分类标志
    ,o.level_five_class_dt -- 五级分类日期
    ,o.cust_open_dt -- 开客户日期
    ,o.agent_acct_open -- 代理开户类型
    ,o.cust_status_cd -- 客户状态
    ,o.close_dt -- 销户日期
    ,o.recommendation_type -- 推荐人类型
    ,o.recommendation_num -- 推荐人号码
    ,o.cust_mgr_num -- 客户经理编号
    ,o.cust_mgr_name -- 客户经理姓名
    ,o.mgmt_org_num -- 管理机构编号
    ,o.mgmt_team_num -- 管理团队编号
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
    ,o.cust_belong_org -- 客户归属机构
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
from ${iol_schema}.eifs_t00_party_pub_info_bk o
    left join ${iol_schema}.eifs_t00_party_pub_info_op n
        on
            o.party_id = n.party_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.eifs_t00_party_pub_info_cl d
        on
            o.party_id = d.party_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.eifs_t00_party_pub_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('eifs_t00_party_pub_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.eifs_t00_party_pub_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.eifs_t00_party_pub_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.eifs_t00_party_pub_info exchange partition p_${batch_date} with table ${iol_schema}.eifs_t00_party_pub_info_cl;
alter table ${iol_schema}.eifs_t00_party_pub_info exchange partition p_20991231 with table ${iol_schema}.eifs_t00_party_pub_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.eifs_t00_party_pub_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t00_party_pub_info_op purge;
drop table ${iol_schema}.eifs_t00_party_pub_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.eifs_t00_party_pub_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'eifs_t00_party_pub_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
