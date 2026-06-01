/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fbms_mod_ssc_customer_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fbms_mod_ssc_customer_info
whenever sqlerror continue none;
drop table ${iol_schema}.fbms_mod_ssc_customer_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fbms_mod_ssc_customer_info(
    sysid varchar2(18) -- 应用编号默认2000
    ,plat_date varchar2(24) -- 平台日期
    ,plat_time varchar2(18) -- 平台时间
    ,plat_serial_no varchar2(120) -- 平台流水号
    ,cust_num varchar2(48) -- 客户号
    ,cust_name varchar2(600) -- 客户名称
    ,cert_type_cd varchar2(12) -- 证件类型（银行）
    ,cert_num varchar2(180) -- 证件号码
    ,phys_addr_cty_zone_cd varchar2(9) -- 国家地区代码
    ,cert_begin_date date -- 证件生效日期
    ,cert_end_date date -- 证件失效日期
    ,gender_cd varchar2(3) -- 性别,0-未知的性别,-男性,2-女性,9-未说明的性别,
    ,ethnic_cd varchar2(6) -- 民族
    ,birth_dt date -- 出生日期
    ,house_addr varchar2(1200) -- 户口地址
    ,mobile_num varchar2(90) -- 手机号码
    ,tel_num varchar2(90) -- 电话号码
    ,postal_addr varchar2(1200) -- 详细地址-通讯地址
    ,post_cd varchar2(18) -- 邮政编码
    ,email varchar2(1200) -- 电子地址-邮箱
    ,work_corp_num varchar2(105) -- 单位编号
    ,work_corp_name varchar2(600) -- 工作单位名称
    ,work_corp_addr varchar2(1200) -- 工作单位地址
    ,career_cd varchar2(15) -- 职业类型，按银行码值保存
    ,guardian_cert_type_cd varchar2(12) -- 监护人证件类型（银行）
    ,guardian_cert_num varchar2(180) -- 监护人证件号码
    ,guardian_name varchar2(600) -- 监护人姓名
    ,create_timestamp varchar2(60) -- 创建时间戳
    ,update_timestamp varchar2(60) -- 修改时间戳
    ,ext1 varchar2(150) -- 备用字段1
    ,ext2 varchar2(150) -- 备用字段2
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.fbms_mod_ssc_customer_info to ${iml_schema};
grant select on ${iol_schema}.fbms_mod_ssc_customer_info to ${icl_schema};
grant select on ${iol_schema}.fbms_mod_ssc_customer_info to ${idl_schema};
grant select on ${iol_schema}.fbms_mod_ssc_customer_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.fbms_mod_ssc_customer_info is '客户信息表';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.sysid is '应用编号默认2000';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.plat_date is '平台日期';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.plat_time is '平台时间';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.plat_serial_no is '平台流水号';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.cust_num is '客户号';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.cust_name is '客户名称';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.cert_type_cd is '证件类型（银行）';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.cert_num is '证件号码';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.phys_addr_cty_zone_cd is '国家地区代码';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.cert_begin_date is '证件生效日期';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.cert_end_date is '证件失效日期';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.gender_cd is '性别,0-未知的性别,-男性,2-女性,9-未说明的性别,';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.ethnic_cd is '民族';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.birth_dt is '出生日期';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.house_addr is '户口地址';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.mobile_num is '手机号码';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.tel_num is '电话号码';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.postal_addr is '详细地址-通讯地址';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.post_cd is '邮政编码';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.email is '电子地址-邮箱';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.work_corp_num is '单位编号';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.work_corp_name is '工作单位名称';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.work_corp_addr is '工作单位地址';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.career_cd is '职业类型，按银行码值保存';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.guardian_cert_type_cd is '监护人证件类型（银行）';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.guardian_cert_num is '监护人证件号码';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.guardian_name is '监护人姓名';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.create_timestamp is '创建时间戳';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.update_timestamp is '修改时间戳';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.ext1 is '备用字段1';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.ext2 is '备用字段2';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.start_dt is '开始时间';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.end_dt is '结束时间';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.id_mark is '增删标志';
comment on column ${iol_schema}.fbms_mod_ssc_customer_info.etl_timestamp is 'ETL处理时间戳';
