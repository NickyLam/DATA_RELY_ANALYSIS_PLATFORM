/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_hbjg_hmd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_hmd
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_hmd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_hmd(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,punishmentorgan varchar2(4000) -- 列入机关
    ,hbjg_hmd varchar2(4000) -- 关联标签
    ,datakeyid varchar2(4000) -- 数据主键id
    ,datatype varchar2(4000) -- 数据类型值
    ,remark varchar2(4000) -- 备注
    ,punishmentbasis varchar2(4000) -- 处罚依据
    ,idnumber varchar2(4000) -- 身份证号码
    ,punishcause varchar2(4000) -- 处罚事由
    ,punishresult varchar2(4000) -- 处罚结果
    ,penaltytime varchar2(4000) -- 列入日期
    ,legalperson varchar2(4000) -- 法定代表人姓名
    ,name varchar2(4000) -- 企业名称
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_hmd to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_hmd to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_hmd to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_hmd to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_hmd is '环保监管-环保黑名单';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_hmd.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_hmd.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_hmd.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_hmd.punishmentorgan is '列入机关';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_hmd.hbjg_hmd is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_hmd.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_hmd.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_hmd.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_hmd.punishmentbasis is '处罚依据';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_hmd.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_hmd.punishcause is '处罚事由';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_hmd.punishresult is '处罚结果';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_hmd.penaltytime is '列入日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_hmd.legalperson is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_hmd.name is '企业名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_hmd.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_hmd.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_hmd.etl_timestamp is 'ETL处理时间戳';
