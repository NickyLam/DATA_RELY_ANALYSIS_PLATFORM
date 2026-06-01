/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_appraisal_agency_lottery
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_appraisal_agency_lottery
whenever sqlerror continue none;
drop table ${iol_schema}.icms_appraisal_agency_lottery purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_appraisal_agency_lottery(
    serialno varchar2(96) -- 摇号记录流水号
    ,objectno varchar2(192) -- 对象编号
    ,objecttype varchar2(192) -- 对象类型
    ,startdate date -- 生效日
    ,enddate date -- 到期日
    ,status varchar2(30) -- 状态
    ,appraisalorgid varchar2(96) -- 评估机构编号
    ,appraisalorgname varchar2(240) -- 评估机构名称
    ,lotterysortno varchar2(30) -- 摇号顺位
    ,inputuserid varchar2(192) -- 登记人
    ,inputorgid varchar2(192) -- 登记机构
    ,inputdate timestamp -- 登记日期
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_appraisal_agency_lottery to ${iml_schema};
grant select on ${iol_schema}.icms_appraisal_agency_lottery to ${icl_schema};
grant select on ${iol_schema}.icms_appraisal_agency_lottery to ${idl_schema};
grant select on ${iol_schema}.icms_appraisal_agency_lottery to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_appraisal_agency_lottery is '评级机构摇号记录表';
comment on column ${iol_schema}.icms_appraisal_agency_lottery.serialno is '摇号记录流水号';
comment on column ${iol_schema}.icms_appraisal_agency_lottery.objectno is '对象编号';
comment on column ${iol_schema}.icms_appraisal_agency_lottery.objecttype is '对象类型';
comment on column ${iol_schema}.icms_appraisal_agency_lottery.startdate is '生效日';
comment on column ${iol_schema}.icms_appraisal_agency_lottery.enddate is '到期日';
comment on column ${iol_schema}.icms_appraisal_agency_lottery.status is '状态';
comment on column ${iol_schema}.icms_appraisal_agency_lottery.appraisalorgid is '评估机构编号';
comment on column ${iol_schema}.icms_appraisal_agency_lottery.appraisalorgname is '评估机构名称';
comment on column ${iol_schema}.icms_appraisal_agency_lottery.lotterysortno is '摇号顺位';
comment on column ${iol_schema}.icms_appraisal_agency_lottery.inputuserid is '登记人';
comment on column ${iol_schema}.icms_appraisal_agency_lottery.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_appraisal_agency_lottery.inputdate is '登记日期';
comment on column ${iol_schema}.icms_appraisal_agency_lottery.start_dt is '开始时间';
comment on column ${iol_schema}.icms_appraisal_agency_lottery.end_dt is '结束时间';
comment on column ${iol_schema}.icms_appraisal_agency_lottery.id_mark is '增删标志';
comment on column ${iol_schema}.icms_appraisal_agency_lottery.etl_timestamp is 'ETL处理时间戳';
