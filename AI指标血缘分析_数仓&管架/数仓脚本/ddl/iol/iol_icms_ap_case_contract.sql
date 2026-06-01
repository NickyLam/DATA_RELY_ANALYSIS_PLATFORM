/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_case_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_case_contract
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_case_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_case_contract(
    caseno varchar2(64) -- 案件编号
    ,assetno varchar2(64) -- 资产编号
    ,loanno varchar2(64) -- 卡号
    ,updateorgid varchar2(64) -- 更新机构编号
    ,contractno varchar2(64) -- 合同编号
    ,inputorgid varchar2(64) -- 登记机构编号
    ,inputdate date -- 登记日期
    ,tmsp varchar2(64) -- 时间戳
    ,updateuserid varchar2(64) -- 更新人编号
    ,statementdate date -- 账单日
    ,serialno varchar2(48) -- 借据编号
    ,inputuserid varchar2(64) -- 登记人编号
    ,updatedate date -- 更新日期
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
grant select on ${iol_schema}.icms_ap_case_contract to ${iml_schema};
grant select on ${iol_schema}.icms_ap_case_contract to ${icl_schema};
grant select on ${iol_schema}.icms_ap_case_contract to ${idl_schema};
grant select on ${iol_schema}.icms_ap_case_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_case_contract is '案件债项关联表';
comment on column ${iol_schema}.icms_ap_case_contract.caseno is '案件编号';
comment on column ${iol_schema}.icms_ap_case_contract.assetno is '资产编号';
comment on column ${iol_schema}.icms_ap_case_contract.loanno is '卡号';
comment on column ${iol_schema}.icms_ap_case_contract.updateorgid is '更新机构编号';
comment on column ${iol_schema}.icms_ap_case_contract.contractno is '合同编号';
comment on column ${iol_schema}.icms_ap_case_contract.inputorgid is '登记机构编号';
comment on column ${iol_schema}.icms_ap_case_contract.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_case_contract.tmsp is '时间戳';
comment on column ${iol_schema}.icms_ap_case_contract.updateuserid is '更新人编号';
comment on column ${iol_schema}.icms_ap_case_contract.statementdate is '账单日';
comment on column ${iol_schema}.icms_ap_case_contract.serialno is '借据编号';
comment on column ${iol_schema}.icms_ap_case_contract.inputuserid is '登记人编号';
comment on column ${iol_schema}.icms_ap_case_contract.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_case_contract.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_case_contract.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_case_contract.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_case_contract.etl_timestamp is 'ETL处理时间戳';
