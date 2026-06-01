/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml org_int_org_addr_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.org_int_org_addr_h
whenever sqlerror continue none;
drop table ${iml_schema}.org_int_org_addr_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.org_int_org_addr_h(
    org_id varchar2(60) -- 机构编号
    ,lp_id varchar2(60) -- 法人编号
    ,tel_num varchar2(60) -- 电话号码
    ,zip_cd varchar2(15) -- 邮政编码
    ,cty_or_rg_cd varchar2(10) -- 国家或地区代码
    ,prov_cd varchar2(10) -- 省代码
    ,city_cd varchar2(10) -- 市代码
    ,county_cd varchar2(10) -- 县代码
    ,dtl_addr varchar2(750) -- 详细地址
    ,princ_emply_id varchar2(60) -- 负责人员工编号
    ,princ_name varchar2(150) -- 负责人姓名
    ,ddd_area_cd varchar2(60) -- 国内长途区号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.org_int_org_addr_h to ${icl_schema};
grant select on ${iml_schema}.org_int_org_addr_h to ${idl_schema};
grant select on ${iml_schema}.org_int_org_addr_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.org_int_org_addr_h is '内部机构地址历史';
comment on column ${iml_schema}.org_int_org_addr_h.org_id is '机构编号';
comment on column ${iml_schema}.org_int_org_addr_h.lp_id is '法人编号';
comment on column ${iml_schema}.org_int_org_addr_h.tel_num is '电话号码';
comment on column ${iml_schema}.org_int_org_addr_h.zip_cd is '邮政编码';
comment on column ${iml_schema}.org_int_org_addr_h.cty_or_rg_cd is '国家或地区代码';
comment on column ${iml_schema}.org_int_org_addr_h.prov_cd is '省代码';
comment on column ${iml_schema}.org_int_org_addr_h.city_cd is '市代码';
comment on column ${iml_schema}.org_int_org_addr_h.county_cd is '县代码';
comment on column ${iml_schema}.org_int_org_addr_h.dtl_addr is '详细地址';
comment on column ${iml_schema}.org_int_org_addr_h.princ_emply_id is '负责人员工编号';
comment on column ${iml_schema}.org_int_org_addr_h.princ_name is '负责人姓名';
comment on column ${iml_schema}.org_int_org_addr_h.ddd_area_cd is '国内长途区号';
comment on column ${iml_schema}.org_int_org_addr_h.start_dt is '开始时间';
comment on column ${iml_schema}.org_int_org_addr_h.end_dt is '结束时间';
comment on column ${iml_schema}.org_int_org_addr_h.id_mark is '增删标志';
comment on column ${iml_schema}.org_int_org_addr_h.src_table_name is '源表名称';
comment on column ${iml_schema}.org_int_org_addr_h.job_cd is '任务编码';
comment on column ${iml_schema}.org_int_org_addr_h.etl_timestamp is 'ETL处理时间戳';
