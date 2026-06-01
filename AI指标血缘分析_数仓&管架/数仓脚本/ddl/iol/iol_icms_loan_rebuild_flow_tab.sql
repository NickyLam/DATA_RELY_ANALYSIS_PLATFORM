/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_loan_rebuild_flow_tab
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_loan_rebuild_flow_tab
whenever sqlerror continue none;
drop table ${iol_schema}.icms_loan_rebuild_flow_tab purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_loan_rebuild_flow_tab(
    serialno varchar2(64) -- 流水号(主键)
    ,duebillserialno varchar2(64) -- 借据号
    ,dealtyp varchar2(20) -- 处理类型
    ,operasc varchar2(20) -- 操作场景
    ,loanrebuildtype varchar2(20) -- 重组贷款类型
    ,balance number(24,6) -- 借据余额
    ,classifyresult varchar2(10) -- 五级分类
    ,dealdate varchar2(20) -- 处理日期
    ,inputuserid varchar2(20) -- 登记人
    ,inputorgid varchar2(20) -- 登记机构
    ,bizdate varchar2(20) -- 批次时间
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
grant select on ${iol_schema}.icms_loan_rebuild_flow_tab to ${iml_schema};
grant select on ${iol_schema}.icms_loan_rebuild_flow_tab to ${icl_schema};
grant select on ${iol_schema}.icms_loan_rebuild_flow_tab to ${idl_schema};
grant select on ${iol_schema}.icms_loan_rebuild_flow_tab to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_loan_rebuild_flow_tab is '贷款重组流水';
comment on column ${iol_schema}.icms_loan_rebuild_flow_tab.serialno is '流水号(主键)';
comment on column ${iol_schema}.icms_loan_rebuild_flow_tab.duebillserialno is '借据号';
comment on column ${iol_schema}.icms_loan_rebuild_flow_tab.dealtyp is '处理类型';
comment on column ${iol_schema}.icms_loan_rebuild_flow_tab.operasc is '操作场景';
comment on column ${iol_schema}.icms_loan_rebuild_flow_tab.loanrebuildtype is '重组贷款类型';
comment on column ${iol_schema}.icms_loan_rebuild_flow_tab.balance is '借据余额';
comment on column ${iol_schema}.icms_loan_rebuild_flow_tab.classifyresult is '五级分类';
comment on column ${iol_schema}.icms_loan_rebuild_flow_tab.dealdate is '处理日期';
comment on column ${iol_schema}.icms_loan_rebuild_flow_tab.inputuserid is '登记人';
comment on column ${iol_schema}.icms_loan_rebuild_flow_tab.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_loan_rebuild_flow_tab.bizdate is '批次时间';
comment on column ${iol_schema}.icms_loan_rebuild_flow_tab.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_loan_rebuild_flow_tab.etl_timestamp is 'ETL处理时间戳';
