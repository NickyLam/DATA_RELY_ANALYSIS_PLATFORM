/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rcds_ir_tzbl_a_rktj
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
create table ${iol_schema}.rcds_ir_tzbl_a_rktj_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rcds_ir_tzbl_a_rktj;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_tzbl_a_rktj_op purge;
drop table ${iol_schema}.rcds_ir_tzbl_a_rktj_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_tzbl_a_rktj_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_tzbl_a_rktj where 0=1;

create table ${iol_schema}.rcds_ir_tzbl_a_rktj_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_tzbl_a_rktj where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_tzbl_a_rktj_cl(
            grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,serialno -- 申请流水号
            ,create_time -- 创建时间
            ,age_raw -- 年龄
            ,business_code -- 行业类型（金融、建筑、通讯等）
            ,childflag2 -- 有无子女
            ,dummy_employer -- 有无工作单位
            ,dummy_home_address -- 有无家庭地址
            ,dummy_work_address -- 有无单位地址
            ,dummy_mobile_no -- 有无申请人移动电话
            ,dummy_work_phone_no -- 有无单位电话
            ,education -- 教育程度
            ,emp_status -- 雇佣状态（自雇、受薪)
            ,gender -- 性别
            ,marriage_status -- 婚姻状态
            ,residence_type -- 现住房状况（自有，租赁，合住等）
            ,house_value -- 房产价值
            ,house_flag1 -- 本地有无房产
            ,industryage -- 企业成立年限
            ,months_curr_address_raw -- 现住址居住时间
            ,months_curr_employer -- 现单位工作年限
            ,gender_marital -- 性别与婚姻状态
            ,gender_residence -- 性别与现住房状况
            ,residence_marital -- 现住房状况与婚姻
            ,profsn_title_cd -- 职称代码（初级、中级、高级）
            ,verified_income_all -- 认定月收入
            ,worknature -- 单位性质
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_tzbl_a_rktj_op(
            grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,serialno -- 申请流水号
            ,create_time -- 创建时间
            ,age_raw -- 年龄
            ,business_code -- 行业类型（金融、建筑、通讯等）
            ,childflag2 -- 有无子女
            ,dummy_employer -- 有无工作单位
            ,dummy_home_address -- 有无家庭地址
            ,dummy_work_address -- 有无单位地址
            ,dummy_mobile_no -- 有无申请人移动电话
            ,dummy_work_phone_no -- 有无单位电话
            ,education -- 教育程度
            ,emp_status -- 雇佣状态（自雇、受薪)
            ,gender -- 性别
            ,marriage_status -- 婚姻状态
            ,residence_type -- 现住房状况（自有，租赁，合住等）
            ,house_value -- 房产价值
            ,house_flag1 -- 本地有无房产
            ,industryage -- 企业成立年限
            ,months_curr_address_raw -- 现住址居住时间
            ,months_curr_employer -- 现单位工作年限
            ,gender_marital -- 性别与婚姻状态
            ,gender_residence -- 性别与现住房状况
            ,residence_marital -- 现住房状况与婚姻
            ,profsn_title_cd -- 职称代码（初级、中级、高级）
            ,verified_income_all -- 认定月收入
            ,worknature -- 单位性质
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.grade_key_id, o.grade_key_id) as grade_key_id -- 申请评分流水号
    ,nvl(n.data_time, o.data_time) as data_time -- 数据记录时间
    ,nvl(n.serialno, o.serialno) as serialno -- 申请流水号
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.age_raw, o.age_raw) as age_raw -- 年龄
    ,nvl(n.business_code, o.business_code) as business_code -- 行业类型（金融、建筑、通讯等）
    ,nvl(n.childflag2, o.childflag2) as childflag2 -- 有无子女
    ,nvl(n.dummy_employer, o.dummy_employer) as dummy_employer -- 有无工作单位
    ,nvl(n.dummy_home_address, o.dummy_home_address) as dummy_home_address -- 有无家庭地址
    ,nvl(n.dummy_work_address, o.dummy_work_address) as dummy_work_address -- 有无单位地址
    ,nvl(n.dummy_mobile_no, o.dummy_mobile_no) as dummy_mobile_no -- 有无申请人移动电话
    ,nvl(n.dummy_work_phone_no, o.dummy_work_phone_no) as dummy_work_phone_no -- 有无单位电话
    ,nvl(n.education, o.education) as education -- 教育程度
    ,nvl(n.emp_status, o.emp_status) as emp_status -- 雇佣状态（自雇、受薪)
    ,nvl(n.gender, o.gender) as gender -- 性别
    ,nvl(n.marriage_status, o.marriage_status) as marriage_status -- 婚姻状态
    ,nvl(n.residence_type, o.residence_type) as residence_type -- 现住房状况（自有，租赁，合住等）
    ,nvl(n.house_value, o.house_value) as house_value -- 房产价值
    ,nvl(n.house_flag1, o.house_flag1) as house_flag1 -- 本地有无房产
    ,nvl(n.industryage, o.industryage) as industryage -- 企业成立年限
    ,nvl(n.months_curr_address_raw, o.months_curr_address_raw) as months_curr_address_raw -- 现住址居住时间
    ,nvl(n.months_curr_employer, o.months_curr_employer) as months_curr_employer -- 现单位工作年限
    ,nvl(n.gender_marital, o.gender_marital) as gender_marital -- 性别与婚姻状态
    ,nvl(n.gender_residence, o.gender_residence) as gender_residence -- 性别与现住房状况
    ,nvl(n.residence_marital, o.residence_marital) as residence_marital -- 现住房状况与婚姻
    ,nvl(n.profsn_title_cd, o.profsn_title_cd) as profsn_title_cd -- 职称代码（初级、中级、高级）
    ,nvl(n.verified_income_all, o.verified_income_all) as verified_income_all -- 认定月收入
    ,nvl(n.worknature, o.worknature) as worknature -- 单位性质
    ,case when
            n.grade_key_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.grade_key_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.grade_key_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rcds_ir_tzbl_a_rktj_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rcds_ir_tzbl_a_rktj where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.grade_key_id = n.grade_key_id
