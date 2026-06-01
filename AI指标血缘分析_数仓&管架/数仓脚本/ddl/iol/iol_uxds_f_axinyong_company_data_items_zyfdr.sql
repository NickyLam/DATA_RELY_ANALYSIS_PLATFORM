/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_zyfdr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_zyfdr
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_zyfdr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_zyfdr(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,datakeyid varchar2(4000) -- 数据主键id
    ,punishmenttitle varchar2(4000) -- 处罚名称
    ,datatype varchar2(4000) -- 数据类型值
    ,remark varchar2(4000) -- 备注
    ,idnumber varchar2(4000) -- 身份证号码
    ,court varchar2(4000) -- 认定机关
    ,punishcause varchar2(4000) -- 认定事由
    ,penaltytime varchar2(4000) -- 认定日期
    ,money varchar2(4000) -- 涉案金额
    ,legalperson varchar2(4000) -- 法定代表人姓名
    ,name varchar2(4000) -- 失信企业/个人
    ,zyfdr varchar2(4000) -- 关联标签
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_zyfdr to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_zyfdr to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_zyfdr to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_zyfdr to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_zyfdr is '职业放贷人';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zyfdr.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zyfdr.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zyfdr.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zyfdr.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zyfdr.punishmenttitle is '处罚名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zyfdr.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zyfdr.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zyfdr.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zyfdr.court is '认定机关';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zyfdr.punishcause is '认定事由';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zyfdr.penaltytime is '认定日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zyfdr.money is '涉案金额';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zyfdr.legalperson is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zyfdr.name is '失信企业/个人';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zyfdr.zyfdr is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zyfdr.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zyfdr.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zyfdr.etl_timestamp is 'ETL处理时间戳';
