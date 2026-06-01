/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_party_phys_addr_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_party_phys_addr_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_party_phys_addr_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_party_phys_addr_h(
    party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,src_sys_cd varchar2(200) -- 源系统代码
    ,phys_addr_type_cd varchar2(20) -- 物理地址类型代码
    ,seq_num varchar2(60) -- 序号
    ,cont_addr varchar2(750) -- 联系地址
    ,zip_cd varchar2(90) -- 邮政编码
    ,tel_num varchar2(60) -- 电话号码
    ,fax_num varchar2(60) -- 传真号码
    ,cty_rg_cd varchar2(10) -- 国家和地区代码
    ,phys_addr varchar2(750) -- 物理地址
    ,dist_cd varchar2(30) -- 行政区划代码
    ,addr_status_type_cd varchar2(30) -- 地址状态类型代码
    ,fc_flg varchar2(30) -- 首选标志
    ,prov_cd varchar2(30) -- 省代码
    ,city_cd varchar2(30) -- 市代码
    ,rg_county_cd varchar2(30) -- 区县代码
    ,street_name varchar2(750) -- 街道名称
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
grant select on ${iml_schema}.pty_party_phys_addr_h to ${icl_schema};
grant select on ${iml_schema}.pty_party_phys_addr_h to ${idl_schema};
grant select on ${iml_schema}.pty_party_phys_addr_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_party_phys_addr_h is '当事人物理地址历史';
comment on column ${iml_schema}.pty_party_phys_addr_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_party_phys_addr_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_party_phys_addr_h.src_sys_cd is '源系统代码';
comment on column ${iml_schema}.pty_party_phys_addr_h.phys_addr_type_cd is '物理地址类型代码';
comment on column ${iml_schema}.pty_party_phys_addr_h.seq_num is '序号';
comment on column ${iml_schema}.pty_party_phys_addr_h.cont_addr is '联系地址';
comment on column ${iml_schema}.pty_party_phys_addr_h.zip_cd is '邮政编码';
comment on column ${iml_schema}.pty_party_phys_addr_h.tel_num is '电话号码';
comment on column ${iml_schema}.pty_party_phys_addr_h.fax_num is '传真号码';
comment on column ${iml_schema}.pty_party_phys_addr_h.cty_rg_cd is '国家和地区代码';
comment on column ${iml_schema}.pty_party_phys_addr_h.phys_addr is '物理地址';
comment on column ${iml_schema}.pty_party_phys_addr_h.dist_cd is '行政区划代码';
comment on column ${iml_schema}.pty_party_phys_addr_h.addr_status_type_cd is '地址状态类型代码';
comment on column ${iml_schema}.pty_party_phys_addr_h.fc_flg is '首选标志';
comment on column ${iml_schema}.pty_party_phys_addr_h.prov_cd is '省代码';
comment on column ${iml_schema}.pty_party_phys_addr_h.city_cd is '市代码';
comment on column ${iml_schema}.pty_party_phys_addr_h.rg_county_cd is '区县代码';
comment on column ${iml_schema}.pty_party_phys_addr_h.street_name is '街道名称';
comment on column ${iml_schema}.pty_party_phys_addr_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_party_phys_addr_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_party_phys_addr_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_party_phys_addr_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_party_phys_addr_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_party_phys_addr_h.etl_timestamp is 'ETL处理时间戳';
