/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_ttcn_ttcn
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_ttcn_ttcn
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_ttcn_ttcn purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_ttcn_ttcn(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,punishmentorgan varchar2(4000) -- 公示部门
    ,datakeyid varchar2(4000) -- 数据主键id
    ,ttcn_ttcn varchar2(4000) -- 关联标签
    ,datatype varchar2(4000) -- 数据类型值
    ,remark varchar2(4000) -- 备注
    ,idnumber varchar2(4000) -- 身份证号码
    ,casenumber varchar2(4000) -- 文书号
    ,legalperson varchar2(4000) -- 法定代表人姓名
    ,name varchar2(4000) -- 企业名称
    ,casename varchar2(4000) -- 公示标题
    ,announcetime varchar2(4000) -- 公示日期
    ,usccode varchar2(4000) -- 统一社会信用代码
    ,eliminationtype varchar2(4000) -- 淘汰类型
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_ttcn_ttcn to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_ttcn_ttcn to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_ttcn_ttcn to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_ttcn_ttcn to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_ttcn_ttcn is '淘汰产能-淘汰产能名单';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ttcn_ttcn.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ttcn_ttcn.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ttcn_ttcn.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ttcn_ttcn.punishmentorgan is '公示部门';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ttcn_ttcn.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ttcn_ttcn.ttcn_ttcn is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ttcn_ttcn.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ttcn_ttcn.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ttcn_ttcn.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ttcn_ttcn.casenumber is '文书号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ttcn_ttcn.legalperson is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ttcn_ttcn.name is '企业名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ttcn_ttcn.casename is '公示标题';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ttcn_ttcn.announcetime is '公示日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ttcn_ttcn.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ttcn_ttcn.eliminationtype is '淘汰类型';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ttcn_ttcn.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ttcn_ttcn.etl_timestamp is 'ETL处理时间戳';
