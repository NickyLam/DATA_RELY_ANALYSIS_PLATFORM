/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t01_per_cust_work_info
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
create table ${iol_schema}.eifs_t01_per_cust_work_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.eifs_t01_per_cust_work_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t01_per_cust_work_info_op purge;
drop table ${iol_schema}.eifs_t01_per_cust_work_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t01_per_cust_work_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t01_per_cust_work_info where 0=1;

create table ${iol_schema}.eifs_t01_per_cust_work_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t01_per_cust_work_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t01_per_cust_work_info_cl(
            work_resume_id -- 工作履历id
            ,party_id -- 参与人id
            ,work_corp_name -- 工作单位名称
            ,work_unit_addr -- 工作单位地址
            ,work_corp_site_addr_dist -- 工作单位所在地行政区划
            ,work_unit_phone -- 工作单位电话
            ,work_unit_zip_code -- 工作单位邮编
            ,work_permit_no -- 工作证号
            ,career_cd -- 职业类型
            ,other_occupation -- 其他职业说明
            ,work_unit_property -- 工作单位性质
            ,work_unit_belong_industry -- 工作单位所属行业
            ,title_cd -- 职称
            ,pos_level_cd -- 职务类型
            ,mon_in -- 月收入
            ,work_property -- 工作性质
            ,entry_date -- 入职日期
            ,quit_date -- 离职日期
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
            ,corp_size_cd -- 单位所属企业规模
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t01_per_cust_work_info_op(
            work_resume_id -- 工作履历id
            ,party_id -- 参与人id
            ,work_corp_name -- 工作单位名称
            ,work_unit_addr -- 工作单位地址
            ,work_corp_site_addr_dist -- 工作单位所在地行政区划
            ,work_unit_phone -- 工作单位电话
            ,work_unit_zip_code -- 工作单位邮编
            ,work_permit_no -- 工作证号
            ,career_cd -- 职业类型
            ,other_occupation -- 其他职业说明
            ,work_unit_property -- 工作单位性质
            ,work_unit_belong_industry -- 工作单位所属行业
            ,title_cd -- 职称
            ,pos_level_cd -- 职务类型
            ,mon_in -- 月收入
            ,work_property -- 工作性质
            ,entry_date -- 入职日期
            ,quit_date -- 离职日期
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
            ,corp_size_cd -- 单位所属企业规模
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.work_resume_id, o.work_resume_id) as work_resume_id -- 工作履历id
    ,nvl(n.party_id, o.party_id) as party_id -- 参与人id
    ,nvl(n.work_corp_name, o.work_corp_name) as work_corp_name -- 工作单位名称
    ,nvl(n.work_unit_addr, o.work_unit_addr) as work_unit_addr -- 工作单位地址
    ,nvl(n.work_corp_site_addr_dist, o.work_corp_site_addr_dist) as work_corp_site_addr_dist -- 工作单位所在地行政区划
    ,nvl(n.work_unit_phone, o.work_unit_phone) as work_unit_phone -- 工作单位电话
    ,nvl(n.work_unit_zip_code, o.work_unit_zip_code) as work_unit_zip_code -- 工作单位邮编
    ,nvl(n.work_permit_no, o.work_permit_no) as work_permit_no -- 工作证号
    ,nvl(n.career_cd, o.career_cd) as career_cd -- 职业类型
    ,nvl(n.other_occupation, o.other_occupation) as other_occupation -- 其他职业说明
    ,nvl(n.work_unit_property, o.work_unit_property) as work_unit_property -- 工作单位性质
    ,nvl(n.work_unit_belong_industry, o.work_unit_belong_industry) as work_unit_belong_industry -- 工作单位所属行业
    ,nvl(n.title_cd, o.title_cd) as title_cd -- 职称
    ,nvl(n.pos_level_cd, o.pos_level_cd) as pos_level_cd -- 职务类型
    ,nvl(n.mon_in, o.mon_in) as mon_in -- 月收入
    ,nvl(n.work_property, o.work_property) as work_property -- 工作性质
    ,nvl(n.entry_date, o.entry_date) as entry_date -- 入职日期
    ,nvl(n.quit_date, o.quit_date) as quit_date -- 离职日期
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
    ,nvl(n.corp_size_cd, o.corp_size_cd) as corp_size_cd -- 单位所属企业规模
    ,case when
            n.work_resume_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.work_resume_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.work_resume_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.eifs_t01_per_cust_work_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.eifs_t01_per_cust_work_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.work_resume_id = n.work_resume_id
where (
        o.work_resume_id is null
    )
    or (
        n.work_resume_id is null
    )
    or (
        o.party_id <> n.party_id
        or o.work_corp_name <> n.work_corp_name
        or o.work_unit_addr <> n.work_unit_addr
        or o.work_corp_site_addr_dist <> n.work_corp_site_addr_dist
        or o.work_unit_phone <> n.work_unit_phone
        or o.work_unit_zip_code <> n.work_unit_zip_code
        or o.work_permit_no <> n.work_permit_no
        or o.career_cd <> n.career_cd
        or o.other_occupation <> n.other_occupation
        or o.work_unit_property <> n.work_unit_property
        or o.work_unit_belong_industry <> n.work_unit_belong_industry
        or o.title_cd <> n.title_cd
        or o.pos_level_cd <> n.pos_level_cd
        or o.mon_in <> n.mon_in
        or o.work_property <> n.work_property
        or o.entry_date <> n.entry_date
        or o.quit_date <> n.quit_date
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
        or o.corp_size_cd <> n.corp_size_cd
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t01_per_cust_work_info_cl(
            work_resume_id -- 工作履历id
            ,party_id -- 参与人id
            ,work_corp_name -- 工作单位名称
            ,work_unit_addr -- 工作单位地址
            ,work_corp_site_addr_dist -- 工作单位所在地行政区划
            ,work_unit_phone -- 工作单位电话
            ,work_unit_zip_code -- 工作单位邮编
            ,work_permit_no -- 工作证号
            ,career_cd -- 职业类型
            ,other_occupation -- 其他职业说明
            ,work_unit_property -- 工作单位性质
            ,work_unit_belong_industry -- 工作单位所属行业
            ,title_cd -- 职称
            ,pos_level_cd -- 职务类型
            ,mon_in -- 月收入
            ,work_property -- 工作性质
            ,entry_date -- 入职日期
            ,quit_date -- 离职日期
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
            ,corp_size_cd -- 单位所属企业规模
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t01_per_cust_work_info_op(
            work_resume_id -- 工作履历id
            ,party_id -- 参与人id
            ,work_corp_name -- 工作单位名称
            ,work_unit_addr -- 工作单位地址
            ,work_corp_site_addr_dist -- 工作单位所在地行政区划
            ,work_unit_phone -- 工作单位电话
            ,work_unit_zip_code -- 工作单位邮编
            ,work_permit_no -- 工作证号
            ,career_cd -- 职业类型
            ,other_occupation -- 其他职业说明
            ,work_unit_property -- 工作单位性质
            ,work_unit_belong_industry -- 工作单位所属行业
            ,title_cd -- 职称
            ,pos_level_cd -- 职务类型
            ,mon_in -- 月收入
            ,work_property -- 工作性质
            ,entry_date -- 入职日期
            ,quit_date -- 离职日期
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
            ,corp_size_cd -- 单位所属企业规模
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.work_resume_id -- 工作履历id
    ,o.party_id -- 参与人id
    ,o.work_corp_name -- 工作单位名称
    ,o.work_unit_addr -- 工作单位地址
    ,o.work_corp_site_addr_dist -- 工作单位所在地行政区划
    ,o.work_unit_phone -- 工作单位电话
    ,o.work_unit_zip_code -- 工作单位邮编
    ,o.work_permit_no -- 工作证号
    ,o.career_cd -- 职业类型
    ,o.other_occupation -- 其他职业说明
    ,o.work_unit_property -- 工作单位性质
    ,o.work_unit_belong_industry -- 工作单位所属行业
    ,o.title_cd -- 职称
    ,o.pos_level_cd -- 职务类型
    ,o.mon_in -- 月收入
    ,o.work_property -- 工作性质
    ,o.entry_date -- 入职日期
    ,o.quit_date -- 离职日期
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
    ,o.corp_size_cd -- 单位所属企业规模
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
from ${iol_schema}.eifs_t01_per_cust_work_info_bk o
    left join ${iol_schema}.eifs_t01_per_cust_work_info_op n
        on
            o.work_resume_id = n.work_resume_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.eifs_t01_per_cust_work_info_cl d
        on
            o.work_resume_id = d.work_resume_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.eifs_t01_per_cust_work_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('eifs_t01_per_cust_work_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.eifs_t01_per_cust_work_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.eifs_t01_per_cust_work_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.eifs_t01_per_cust_work_info exchange partition p_${batch_date} with table ${iol_schema}.eifs_t01_per_cust_work_info_cl;
alter table ${iol_schema}.eifs_t01_per_cust_work_info exchange partition p_20991231 with table ${iol_schema}.eifs_t01_per_cust_work_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.eifs_t01_per_cust_work_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t01_per_cust_work_info_op purge;
drop table ${iol_schema}.eifs_t01_per_cust_work_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.eifs_t01_per_cust_work_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'eifs_t01_per_cust_work_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
