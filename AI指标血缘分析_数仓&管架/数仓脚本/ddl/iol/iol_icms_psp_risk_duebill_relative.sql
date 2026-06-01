/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_psp_risk_duebill_relative
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_psp_risk_duebill_relative
whenever sqlerror continue none;
drop table ${iol_schema}.icms_psp_risk_duebill_relative purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_psp_risk_duebill_relative(
    warningsignno varchar2(64) -- 预警信号编号
    ,duebillno varchar2(64) -- 借据预警信息编号
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateorgid varchar2(64) -- 更新机构
    ,updateuserid varchar2(64) -- 更新人
    ,updatedate date -- 更新日期
    ,migtflag varchar2(80) -- 迁移标识
    ,kgsurl varchar2(4000) -- 知识图谱调整链接
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
grant select on ${iol_schema}.icms_psp_risk_duebill_relative to ${iml_schema};
grant select on ${iol_schema}.icms_psp_risk_duebill_relative to ${icl_schema};
grant select on ${iol_schema}.icms_psp_risk_duebill_relative to ${idl_schema};
grant select on ${iol_schema}.icms_psp_risk_duebill_relative to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_psp_risk_duebill_relative is '预警信号信息和借据关联表';
comment on column ${iol_schema}.icms_psp_risk_duebill_relative.warningsignno is '预警信号编号';
comment on column ${iol_schema}.icms_psp_risk_duebill_relative.duebillno is '借据预警信息编号';
comment on column ${iol_schema}.icms_psp_risk_duebill_relative.inputuserid is '登记人';
comment on column ${iol_schema}.icms_psp_risk_duebill_relative.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_psp_risk_duebill_relative.inputdate is '登记日期';
comment on column ${iol_schema}.icms_psp_risk_duebill_relative.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_psp_risk_duebill_relative.updateuserid is '更新人';
comment on column ${iol_schema}.icms_psp_risk_duebill_relative.updatedate is '更新日期';
comment on column ${iol_schema}.icms_psp_risk_duebill_relative.migtflag is '迁移标识';
comment on column ${iol_schema}.icms_psp_risk_duebill_relative.kgsurl is '知识图谱调整链接';
comment on column ${iol_schema}.icms_psp_risk_duebill_relative.start_dt is '开始时间';
comment on column ${iol_schema}.icms_psp_risk_duebill_relative.end_dt is '结束时间';
comment on column ${iol_schema}.icms_psp_risk_duebill_relative.id_mark is '增删标志';
comment on column ${iol_schema}.icms_psp_risk_duebill_relative.etl_timestamp is 'ETL处理时间戳';
