/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t01_per_cust_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t01_per_cust_info
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t01_per_cust_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t01_per_cust_info(
    party_id varchar2(45) -- 参与人id
    ,cust_name varchar2(300) -- 客户名称
    ,former_name varchar2(270) -- 曾用名
    ,gender_cd varchar2(30) -- 性别
    ,ethnic_cd varchar2(30) -- 民族
    ,birth_place_cd varchar2(600) -- 籍贯
    ,birth_dt varchar2(12) -- 出生日期
    ,birth_place varchar2(383) -- 出生地
    ,depositor_type_cd varchar2(30) -- 存款人类别
    ,poltc_stat_cd varchar2(30) -- 政治面貌
    ,marriage_situ_cd varchar2(30) -- 婚姻状况
    ,supr_edu_degree_cd varchar2(30) -- 学历
    ,supr_degree_cd varchar2(30) -- 学位
    ,work_stat_cd varchar2(30) -- 就业状况
    ,career_cd varchar2(30) -- 职业类型
    ,other_occupation varchar2(135) -- 其他职业说明
    ,title_cd varchar2(30) -- 职称
    ,pos_level_cd varchar2(30) -- 职务类型
    ,emply_ind varchar2(6) -- 员工标志
    ,emply_num varchar2(90) -- 员工编号
    ,create_te varchar2(15) -- 创建柜员
    ,create_org varchar2(15) -- 创建机构号
    ,init_system_id varchar2(15) -- 创建渠道
    ,init_created_ts timestamp -- 源系统创建时间
    ,created_ts timestamp -- 进入ecif的时间
    ,updated_ts timestamp -- 在ecif中失效的时间
    ,last_updated_te varchar2(45) -- 最新更新柜员
    ,last_updated_org varchar2(30) -- 最新更新机构号
    ,last_system_id varchar2(15) -- 最新更新渠道
    ,last_updated_ts timestamp -- 最新更新时间
    ,src_sys_num varchar2(45) -- 来源系统编号
    ,last_updated_src_sys_num varchar2(45) -- 最新更新源系统编号
    ,loan_flag varchar2(2) -- 信贷客户标识
    ,self_sup_flag varchar2(2) -- 自营客户标识
    ,career_desc_level1 varchar2(300) -- 职业中文名称一级
    ,career_desc_level2 varchar2(300) -- 职业中文名称二级
    ,guarantee_flag varchar2(2) -- 担保客户标志
    ,party_role varchar2(3) -- 参与人角色
    ,aml_dep_flag varchar2(2) -- 担保类标志
    ,aml_loan_flag varchar2(2) -- 贷款类标志
    ,aml_guar_flag varchar2(2) -- 
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
grant select on ${iol_schema}.eifs_t01_per_cust_info to ${iml_schema};
grant select on ${iol_schema}.eifs_t01_per_cust_info to ${icl_schema};
grant select on ${iol_schema}.eifs_t01_per_cust_info to ${idl_schema};
grant select on ${iol_schema}.eifs_t01_per_cust_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t01_per_cust_info is '对私客户基本信息';
comment on column ${iol_schema}.eifs_t01_per_cust_info.party_id is '参与人id';
comment on column ${iol_schema}.eifs_t01_per_cust_info.cust_name is '客户名称';
comment on column ${iol_schema}.eifs_t01_per_cust_info.former_name is '曾用名';
comment on column ${iol_schema}.eifs_t01_per_cust_info.gender_cd is '性别';
comment on column ${iol_schema}.eifs_t01_per_cust_info.ethnic_cd is '民族';
comment on column ${iol_schema}.eifs_t01_per_cust_info.birth_place_cd is '籍贯';
comment on column ${iol_schema}.eifs_t01_per_cust_info.birth_dt is '出生日期';
comment on column ${iol_schema}.eifs_t01_per_cust_info.birth_place is '出生地';
comment on column ${iol_schema}.eifs_t01_per_cust_info.depositor_type_cd is '存款人类别';
comment on column ${iol_schema}.eifs_t01_per_cust_info.poltc_stat_cd is '政治面貌';
comment on column ${iol_schema}.eifs_t01_per_cust_info.marriage_situ_cd is '婚姻状况';
comment on column ${iol_schema}.eifs_t01_per_cust_info.supr_edu_degree_cd is '学历';
comment on column ${iol_schema}.eifs_t01_per_cust_info.supr_degree_cd is '学位';
comment on column ${iol_schema}.eifs_t01_per_cust_info.work_stat_cd is '就业状况';
comment on column ${iol_schema}.eifs_t01_per_cust_info.career_cd is '职业类型';
comment on column ${iol_schema}.eifs_t01_per_cust_info.other_occupation is '其他职业说明';
comment on column ${iol_schema}.eifs_t01_per_cust_info.title_cd is '职称';
comment on column ${iol_schema}.eifs_t01_per_cust_info.pos_level_cd is '职务类型';
comment on column ${iol_schema}.eifs_t01_per_cust_info.emply_ind is '员工标志';
comment on column ${iol_schema}.eifs_t01_per_cust_info.emply_num is '员工编号';
comment on column ${iol_schema}.eifs_t01_per_cust_info.create_te is '创建柜员';
comment on column ${iol_schema}.eifs_t01_per_cust_info.create_org is '创建机构号';
comment on column ${iol_schema}.eifs_t01_per_cust_info.init_system_id is '创建渠道';
comment on column ${iol_schema}.eifs_t01_per_cust_info.init_created_ts is '源系统创建时间';
comment on column ${iol_schema}.eifs_t01_per_cust_info.created_ts is '进入ecif的时间';
comment on column ${iol_schema}.eifs_t01_per_cust_info.updated_ts is '在ecif中失效的时间';
comment on column ${iol_schema}.eifs_t01_per_cust_info.last_updated_te is '最新更新柜员';
comment on column ${iol_schema}.eifs_t01_per_cust_info.last_updated_org is '最新更新机构号';
comment on column ${iol_schema}.eifs_t01_per_cust_info.last_system_id is '最新更新渠道';
comment on column ${iol_schema}.eifs_t01_per_cust_info.last_updated_ts is '最新更新时间';
comment on column ${iol_schema}.eifs_t01_per_cust_info.src_sys_num is '来源系统编号';
comment on column ${iol_schema}.eifs_t01_per_cust_info.last_updated_src_sys_num is '最新更新源系统编号';
comment on column ${iol_schema}.eifs_t01_per_cust_info.loan_flag is '信贷客户标识';
comment on column ${iol_schema}.eifs_t01_per_cust_info.self_sup_flag is '自营客户标识';
comment on column ${iol_schema}.eifs_t01_per_cust_info.career_desc_level1 is '职业中文名称一级';
comment on column ${iol_schema}.eifs_t01_per_cust_info.career_desc_level2 is '职业中文名称二级';
comment on column ${iol_schema}.eifs_t01_per_cust_info.guarantee_flag is '担保客户标志';
comment on column ${iol_schema}.eifs_t01_per_cust_info.party_role is '参与人角色';
comment on column ${iol_schema}.eifs_t01_per_cust_info.aml_dep_flag is '担保类标志';
comment on column ${iol_schema}.eifs_t01_per_cust_info.aml_loan_flag is '贷款类标志';
comment on column ${iol_schema}.eifs_t01_per_cust_info.aml_guar_flag is '';
comment on column ${iol_schema}.eifs_t01_per_cust_info.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t01_per_cust_info.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t01_per_cust_info.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t01_per_cust_info.etl_timestamp is 'ETL处理时间戳';
