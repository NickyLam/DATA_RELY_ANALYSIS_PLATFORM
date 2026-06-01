/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t01_per_cust_info
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
create table ${iol_schema}.eifs_t01_per_cust_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.eifs_t01_per_cust_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t01_per_cust_info_op purge;
drop table ${iol_schema}.eifs_t01_per_cust_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t01_per_cust_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t01_per_cust_info where 0=1;

create table ${iol_schema}.eifs_t01_per_cust_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t01_per_cust_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t01_per_cust_info_cl(
            party_id -- 参与人id
            ,cust_name -- 客户名称
            ,former_name -- 曾用名
            ,gender_cd -- 性别
            ,ethnic_cd -- 民族
            ,birth_place_cd -- 籍贯
            ,birth_dt -- 出生日期
            ,birth_place -- 出生地
            ,depositor_type_cd -- 存款人类别
            ,poltc_stat_cd -- 政治面貌
            ,marriage_situ_cd -- 婚姻状况
            ,supr_edu_degree_cd -- 学历
            ,supr_degree_cd -- 学位
            ,work_stat_cd -- 就业状况
            ,career_cd -- 职业类型
            ,other_occupation -- 其他职业说明
            ,title_cd -- 职称
            ,pos_level_cd -- 职务类型
            ,emply_ind -- 员工标志
            ,emply_num -- 员工编号
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
            ,loan_flag -- 信贷客户标识
            ,self_sup_flag -- 自营客户标识
            ,career_desc_level1 -- 职业中文名称一级
            ,career_desc_level2 -- 职业中文名称二级
            ,guarantee_flag -- 担保客户标志
            ,party_role -- 参与人角色
            ,aml_dep_flag -- 担保类标志
            ,aml_loan_flag -- 贷款类标志
            ,aml_guar_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t01_per_cust_info_op(
            party_id -- 参与人id
            ,cust_name -- 客户名称
            ,former_name -- 曾用名
            ,gender_cd -- 性别
            ,ethnic_cd -- 民族
            ,birth_place_cd -- 籍贯
            ,birth_dt -- 出生日期
            ,birth_place -- 出生地
            ,depositor_type_cd -- 存款人类别
            ,poltc_stat_cd -- 政治面貌
            ,marriage_situ_cd -- 婚姻状况
            ,supr_edu_degree_cd -- 学历
            ,supr_degree_cd -- 学位
            ,work_stat_cd -- 就业状况
            ,career_cd -- 职业类型
            ,other_occupation -- 其他职业说明
            ,title_cd -- 职称
            ,pos_level_cd -- 职务类型
            ,emply_ind -- 员工标志
            ,emply_num -- 员工编号
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
            ,loan_flag -- 信贷客户标识
            ,self_sup_flag -- 自营客户标识
            ,career_desc_level1 -- 职业中文名称一级
            ,career_desc_level2 -- 职业中文名称二级
            ,guarantee_flag -- 担保客户标志
            ,party_role -- 参与人角色
            ,aml_dep_flag -- 担保类标志
            ,aml_loan_flag -- 贷款类标志
            ,aml_guar_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 参与人id
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.former_name, o.former_name) as former_name -- 曾用名
    ,nvl(n.gender_cd, o.gender_cd) as gender_cd -- 性别
    ,nvl(n.ethnic_cd, o.ethnic_cd) as ethnic_cd -- 民族
    ,nvl(n.birth_place_cd, o.birth_place_cd) as birth_place_cd -- 籍贯
    ,nvl(n.birth_dt, o.birth_dt) as birth_dt -- 出生日期
    ,nvl(n.birth_place, o.birth_place) as birth_place -- 出生地
    ,nvl(n.depositor_type_cd, o.depositor_type_cd) as depositor_type_cd -- 存款人类别
    ,nvl(n.poltc_stat_cd, o.poltc_stat_cd) as poltc_stat_cd -- 政治面貌
    ,nvl(n.marriage_situ_cd, o.marriage_situ_cd) as marriage_situ_cd -- 婚姻状况
    ,nvl(n.supr_edu_degree_cd, o.supr_edu_degree_cd) as supr_edu_degree_cd -- 学历
    ,nvl(n.supr_degree_cd, o.supr_degree_cd) as supr_degree_cd -- 学位
    ,nvl(n.work_stat_cd, o.work_stat_cd) as work_stat_cd -- 就业状况
    ,nvl(n.career_cd, o.career_cd) as career_cd -- 职业类型
    ,nvl(n.other_occupation, o.other_occupation) as other_occupation -- 其他职业说明
    ,nvl(n.title_cd, o.title_cd) as title_cd -- 职称
    ,nvl(n.pos_level_cd, o.pos_level_cd) as pos_level_cd -- 职务类型
    ,nvl(n.emply_ind, o.emply_ind) as emply_ind -- 员工标志
    ,nvl(n.emply_num, o.emply_num) as emply_num -- 员工编号
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
    ,nvl(n.loan_flag, o.loan_flag) as loan_flag -- 信贷客户标识
    ,nvl(n.self_sup_flag, o.self_sup_flag) as self_sup_flag -- 自营客户标识
    ,nvl(n.career_desc_level1, o.career_desc_level1) as career_desc_level1 -- 职业中文名称一级
    ,nvl(n.career_desc_level2, o.career_desc_level2) as career_desc_level2 -- 职业中文名称二级
    ,nvl(n.guarantee_flag, o.guarantee_flag) as guarantee_flag -- 担保客户标志
    ,nvl(n.party_role, o.party_role) as party_role -- 参与人角色
    ,nvl(n.aml_dep_flag, o.aml_dep_flag) as aml_dep_flag -- 担保类标志
    ,nvl(n.aml_loan_flag, o.aml_loan_flag) as aml_loan_flag -- 贷款类标志
    ,nvl(n.aml_guar_flag, o.aml_guar_flag) as aml_guar_flag -- 
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
from (select * from ${iol_schema}.eifs_t01_per_cust_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.eifs_t01_per_cust_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.party_id = n.party_id
where (
        o.party_id is null
    )
    or (
        n.party_id is null
    )
    or (
        o.cust_name <> n.cust_name
        or o.former_name <> n.former_name
        or o.gender_cd <> n.gender_cd
        or o.ethnic_cd <> n.ethnic_cd
        or o.birth_place_cd <> n.birth_place_cd
        or o.birth_dt <> n.birth_dt
        or o.birth_place <> n.birth_place
        or o.depositor_type_cd <> n.depositor_type_cd
        or o.poltc_stat_cd <> n.poltc_stat_cd
        or o.marriage_situ_cd <> n.marriage_situ_cd
        or o.supr_edu_degree_cd <> n.supr_edu_degree_cd
        or o.supr_degree_cd <> n.supr_degree_cd
        or o.work_stat_cd <> n.work_stat_cd
        or o.career_cd <> n.career_cd
        or o.other_occupation <> n.other_occupation
        or o.title_cd <> n.title_cd
        or o.pos_level_cd <> n.pos_level_cd
        or o.emply_ind <> n.emply_ind
        or o.emply_num <> n.emply_num
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
        or o.loan_flag <> n.loan_flag
        or o.self_sup_flag <> n.self_sup_flag
        or o.career_desc_level1 <> n.career_desc_level1
        or o.career_desc_level2 <> n.career_desc_level2
        or o.guarantee_flag <> n.guarantee_flag
        or o.party_role <> n.party_role
        or o.aml_dep_flag <> n.aml_dep_flag
        or o.aml_loan_flag <> n.aml_loan_flag
        or o.aml_guar_flag <> n.aml_guar_flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t01_per_cust_info_cl(
            party_id -- 参与人id
            ,cust_name -- 客户名称
            ,former_name -- 曾用名
            ,gender_cd -- 性别
            ,ethnic_cd -- 民族
            ,birth_place_cd -- 籍贯
            ,birth_dt -- 出生日期
            ,birth_place -- 出生地
            ,depositor_type_cd -- 存款人类别
            ,poltc_stat_cd -- 政治面貌
            ,marriage_situ_cd -- 婚姻状况
            ,supr_edu_degree_cd -- 学历
            ,supr_degree_cd -- 学位
            ,work_stat_cd -- 就业状况
            ,career_cd -- 职业类型
            ,other_occupation -- 其他职业说明
            ,title_cd -- 职称
            ,pos_level_cd -- 职务类型
            ,emply_ind -- 员工标志
            ,emply_num -- 员工编号
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
            ,loan_flag -- 信贷客户标识
            ,self_sup_flag -- 自营客户标识
            ,career_desc_level1 -- 职业中文名称一级
            ,career_desc_level2 -- 职业中文名称二级
            ,guarantee_flag -- 担保客户标志
            ,party_role -- 参与人角色
            ,aml_dep_flag -- 担保类标志
            ,aml_loan_flag -- 贷款类标志
            ,aml_guar_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t01_per_cust_info_op(
            party_id -- 参与人id
            ,cust_name -- 客户名称
            ,former_name -- 曾用名
            ,gender_cd -- 性别
            ,ethnic_cd -- 民族
            ,birth_place_cd -- 籍贯
            ,birth_dt -- 出生日期
            ,birth_place -- 出生地
            ,depositor_type_cd -- 存款人类别
            ,poltc_stat_cd -- 政治面貌
            ,marriage_situ_cd -- 婚姻状况
            ,supr_edu_degree_cd -- 学历
            ,supr_degree_cd -- 学位
            ,work_stat_cd -- 就业状况
            ,career_cd -- 职业类型
            ,other_occupation -- 其他职业说明
            ,title_cd -- 职称
            ,pos_level_cd -- 职务类型
            ,emply_ind -- 员工标志
            ,emply_num -- 员工编号
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
            ,loan_flag -- 信贷客户标识
            ,self_sup_flag -- 自营客户标识
            ,career_desc_level1 -- 职业中文名称一级
            ,career_desc_level2 -- 职业中文名称二级
            ,guarantee_flag -- 担保客户标志
            ,party_role -- 参与人角色
            ,aml_dep_flag -- 担保类标志
            ,aml_loan_flag -- 贷款类标志
            ,aml_guar_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 参与人id
    ,o.cust_name -- 客户名称
    ,o.former_name -- 曾用名
    ,o.gender_cd -- 性别
    ,o.ethnic_cd -- 民族
    ,o.birth_place_cd -- 籍贯
    ,o.birth_dt -- 出生日期
    ,o.birth_place -- 出生地
    ,o.depositor_type_cd -- 存款人类别
    ,o.poltc_stat_cd -- 政治面貌
    ,o.marriage_situ_cd -- 婚姻状况
    ,o.supr_edu_degree_cd -- 学历
    ,o.supr_degree_cd -- 学位
    ,o.work_stat_cd -- 就业状况
    ,o.career_cd -- 职业类型
    ,o.other_occupation -- 其他职业说明
    ,o.title_cd -- 职称
    ,o.pos_level_cd -- 职务类型
    ,o.emply_ind -- 员工标志
    ,o.emply_num -- 员工编号
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
    ,o.loan_flag -- 信贷客户标识
    ,o.self_sup_flag -- 自营客户标识
    ,o.career_desc_level1 -- 职业中文名称一级
    ,o.career_desc_level2 -- 职业中文名称二级
    ,o.guarantee_flag -- 担保客户标志
    ,o.party_role -- 参与人角色
    ,o.aml_dep_flag -- 担保类标志
    ,o.aml_loan_flag -- 贷款类标志
    ,o.aml_guar_flag -- 
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
from ${iol_schema}.eifs_t01_per_cust_info_bk o
    left join ${iol_schema}.eifs_t01_per_cust_info_op n
        on
            o.party_id = n.party_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.eifs_t01_per_cust_info_cl d
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
--truncate table ${iol_schema}.eifs_t01_per_cust_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('eifs_t01_per_cust_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.eifs_t01_per_cust_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.eifs_t01_per_cust_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.eifs_t01_per_cust_info exchange partition p_${batch_date} with table ${iol_schema}.eifs_t01_per_cust_info_cl;
alter table ${iol_schema}.eifs_t01_per_cust_info exchange partition p_20991231 with table ${iol_schema}.eifs_t01_per_cust_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.eifs_t01_per_cust_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t01_per_cust_info_op purge;
drop table ${iol_schema}.eifs_t01_per_cust_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.eifs_t01_per_cust_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'eifs_t01_per_cust_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
