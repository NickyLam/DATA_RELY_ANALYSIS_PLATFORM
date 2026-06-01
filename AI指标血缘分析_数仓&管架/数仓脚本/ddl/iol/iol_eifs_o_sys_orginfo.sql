/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_o_sys_orginfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_o_sys_orginfo
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_o_sys_orginfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_o_sys_orginfo(
    org_id varchar2(60) -- 机构ID
    ,org_no varchar2(75) -- 机构号
    ,org_name varchar2(150) -- 机构名称
    ,org_type_cd varchar2(24) -- 机构类型代码
    ,up_org_id varchar2(48) -- 上级机构ID
    ,b_org_id varchar2(48) -- 所属机构
    ,expend_no varchar2(75) -- 扩展信息
    ,status_cd varchar2(30) -- 状态
    ,created_by varchar2(150) -- 创建人
    ,created_ts timestamp -- 创建时间
    ,last_upd_by varchar2(150) -- 更新人
    ,last_upd_ts timestamp -- 更新时间
    ,org_level number(8) -- 机构层级
    ,below_line varchar2(24) -- 归属线条
    ,remarks varchar2(780) -- 备注说明
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
grant select on ${iol_schema}.eifs_o_sys_orginfo to ${iml_schema};
grant select on ${iol_schema}.eifs_o_sys_orginfo to ${icl_schema};
grant select on ${iol_schema}.eifs_o_sys_orginfo to ${idl_schema};
grant select on ${iol_schema}.eifs_o_sys_orginfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_o_sys_orginfo is '';
comment on column ${iol_schema}.eifs_o_sys_orginfo.org_id is '机构ID';
comment on column ${iol_schema}.eifs_o_sys_orginfo.org_no is '机构号';
comment on column ${iol_schema}.eifs_o_sys_orginfo.org_name is '机构名称';
comment on column ${iol_schema}.eifs_o_sys_orginfo.org_type_cd is '机构类型代码';
comment on column ${iol_schema}.eifs_o_sys_orginfo.up_org_id is '上级机构ID';
comment on column ${iol_schema}.eifs_o_sys_orginfo.b_org_id is '所属机构';
comment on column ${iol_schema}.eifs_o_sys_orginfo.expend_no is '扩展信息';
comment on column ${iol_schema}.eifs_o_sys_orginfo.status_cd is '状态';
comment on column ${iol_schema}.eifs_o_sys_orginfo.created_by is '创建人';
comment on column ${iol_schema}.eifs_o_sys_orginfo.created_ts is '创建时间';
comment on column ${iol_schema}.eifs_o_sys_orginfo.last_upd_by is '更新人';
comment on column ${iol_schema}.eifs_o_sys_orginfo.last_upd_ts is '更新时间';
comment on column ${iol_schema}.eifs_o_sys_orginfo.org_level is '机构层级';
comment on column ${iol_schema}.eifs_o_sys_orginfo.below_line is '归属线条';
comment on column ${iol_schema}.eifs_o_sys_orginfo.remarks is '备注说明';
comment on column ${iol_schema}.eifs_o_sys_orginfo.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_o_sys_orginfo.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_o_sys_orginfo.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_o_sys_orginfo.etl_timestamp is 'ETL处理时间戳';
