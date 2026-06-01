/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_ama_manu
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_ama_manu
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_ama_manu purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_ama_manu(
    stacid number(19) -- 账套
    ,loanno varchar2(60) -- 贷款账户编号
    ,systid varchar2(30) -- 来源系统编号
    ,bsnsdt varchar2(8) -- 调账日期
    ,transq varchar2(20) -- 调账流水号
    ,tranbr varchar2(12) -- 机构编号
    ,remark varchar2(150) -- 调账说明
    ,custna varchar2(200) -- 客户名称
    ,devatg varchar2(1) -- 减值标识y-是n-否
    ,usercd varchar2(16) -- 录入人
    ,psauus varchar2(16) -- 复核人
    ,transt varchar2(1) -- 审批状态1-未审批2-已审批3-审批中4-已作废
    ,adjttg varchar2(1) -- 是否调整减值状态,y-是,n-否
    ,devaaf varchar2(1) -- 调整后减值标示,y-是,n-否
    ,wkflid varchar2(20) -- 流程id
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
grant select on ${iol_schema}.tgls_ama_manu to ${iml_schema};
grant select on ${iol_schema}.tgls_ama_manu to ${icl_schema};
grant select on ${iol_schema}.tgls_ama_manu to ${idl_schema};
grant select on ${iol_schema}.tgls_ama_manu to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_ama_manu is '手工调账记录';
comment on column ${iol_schema}.tgls_ama_manu.stacid is '账套';
comment on column ${iol_schema}.tgls_ama_manu.loanno is '贷款账户编号';
comment on column ${iol_schema}.tgls_ama_manu.systid is '来源系统编号';
comment on column ${iol_schema}.tgls_ama_manu.bsnsdt is '调账日期';
comment on column ${iol_schema}.tgls_ama_manu.transq is '调账流水号';
comment on column ${iol_schema}.tgls_ama_manu.tranbr is '机构编号';
comment on column ${iol_schema}.tgls_ama_manu.remark is '调账说明';
comment on column ${iol_schema}.tgls_ama_manu.custna is '客户名称';
comment on column ${iol_schema}.tgls_ama_manu.devatg is '减值标识y-是n-否';
comment on column ${iol_schema}.tgls_ama_manu.usercd is '录入人';
comment on column ${iol_schema}.tgls_ama_manu.psauus is '复核人';
comment on column ${iol_schema}.tgls_ama_manu.transt is '审批状态1-未审批2-已审批3-审批中4-已作废';
comment on column ${iol_schema}.tgls_ama_manu.adjttg is '是否调整减值状态,y-是,n-否';
comment on column ${iol_schema}.tgls_ama_manu.devaaf is '调整后减值标示,y-是,n-否';
comment on column ${iol_schema}.tgls_ama_manu.wkflid is '流程id';
comment on column ${iol_schema}.tgls_ama_manu.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_ama_manu.etl_timestamp is 'ETL处理时间戳';
