/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_actctrlrinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_actctrlrinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_actctrlrinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_actctrlrinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,act_ctrlr_idnt_cgy varchar2(2) -- 实际控制人身份类型:ec050d01
    ,act_ctrlr_nm varchar2(360) -- 实际控制人名称:ec050q01
    ,act_ctrlr_idnt_idr_tp varchar2(11) -- 实际控制人身份标识类型:ec050d02
    ,act_ctrlr_idnt_idr_no varchar2(180) -- 实际控制人身份标识号码:ec050i01
    ,crdt_no varchar2(180) -- 
    ,crt_dt_tm date -- 创建日期时间
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.cqss_e_r_actctrlrinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_actctrlrinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_actctrlrinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_actctrlrinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_actctrlrinf is '实际控制人信息';
comment on column ${iol_schema}.cqss_e_r_actctrlrinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_actctrlrinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_actctrlrinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_actctrlrinf.act_ctrlr_idnt_cgy is '实际控制人身份类型:ec050d01';
comment on column ${iol_schema}.cqss_e_r_actctrlrinf.act_ctrlr_nm is '实际控制人名称:ec050q01';
comment on column ${iol_schema}.cqss_e_r_actctrlrinf.act_ctrlr_idnt_idr_tp is '实际控制人身份标识类型:ec050d02';
comment on column ${iol_schema}.cqss_e_r_actctrlrinf.act_ctrlr_idnt_idr_no is '实际控制人身份标识号码:ec050i01';
comment on column ${iol_schema}.cqss_e_r_actctrlrinf.crdt_no is '';
comment on column ${iol_schema}.cqss_e_r_actctrlrinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_actctrlrinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_actctrlrinf.etl_timestamp is 'ETL处理时间戳';
