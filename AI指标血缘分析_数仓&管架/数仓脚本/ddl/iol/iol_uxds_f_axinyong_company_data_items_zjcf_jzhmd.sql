/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_zjcf_jzhmd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_jzhmd
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_jzhmd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_jzhmd(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,punishmentorgan varchar2(4000) -- 黑名单报送单位
    ,datakeyid varchar2(4000) -- 数据主键id
    ,datatype varchar2(4000) -- 数据类型值
    ,remark varchar2(4000) -- 备注
    ,idnumber varchar2(4000) -- 身份证号码
    ,blacklisttitle varchar2(4000) -- 黑名单名称
    ,zjcf_jzhmd varchar2(4000) -- 关联标签
    ,blacklistcause varchar2(4000) -- 纳入黑名单事由
    ,casenumber varchar2(4000) -- 文书字号
    ,legalperson varchar2(4000) -- 法定代表人姓名
    ,name varchar2(4000) -- 企业名称
    ,announcetime varchar2(4000) -- 公示日期
    ,usccode varchar2(4000) -- 统一社会信用代码
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_jzhmd to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_jzhmd to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_jzhmd to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_jzhmd to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_jzhmd is '住建处罚-建筑黑名单';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_jzhmd.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_jzhmd.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_jzhmd.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_jzhmd.punishmentorgan is '黑名单报送单位';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_jzhmd.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_jzhmd.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_jzhmd.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_jzhmd.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_jzhmd.blacklisttitle is '黑名单名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_jzhmd.zjcf_jzhmd is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_jzhmd.blacklistcause is '纳入黑名单事由';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_jzhmd.casenumber is '文书字号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_jzhmd.legalperson is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_jzhmd.name is '企业名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_jzhmd.announcetime is '公示日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_jzhmd.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_jzhmd.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_jzhmd.etl_timestamp is 'ETL处理时间戳';
