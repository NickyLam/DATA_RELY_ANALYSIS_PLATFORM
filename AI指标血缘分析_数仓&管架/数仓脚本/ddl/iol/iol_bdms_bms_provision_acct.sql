/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_provision_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_provision_acct
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_provision_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_provision_acct(
    prov_acct_id varchar2(60) -- 计提记账表ID
    ,top_bank_no varchar2(60) -- 所属总行行号
    ,brch_no varchar2(30) -- 机构号
    ,dr_subject_no varchar2(150) -- 借科目
    ,cr_subject_no varchar2(150) -- 贷科目
    ,prov_interest number(18,2) -- 计提利息
    ,acct_dt varchar2(12) -- 计账日
    ,is_success varchar2(3) -- 是否记账成功
    ,prod_no varchar2(23) -- 业务产品号
    ,create_time timestamp -- 创建时间
    ,reserve1 varchar2(150) -- 保留字段1
    ,reserve2 varchar2(150) -- 保留字段2
    ,reserve3 varchar2(150) -- 保留字段3
    ,draft_number varchar2(48) -- 票号
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
grant select on ${iol_schema}.bdms_bms_provision_acct to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_provision_acct to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_provision_acct to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_provision_acct to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_provision_acct is '计提记账表';
comment on column ${iol_schema}.bdms_bms_provision_acct.prov_acct_id is '计提记账表ID';
comment on column ${iol_schema}.bdms_bms_provision_acct.top_bank_no is '所属总行行号';
comment on column ${iol_schema}.bdms_bms_provision_acct.brch_no is '机构号';
comment on column ${iol_schema}.bdms_bms_provision_acct.dr_subject_no is '借科目';
comment on column ${iol_schema}.bdms_bms_provision_acct.cr_subject_no is '贷科目';
comment on column ${iol_schema}.bdms_bms_provision_acct.prov_interest is '计提利息';
comment on column ${iol_schema}.bdms_bms_provision_acct.acct_dt is '计账日';
comment on column ${iol_schema}.bdms_bms_provision_acct.is_success is '是否记账成功';
comment on column ${iol_schema}.bdms_bms_provision_acct.prod_no is '业务产品号';
comment on column ${iol_schema}.bdms_bms_provision_acct.create_time is '创建时间';
comment on column ${iol_schema}.bdms_bms_provision_acct.reserve1 is '保留字段1';
comment on column ${iol_schema}.bdms_bms_provision_acct.reserve2 is '保留字段2';
comment on column ${iol_schema}.bdms_bms_provision_acct.reserve3 is '保留字段3';
comment on column ${iol_schema}.bdms_bms_provision_acct.draft_number is '票号';
comment on column ${iol_schema}.bdms_bms_provision_acct.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_bms_provision_acct.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_bms_provision_acct.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_bms_provision_acct.etl_timestamp is 'ETL处理时间戳';
