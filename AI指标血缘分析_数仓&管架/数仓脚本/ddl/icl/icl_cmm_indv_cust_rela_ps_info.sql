/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_indv_cust_rela_ps_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_indv_cust_rela_ps_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_indv_cust_rela_ps_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_indv_cust_rela_ps_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,cust_id varchar2(60) -- 客户编号
    ,rela_ps_cust_id varchar2(60) -- 关联人客户编号
    ,rela_ps_id varchar2(60) -- 关联人编号
    ,rela_type_cd varchar2(20) -- 关联类型代码
    ,rela_ps_name varchar2(750) -- 关联人姓名
    ,rela_ps_cert_type_cd varchar2(20) -- 关联人证件类型代码
    ,rela_ps_cert_no varchar2(60) -- 关联人证件号码
    ,rela_ps_gender_cd varchar2(10) -- 关联人性别代码
    ,rela_ps_birth_dt date -- 关联人出生日期
    ,rela_ps_nati_place varchar2(500) -- 关联人籍贯
    ,rela_ps_nationty_cd varchar2(20) -- 关联人民族代码
    ,rela_ps_nation_cd varchar2(20) -- 关联人国籍代码
    ,rela_ps_dist_cd varchar2(30) -- 关联人行政区划代码
    ,rela_ps_marriage_situ_cd varchar2(10) -- 关联人婚姻状况代码
    ,rela_ps_resd_status_cd varchar2(20) -- 关联人居住状态代码
    ,rela_ps_politic_status_cd varchar2(10) -- 关联人政治面貌代码
    ,rela_ps_work_unit_cust_id varchar2(60) -- 关联人工作单位客户编号
    ,rela_ps_work_unit_name varchar2(500) -- 关联人工作单位名称
    ,rela_ps_tel_num varchar2(60) -- 关联人电话号码
    ,rela_ps_tel_ext_num varchar2(60) -- 关联人电话分机号码
    ,rela_ps_mobile_no varchar2(60) -- 关联人手机号码
    ,rela_ps_work_unit_addr varchar2(1000) -- 关联人工作单位地址
    ,rela_ps_work_unit_tel varchar2(60) -- 关联人工作单位电话
    ,rela_ps_create_tm date -- 关联人创建时间
    ,rela_ps_input_sys_tm date -- 关联人录入系统时间
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_indv_cust_rela_ps_info to ${idl_schema};
grant select on ${icl_schema}.cmm_indv_cust_rela_ps_info to ${iel_schema};
grant select on ${icl_schema}.cmm_indv_cust_rela_ps_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_indv_cust_rela_ps_info is '个人客户关联人信息';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.rela_ps_cust_id is '关联人客户编号';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.rela_ps_id is '关联人编号';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.rela_type_cd is '关联类型代码';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.rela_ps_name is '关联人姓名';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.rela_ps_cert_type_cd is '关联人证件类型代码';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.rela_ps_cert_no is '关联人证件号码';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.rela_ps_gender_cd is '关联人性别代码';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.rela_ps_birth_dt is '关联人出生日期';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.rela_ps_nati_place is '关联人籍贯';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.rela_ps_nationty_cd is '关联人民族代码';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.rela_ps_nation_cd is '关联人国籍代码';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.rela_ps_dist_cd is '关联人行政区划代码';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.rela_ps_marriage_situ_cd is '关联人婚姻状况代码';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.rela_ps_resd_status_cd is '关联人居住状态代码';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.rela_ps_politic_status_cd is '关联人政治面貌代码';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.rela_ps_work_unit_cust_id is '关联人工作单位客户编号';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.rela_ps_work_unit_name is '关联人工作单位名称';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.rela_ps_tel_num is '关联人电话号码';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.rela_ps_tel_ext_num is '关联人电话分机号码';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.rela_ps_mobile_no is '关联人手机号码';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.rela_ps_work_unit_addr is '关联人工作单位地址';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.rela_ps_work_unit_tel is '关联人工作单位电话';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.rela_ps_create_tm is '关联人创建时间';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.rela_ps_input_sys_tm is '关联人录入系统时间';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_indv_cust_rela_ps_info.etl_timestamp is 'ETL处理时间戳';
