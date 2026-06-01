/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_nydl_sdly
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,punishmentorgan varchar2(4000) -- 处罚/报送单位
    ,datakeyid varchar2(4000) -- 数据主键id
    ,datatype varchar2(4000) -- 数据类型值
    ,remark varchar2(4000) -- 备注
    ,nydl_sdly varchar2(4000) -- 关联标签
    ,punishmentbasis varchar2(4000) -- 处罚依据
    ,idnumber varchar2(4000) -- 身份证号码
    ,punishcause varchar2(4000) -- 失信行为
    ,punishresult varchar2(4000) -- 处罚结果
    ,penaltytime varchar2(4000) -- 处罚决定日期
    ,casenumber varchar2(4000) -- 文书字号
    ,legalperson varchar2(4000) -- 法定代表人姓名
    ,name varchar2(4000) -- 失信企业/个人
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly is '能源电力-涉电领域处罚';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly.punishmentorgan is '处罚/报送单位';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly.nydl_sdly is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly.punishmentbasis is '处罚依据';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly.punishcause is '失信行为';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly.punishresult is '处罚结果';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly.penaltytime is '处罚决定日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly.casenumber is '文书字号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly.legalperson is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly.name is '失信企业/个人';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_nydl_sdly.etl_timestamp is 'ETL处理时间戳';
