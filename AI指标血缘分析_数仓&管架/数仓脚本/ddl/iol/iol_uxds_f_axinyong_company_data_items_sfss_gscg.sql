/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_sfss_gscg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_gscg
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_gscg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_gscg(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,penaltytime varchar2(4000) -- 公告日期
    ,contents varchar2(4000) -- 公告内容
    ,documenttype varchar2(4000) -- 文书类型
    ,datakeyid varchar2(4000) -- 数据主键ID
    ,sfss_gscg varchar2(4000) -- 关联标签
    ,datatype varchar2(4000) -- 数据类型值
    ,name varchar2(4000) -- 当事人
    ,cause varchar2(4000) -- 案由
    ,remark varchar2(4000) -- 备注
    ,court varchar2(4000) -- 公告法院
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_gscg to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_gscg to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_gscg to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_gscg to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_gscg is '司法涉诉-公示催告';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_gscg.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_gscg.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_gscg.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_gscg.penaltytime is '公告日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_gscg.contents is '公告内容';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_gscg.documenttype is '文书类型';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_gscg.datakeyid is '数据主键ID';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_gscg.sfss_gscg is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_gscg.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_gscg.name is '当事人';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_gscg.cause is '案由';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_gscg.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_gscg.court is '公告法院';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_gscg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_gscg.etl_timestamp is 'ETL处理时间戳';
