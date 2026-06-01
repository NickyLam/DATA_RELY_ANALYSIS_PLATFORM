/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rcds_ir_tzbl_jbxx
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
create table ${iol_schema}.rcds_ir_tzbl_jbxx_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rcds_ir_tzbl_jbxx
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_tzbl_jbxx_op purge;
drop table ${iol_schema}.rcds_ir_tzbl_jbxx_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_tzbl_jbxx_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_tzbl_jbxx where 0=1;

create table ${iol_schema}.rcds_ir_tzbl_jbxx_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_tzbl_jbxx where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_tzbl_jbxx_cl(
            key_id -- 主键
            ,data_dt -- 数据日期
            ,cust_id -- 客户号
            ,cust_name -- 客户名称
            ,pty_typ_cd -- 客户类型代码
            ,pty_blng_indu_cd -- 客户所属行业代码
            ,pty_loc_cd -- 客户所在地代码
            ,non_resident_flg -- 非居民标志
            ,farmer_flg -- 农户标志
            ,indv_indu_com_acct_flg -- 个体工商户标志
            ,pty_status_cd -- 客户状态代码
            ,age -- 年龄
            ,valid_gender_cd -- 性别
            ,native_place_cd -- 籍贯代码
            ,nation_cd -- 国籍代码
            ,poli_face_cd -- 政治面貌代码
            ,marriage_status_cd -- 婚姻状况代码
            ,highest_edu_degree_cd -- 最高学历代码
            ,reside_status_cd -- 居住状况代码
            ,join_work_year -- 参加工作年限
            ,join_enterprise_year -- 加入现单位年限
            ,corp_blng_indu_cd -- 单位所属行业代码
            ,corp_prop_cd -- 单位性质代码
            ,profsn_title_cd -- 职称代码
            ,ghb_emp_flg -- 本行员工标志
            ,ghb_shrholder_flg -- 本行股东标志
            ,raise_cnt -- 供养人数
            ,family_anl_inc -- 家庭年收入
            ,family_mon_income -- 家庭月收入
            ,indv_mon_income -- 个人月收入
            ,indv_year_income -- 个人年收入
            ,blkl_pty_flg -- 黑名单客户标志
            ,crdt_pty_flg -- 授信客户标志
            ,small_eown_flg -- 小微企业主标志
            ,pty_level_cd -- 客户级别代码
            ,insd_and_otsd_flg -- 境内外标志
            ,work_stus -- 雇佣状态
            ,house_value -- 房产价值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_tzbl_jbxx_op(
            key_id -- 主键
            ,data_dt -- 数据日期
            ,cust_id -- 客户号
            ,cust_name -- 客户名称
            ,pty_typ_cd -- 客户类型代码
            ,pty_blng_indu_cd -- 客户所属行业代码
            ,pty_loc_cd -- 客户所在地代码
            ,non_resident_flg -- 非居民标志
            ,farmer_flg -- 农户标志
            ,indv_indu_com_acct_flg -- 个体工商户标志
            ,pty_status_cd -- 客户状态代码
            ,age -- 年龄
            ,valid_gender_cd -- 性别
            ,native_place_cd -- 籍贯代码
            ,nation_cd -- 国籍代码
            ,poli_face_cd -- 政治面貌代码
            ,marriage_status_cd -- 婚姻状况代码
            ,highest_edu_degree_cd -- 最高学历代码
            ,reside_status_cd -- 居住状况代码
            ,join_work_year -- 参加工作年限
            ,join_enterprise_year -- 加入现单位年限
            ,corp_blng_indu_cd -- 单位所属行业代码
            ,corp_prop_cd -- 单位性质代码
            ,profsn_title_cd -- 职称代码
            ,ghb_emp_flg -- 本行员工标志
            ,ghb_shrholder_flg -- 本行股东标志
            ,raise_cnt -- 供养人数
            ,family_anl_inc -- 家庭年收入
            ,family_mon_income -- 家庭月收入
            ,indv_mon_income -- 个人月收入
            ,indv_year_income -- 个人年收入
            ,blkl_pty_flg -- 黑名单客户标志
            ,crdt_pty_flg -- 授信客户标志
            ,small_eown_flg -- 小微企业主标志
            ,pty_level_cd -- 客户级别代码
            ,insd_and_otsd_flg -- 境内外标志
            ,work_stus -- 雇佣状态
            ,house_value -- 房产价值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.key_id, o.key_id) as key_id -- 主键
    ,nvl(n.data_dt, o.data_dt) as data_dt -- 数据日期
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.pty_typ_cd, o.pty_typ_cd) as pty_typ_cd -- 客户类型代码
    ,nvl(n.pty_blng_indu_cd, o.pty_blng_indu_cd) as pty_blng_indu_cd -- 客户所属行业代码
    ,nvl(n.pty_loc_cd, o.pty_loc_cd) as pty_loc_cd -- 客户所在地代码
    ,nvl(n.non_resident_flg, o.non_resident_flg) as non_resident_flg -- 非居民标志
    ,nvl(n.farmer_flg, o.farmer_flg) as farmer_flg -- 农户标志
    ,nvl(n.indv_indu_com_acct_flg, o.indv_indu_com_acct_flg) as indv_indu_com_acct_flg -- 个体工商户标志
    ,nvl(n.pty_status_cd, o.pty_status_cd) as pty_status_cd -- 客户状态代码
    ,nvl(n.age, o.age) as age -- 年龄
    ,nvl(n.valid_gender_cd, o.valid_gender_cd) as valid_gender_cd -- 性别
    ,nvl(n.native_place_cd, o.native_place_cd) as native_place_cd -- 籍贯代码
    ,nvl(n.nation_cd, o.nation_cd) as nation_cd -- 国籍代码
    ,nvl(n.poli_face_cd, o.poli_face_cd) as poli_face_cd -- 政治面貌代码
    ,nvl(n.marriage_status_cd, o.marriage_status_cd) as marriage_status_cd -- 婚姻状况代码
    ,nvl(n.highest_edu_degree_cd, o.highest_edu_degree_cd) as highest_edu_degree_cd -- 最高学历代码
    ,nvl(n.reside_status_cd, o.reside_status_cd) as reside_status_cd -- 居住状况代码
    ,nvl(n.join_work_year, o.join_work_year) as join_work_year -- 参加工作年限
    ,nvl(n.join_enterprise_year, o.join_enterprise_year) as join_enterprise_year -- 加入现单位年限
    ,nvl(n.corp_blng_indu_cd, o.corp_blng_indu_cd) as corp_blng_indu_cd -- 单位所属行业代码
    ,nvl(n.corp_prop_cd, o.corp_prop_cd) as corp_prop_cd -- 单位性质代码
    ,nvl(n.profsn_title_cd, o.profsn_title_cd) as profsn_title_cd -- 职称代码
    ,nvl(n.ghb_emp_flg, o.ghb_emp_flg) as ghb_emp_flg -- 本行员工标志
    ,nvl(n.ghb_shrholder_flg, o.ghb_shrholder_flg) as ghb_shrholder_flg -- 本行股东标志
    ,nvl(n.raise_cnt, o.raise_cnt) as raise_cnt -- 供养人数
    ,nvl(n.family_anl_inc, o.family_anl_inc) as family_anl_inc -- 家庭年收入
    ,nvl(n.family_mon_income, o.family_mon_income) as family_mon_income -- 家庭月收入
    ,nvl(n.indv_mon_income, o.indv_mon_income) as indv_mon_income -- 个人月收入
    ,nvl(n.indv_year_income, o.indv_year_income) as indv_year_income -- 个人年收入
    ,nvl(n.blkl_pty_flg, o.blkl_pty_flg) as blkl_pty_flg -- 黑名单客户标志
    ,nvl(n.crdt_pty_flg, o.crdt_pty_flg) as crdt_pty_flg -- 授信客户标志
    ,nvl(n.small_eown_flg, o.small_eown_flg) as small_eown_flg -- 小微企业主标志
    ,nvl(n.pty_level_cd, o.pty_level_cd) as pty_level_cd -- 客户级别代码
    ,nvl(n.insd_and_otsd_flg, o.insd_and_otsd_flg) as insd_and_otsd_flg -- 境内外标志
    ,nvl(n.work_stus, o.work_stus) as work_stus -- 雇佣状态
    ,nvl(n.house_value, o.house_value) as house_value -- 房产价值
    ,case when
            n.key_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.key_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.key_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rcds_ir_tzbl_jbxx_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rcds_ir_tzbl_jbxx where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.key_id = n.key_id
