/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ind_social_ins
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ind_social_ins
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ind_social_ins purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ind_social_ins(
    serialno varchar2(64) -- 流水号
    ,customerid varchar2(16) -- 客户编号
    ,sibalance number(24,6) -- 余额余额（单位：元）
    ,uptodate date -- 统计截止日期
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateorgid varchar2(64) -- 更新机构
    ,sitype varchar2(36) -- 保险种类保险种类（代码：1-养老保险2-医疗保险3-住房公积金4-失业保险金5-其他保险）
    ,inputuserid varchar2(64) -- 登记人
    ,updatedate date -- 更新日期
    ,remark varchar2(1000) -- 备注
    ,corporgid varchar2(64) -- 法人机构编号
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,updateuserid varchar2(64) -- 更新人
    ,sitno varchar2(80) -- 社会保险号
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
grant select on ${iol_schema}.icms_ind_social_ins to ${iml_schema};
grant select on ${iol_schema}.icms_ind_social_ins to ${icl_schema};
grant select on ${iol_schema}.icms_ind_social_ins to ${idl_schema};
grant select on ${iol_schema}.icms_ind_social_ins to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ind_social_ins is '社会保险社会保险表';
comment on column ${iol_schema}.icms_ind_social_ins.serialno is '流水号';
comment on column ${iol_schema}.icms_ind_social_ins.customerid is '客户编号';
comment on column ${iol_schema}.icms_ind_social_ins.sibalance is '余额余额（单位：元）';
comment on column ${iol_schema}.icms_ind_social_ins.uptodate is '统计截止日期';
comment on column ${iol_schema}.icms_ind_social_ins.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ind_social_ins.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ind_social_ins.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ind_social_ins.sitype is '保险种类保险种类（代码：1-养老保险2-医疗保险3-住房公积金4-失业保险金5-其他保险）';
comment on column ${iol_schema}.icms_ind_social_ins.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ind_social_ins.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ind_social_ins.remark is '备注';
comment on column ${iol_schema}.icms_ind_social_ins.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_ind_social_ins.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_ind_social_ins.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ind_social_ins.sitno is '社会保险号';
comment on column ${iol_schema}.icms_ind_social_ins.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ind_social_ins.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ind_social_ins.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ind_social_ins.etl_timestamp is 'ETL处理时间戳';
