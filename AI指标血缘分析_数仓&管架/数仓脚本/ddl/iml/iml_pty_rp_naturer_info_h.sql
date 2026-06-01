/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_rp_naturer_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_rp_naturer_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_rp_naturer_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_rp_naturer_info_h(
    bus_id varchar2(100) -- 业务编号
    ,cert_no varchar2(250) -- 证件号码
    ,lp_id varchar2(100) -- 法人编号
    ,rela_party_id varchar2(100) -- 关联方编号
    ,rela_party_name varchar2(500) -- 关联方名称
    ,rela_party_from_comb varchar2(500) -- 关联方成因组合
    ,rela_party_from_descb_comb varchar2(500) -- 关联方成因描述组合
    ,sys_in_bus_id varchar2(100) -- 系统内业务编号
    ,east_rela_party_type_cd varchar2(30) -- EAST关联方类型代码
    ,east_rela_party_rela_type_cd varchar2(30) -- EAST关联方关系类型代码
    ,east_cert_type_cd varchar2(30) -- EAST证件类型代码
    ,ybj_rela_party_type_cd varchar2(30) -- 银保监会关联方类型代码
    ,ybj_cert_type_cd varchar2(30) -- 银保监会证件类型代码
    ,rrp_non_type_cd varchar2(30) -- 一表通不良类型代码
    ,rrp_rela_party_type_cd varchar2(30) -- 一表通关联方类型代码
    ,dom_overs_idf_cd varchar2(30) -- 境内外标识代码
    ,supv_org_cd varchar2(60) -- 监管机构代码
    ,remark varchar2(1000) -- 备注
    ,status_cd varchar2(10) -- 关联方有效标志
    ,effect_status_cd varchar2(30) -- 生效状态代码
    ,effect_tm date -- 生效时间
    ,invalid_tm date -- 失效时间
    ,creator_id varchar2(100) -- 创建人编号
    ,create_tm date -- 创建时间
    ,create_org_id varchar2(100) -- 创建机构编号
    ,create_dept_id varchar2(100) -- 创建部门编号
    ,ghb_post_id varchar2(500) -- 本行职务编号
    ,ghb_post_descb varchar2(500) -- 本行职务描述
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
grant select on ${iml_schema}.pty_rp_naturer_info_h to ${icl_schema};
grant select on ${iml_schema}.pty_rp_naturer_info_h to ${idl_schema};
grant select on ${iml_schema}.pty_rp_naturer_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_rp_naturer_info_h is '自然人关联方信息历史';
comment on column ${iml_schema}.pty_rp_naturer_info_h.bus_id is '业务编号';
comment on column ${iml_schema}.pty_rp_naturer_info_h.cert_no is '证件号码';
comment on column ${iml_schema}.pty_rp_naturer_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_rp_naturer_info_h.rela_party_id is '关联方编号';
comment on column ${iml_schema}.pty_rp_naturer_info_h.rela_party_name is '关联方名称';
comment on column ${iml_schema}.pty_rp_naturer_info_h.rela_party_from_comb is '关联方成因组合';
comment on column ${iml_schema}.pty_rp_naturer_info_h.rela_party_from_descb_comb is '关联方成因描述组合';
comment on column ${iml_schema}.pty_rp_naturer_info_h.sys_in_bus_id is '系统内业务编号';
comment on column ${iml_schema}.pty_rp_naturer_info_h.east_rela_party_type_cd is 'EAST关联方类型代码';
comment on column ${iml_schema}.pty_rp_naturer_info_h.east_rela_party_rela_type_cd is 'EAST关联方关系类型代码';
comment on column ${iml_schema}.pty_rp_naturer_info_h.east_cert_type_cd is 'EAST证件类型代码';
comment on column ${iml_schema}.pty_rp_naturer_info_h.ybj_rela_party_type_cd is '银保监会关联方类型代码';
comment on column ${iml_schema}.pty_rp_naturer_info_h.ybj_cert_type_cd is '银保监会证件类型代码';
comment on column ${iml_schema}.pty_rp_naturer_info_h.rrp_non_type_cd is '一表通不良类型代码';
comment on column ${iml_schema}.pty_rp_naturer_info_h.rrp_rela_party_type_cd is '一表通关联方类型代码';
comment on column ${iml_schema}.pty_rp_naturer_info_h.dom_overs_idf_cd is '境内外标识代码';
comment on column ${iml_schema}.pty_rp_naturer_info_h.supv_org_cd is '监管机构代码';
comment on column ${iml_schema}.pty_rp_naturer_info_h.remark is '备注';
comment on column ${iml_schema}.pty_rp_naturer_info_h.status_cd is '关联方有效标志';
comment on column ${iml_schema}.pty_rp_naturer_info_h.effect_status_cd is '生效状态代码';
comment on column ${iml_schema}.pty_rp_naturer_info_h.effect_tm is '生效时间';
comment on column ${iml_schema}.pty_rp_naturer_info_h.invalid_tm is '失效时间';
comment on column ${iml_schema}.pty_rp_naturer_info_h.creator_id is '创建人编号';
comment on column ${iml_schema}.pty_rp_naturer_info_h.create_tm is '创建时间';
comment on column ${iml_schema}.pty_rp_naturer_info_h.create_org_id is '创建机构编号';
comment on column ${iml_schema}.pty_rp_naturer_info_h.create_dept_id is '创建部门编号';
comment on column ${iml_schema}.pty_rp_naturer_info_h.ghb_post_id is '本行职务编号';
comment on column ${iml_schema}.pty_rp_naturer_info_h.ghb_post_descb is '本行职务描述';
comment on column ${iml_schema}.pty_rp_naturer_info_h.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.pty_rp_naturer_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_rp_naturer_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_rp_naturer_info_h.etl_timestamp is 'ETL处理时间戳';
