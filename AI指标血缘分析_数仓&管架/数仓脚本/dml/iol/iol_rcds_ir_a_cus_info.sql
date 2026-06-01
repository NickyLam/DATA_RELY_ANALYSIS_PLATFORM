/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rcds_ir_a_cus_info
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
create table ${iol_schema}.rcds_ir_a_cus_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rcds_ir_a_cus_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_a_cus_info_op purge;
drop table ${iol_schema}.rcds_ir_a_cus_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_a_cus_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_a_cus_info where 0=1;

create table ${iol_schema}.rcds_ir_a_cus_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_a_cus_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_a_cus_info_cl(
            grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,customerid -- 客户身份证号
            ,cus_name -- 客户姓名
            ,cus_mobile -- 手机号码
            ,cus_home_tel -- 家庭电话
            ,cus_corp_name -- 工作单位
            ,cus_corp_tel -- 工作单位电话
            ,cus_home_ad -- 居住地址
            ,cus_reg_ad -- 户籍地址
            ,cus_post_ad -- 通讯地址
            ,cus_corp_ad -- 工作单位地址
            ,cus_email -- 电子邮箱
            ,emergencontact_name -- 紧急联系人姓名
            ,emergencontact_id -- 紧急联系人身份证号
            ,emergencontact_mobile -- 紧急联系人手机号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_a_cus_info_op(
            grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,customerid -- 客户身份证号
            ,cus_name -- 客户姓名
            ,cus_mobile -- 手机号码
            ,cus_home_tel -- 家庭电话
            ,cus_corp_name -- 工作单位
            ,cus_corp_tel -- 工作单位电话
            ,cus_home_ad -- 居住地址
            ,cus_reg_ad -- 户籍地址
            ,cus_post_ad -- 通讯地址
            ,cus_corp_ad -- 工作单位地址
            ,cus_email -- 电子邮箱
            ,emergencontact_name -- 紧急联系人姓名
            ,emergencontact_id -- 紧急联系人身份证号
            ,emergencontact_mobile -- 紧急联系人手机号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.grade_key_id, o.grade_key_id) as grade_key_id -- 申请评分流水号
    ,nvl(n.data_time, o.data_time) as data_time -- 数据记录时间
    ,nvl(n.customerid, o.customerid) as customerid -- 客户身份证号
    ,nvl(n.cus_name, o.cus_name) as cus_name -- 客户姓名
    ,nvl(n.cus_mobile, o.cus_mobile) as cus_mobile -- 手机号码
    ,nvl(n.cus_home_tel, o.cus_home_tel) as cus_home_tel -- 家庭电话
    ,nvl(n.cus_corp_name, o.cus_corp_name) as cus_corp_name -- 工作单位
    ,nvl(n.cus_corp_tel, o.cus_corp_tel) as cus_corp_tel -- 工作单位电话
    ,nvl(n.cus_home_ad, o.cus_home_ad) as cus_home_ad -- 居住地址
    ,nvl(n.cus_reg_ad, o.cus_reg_ad) as cus_reg_ad -- 户籍地址
    ,nvl(n.cus_post_ad, o.cus_post_ad) as cus_post_ad -- 通讯地址
    ,nvl(n.cus_corp_ad, o.cus_corp_ad) as cus_corp_ad -- 工作单位地址
    ,nvl(n.cus_email, o.cus_email) as cus_email -- 电子邮箱
    ,nvl(n.emergencontact_name, o.emergencontact_name) as emergencontact_name -- 紧急联系人姓名
    ,nvl(n.emergencontact_id, o.emergencontact_id) as emergencontact_id -- 紧急联系人身份证号
    ,nvl(n.emergencontact_mobile, o.emergencontact_mobile) as emergencontact_mobile -- 紧急联系人手机号
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
from (select * from ${iol_schema}.rcds_ir_a_cus_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rcds_ir_a_cus_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.customerid <> n.customerid
        or o.cus_name <> n.cus_name
        or o.cus_mobile <> n.cus_mobile
        or o.cus_home_tel <> n.cus_home_tel
        or o.cus_corp_name <> n.cus_corp_name
        or o.cus_corp_tel <> n.cus_corp_tel
        or o.cus_home_ad <> n.cus_home_ad
        or o.cus_reg_ad <> n.cus_reg_ad
        or o.cus_post_ad <> n.cus_post_ad
        or o.cus_corp_ad <> n.cus_corp_ad
        or o.cus_email <> n.cus_email
        or o.emergencontact_name <> n.emergencontact_name
        or o.emergencontact_id <> n.emergencontact_id
        or o.emergencontact_mobile <> n.emergencontact_mobile
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_a_cus_info_cl(
            grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,customerid -- 客户身份证号
            ,cus_name -- 客户姓名
            ,cus_mobile -- 手机号码
            ,cus_home_tel -- 家庭电话
            ,cus_corp_name -- 工作单位
            ,cus_corp_tel -- 工作单位电话
            ,cus_home_ad -- 居住地址
            ,cus_reg_ad -- 户籍地址
            ,cus_post_ad -- 通讯地址
            ,cus_corp_ad -- 工作单位地址
            ,cus_email -- 电子邮箱
            ,emergencontact_name -- 紧急联系人姓名
            ,emergencontact_id -- 紧急联系人身份证号
            ,emergencontact_mobile -- 紧急联系人手机号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_a_cus_info_op(
            grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,customerid -- 客户身份证号
            ,cus_name -- 客户姓名
            ,cus_mobile -- 手机号码
            ,cus_home_tel -- 家庭电话
            ,cus_corp_name -- 工作单位
            ,cus_corp_tel -- 工作单位电话
            ,cus_home_ad -- 居住地址
            ,cus_reg_ad -- 户籍地址
            ,cus_post_ad -- 通讯地址
            ,cus_corp_ad -- 工作单位地址
            ,cus_email -- 电子邮箱
            ,emergencontact_name -- 紧急联系人姓名
            ,emergencontact_id -- 紧急联系人身份证号
            ,emergencontact_mobile -- 紧急联系人手机号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.grade_key_id -- 申请评分流水号
    ,o.data_time -- 数据记录时间
    ,o.customerid -- 客户身份证号
    ,o.cus_name -- 客户姓名
    ,o.cus_mobile -- 手机号码
    ,o.cus_home_tel -- 家庭电话
    ,o.cus_corp_name -- 工作单位
    ,o.cus_corp_tel -- 工作单位电话
    ,o.cus_home_ad -- 居住地址
    ,o.cus_reg_ad -- 户籍地址
    ,o.cus_post_ad -- 通讯地址
    ,o.cus_corp_ad -- 工作单位地址
    ,o.cus_email -- 电子邮箱
    ,o.emergencontact_name -- 紧急联系人姓名
    ,o.emergencontact_id -- 紧急联系人身份证号
    ,o.emergencontact_mobile -- 紧急联系人手机号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.rcds_ir_a_cus_info_bk o
    left join ${iol_schema}.rcds_ir_a_cus_info_op n
        on
            o.grade_key_id = n.grade_key_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rcds_ir_a_cus_info_cl d
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
-- truncate table ${iol_schema}.rcds_ir_a_cus_info;

-- 4.2 exchange partition
alter table ${iol_schema}.rcds_ir_a_cus_info exchange partition p_19000101 with table ${iol_schema}.rcds_ir_a_cus_info_cl;
alter table ${iol_schema}.rcds_ir_a_cus_info exchange partition p_20991231 with table ${iol_schema}.rcds_ir_a_cus_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rcds_ir_a_cus_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_a_cus_info_op purge;
drop table ${iol_schema}.rcds_ir_a_cus_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rcds_ir_a_cus_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rcds_ir_a_cus_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
