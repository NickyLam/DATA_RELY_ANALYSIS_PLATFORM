/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_criminal_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_criminal_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_criminal_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_criminal_info(
    criminalno varchar2(64) -- 案件编号
    ,prosecutionorgans varchar2(160) -- 起诉机关
    ,committalcharge varchar2(160) -- 起诉罪名
    ,updatedate date -- 更新日期
    ,objectno varchar2(64) -- 关联案件编号
    ,acceptancecourt varchar2(160) -- 受理法院
    ,tmsp date -- 时间戳
    ,defendant varchar2(4000) -- 被告
    ,updateorgid varchar2(64) -- 更新机构
    ,caseprogramstage varchar2(36) -- 程序阶段
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,litigationoutcome varchar2(4000) -- 诉讼结果简述
    ,fileno varchar2(4000) -- 判决书影像
    ,remark varchar2(1000) -- 备注
    ,inputuserid varchar2(64) -- 登记人
    ,defendantid varchar2(2000) -- 被告人编号
    ,updateuserid varchar2(64) -- 更新人
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
grant select on ${iol_schema}.icms_ap_criminal_info to ${iml_schema};
grant select on ${iol_schema}.icms_ap_criminal_info to ${icl_schema};
grant select on ${iol_schema}.icms_ap_criminal_info to ${idl_schema};
grant select on ${iol_schema}.icms_ap_criminal_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_criminal_info is '民事转刑事案件信息表';
comment on column ${iol_schema}.icms_ap_criminal_info.criminalno is '案件编号';
comment on column ${iol_schema}.icms_ap_criminal_info.prosecutionorgans is '起诉机关';
comment on column ${iol_schema}.icms_ap_criminal_info.committalcharge is '起诉罪名';
comment on column ${iol_schema}.icms_ap_criminal_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_criminal_info.objectno is '关联案件编号';
comment on column ${iol_schema}.icms_ap_criminal_info.acceptancecourt is '受理法院';
comment on column ${iol_schema}.icms_ap_criminal_info.tmsp is '时间戳';
comment on column ${iol_schema}.icms_ap_criminal_info.defendant is '被告';
comment on column ${iol_schema}.icms_ap_criminal_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_criminal_info.caseprogramstage is '程序阶段';
comment on column ${iol_schema}.icms_ap_criminal_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ap_criminal_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_criminal_info.litigationoutcome is '诉讼结果简述';
comment on column ${iol_schema}.icms_ap_criminal_info.fileno is '判决书影像';
comment on column ${iol_schema}.icms_ap_criminal_info.remark is '备注';
comment on column ${iol_schema}.icms_ap_criminal_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_criminal_info.defendantid is '被告人编号';
comment on column ${iol_schema}.icms_ap_criminal_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ap_criminal_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_criminal_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_criminal_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_criminal_info.etl_timestamp is 'ETL处理时间戳';
