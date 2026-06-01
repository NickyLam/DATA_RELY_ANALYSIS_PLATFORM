/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_jcaj_jcaj
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,punishmentorgan varchar2(4000) -- 判决法院
    ,instrumenttype varchar2(4000) -- 文书类型
    ,datakeyid varchar2(4000) -- 数据主键id
    ,prosecution varchar2(4000) -- 检方
    ,datatype varchar2(4000) -- 数据类型值
    ,cause varchar2(4000) -- 案由
    ,remark varchar2(4000) -- 备注
    ,punishmentbasis varchar2(4000) -- 判决依据
    ,jcaj_jcaj varchar2(4000) -- 关联标签
    ,idnumber varchar2(4000) -- 身份证号码
    ,casetype varchar2(4000) -- 案件类型
    ,punishresult varchar2(4000) -- 判决结果
    ,penaltytime varchar2(4000) -- 公示日期
    ,casenumber varchar2(4000) -- 案号
    ,legalperson varchar2(4000) -- 法定代表人姓名
    ,name varchar2(4000) -- 被告
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj is '检察案件';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj.punishmentorgan is '判决法院';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj.instrumenttype is '文书类型';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj.prosecution is '检方';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj.cause is '案由';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj.punishmentbasis is '判决依据';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj.jcaj_jcaj is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj.casetype is '案件类型';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj.punishresult is '判决结果';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj.penaltytime is '公示日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj.casenumber is '案号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj.legalperson is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj.name is '被告';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj.casename is '案件名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jcaj_jcaj.etl_timestamp is 'ETL处理时间戳';
