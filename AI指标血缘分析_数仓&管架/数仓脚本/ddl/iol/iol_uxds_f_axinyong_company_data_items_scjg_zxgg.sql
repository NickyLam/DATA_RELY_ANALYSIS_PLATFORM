/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_scjg_zxgg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_zxgg
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_zxgg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_zxgg(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,announcedate varchar2(4000) -- 公告日期
    ,cancellationreason varchar2(4000) -- 注销事由
    ,datakeyid varchar2(4000) -- 数据主键id
    ,legalperson varchar2(4000) -- 法定代表人姓名
    ,datatype varchar2(4000) -- 数据类型值
    ,name varchar2(4000) -- 被执行人
    ,remark varchar2(4000) -- 备注
    ,usccode varchar2(4000) -- 统一社会信用代码
    ,idnumber varchar2(4000) -- 身份证号码
    ,announcementorgan varchar2(4000) -- 发布单位
    ,scjg_zxgg varchar2(4000) -- 关联标签
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_zxgg to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_zxgg to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_zxgg to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_zxgg to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_zxgg is '市场监管-注销公告';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_zxgg.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_zxgg.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_zxgg.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_zxgg.announcedate is '公告日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_zxgg.cancellationreason is '注销事由';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_zxgg.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_zxgg.legalperson is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_zxgg.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_zxgg.name is '被执行人';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_zxgg.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_zxgg.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_zxgg.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_zxgg.announcementorgan is '发布单位';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_zxgg.scjg_zxgg is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_zxgg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_zxgg.etl_timestamp is 'ETL处理时间戳';
