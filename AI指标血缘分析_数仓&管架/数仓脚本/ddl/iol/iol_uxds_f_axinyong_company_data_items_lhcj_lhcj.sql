/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_lhcj_lhcj
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,punishmentorgan varchar2(4000) -- 认定部门/作出判决机构
    ,datakeyid varchar2(4000) -- 数据主键id
    ,datatype varchar2(4000) -- 数据类型值
    ,remark varchar2(4000) -- 备注
    ,idnumber varchar2(4000) -- 身份证号码
    ,lhcj_lhcj varchar2(4000) -- 关联标签
    ,announceresult varchar2(4000) -- 惩戒结果
    ,punishcause varchar2(4000) -- 惩戒事由
    ,casenumber varchar2(4000) -- 案号
    ,legalperson varchar2(4000) -- 法定代表人姓名
    ,name varchar2(4000) -- 被惩戒对象名称
    ,announcetime varchar2(4000) -- 认定日期
    ,usccode varchar2(4000) -- 统一社会信用代码
    ,status varchar2(4000) -- 类型
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj is '失信联合惩戒-联合惩戒';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj.punishmentorgan is '认定部门/作出判决机构';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj.lhcj_lhcj is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj.announceresult is '惩戒结果';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj.punishcause is '惩戒事由';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj.casenumber is '案号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj.legalperson is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj.name is '被惩戒对象名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj.announcetime is '认定日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj.status is '类型';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_lhcj_lhcj.etl_timestamp is 'ETL处理时间戳';
