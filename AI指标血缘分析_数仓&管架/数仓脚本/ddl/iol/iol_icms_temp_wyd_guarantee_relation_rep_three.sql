/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_temp_wyd_guarantee_relation_rep_three
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_temp_wyd_guarantee_relation_rep_three
whenever sqlerror continue none;
drop table ${iol_schema}.icms_temp_wyd_guarantee_relation_rep_three purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_temp_wyd_guarantee_relation_rep_three(
    datadtt varchar2(10) -- 数据日期
    ,contractno varchar2(64) -- 合同号
    ,lendingref varchar2(64) -- 主借据号
    ,guarcontractno varchar2(64) -- 担保合同号
    ,orgid varchar2(20) -- 机构号
    ,loanbalance number(20,4) -- 总贷款余额
    ,guarantyamt number(20,4) -- 此笔贷款担保总金额（保证人担保金额）
    ,guarantystat varchar2(1) -- 担保关系状态
    ,inputtime varchar2(10) -- 担保关系建立时间
    ,maturitydate varchar2(10) -- 担保关系解除日期
    ,merchantid varchar2(32) -- 平台ID
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
grant select on ${iol_schema}.icms_temp_wyd_guarantee_relation_rep_three to ${iml_schema};
grant select on ${iol_schema}.icms_temp_wyd_guarantee_relation_rep_three to ${icl_schema};
grant select on ${iol_schema}.icms_temp_wyd_guarantee_relation_rep_three to ${idl_schema};
grant select on ${iol_schema}.icms_temp_wyd_guarantee_relation_rep_three to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_temp_wyd_guarantee_relation_rep_three is '借据与担保合同关系报表中间表03';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_relation_rep_three.datadtt is '数据日期';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_relation_rep_three.contractno is '合同号';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_relation_rep_three.lendingref is '主借据号';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_relation_rep_three.guarcontractno is '担保合同号';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_relation_rep_three.orgid is '机构号';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_relation_rep_three.loanbalance is '总贷款余额';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_relation_rep_three.guarantyamt is '此笔贷款担保总金额（保证人担保金额）';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_relation_rep_three.guarantystat is '担保关系状态';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_relation_rep_three.inputtime is '担保关系建立时间';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_relation_rep_three.maturitydate is '担保关系解除日期';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_relation_rep_three.merchantid is '平台ID';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_relation_rep_three.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_relation_rep_three.etl_timestamp is 'ETL处理时间戳';
