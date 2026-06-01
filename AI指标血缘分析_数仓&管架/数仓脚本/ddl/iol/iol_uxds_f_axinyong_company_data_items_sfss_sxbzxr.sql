/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_sfss_sxbzxr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,punishmentorgan varchar2(4000) -- 执行法院
    ,datakeyid varchar2(4000) -- 数据主键id
    ,sex varchar2(4000) -- 性别
    ,datatype varchar2(4000) -- 数据类型值
    ,remark varchar2(4000) -- 备注
    ,idnumber varchar2(4000) -- 身份证号码
    ,filingtime varchar2(4000) -- 立案时间
    ,performance varchar2(4000) -- 被执行人的履行情况
    ,province varchar2(4000) -- 省份
    ,casenumber varchar2(4000) -- 案号
    ,obligation varchar2(4000) -- 生效法律文书确定的义务
    ,name varchar2(4000) -- 被执行人姓名/名称
    ,sfss_sxbzxr varchar2(4000) -- 关联标签
    ,usccode varchar2(4000) -- 统一社会信用代码
    ,referencecasenumber varchar2(4000) -- 执行依据文号
    ,situation varchar2(4000) -- 失信被执行人行为具体情形
    ,basisorgan varchar2(4000) -- 做出执行依据单位
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr is '司法涉诉-失信被执行人';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr.punishmentorgan is '执行法院';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr.sex is '性别';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr.filingtime is '立案时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr.performance is '被执行人的履行情况';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr.province is '省份';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr.casenumber is '案号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr.obligation is '生效法律文书确定的义务';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr.name is '被执行人姓名/名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr.sfss_sxbzxr is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr.referencecasenumber is '执行依据文号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr.situation is '失信被执行人行为具体情形';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr.basisorgan is '做出执行依据单位';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_sxbzxr.etl_timestamp is 'ETL处理时间戳';
