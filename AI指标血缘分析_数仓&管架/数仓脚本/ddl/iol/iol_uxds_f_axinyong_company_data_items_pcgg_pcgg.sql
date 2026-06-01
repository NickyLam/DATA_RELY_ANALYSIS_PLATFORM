/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_pcgg_pcgg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,charge varchar2(4000) -- 管理人主要负责人
    ,announcecontent varchar2(4000) -- 公告内容
    ,managerorganization varchar2(4000) -- 管理人机构
    ,datakeyid varchar2(4000) -- 数据主键id
    ,pcgg_pcgg varchar2(4000) -- 关联标签
    ,punishcategory varchar2(4000) -- 公告类型
    ,datatype varchar2(4000) -- 数据类型值
    ,remark varchar2(4000) -- 备注
    ,idnumber varchar2(4000) -- 身份证号码
    ,applicant varchar2(4000) -- 申请人
    ,casenumber varchar2(4000) -- 文书号
    ,noticename varchar2(4000) -- 公告文书名称
    ,legalperson varchar2(4000) -- 法定代表人姓名
    ,name varchar2(4000) -- 企业名称
    ,announceorgan varchar2(4000) -- 公告机关
    ,announcetime varchar2(4000) -- 公示日期
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg is '破产公告-破产公告';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg.charge is '管理人主要负责人';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg.announcecontent is '公告内容';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg.managerorganization is '管理人机构';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg.pcgg_pcgg is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg.punishcategory is '公告类型';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg.applicant is '申请人';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg.casenumber is '文书号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg.noticename is '公告文书名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg.legalperson is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg.name is '企业名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg.announceorgan is '公告机关';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg.announcetime is '公示日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_pcgg_pcgg.etl_timestamp is 'ETL处理时间戳';
