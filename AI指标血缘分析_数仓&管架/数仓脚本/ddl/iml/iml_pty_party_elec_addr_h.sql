/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_party_elec_addr_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_party_elec_addr_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_party_elec_addr_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_party_elec_addr_h(
    party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,src_sys_cd varchar2(10) -- 源系统代码
    ,elec_addr_type_cd varchar2(20) -- 电子地址类型代码
    ,seq_num varchar2(60) -- 序号
    ,elec_addr varchar2(750) -- 电子地址
    ,main_elec_addr_flg varchar2(200) -- 主电子地址标志
    ,dd_area_cd varchar2(60) -- 长途区号
    ,ext_num varchar2(60) -- 分机号码
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
grant select on ${iml_schema}.pty_party_elec_addr_h to ${icl_schema};
grant select on ${iml_schema}.pty_party_elec_addr_h to ${idl_schema};
grant select on ${iml_schema}.pty_party_elec_addr_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_party_elec_addr_h is '当事人电子地址历史';
comment on column ${iml_schema}.pty_party_elec_addr_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_party_elec_addr_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_party_elec_addr_h.src_sys_cd is '源系统代码';
comment on column ${iml_schema}.pty_party_elec_addr_h.elec_addr_type_cd is '电子地址类型代码';
comment on column ${iml_schema}.pty_party_elec_addr_h.seq_num is '序号';
comment on column ${iml_schema}.pty_party_elec_addr_h.elec_addr is '电子地址';
comment on column ${iml_schema}.pty_party_elec_addr_h.main_elec_addr_flg is '主电子地址标志';
comment on column ${iml_schema}.pty_party_elec_addr_h.dd_area_cd is '长途区号';
comment on column ${iml_schema}.pty_party_elec_addr_h.ext_num is '分机号码';
comment on column ${iml_schema}.pty_party_elec_addr_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_party_elec_addr_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_party_elec_addr_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_party_elec_addr_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_party_elec_addr_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_party_elec_addr_h.etl_timestamp is 'ETL处理时间戳';
