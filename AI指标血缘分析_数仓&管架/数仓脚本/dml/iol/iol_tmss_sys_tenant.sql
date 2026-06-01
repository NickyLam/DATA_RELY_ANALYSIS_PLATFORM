/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tmss_sys_tenant
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
create table ${iol_schema}.tmss_sys_tenant_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tmss_sys_tenant
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tmss_sys_tenant_op purge;
drop table ${iol_schema}.tmss_sys_tenant_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tmss_sys_tenant_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tmss_sys_tenant where 0=1;

create table ${iol_schema}.tmss_sys_tenant_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tmss_sys_tenant where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tmss_sys_tenant_cl(
            id -- 主键ID
            ,tenant_code -- 客户号
            ,tenant_name -- 企业名称
            ,tenant_cert_type -- 企业证件类型
            ,tenant_cert_code -- 企业证件号码
            ,sign_code -- 签约机构
            ,sign_time -- 签约时间
            ,post_code -- 邮政编码
            ,tenant_phone -- 企业联系电话
            ,tenant_sina_name -- 企业中文名称
            ,tenant_eng_name -- 企业英文名称
            ,tenant_time -- 企业证明文件有效期
            ,tenant_addr -- 企业地址
            ,fr_name -- 法人/负责人
            ,fr_mobile -- 法人联系方式
            ,fr_cert_type -- 法人证件类型:01 第二代居民身份证、02 户口簿、03 临时身份证、04 中国护照、05 军官证、06 离休干部荣誉证、07 军官退休证、08 军事学员证、09 武警证、10 士兵证、11 香港通行证、12 澳门通行证、13 胞通行证或有效旅行证件、14 外国人永久居留证、15 边民出入境通行证、16:外国护照、99其他 (或采用柜面现有类别代码)
            ,fr_cert_code -- 法人证件号码
            ,fr_cert_time -- 法人证件有效期
            ,bank_seal_id -- 影像流水
            ,charge_mode -- 管理员模式: 0：否 1：是  如果是双冠 传输两个 校验list长度
            ,create_by -- 创建人
            ,create_date -- 创建时间
            ,update_by -- 更新人
            ,update_date -- 更新时间
            ,status -- 状态 0禁用 1启用
            ,sign_name -- 签约机构名称
            ,un_sign_time -- 解约时间
            ,sign_model -- 签约客户模式  common：通用功能模式、query：仅查询模式
            ,sign_user_id -- 签约柜员编码
            ,sign_agreement_id -- 协议编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tmss_sys_tenant_op(
            id -- 主键ID
            ,tenant_code -- 客户号
            ,tenant_name -- 企业名称
            ,tenant_cert_type -- 企业证件类型
            ,tenant_cert_code -- 企业证件号码
            ,sign_code -- 签约机构
            ,sign_time -- 签约时间
            ,post_code -- 邮政编码
            ,tenant_phone -- 企业联系电话
            ,tenant_sina_name -- 企业中文名称
            ,tenant_eng_name -- 企业英文名称
            ,tenant_time -- 企业证明文件有效期
            ,tenant_addr -- 企业地址
            ,fr_name -- 法人/负责人
            ,fr_mobile -- 法人联系方式
            ,fr_cert_type -- 法人证件类型:01 第二代居民身份证、02 户口簿、03 临时身份证、04 中国护照、05 军官证、06 离休干部荣誉证、07 军官退休证、08 军事学员证、09 武警证、10 士兵证、11 香港通行证、12 澳门通行证、13 胞通行证或有效旅行证件、14 外国人永久居留证、15 边民出入境通行证、16:外国护照、99其他 (或采用柜面现有类别代码)
            ,fr_cert_code -- 法人证件号码
            ,fr_cert_time -- 法人证件有效期
            ,bank_seal_id -- 影像流水
            ,charge_mode -- 管理员模式: 0：否 1：是  如果是双冠 传输两个 校验list长度
            ,create_by -- 创建人
            ,create_date -- 创建时间
            ,update_by -- 更新人
            ,update_date -- 更新时间
            ,status -- 状态 0禁用 1启用
            ,sign_name -- 签约机构名称
            ,un_sign_time -- 解约时间
            ,sign_model -- 签约客户模式  common：通用功能模式、query：仅查询模式
            ,sign_user_id -- 签约柜员编码
            ,sign_agreement_id -- 协议编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键ID
    ,nvl(n.tenant_code, o.tenant_code) as tenant_code -- 客户号
    ,nvl(n.tenant_name, o.tenant_name) as tenant_name -- 企业名称
    ,nvl(n.tenant_cert_type, o.tenant_cert_type) as tenant_cert_type -- 企业证件类型
    ,nvl(n.tenant_cert_code, o.tenant_cert_code) as tenant_cert_code -- 企业证件号码
    ,nvl(n.sign_code, o.sign_code) as sign_code -- 签约机构
    ,nvl(n.sign_time, o.sign_time) as sign_time -- 签约时间
    ,nvl(n.post_code, o.post_code) as post_code -- 邮政编码
    ,nvl(n.tenant_phone, o.tenant_phone) as tenant_phone -- 企业联系电话
    ,nvl(n.tenant_sina_name, o.tenant_sina_name) as tenant_sina_name -- 企业中文名称
    ,nvl(n.tenant_eng_name, o.tenant_eng_name) as tenant_eng_name -- 企业英文名称
    ,nvl(n.tenant_time, o.tenant_time) as tenant_time -- 企业证明文件有效期
    ,nvl(n.tenant_addr, o.tenant_addr) as tenant_addr -- 企业地址
    ,nvl(n.fr_name, o.fr_name) as fr_name -- 法人/负责人
    ,nvl(n.fr_mobile, o.fr_mobile) as fr_mobile -- 法人联系方式
    ,nvl(n.fr_cert_type, o.fr_cert_type) as fr_cert_type -- 法人证件类型:01 第二代居民身份证、02 户口簿、03 临时身份证、04 中国护照、05 军官证、06 离休干部荣誉证、07 军官退休证、08 军事学员证、09 武警证、10 士兵证、11 香港通行证、12 澳门通行证、13 胞通行证或有效旅行证件、14 外国人永久居留证、15 边民出入境通行证、16:外国护照、99其他 (或采用柜面现有类别代码)
    ,nvl(n.fr_cert_code, o.fr_cert_code) as fr_cert_code -- 法人证件号码
    ,nvl(n.fr_cert_time, o.fr_cert_time) as fr_cert_time -- 法人证件有效期
    ,nvl(n.bank_seal_id, o.bank_seal_id) as bank_seal_id -- 影像流水
    ,nvl(n.charge_mode, o.charge_mode) as charge_mode -- 管理员模式: 0：否 1：是  如果是双冠 传输两个 校验list长度
    ,nvl(n.create_by, o.create_by) as create_by -- 创建人
    ,nvl(n.create_date, o.create_date) as create_date -- 创建时间
    ,nvl(n.update_by, o.update_by) as update_by -- 更新人
    ,nvl(n.update_date, o.update_date) as update_date -- 更新时间
    ,nvl(n.status, o.status) as status -- 状态 0禁用 1启用
    ,nvl(n.sign_name, o.sign_name) as sign_name -- 签约机构名称
    ,nvl(n.un_sign_time, o.un_sign_time) as un_sign_time -- 解约时间
    ,nvl(n.sign_model, o.sign_model) as sign_model -- 签约客户模式  common：通用功能模式、query：仅查询模式
    ,nvl(n.sign_user_id, o.sign_user_id) as sign_user_id -- 签约柜员编码
    ,nvl(n.sign_agreement_id, o.sign_agreement_id) as sign_agreement_id -- 协议编码
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
from (select * from ${iol_schema}.tmss_sys_tenant_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tmss_sys_tenant where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.tenant_code <> n.tenant_code
        or o.tenant_name <> n.tenant_name
        or o.tenant_cert_type <> n.tenant_cert_type
        or o.tenant_cert_code <> n.tenant_cert_code
        or o.sign_code <> n.sign_code
        or o.sign_time <> n.sign_time
        or o.post_code <> n.post_code
        or o.tenant_phone <> n.tenant_phone
        or o.tenant_sina_name <> n.tenant_sina_name
        or o.tenant_eng_name <> n.tenant_eng_name
        or o.tenant_time <> n.tenant_time
        or o.tenant_addr <> n.tenant_addr
        or o.fr_name <> n.fr_name
        or o.fr_mobile <> n.fr_mobile
        or o.fr_cert_type <> n.fr_cert_type
        or o.fr_cert_code <> n.fr_cert_code
        or o.fr_cert_time <> n.fr_cert_time
        or o.bank_seal_id <> n.bank_seal_id
        or o.charge_mode <> n.charge_mode
        or o.create_by <> n.create_by
        or o.create_date <> n.create_date
        or o.update_by <> n.update_by
        or o.update_date <> n.update_date
        or o.status <> n.status
        or o.sign_name <> n.sign_name
        or o.un_sign_time <> n.un_sign_time
        or o.sign_model <> n.sign_model
        or o.sign_user_id <> n.sign_user_id
        or o.sign_agreement_id <> n.sign_agreement_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tmss_sys_tenant_cl(
            id -- 主键ID
            ,tenant_code -- 客户号
            ,tenant_name -- 企业名称
            ,tenant_cert_type -- 企业证件类型
            ,tenant_cert_code -- 企业证件号码
            ,sign_code -- 签约机构
            ,sign_time -- 签约时间
            ,post_code -- 邮政编码
            ,tenant_phone -- 企业联系电话
            ,tenant_sina_name -- 企业中文名称
            ,tenant_eng_name -- 企业英文名称
            ,tenant_time -- 企业证明文件有效期
            ,tenant_addr -- 企业地址
            ,fr_name -- 法人/负责人
            ,fr_mobile -- 法人联系方式
            ,fr_cert_type -- 法人证件类型:01 第二代居民身份证、02 户口簿、03 临时身份证、04 中国护照、05 军官证、06 离休干部荣誉证、07 军官退休证、08 军事学员证、09 武警证、10 士兵证、11 香港通行证、12 澳门通行证、13 胞通行证或有效旅行证件、14 外国人永久居留证、15 边民出入境通行证、16:外国护照、99其他 (或采用柜面现有类别代码)
            ,fr_cert_code -- 法人证件号码
            ,fr_cert_time -- 法人证件有效期
            ,bank_seal_id -- 影像流水
            ,charge_mode -- 管理员模式: 0：否 1：是  如果是双冠 传输两个 校验list长度
            ,create_by -- 创建人
            ,create_date -- 创建时间
            ,update_by -- 更新人
            ,update_date -- 更新时间
            ,status -- 状态 0禁用 1启用
            ,sign_name -- 签约机构名称
            ,un_sign_time -- 解约时间
            ,sign_model -- 签约客户模式  common：通用功能模式、query：仅查询模式
            ,sign_user_id -- 签约柜员编码
            ,sign_agreement_id -- 协议编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tmss_sys_tenant_op(
            id -- 主键ID
            ,tenant_code -- 客户号
            ,tenant_name -- 企业名称
            ,tenant_cert_type -- 企业证件类型
            ,tenant_cert_code -- 企业证件号码
            ,sign_code -- 签约机构
            ,sign_time -- 签约时间
            ,post_code -- 邮政编码
            ,tenant_phone -- 企业联系电话
            ,tenant_sina_name -- 企业中文名称
            ,tenant_eng_name -- 企业英文名称
            ,tenant_time -- 企业证明文件有效期
            ,tenant_addr -- 企业地址
            ,fr_name -- 法人/负责人
            ,fr_mobile -- 法人联系方式
            ,fr_cert_type -- 法人证件类型:01 第二代居民身份证、02 户口簿、03 临时身份证、04 中国护照、05 军官证、06 离休干部荣誉证、07 军官退休证、08 军事学员证、09 武警证、10 士兵证、11 香港通行证、12 澳门通行证、13 胞通行证或有效旅行证件、14 外国人永久居留证、15 边民出入境通行证、16:外国护照、99其他 (或采用柜面现有类别代码)
            ,fr_cert_code -- 法人证件号码
            ,fr_cert_time -- 法人证件有效期
            ,bank_seal_id -- 影像流水
            ,charge_mode -- 管理员模式: 0：否 1：是  如果是双冠 传输两个 校验list长度
            ,create_by -- 创建人
            ,create_date -- 创建时间
            ,update_by -- 更新人
            ,update_date -- 更新时间
            ,status -- 状态 0禁用 1启用
            ,sign_name -- 签约机构名称
            ,un_sign_time -- 解约时间
            ,sign_model -- 签约客户模式  common：通用功能模式、query：仅查询模式
            ,sign_user_id -- 签约柜员编码
            ,sign_agreement_id -- 协议编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键ID
    ,o.tenant_code -- 客户号
    ,o.tenant_name -- 企业名称
    ,o.tenant_cert_type -- 企业证件类型
    ,o.tenant_cert_code -- 企业证件号码
    ,o.sign_code -- 签约机构
    ,o.sign_time -- 签约时间
    ,o.post_code -- 邮政编码
    ,o.tenant_phone -- 企业联系电话
    ,o.tenant_sina_name -- 企业中文名称
    ,o.tenant_eng_name -- 企业英文名称
    ,o.tenant_time -- 企业证明文件有效期
    ,o.tenant_addr -- 企业地址
    ,o.fr_name -- 法人/负责人
    ,o.fr_mobile -- 法人联系方式
    ,o.fr_cert_type -- 法人证件类型:01 第二代居民身份证、02 户口簿、03 临时身份证、04 中国护照、05 军官证、06 离休干部荣誉证、07 军官退休证、08 军事学员证、09 武警证、10 士兵证、11 香港通行证、12 澳门通行证、13 胞通行证或有效旅行证件、14 外国人永久居留证、15 边民出入境通行证、16:外国护照、99其他 (或采用柜面现有类别代码)
    ,o.fr_cert_code -- 法人证件号码
    ,o.fr_cert_time -- 法人证件有效期
    ,o.bank_seal_id -- 影像流水
    ,o.charge_mode -- 管理员模式: 0：否 1：是  如果是双冠 传输两个 校验list长度
    ,o.create_by -- 创建人
    ,o.create_date -- 创建时间
    ,o.update_by -- 更新人
    ,o.update_date -- 更新时间
    ,o.status -- 状态 0禁用 1启用
    ,o.sign_name -- 签约机构名称
    ,o.un_sign_time -- 解约时间
    ,o.sign_model -- 签约客户模式  common：通用功能模式、query：仅查询模式
    ,o.sign_user_id -- 签约柜员编码
    ,o.sign_agreement_id -- 协议编码
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
from ${iol_schema}.tmss_sys_tenant_bk o
    left join ${iol_schema}.tmss_sys_tenant_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tmss_sys_tenant_cl d
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
--truncate table ${iol_schema}.tmss_sys_tenant;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tmss_sys_tenant') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tmss_sys_tenant drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tmss_sys_tenant add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tmss_sys_tenant exchange partition p_${batch_date} with table ${iol_schema}.tmss_sys_tenant_cl;
alter table ${iol_schema}.tmss_sys_tenant exchange partition p_20991231 with table ${iol_schema}.tmss_sys_tenant_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tmss_sys_tenant to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tmss_sys_tenant_op purge;
drop table ${iol_schema}.tmss_sys_tenant_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tmss_sys_tenant_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tmss_sys_tenant',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
