/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_aqcf_sgtb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,announcecontent varchar2(4000) -- 通报内容
    ,datakeyid varchar2(4000) -- 数据主键id
    ,datatype varchar2(4000) -- 数据类型值
    ,arbitrationtime varchar2(4000) -- 通报时间
    ,remark varchar2(4000) -- 备注
    ,idnumber varchar2(4000) -- 身份证号码
    ,announcementorgan varchar2(4000) -- 通报单位
    ,announcedate varchar2(4000) -- 通报事由
    ,aqcf_sgtb varchar2(4000) -- 关联标签
    ,casenumber varchar2(4000) -- 文书号
    ,legalperson varchar2(4000) -- 法定代表人姓名
    ,name varchar2(4000) -- 被通报单位/个人名称
    ,casename varchar2(4000) -- 案件名称
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb is '应急安监-事故通报';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb.announcecontent is '通报内容';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb.arbitrationtime is '通报时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb.announcementorgan is '通报单位';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb.announcedate is '通报事由';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb.aqcf_sgtb is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb.casenumber is '文书号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb.legalperson is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb.name is '被通报单位/个人名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb.casename is '案件名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_sgtb.etl_timestamp is 'ETL处理时间戳';