where (
        o.grade_key_id is null
    )
    or (
        n.grade_key_id is null
    )
    or (
        o.data_time <> n.data_time
        or o.serialno <> n.serialno
        or o.create_time <> n.create_time
        or o.age_raw <> n.age_raw
        or o.business_code <> n.business_code
        or o.childflag2 <> n.childflag2
        or o.dummy_employer <> n.dummy_employer
        or o.dummy_home_address <> n.dummy_home_address
        or o.dummy_work_address <> n.dummy_work_address
        or o.dummy_mobile_no <> n.dummy_mobile_no
        or o.dummy_work_phone_no <> n.dummy_work_phone_no
        or o.education <> n.education
        or o.emp_status <> n.emp_status
        or o.gender <> n.gender
        or o.marriage_status <> n.marriage_status
        or o.residence_type <> n.residence_type
        or o.house_value <> n.house_value
        or o.house_flag1 <> n.house_flag1
        or o.industryage <> n.industryage
        or o.months_curr_address_raw <> n.months_curr_address_raw
        or o.months_curr_employer <> n.months_curr_employer
        or o.gender_marital <> n.gender_marital
        or o.gender_residence <> n.gender_residence
        or o.residence_marital <> n.residence_marital
        or o.profsn_title_cd <> n.profsn_title_cd
        or o.verified_income_all <> n.verified_income_all
        or o.worknature <> n.worknature
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_tzbl_a_rktj_cl(
            grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,serialno -- 申请流水号
            ,create_time -- 创建时间
            ,age_raw -- 年龄
            ,business_code -- 行业类型（金融、建筑、通讯等）
            ,childflag2 -- 有无子女
            ,dummy_employer -- 有无工作单位
            ,dummy_home_address -- 有无家庭地址
            ,dummy_work_address -- 有无单位地址
            ,dummy_mobile_no -- 有无申请人移动电话
            ,dummy_work_phone_no -- 有无单位电话
            ,education -- 教育程度
            ,emp_status -- 雇佣状态（自雇、受薪)
            ,gender -- 性别
            ,marriage_status -- 婚姻状态
            ,residence_type -- 现住房状况（自有，租赁，合住等）
            ,house_value -- 房产价值
            ,house_flag1 -- 本地有无房产
            ,industryage -- 企业成立年限
            ,months_curr_address_raw -- 现住址居住时间
            ,months_curr_employer -- 现单位工作年限
            ,gender_marital -- 性别与婚姻状态
            ,gender_residence -- 性别与现住房状况
            ,residence_marital -- 现住房状况与婚姻
            ,profsn_title_cd -- 职称代码（初级、中级、高级）
            ,verified_income_all -- 认定月收入
            ,worknature -- 单位性质
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_tzbl_a_rktj_op(
            grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,serialno -- 申请流水号
            ,create_time -- 创建时间
            ,age_raw -- 年龄
            ,business_code -- 行业类型（金融、建筑、通讯等）
            ,childflag2 -- 有无子女
            ,dummy_employer -- 有无工作单位
            ,dummy_home_address -- 有无家庭地址
            ,dummy_work_address -- 有无单位地址
            ,dummy_mobile_no -- 有无申请人移动电话
            ,dummy_work_phone_no -- 有无单位电话
            ,education -- 教育程度
            ,emp_status -- 雇佣状态（自雇、受薪)
            ,gender -- 性别
            ,marriage_status -- 婚姻状态
            ,residence_type -- 现住房状况（自有，租赁，合住等）
            ,house_value -- 房产价值
            ,house_flag1 -- 本地有无房产
            ,industryage -- 企业成立年限
            ,months_curr_address_raw -- 现住址居住时间
            ,months_curr_employer -- 现单位工作年限
            ,gender_marital -- 性别与婚姻状态
            ,gender_residence -- 性别与现住房状况
            ,residence_marital -- 现住房状况与婚姻
            ,profsn_title_cd -- 职称代码（初级、中级、高级）
            ,verified_income_all -- 认定月收入
            ,worknature -- 单位性质
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.grade_key_id -- 申请评分流水号
    ,o.data_time -- 数据记录时间
    ,o.serialno -- 申请流水号
    ,o.create_time -- 创建时间
    ,o.age_raw -- 年龄
    ,o.business_code -- 行业类型（金融、建筑、通讯等）
    ,o.childflag2 -- 有无子女
    ,o.dummy_employer -- 有无工作单位
    ,o.dummy_home_address -- 有无家庭地址
    ,o.dummy_work_address -- 有无单位地址
    ,o.dummy_mobile_no -- 有无申请人移动电话
    ,o.dummy_work_phone_no -- 有无单位电话
    ,o.education -- 教育程度
    ,o.emp_status -- 雇佣状态（自雇、受薪)
    ,o.gender -- 性别
    ,o.marriage_status -- 婚姻状态
    ,o.residence_type -- 现住房状况（自有，租赁，合住等）
    ,o.house_value -- 房产价值
    ,o.house_flag1 -- 本地有无房产
    ,o.industryage -- 企业成立年限
    ,o.months_curr_address_raw -- 现住址居住时间
    ,o.months_curr_employer -- 现单位工作年限
    ,o.gender_marital -- 性别与婚姻状态
    ,o.gender_residence -- 性别与现住房状况
    ,o.residence_marital -- 现住房状况与婚姻
    ,o.profsn_title_cd -- 职称代码（初级、中级、高级）
    ,o.verified_income_all -- 认定月收入
    ,o.worknature -- 单位性质
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.rcds_ir_tzbl_a_rktj_bk o
    left join ${iol_schema}.rcds_ir_tzbl_a_rktj_op n
        on
            o.grade_key_id = n.grade_key_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rcds_ir_tzbl_a_rktj_cl d
        on
            o.grade_key_id = d.grade_key_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.rcds_ir_tzbl_a_rktj;

-- 4.2 exchange partition
alter table ${iol_schema}.rcds_ir_tzbl_a_rktj exchange partition p_19000101 with table ${iol_schema}.rcds_ir_tzbl_a_rktj_cl;
alter table ${iol_schema}.rcds_ir_tzbl_a_rktj exchange partition p_20991231 with table ${iol_schema}.rcds_ir_tzbl_a_rktj_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rcds_ir_tzbl_a_rktj to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_tzbl_a_rktj_op purge;
drop table ${iol_schema}.rcds_ir_tzbl_a_rktj_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rcds_ir_tzbl_a_rktj_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rcds_ir_tzbl_a_rktj',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
