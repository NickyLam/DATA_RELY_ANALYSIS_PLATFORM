/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_scjg_gqdj
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,punishmentorgan varchar2(4000) -- 执行法院
    ,amount varchar2(4000) -- 被执行人持有股权其他投资权益的数额
    ,idtype varchar2(4000) -- 被执行人证照/证件类型
    ,datakeyid varchar2(4000) -- 数据主键id
    ,datatype varchar2(4000) -- 数据类型值
    ,remark varchar2(4000) -- 备注
    ,idnumber varchar2(4000) -- 被执行人证照/证件号码
    ,result varchar2(4000) -- 执行事项
    ,penaltytime varchar2(4000) -- 公示日期
    ,executor varchar2(4000) -- 被执行人
    ,casenumber varchar2(4000) -- 文书字号
    ,scjg_gqdj varchar2(4000) -- 关联标签
    ,name varchar2(4000) -- 股权冻结公司名称
    ,unfreezingdate varchar2(4000) -- 解除冻结日期
    ,freezeperiod varchar2(4000) -- 冻结/续行冻结期限
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj is '市场监管-股权冻结';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj.punishmentorgan is '执行法院';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj.amount is '被执行人持有股权其他投资权益的数额';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj.idtype is '被执行人证照/证件类型';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj.idnumber is '被执行人证照/证件号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj.result is '执行事项';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj.penaltytime is '公示日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj.executor is '被执行人';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj.casenumber is '文书字号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj.scjg_gqdj is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj.name is '股权冻结公司名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj.unfreezingdate is '解除冻结日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj.freezeperiod is '冻结/续行冻结期限';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_gqdj.etl_timestamp is 'ETL处理时间戳';
