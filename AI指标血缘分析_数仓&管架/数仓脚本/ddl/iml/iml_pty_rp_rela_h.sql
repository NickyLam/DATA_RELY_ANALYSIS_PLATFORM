/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_rp_rela_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_rp_rela_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_rp_rela_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_rp_rela_h(
    bus_id varchar2(100) -- 业务编号
    ,lp_id varchar2(100) -- 法人编号
    ,rela_party_id varchar2(100) -- 关联方编号
    ,sys_in_bus_id varchar2(100) -- 系统内业务编号
    ,rela_party_type_cd varchar2(30) -- 关联方类型代码
    ,this_rela_party_bus_id varchar2(100) -- 本层关联方业务编号
    ,super_rela_party_type_cd varchar2(30) -- 上级关联方类型代码
    ,super_rela_party_id varchar2(100) -- 上级关联方编号
    ,super_rela_party_name varchar2(500) -- 上级关联方名称
    ,super_cert_type_cd varchar2(30) -- 上级证件类型代码
    ,super_cert_no varchar2(250) -- 上级证件号码
    ,and_super_incid_rela_type_cd varchar2(30) -- 与上级关联关系类型代码
    ,and_super_eqty_rela_type_cd varchar2(30) -- 与上级权益关系类型代码
    ,hold_ratio number(18,6) -- 持有比例
    ,incid_rela_comnt varchar2(4000) -- 关联关系说明
    ,status_cd varchar2(10) -- 关联方有效标志
    ,valid_flg varchar2(10) -- 有效标志
    ,effect_tm date -- 生效时间
    ,invalid_tm date -- 失效时间
    ,remit_tm date -- 解除时间
    ,remark varchar2(4000) -- 备注
    ,creator_id varchar2(100) -- 创建人编号
    ,create_tm date -- 创建时间
    ,create_org_id varchar2(100) -- 创建机构编号
    ,create_dept_id varchar2(100) -- 创建部门编号
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.pty_rp_rela_h to ${icl_schema};
grant select on ${iml_schema}.pty_rp_rela_h to ${idl_schema};
grant select on ${iml_schema}.pty_rp_rela_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_rp_rela_h is '关联关系信息历史';
comment on column ${iml_schema}.pty_rp_rela_h.bus_id is '业务编号';
comment on column ${iml_schema}.pty_rp_rela_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_rp_rela_h.rela_party_id is '关联方编号';
comment on column ${iml_schema}.pty_rp_rela_h.sys_in_bus_id is '系统内业务编号';
comment on column ${iml_schema}.pty_rp_rela_h.rela_party_type_cd is '关联方类型代码';
comment on column ${iml_schema}.pty_rp_rela_h.this_rela_party_bus_id is '本层关联方业务编号';
comment on column ${iml_schema}.pty_rp_rela_h.super_rela_party_type_cd is '上级关联方类型代码';
comment on column ${iml_schema}.pty_rp_rela_h.super_rela_party_id is '上级关联方编号';
comment on column ${iml_schema}.pty_rp_rela_h.super_rela_party_name is '上级关联方名称';
comment on column ${iml_schema}.pty_rp_rela_h.super_cert_type_cd is '上级证件类型代码';
comment on column ${iml_schema}.pty_rp_rela_h.super_cert_no is '上级证件号码';
comment on column ${iml_schema}.pty_rp_rela_h.and_super_incid_rela_type_cd is '与上级关联关系类型代码';
comment on column ${iml_schema}.pty_rp_rela_h.and_super_eqty_rela_type_cd is '与上级权益关系类型代码';
comment on column ${iml_schema}.pty_rp_rela_h.hold_ratio is '持有比例';
comment on column ${iml_schema}.pty_rp_rela_h.incid_rela_comnt is '关联关系说明';
comment on column ${iml_schema}.pty_rp_rela_h.status_cd is '关联方有效标志';
comment on column ${iml_schema}.pty_rp_rela_h.valid_flg is '有效标志';
comment on column ${iml_schema}.pty_rp_rela_h.effect_tm is '生效时间';
comment on column ${iml_schema}.pty_rp_rela_h.invalid_tm is '失效时间';
comment on column ${iml_schema}.pty_rp_rela_h.remit_tm is '解除时间';
comment on column ${iml_schema}.pty_rp_rela_h.remark is '备注';
comment on column ${iml_schema}.pty_rp_rela_h.creator_id is '创建人编号';
comment on column ${iml_schema}.pty_rp_rela_h.create_tm is '创建时间';
comment on column ${iml_schema}.pty_rp_rela_h.create_org_id is '创建机构编号';
comment on column ${iml_schema}.pty_rp_rela_h.create_dept_id is '创建部门编号';
comment on column ${iml_schema}.pty_rp_rela_h.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.pty_rp_rela_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_rp_rela_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_rp_rela_h.etl_timestamp is 'ETL处理时间戳';
