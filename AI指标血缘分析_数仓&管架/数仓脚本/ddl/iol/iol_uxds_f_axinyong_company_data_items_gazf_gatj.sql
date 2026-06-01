/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_gazf_gatj
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_gazf_gatj
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_gazf_gatj purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_gazf_gatj(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,gazf_gatj varchar2(4000) -- 关联标签
    ,wantedcircular varchar2(4000) -- 通缉令信息
    ,datakeyid varchar2(4000) -- 数据主键id
    ,datatype varchar2(4000) -- 数据类型值
    ,name varchar2(4000) -- 被通缉人姓名
    ,announceorgan varchar2(4000) -- 发布机构
    ,announcetime varchar2(4000) -- 公示日期
    ,remark varchar2(4000) -- 备注
    ,idnumber varchar2(4000) -- 身份证号码
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_gazf_gatj to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_gazf_gatj to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_gazf_gatj to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_gazf_gatj to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_gazf_gatj is '公安执法-公安通缉';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gazf_gatj.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gazf_gatj.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gazf_gatj.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gazf_gatj.gazf_gatj is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gazf_gatj.wantedcircular is '通缉令信息';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gazf_gatj.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gazf_gatj.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gazf_gatj.name is '被通缉人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gazf_gatj.announceorgan is '发布机构';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gazf_gatj.announcetime is '公示日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gazf_gatj.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gazf_gatj.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gazf_gatj.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gazf_gatj.etl_timestamp is 'ETL处理时间戳';