where (
        o.key_id is null
    )
    or (
        n.key_id is null
    )
    or (
        o.data_dt <> n.data_dt
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.pty_typ_cd <> n.pty_typ_cd
        or o.pty_blng_indu_cd <> n.pty_blng_indu_cd
        or o.pty_loc_cd <> n.pty_loc_cd
        or o.non_resident_flg <> n.non_resident_flg
        or o.farmer_flg <> n.farmer_flg
        or o.indv_indu_com_acct_flg <> n.indv_indu_com_acct_flg
        or o.pty_status_cd <> n.pty_status_cd
        or o.age <> n.age
        or o.valid_gender_cd <> n.valid_gender_cd
        or o.native_place_cd <> n.native_place_cd
        or o.nation_cd <> n.nation_cd
        or o.poli_face_cd <> n.poli_face_cd
        or o.marriage_status_cd <> n.marriage_status_cd
        or o.highest_edu_degree_cd <> n.highest_edu_degree_cd
        or o.reside_status_cd <> n.reside_status_cd
        or o.join_work_year <> n.join_work_year
        or o.join_enterprise_year <> n.join_enterprise_year
        or o.corp_blng_indu_cd <> n.corp_blng_indu_cd
        or o.corp_prop_cd <> n.corp_prop_cd
        or o.profsn_title_cd <> n.profsn_title_cd
        or o.ghb_emp_flg <> n.ghb_emp_flg
        or o.ghb_shrholder_flg <> n.ghb_shrholder_flg
        or o.raise_cnt <> n.raise_cnt
        or o.family_anl_inc <> n.family_anl_inc
        or o.family_mon_income <> n.family_mon_income
        or o.indv_mon_income <> n.indv_mon_income
        or o.indv_year_income <> n.indv_year_income
        or o.blkl_pty_flg <> n.blkl_pty_flg
        or o.crdt_pty_flg <> n.crdt_pty_flg
        or o.small_eown_flg <> n.small_eown_flg
        or o.pty_level_cd <> n.pty_level_cd
        or o.insd_and_otsd_flg <> n.insd_and_otsd_flg
        or o.work_stus <> n.work_stus
        or o.house_value <> n.house_value
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_tzbl_jbxx_cl(
            key_id -- 主键
            ,data_dt -- 数据日期
            ,cust_id -- 客户号
            ,cust_name -- 客户名称
            ,pty_typ_cd -- 客户类型代码
            ,pty_blng_indu_cd -- 客户所属行业代码
            ,pty_loc_cd -- 客户所在地代码
            ,non_resident_flg -- 非居民标志
            ,farmer_flg -- 农户标志
            ,indv_indu_com_acct_flg -- 个体工商户标志
            ,pty_status_cd -- 客户状态代码
            ,age -- 年龄
            ,valid_gender_cd -- 性别
            ,native_place_cd -- 籍贯代码
            ,nation_cd -- 国籍代码
            ,poli_face_cd -- 政治面貌代码
            ,marriage_status_cd -- 婚姻状况代码
            ,highest_edu_degree_cd -- 最高学历代码
            ,reside_status_cd -- 居住状况代码
            ,join_work_year -- 参加工作年限
            ,join_enterprise_year -- 加入现单位年限
            ,corp_blng_indu_cd -- 单位所属行业代码
            ,corp_prop_cd -- 单位性质代码
            ,profsn_title_cd -- 职称代码
            ,ghb_emp_flg -- 本行员工标志
            ,ghb_shrholder_flg -- 本行股东标志
            ,raise_cnt -- 供养人数
            ,family_anl_inc -- 家庭年收入
            ,family_mon_income -- 家庭月收入
            ,indv_mon_income -- 个人月收入
            ,indv_year_income -- 个人年收入
            ,blkl_pty_flg -- 黑名单客户标志
            ,crdt_pty_flg -- 授信客户标志
            ,small_eown_flg -- 小微企业主标志
            ,pty_level_cd -- 客户级别代码
            ,insd_and_otsd_flg -- 境内外标志
            ,work_stus -- 雇佣状态
            ,house_value -- 房产价值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_tzbl_jbxx_op(
            key_id -- 主键
            ,data_dt -- 数据日期
            ,cust_id -- 客户号
            ,cust_name -- 客户名称
            ,pty_typ_cd -- 客户类型代码
            ,pty_blng_indu_cd -- 客户所属行业代码
            ,pty_loc_cd -- 客户所在地代码
            ,non_resident_flg -- 非居民标志
            ,farmer_flg -- 农户标志
            ,indv_indu_com_acct_flg -- 个体工商户标志
            ,pty_status_cd -- 客户状态代码
            ,age -- 年龄
            ,valid_gender_cd -- 性别
            ,native_place_cd -- 籍贯代码
            ,nation_cd -- 国籍代码
            ,poli_face_cd -- 政治面貌代码
            ,marriage_status_cd -- 婚姻状况代码
            ,highest_edu_degree_cd -- 最高学历代码
            ,reside_status_cd -- 居住状况代码
            ,join_work_year -- 参加工作年限
            ,join_enterprise_year -- 加入现单位年限
            ,corp_blng_indu_cd -- 单位所属行业代码
            ,corp_prop_cd -- 单位性质代码
            ,profsn_title_cd -- 职称代码
            ,ghb_emp_flg -- 本行员工标志
            ,ghb_shrholder_flg -- 本行股东标志
            ,raise_cnt -- 供养人数
            ,family_anl_inc -- 家庭年收入
            ,family_mon_income -- 家庭月收入
            ,indv_mon_income -- 个人月收入
            ,indv_year_income -- 个人年收入
            ,blkl_pty_flg -- 黑名单客户标志
            ,crdt_pty_flg -- 授信客户标志
            ,small_eown_flg -- 小微企业主标志
            ,pty_level_cd -- 客户级别代码
            ,insd_and_otsd_flg -- 境内外标志
            ,work_stus -- 雇佣状态
            ,house_value -- 房产价值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.key_id -- 主键
    ,o.data_dt -- 数据日期
    ,o.cust_id -- 客户号
    ,o.cust_name -- 客户名称
    ,o.pty_typ_cd -- 客户类型代码
    ,o.pty_blng_indu_cd -- 客户所属行业代码
    ,o.pty_loc_cd -- 客户所在地代码
    ,o.non_resident_flg -- 非居民标志
    ,o.farmer_flg -- 农户标志
    ,o.indv_indu_com_acct_flg -- 个体工商户标志
    ,o.pty_status_cd -- 客户状态代码
    ,o.age -- 年龄
    ,o.valid_gender_cd -- 性别
    ,o.native_place_cd -- 籍贯代码
    ,o.nation_cd -- 国籍代码
    ,o.poli_face_cd -- 政治面貌代码
    ,o.marriage_status_cd -- 婚姻状况代码
    ,o.highest_edu_degree_cd -- 最高学历代码
    ,o.reside_status_cd -- 居住状况代码
    ,o.join_work_year -- 参加工作年限
    ,o.join_enterprise_year -- 加入现单位年限
    ,o.corp_blng_indu_cd -- 单位所属行业代码
    ,o.corp_prop_cd -- 单位性质代码
    ,o.profsn_title_cd -- 职称代码
    ,o.ghb_emp_flg -- 本行员工标志
    ,o.ghb_shrholder_flg -- 本行股东标志
    ,o.raise_cnt -- 供养人数
    ,o.family_anl_inc -- 家庭年收入
    ,o.family_mon_income -- 家庭月收入
    ,o.indv_mon_income -- 个人月收入
    ,o.indv_year_income -- 个人年收入
    ,o.blkl_pty_flg -- 黑名单客户标志
    ,o.crdt_pty_flg -- 授信客户标志
    ,o.small_eown_flg -- 小微企业主标志
    ,o.pty_level_cd -- 客户级别代码
    ,o.insd_and_otsd_flg -- 境内外标志
    ,o.work_stus -- 雇佣状态
    ,o.house_value -- 房产价值
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
from ${iol_schema}.rcds_ir_tzbl_jbxx_bk o
    left join ${iol_schema}.rcds_ir_tzbl_jbxx_op n
        on
            o.key_id = n.key_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rcds_ir_tzbl_jbxx_cl d
        on
            o.key_id = d.key_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.rcds_ir_tzbl_jbxx;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rcds_ir_tzbl_jbxx') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rcds_ir_tzbl_jbxx drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rcds_ir_tzbl_jbxx add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rcds_ir_tzbl_jbxx exchange partition p_${batch_date} with table ${iol_schema}.rcds_ir_tzbl_jbxx_cl;
alter table ${iol_schema}.rcds_ir_tzbl_jbxx exchange partition p_20991231 with table ${iol_schema}.rcds_ir_tzbl_jbxx_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rcds_ir_tzbl_jbxx to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_tzbl_jbxx_op purge;
drop table ${iol_schema}.rcds_ir_tzbl_jbxx_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rcds_ir_tzbl_jbxx_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rcds_ir_tzbl_jbxx',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
