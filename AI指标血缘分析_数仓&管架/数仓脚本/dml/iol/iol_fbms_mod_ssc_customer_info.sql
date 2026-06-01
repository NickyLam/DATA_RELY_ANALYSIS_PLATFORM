/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fbms_mod_ssc_customer_info
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
create table ${iol_schema}.fbms_mod_ssc_customer_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fbms_mod_ssc_customer_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fbms_mod_ssc_customer_info_op purge;
drop table ${iol_schema}.fbms_mod_ssc_customer_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fbms_mod_ssc_customer_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fbms_mod_ssc_customer_info where 0=1;

create table ${iol_schema}.fbms_mod_ssc_customer_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fbms_mod_ssc_customer_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fbms_mod_ssc_customer_info_cl(
            sysid -- 应用编号默认2000
            ,plat_date -- 平台日期
            ,plat_time -- 平台时间
            ,plat_serial_no -- 平台流水号
            ,cust_num -- 客户号
            ,cust_name -- 客户名称
            ,cert_type_cd -- 证件类型（银行）
            ,cert_num -- 证件号码
            ,phys_addr_cty_zone_cd -- 国家地区代码
            ,cert_begin_date -- 证件生效日期
            ,cert_end_date -- 证件失效日期
            ,gender_cd -- 性别,0-未知的性别,-男性,2-女性,9-未说明的性别,
            ,ethnic_cd -- 民族
            ,birth_dt -- 出生日期
            ,house_addr -- 户口地址
            ,mobile_num -- 手机号码
            ,tel_num -- 电话号码
            ,postal_addr -- 详细地址-通讯地址
            ,post_cd -- 邮政编码
            ,email -- 电子地址-邮箱
            ,work_corp_num -- 单位编号
            ,work_corp_name -- 工作单位名称
            ,work_corp_addr -- 工作单位地址
            ,career_cd -- 职业类型，按银行码值保存
            ,guardian_cert_type_cd -- 监护人证件类型（银行）
            ,guardian_cert_num -- 监护人证件号码
            ,guardian_name -- 监护人姓名
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 修改时间戳
            ,ext1 -- 备用字段1
            ,ext2 -- 备用字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fbms_mod_ssc_customer_info_op(
            sysid -- 应用编号默认2000
            ,plat_date -- 平台日期
            ,plat_time -- 平台时间
            ,plat_serial_no -- 平台流水号
            ,cust_num -- 客户号
            ,cust_name -- 客户名称
            ,cert_type_cd -- 证件类型（银行）
            ,cert_num -- 证件号码
            ,phys_addr_cty_zone_cd -- 国家地区代码
            ,cert_begin_date -- 证件生效日期
            ,cert_end_date -- 证件失效日期
            ,gender_cd -- 性别,0-未知的性别,-男性,2-女性,9-未说明的性别,
            ,ethnic_cd -- 民族
            ,birth_dt -- 出生日期
            ,house_addr -- 户口地址
            ,mobile_num -- 手机号码
            ,tel_num -- 电话号码
            ,postal_addr -- 详细地址-通讯地址
            ,post_cd -- 邮政编码
            ,email -- 电子地址-邮箱
            ,work_corp_num -- 单位编号
            ,work_corp_name -- 工作单位名称
            ,work_corp_addr -- 工作单位地址
            ,career_cd -- 职业类型，按银行码值保存
            ,guardian_cert_type_cd -- 监护人证件类型（银行）
            ,guardian_cert_num -- 监护人证件号码
            ,guardian_name -- 监护人姓名
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 修改时间戳
            ,ext1 -- 备用字段1
            ,ext2 -- 备用字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sysid, o.sysid) as sysid -- 应用编号默认2000
    ,nvl(n.plat_date, o.plat_date) as plat_date -- 平台日期
    ,nvl(n.plat_time, o.plat_time) as plat_time -- 平台时间
    ,nvl(n.plat_serial_no, o.plat_serial_no) as plat_serial_no -- 平台流水号
    ,nvl(n.cust_num, o.cust_num) as cust_num -- 客户号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型（银行）
    ,nvl(n.cert_num, o.cert_num) as cert_num -- 证件号码
    ,nvl(n.phys_addr_cty_zone_cd, o.phys_addr_cty_zone_cd) as phys_addr_cty_zone_cd -- 国家地区代码
    ,nvl(n.cert_begin_date, o.cert_begin_date) as cert_begin_date -- 证件生效日期
    ,nvl(n.cert_end_date, o.cert_end_date) as cert_end_date -- 证件失效日期
    ,nvl(n.gender_cd, o.gender_cd) as gender_cd -- 性别,0-未知的性别,-男性,2-女性,9-未说明的性别,
    ,nvl(n.ethnic_cd, o.ethnic_cd) as ethnic_cd -- 民族
    ,nvl(n.birth_dt, o.birth_dt) as birth_dt -- 出生日期
    ,nvl(n.house_addr, o.house_addr) as house_addr -- 户口地址
    ,nvl(n.mobile_num, o.mobile_num) as mobile_num -- 手机号码
    ,nvl(n.tel_num, o.tel_num) as tel_num -- 电话号码
    ,nvl(n.postal_addr, o.postal_addr) as postal_addr -- 详细地址-通讯地址
    ,nvl(n.post_cd, o.post_cd) as post_cd -- 邮政编码
    ,nvl(n.email, o.email) as email -- 电子地址-邮箱
    ,nvl(n.work_corp_num, o.work_corp_num) as work_corp_num -- 单位编号
    ,nvl(n.work_corp_name, o.work_corp_name) as work_corp_name -- 工作单位名称
    ,nvl(n.work_corp_addr, o.work_corp_addr) as work_corp_addr -- 工作单位地址
    ,nvl(n.career_cd, o.career_cd) as career_cd -- 职业类型，按银行码值保存
    ,nvl(n.guardian_cert_type_cd, o.guardian_cert_type_cd) as guardian_cert_type_cd -- 监护人证件类型（银行）
    ,nvl(n.guardian_cert_num, o.guardian_cert_num) as guardian_cert_num -- 监护人证件号码
    ,nvl(n.guardian_name, o.guardian_name) as guardian_name -- 监护人姓名
    ,nvl(n.create_timestamp, o.create_timestamp) as create_timestamp -- 创建时间戳
    ,nvl(n.update_timestamp, o.update_timestamp) as update_timestamp -- 修改时间戳
    ,nvl(n.ext1, o.ext1) as ext1 -- 备用字段1
    ,nvl(n.ext2, o.ext2) as ext2 -- 备用字段2
    ,case when
            n.cust_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cust_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cust_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fbms_mod_ssc_customer_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fbms_mod_ssc_customer_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cust_num = n.cust_num
where (
        o.cust_num is null
    )
    or (
        n.cust_num is null
    )
    or (
        o.sysid <> n.sysid
        or o.plat_date <> n.plat_date
        or o.plat_time <> n.plat_time
        or o.plat_serial_no <> n.plat_serial_no
        or o.cust_name <> n.cust_name
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_num <> n.cert_num
        or o.phys_addr_cty_zone_cd <> n.phys_addr_cty_zone_cd
        or o.cert_begin_date <> n.cert_begin_date
        or o.cert_end_date <> n.cert_end_date
        or o.gender_cd <> n.gender_cd
        or o.ethnic_cd <> n.ethnic_cd
        or o.birth_dt <> n.birth_dt
        or o.house_addr <> n.house_addr
        or o.mobile_num <> n.mobile_num
        or o.tel_num <> n.tel_num
        or o.postal_addr <> n.postal_addr
        or o.post_cd <> n.post_cd
        or o.email <> n.email
        or o.work_corp_num <> n.work_corp_num
        or o.work_corp_name <> n.work_corp_name
        or o.work_corp_addr <> n.work_corp_addr
        or o.career_cd <> n.career_cd
        or o.guardian_cert_type_cd <> n.guardian_cert_type_cd
        or o.guardian_cert_num <> n.guardian_cert_num
        or o.guardian_name <> n.guardian_name
        or o.create_timestamp <> n.create_timestamp
        or o.update_timestamp <> n.update_timestamp
        or o.ext1 <> n.ext1
        or o.ext2 <> n.ext2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fbms_mod_ssc_customer_info_cl(
            sysid -- 应用编号默认2000
            ,plat_date -- 平台日期
            ,plat_time -- 平台时间
            ,plat_serial_no -- 平台流水号
            ,cust_num -- 客户号
            ,cust_name -- 客户名称
            ,cert_type_cd -- 证件类型（银行）
            ,cert_num -- 证件号码
            ,phys_addr_cty_zone_cd -- 国家地区代码
            ,cert_begin_date -- 证件生效日期
            ,cert_end_date -- 证件失效日期
            ,gender_cd -- 性别,0-未知的性别,-男性,2-女性,9-未说明的性别,
            ,ethnic_cd -- 民族
            ,birth_dt -- 出生日期
            ,house_addr -- 户口地址
            ,mobile_num -- 手机号码
            ,tel_num -- 电话号码
            ,postal_addr -- 详细地址-通讯地址
            ,post_cd -- 邮政编码
            ,email -- 电子地址-邮箱
            ,work_corp_num -- 单位编号
            ,work_corp_name -- 工作单位名称
            ,work_corp_addr -- 工作单位地址
            ,career_cd -- 职业类型，按银行码值保存
            ,guardian_cert_type_cd -- 监护人证件类型（银行）
            ,guardian_cert_num -- 监护人证件号码
            ,guardian_name -- 监护人姓名
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 修改时间戳
            ,ext1 -- 备用字段1
            ,ext2 -- 备用字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fbms_mod_ssc_customer_info_op(
            sysid -- 应用编号默认2000
            ,plat_date -- 平台日期
            ,plat_time -- 平台时间
            ,plat_serial_no -- 平台流水号
            ,cust_num -- 客户号
            ,cust_name -- 客户名称
            ,cert_type_cd -- 证件类型（银行）
            ,cert_num -- 证件号码
            ,phys_addr_cty_zone_cd -- 国家地区代码
            ,cert_begin_date -- 证件生效日期
            ,cert_end_date -- 证件失效日期
            ,gender_cd -- 性别,0-未知的性别,-男性,2-女性,9-未说明的性别,
            ,ethnic_cd -- 民族
            ,birth_dt -- 出生日期
            ,house_addr -- 户口地址
            ,mobile_num -- 手机号码
            ,tel_num -- 电话号码
            ,postal_addr -- 详细地址-通讯地址
            ,post_cd -- 邮政编码
            ,email -- 电子地址-邮箱
            ,work_corp_num -- 单位编号
            ,work_corp_name -- 工作单位名称
            ,work_corp_addr -- 工作单位地址
            ,career_cd -- 职业类型，按银行码值保存
            ,guardian_cert_type_cd -- 监护人证件类型（银行）
            ,guardian_cert_num -- 监护人证件号码
            ,guardian_name -- 监护人姓名
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 修改时间戳
            ,ext1 -- 备用字段1
            ,ext2 -- 备用字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sysid -- 应用编号默认2000
    ,o.plat_date -- 平台日期
    ,o.plat_time -- 平台时间
    ,o.plat_serial_no -- 平台流水号
    ,o.cust_num -- 客户号
    ,o.cust_name -- 客户名称
    ,o.cert_type_cd -- 证件类型（银行）
    ,o.cert_num -- 证件号码
    ,o.phys_addr_cty_zone_cd -- 国家地区代码
    ,o.cert_begin_date -- 证件生效日期
    ,o.cert_end_date -- 证件失效日期
    ,o.gender_cd -- 性别,0-未知的性别,-男性,2-女性,9-未说明的性别,
    ,o.ethnic_cd -- 民族
    ,o.birth_dt -- 出生日期
    ,o.house_addr -- 户口地址
    ,o.mobile_num -- 手机号码
    ,o.tel_num -- 电话号码
    ,o.postal_addr -- 详细地址-通讯地址
    ,o.post_cd -- 邮政编码
    ,o.email -- 电子地址-邮箱
    ,o.work_corp_num -- 单位编号
    ,o.work_corp_name -- 工作单位名称
    ,o.work_corp_addr -- 工作单位地址
    ,o.career_cd -- 职业类型，按银行码值保存
    ,o.guardian_cert_type_cd -- 监护人证件类型（银行）
    ,o.guardian_cert_num -- 监护人证件号码
    ,o.guardian_name -- 监护人姓名
    ,o.create_timestamp -- 创建时间戳
    ,o.update_timestamp -- 修改时间戳
    ,o.ext1 -- 备用字段1
    ,o.ext2 -- 备用字段2
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
from ${iol_schema}.fbms_mod_ssc_customer_info_bk o
    left join ${iol_schema}.fbms_mod_ssc_customer_info_op n
        on
            o.cust_num = n.cust_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fbms_mod_ssc_customer_info_cl d
        on
            o.cust_num = d.cust_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fbms_mod_ssc_customer_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fbms_mod_ssc_customer_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fbms_mod_ssc_customer_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fbms_mod_ssc_customer_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fbms_mod_ssc_customer_info exchange partition p_${batch_date} with table ${iol_schema}.fbms_mod_ssc_customer_info_cl;
alter table ${iol_schema}.fbms_mod_ssc_customer_info exchange partition p_20991231 with table ${iol_schema}.fbms_mod_ssc_customer_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fbms_mod_ssc_customer_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fbms_mod_ssc_customer_info_op purge;
drop table ${iol_schema}.fbms_mod_ssc_customer_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fbms_mod_ssc_customer_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fbms_mod_ssc_customer_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
