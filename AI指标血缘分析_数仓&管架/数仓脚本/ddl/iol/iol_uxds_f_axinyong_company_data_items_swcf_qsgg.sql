/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_swcf_qsgg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_qsgg
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_qsgg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_qsgg(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,punishmentorgan varchar2(4000) -- 执法机关
    ,amount varchar2(4000) -- 欠税金额
    ,taxestype varchar2(4000) -- 欠税税种
    ,datakeyid varchar2(4000) -- 数据主键id
    ,datatype varchar2(4000) -- 数据类型值
    ,remark varchar2(4000) -- 备注
    ,swcf_qsgg varchar2(4000) -- 关联标签
    ,idnumber varchar2(4000) -- 身份证号码
    ,penaltytime varchar2(4000) -- 公告日期
    ,casenumber varchar2(4000) -- 文书字号
    ,legalperson varchar2(4000) -- 法定代表人姓名
    ,name varchar2(4000) -- 纳税主体
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_qsgg to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_qsgg to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_qsgg to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_qsgg to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_qsgg is '税务处罚-欠税公告';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_qsgg.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_qsgg.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_qsgg.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_qsgg.punishmentorgan is '执法机关';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_qsgg.amount is '欠税金额';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_qsgg.taxestype is '欠税税种';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_qsgg.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_qsgg.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_qsgg.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_qsgg.swcf_qsgg is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_qsgg.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_qsgg.penaltytime is '公告日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_qsgg.casenumber is '文书字号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_qsgg.legalperson is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_qsgg.name is '纳税主体';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_qsgg.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_qsgg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_qsgg.etl_timestamp is 'ETL处理时间戳';
