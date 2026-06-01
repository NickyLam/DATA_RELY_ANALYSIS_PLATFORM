/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_shell_company_data_puppet_puppetrelatcompanies
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,puppetrelatcompanies varchar2(4000) -- 关联标签
    ,distance varchar2(4000) -- 法人集中度
    ,dom varchar2(4000) -- 住所
    ,entname varchar2(4000) -- 公司名称
    ,entstatus varchar2(4000) -- 经营状态
    ,esdate varchar2(4000) -- 成立日期
    ,finalshareholder varchar2(4000) -- 最终控股股东
    ,frname varchar2(4000) -- 法定代表人
    ,liacconam varchar2(4000) -- 累计实缴（万元）
    ,reccap varchar2(4000) -- 实收资本（万元）
    ,regcap varchar2(4000) -- 注册资本（万元）
    ,regorgcode varchar2(4000) -- 注册地区
    ,shareholderratio varchar2(4000) -- 法人持股比例（%）
    ,genmonth varchar2(4000) -- 
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
grant select on ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies to ${iml_schema};
grant select on ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies to ${icl_schema};
grant select on ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies to ${idl_schema};
grant select on ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies is 'shell_company_DATA_PUPPET_PUPPETRELATCOMPANIES';
comment on column ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies.puppetrelatcompanies is '关联标签';
comment on column ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies.distance is '法人集中度';
comment on column ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies.dom is '住所';
comment on column ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies.entname is '公司名称';
comment on column ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies.entstatus is '经营状态';
comment on column ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies.esdate is '成立日期';
comment on column ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies.finalshareholder is '最终控股股东';
comment on column ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies.frname is '法定代表人';
comment on column ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies.liacconam is '累计实缴（万元）';
comment on column ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies.reccap is '实收资本（万元）';
comment on column ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies.regcap is '注册资本（万元）';
comment on column ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies.regorgcode is '注册地区';
comment on column ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies.shareholderratio is '法人持股比例（%）';
comment on column ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies.genmonth is '';
comment on column ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_shell_company_data_puppet_puppetrelatcompanies.etl_timestamp is 'ETL处理时间戳';
