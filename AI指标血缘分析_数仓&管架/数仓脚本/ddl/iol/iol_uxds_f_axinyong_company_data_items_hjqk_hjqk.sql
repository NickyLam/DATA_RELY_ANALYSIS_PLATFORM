/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_hjqk_hjqk
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,amount varchar2(4000) -- 累计借款金额（元）
    ,overdueamount varchar2(4000) -- 逾期金额（元）
    ,datakeyid varchar2(4000) -- 数据主键id
    ,announcementdate varchar2(4000) -- 公示日期
    ,datatype varchar2(4000) -- 数据类型值
    ,remark varchar2(4000) -- 备注
    ,idnumber varchar2(4000) -- 身份证号码
    ,platform varchar2(4000) -- 公示平台
    ,arrearsinformation varchar2(4000) -- 欠款信息
    ,hjqk_hjqk varchar2(4000) -- 关联标签
    ,legalperson varchar2(4000) -- 法定代表人姓名
    ,name varchar2(4000) -- 欠款人/企业名称
    ,usccode varchar2(4000) -- 统一社会信用代码
    ,startdate varchar2(4000) -- 逾期开始时间
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk is '民间欠款';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk.amount is '累计借款金额（元）';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk.overdueamount is '逾期金额（元）';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk.announcementdate is '公示日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk.platform is '公示平台';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk.arrearsinformation is '欠款信息';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk.hjqk_hjqk is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk.legalperson is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk.name is '欠款人/企业名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk.startdate is '逾期开始时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hjqk_hjqk.etl_timestamp is 'ETL处理时间戳';
