/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_shell_company_data_baseinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_shell_company_data_baseinfo
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_shell_company_data_baseinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_shell_company_data_baseinfo(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,dom varchar2(4000) -- 住所
    ,entstatus varchar2(4000) -- 企业状态
    ,regcap varchar2(4000) -- 注册资本（万元
    ,data_baseinfo varchar2(4000) -- 关联标签
    ,creditcode varchar2(4000) -- 统一社会信用代码
    ,data_date varchar2(4000) -- 批次日期
    ,enttype varchar2(4000) -- 机构类型
    ,liacconam varchar2(4000) -- 累积实缴（万元）
    ,finalshareholder varchar2(4000) -- 最终控股股东
    ,name varchar2(4000) -- 法定代表人
    ,opscope varchar2(4000) -- 经营业务范围
    ,regno varchar2(4000) -- 注册号
    ,opto varchar2(4000) -- 经营期限至
    ,entname varchar2(4000) -- 企业名称
    ,opfrom varchar2(4000) -- 经营期限自
    ,existyear varchar2(4000) -- 存续时间（年）
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
grant select on ${iol_schema}.uxds_f_shell_company_data_baseinfo to ${iml_schema};
grant select on ${iol_schema}.uxds_f_shell_company_data_baseinfo to ${icl_schema};
grant select on ${iol_schema}.uxds_f_shell_company_data_baseinfo to ${idl_schema};
grant select on ${iol_schema}.uxds_f_shell_company_data_baseinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_shell_company_data_baseinfo is '中数智汇空壳公司_基本信息';
comment on column ${iol_schema}.uxds_f_shell_company_data_baseinfo.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_shell_company_data_baseinfo.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_shell_company_data_baseinfo.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_shell_company_data_baseinfo.dom is '住所';
comment on column ${iol_schema}.uxds_f_shell_company_data_baseinfo.entstatus is '企业状态';
comment on column ${iol_schema}.uxds_f_shell_company_data_baseinfo.regcap is '注册资本（万元';
comment on column ${iol_schema}.uxds_f_shell_company_data_baseinfo.data_baseinfo is '关联标签';
comment on column ${iol_schema}.uxds_f_shell_company_data_baseinfo.creditcode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_shell_company_data_baseinfo.data_date is '批次日期';
comment on column ${iol_schema}.uxds_f_shell_company_data_baseinfo.enttype is '机构类型';
comment on column ${iol_schema}.uxds_f_shell_company_data_baseinfo.liacconam is '累积实缴（万元）';
comment on column ${iol_schema}.uxds_f_shell_company_data_baseinfo.finalshareholder is '最终控股股东';
comment on column ${iol_schema}.uxds_f_shell_company_data_baseinfo.name is '法定代表人';
comment on column ${iol_schema}.uxds_f_shell_company_data_baseinfo.opscope is '经营业务范围';
comment on column ${iol_schema}.uxds_f_shell_company_data_baseinfo.regno is '注册号';
comment on column ${iol_schema}.uxds_f_shell_company_data_baseinfo.opto is '经营期限至';
comment on column ${iol_schema}.uxds_f_shell_company_data_baseinfo.entname is '企业名称';
comment on column ${iol_schema}.uxds_f_shell_company_data_baseinfo.opfrom is '经营期限自';
comment on column ${iol_schema}.uxds_f_shell_company_data_baseinfo.existyear is '存续时间（年）';
comment on column ${iol_schema}.uxds_f_shell_company_data_baseinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_shell_company_data_baseinfo.etl_timestamp is 'ETL处理时间戳';
