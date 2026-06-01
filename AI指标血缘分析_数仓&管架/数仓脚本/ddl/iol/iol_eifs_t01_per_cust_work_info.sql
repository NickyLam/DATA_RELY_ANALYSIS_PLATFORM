/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t01_per_cust_work_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t01_per_cust_work_info
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t01_per_cust_work_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t01_per_cust_work_info(
    work_resume_id varchar2(45) -- 工作履历id
    ,party_id varchar2(45) -- 参与人id
    ,work_corp_name varchar2(300) -- 工作单位名称
    ,work_unit_addr varchar2(600) -- 工作单位地址
    ,work_corp_site_addr_dist varchar2(30) -- 工作单位所在地行政区划
    ,work_unit_phone varchar2(30) -- 工作单位电话
    ,work_unit_zip_code varchar2(30) -- 工作单位邮编
    ,work_permit_no varchar2(30) -- 工作证号
    ,career_cd varchar2(30) -- 职业类型
    ,other_occupation varchar2(135) -- 其他职业说明
    ,work_unit_property varchar2(150) -- 工作单位性质
    ,work_unit_belong_industry varchar2(30) -- 工作单位所属行业
    ,title_cd varchar2(30) -- 职称
    ,pos_level_cd varchar2(30) -- 职务类型
    ,mon_in number(20,2) -- 月收入
    ,work_property varchar2(15) -- 工作性质
    ,entry_date varchar2(15) -- 入职日期
    ,quit_date varchar2(15) -- 离职日期
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
    ,corp_size_cd varchar2(30) -- 单位所属企业规模
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
grant select on ${iol_schema}.eifs_t01_per_cust_work_info to ${iml_schema};
grant select on ${iol_schema}.eifs_t01_per_cust_work_info to ${icl_schema};
grant select on ${iol_schema}.eifs_t01_per_cust_work_info to ${idl_schema};
grant select on ${iol_schema}.eifs_t01_per_cust_work_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t01_per_cust_work_info is '对私客户工作履历信息';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.work_resume_id is '工作履历id';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.party_id is '参与人id';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.work_corp_name is '工作单位名称';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.work_unit_addr is '工作单位地址';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.work_corp_site_addr_dist is '工作单位所在地行政区划';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.work_unit_phone is '工作单位电话';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.work_unit_zip_code is '工作单位邮编';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.work_permit_no is '工作证号';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.career_cd is '职业类型';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.other_occupation is '其他职业说明';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.work_unit_property is '工作单位性质';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.work_unit_belong_industry is '工作单位所属行业';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.title_cd is '职称';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.pos_level_cd is '职务类型';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.mon_in is '月收入';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.work_property is '工作性质';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.entry_date is '入职日期';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.quit_date is '离职日期';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.create_te is '创建柜员';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.create_org is '创建机构号';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.init_system_id is '创建渠道';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.init_created_ts is '源系统创建时间';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.created_ts is '进入ecif的时间';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.updated_ts is '在ecif中失效的时间';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.last_updated_te is '最新更新柜员';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.last_updated_org is '最新更新机构号';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.last_system_id is '最新更新渠道';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.last_updated_ts is '最新更新时间';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.src_sys_num is '来源系统编号';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.last_updated_src_sys_num is '最新更新源系统编号';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.corp_size_cd is '单位所属企业规模';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t01_per_cust_work_info.etl_timestamp is 'ETL处理时间戳';
