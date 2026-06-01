/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_tlr_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_tlr_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_tlr_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_tlr_info(
    id varchar2(45) -- 
    ,tlr_no varchar2(45) -- 操作员编号
    ,tlr_name varchar2(45) -- 操作员姓名
    ,br_id varchar2(45) -- 所属机构id
    ,update_date timestamp -- 修改时间
    ,update_userid varchar2(48) -- 修改人
    ,br_manager_id varchar2(45) -- 总行id
    ,status varchar2(2) -- 状态
    ,is_del number(22,0) -- 是否已删除
    ,create_userid varchar2(48) -- 创建人
    ,create_date timestamp -- 创建时间
    ,mem_user_id varchar2(15) -- 
    ,domainid varchar2(30) -- 
    ,employeeid varchar2(12) -- 员工编号
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
grant select on ${iol_schema}.bdms_tlr_info to ${iml_schema};
grant select on ${iol_schema}.bdms_tlr_info to ${icl_schema};
grant select on ${iol_schema}.bdms_tlr_info to ${idl_schema};
grant select on ${iol_schema}.bdms_tlr_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_tlr_info is '用户信息表';
comment on column ${iol_schema}.bdms_tlr_info.id is '';
comment on column ${iol_schema}.bdms_tlr_info.tlr_no is '操作员编号';
comment on column ${iol_schema}.bdms_tlr_info.tlr_name is '操作员姓名';
comment on column ${iol_schema}.bdms_tlr_info.br_id is '所属机构id';
comment on column ${iol_schema}.bdms_tlr_info.update_date is '修改时间';
comment on column ${iol_schema}.bdms_tlr_info.update_userid is '修改人';
comment on column ${iol_schema}.bdms_tlr_info.br_manager_id is '总行id';
comment on column ${iol_schema}.bdms_tlr_info.status is '状态';
comment on column ${iol_schema}.bdms_tlr_info.is_del is '是否已删除';
comment on column ${iol_schema}.bdms_tlr_info.create_userid is '创建人';
comment on column ${iol_schema}.bdms_tlr_info.create_date is '创建时间';
comment on column ${iol_schema}.bdms_tlr_info.mem_user_id is '';
comment on column ${iol_schema}.bdms_tlr_info.domainid is '';
comment on column ${iol_schema}.bdms_tlr_info.employeeid is '员工编号';
comment on column ${iol_schema}.bdms_tlr_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_tlr_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_tlr_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_tlr_info.etl_timestamp is 'ETL处理时间戳';
