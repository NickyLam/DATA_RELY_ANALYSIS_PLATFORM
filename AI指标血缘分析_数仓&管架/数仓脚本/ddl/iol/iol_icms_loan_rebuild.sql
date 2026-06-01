/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_loan_rebuild
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_loan_rebuild
whenever sqlerror continue none;
drop table ${iol_schema}.icms_loan_rebuild purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_loan_rebuild(
    serialno varchar2(64) -- 流水号
    ,approvestatus varchar2(64) -- 审批状态
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,customerid varchar2(16) -- 客户编号
    ,customername varchar2(200) -- 客户名称
    ,dealtype varchar2(10) -- 处理类型(A-加入,D-解除)
    ,removereason varchar2(10) -- 解除原因(1-观察期内正常还款,2-无效重组贷款认定)
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
grant select on ${iol_schema}.icms_loan_rebuild to ${iml_schema};
grant select on ${iol_schema}.icms_loan_rebuild to ${icl_schema};
grant select on ${iol_schema}.icms_loan_rebuild to ${idl_schema};
grant select on ${iol_schema}.icms_loan_rebuild to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_loan_rebuild is '贷款重组';
comment on column ${iol_schema}.icms_loan_rebuild.serialno is '流水号';
comment on column ${iol_schema}.icms_loan_rebuild.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_loan_rebuild.inputuserid is '登记人';
comment on column ${iol_schema}.icms_loan_rebuild.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_loan_rebuild.inputdate is '登记日期';
comment on column ${iol_schema}.icms_loan_rebuild.updateuserid is '更新人';
comment on column ${iol_schema}.icms_loan_rebuild.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_loan_rebuild.updatedate is '更新日期';
comment on column ${iol_schema}.icms_loan_rebuild.customerid is '客户编号';
comment on column ${iol_schema}.icms_loan_rebuild.customername is '客户名称';
comment on column ${iol_schema}.icms_loan_rebuild.dealtype is '处理类型(A-加入,D-解除)';
comment on column ${iol_schema}.icms_loan_rebuild.removereason is '解除原因(1-观察期内正常还款,2-无效重组贷款认定)';
comment on column ${iol_schema}.icms_loan_rebuild.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_loan_rebuild.etl_timestamp is 'ETL处理时间戳';
