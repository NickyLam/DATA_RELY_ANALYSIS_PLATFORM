/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_scjg_gqcz
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,holdcompany varchar2(4000) -- 出质人持有股份单位名称
    ,amount varchar2(4000) -- 出质股权数额
    ,datakeyid varchar2(4000) -- 数据主键id
    ,scjg_gqcz varchar2(4000) -- 关联标签
    ,datatype varchar2(4000) -- 数据类型值
    ,remark varchar2(4000) -- 备注
    ,idnumber varchar2(4000) -- 身份证号码
    ,pledgee varchar2(4000) -- 质权人
    ,registrationauthority varchar2(4000) -- 登记机关
    ,pledgeeidnumber varchar2(4000) -- 质权人号码
    ,registrationnumber varchar2(4000) -- 登记编号
    ,legalperson varchar2(4000) -- 法定代表人姓名
    ,name varchar2(4000) -- 出质人
    ,registrationdate varchar2(4000) -- 登记日期
    ,usccode varchar2(4000) -- 统一社会信用代码
    ,status varchar2(4000) -- 状态
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz is '市场监管-股权出质';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz.holdcompany is '出质人持有股份单位名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz.amount is '出质股权数额';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz.scjg_gqcz is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz.pledgee is '质权人';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz.registrationauthority is '登记机关';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz.pledgeeidnumber is '质权人号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz.registrationnumber is '登记编号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz.legalperson is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz.name is '出质人';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz.registrationdate is '登记日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz.status is '状态';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqcz.etl_timestamp is 'ETL处理时间戳';
