/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_swcf_fzch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_fzch
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_fzch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_fzch(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,punishmentorgan varchar2(4000) -- 执法机关
    ,penaltytime varchar2(4000) -- 认定日期
    ,casenumber varchar2(4000) -- 文书字号
    ,datakeyid varchar2(4000) -- 数据主键id
    ,legalperson varchar2(4000) -- 法定代表人姓名
    ,datatype varchar2(4000) -- 数据类型值
    ,name varchar2(4000) -- 纳税主体
    ,remark varchar2(4000) -- 备注
    ,swcf_fzch varchar2(4000) -- 关联标签
    ,usccode varchar2(4000) -- 统一社会信用代码
    ,idnumber varchar2(4000) -- 身份证号码
    ,taxstatus varchar2(4000) -- 纳税人状态
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_fzch to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_fzch to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_fzch to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_fzch to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_fzch is '税务处罚-非正常户';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_fzch.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_fzch.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_fzch.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_fzch.punishmentorgan is '执法机关';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_fzch.penaltytime is '认定日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_fzch.casenumber is '文书字号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_fzch.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_fzch.legalperson is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_fzch.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_fzch.name is '纳税主体';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_fzch.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_fzch.swcf_fzch is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_fzch.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_fzch.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_fzch.taxstatus is '纳税人状态';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_fzch.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_swcf_fzch.etl_timestamp is 'ETL处理时间戳';
