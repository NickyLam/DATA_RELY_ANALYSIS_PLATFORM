/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_alert_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_alert_data
whenever sqlerror continue none;
drop table ${iol_schema}.icms_alert_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_alert_data(
    customerid varchar2(64) -- 客户号
    ,objecttype varchar2(32) -- 对象类型
    ,objectno varchar2(64) -- 对象号
    ,signid varchar2(32) -- 警示号
    ,signdescribe varchar2(1000) -- 警示描述
    ,confirmstatus varchar2(18) -- 确认状态
    ,confirmconment varchar2(4000) -- 预警信号认定说明
    ,relieverexplain varchar2(400) -- 解除说明
    ,remark varchar2(200) -- 备注
    ,inputorgid varchar2(64) -- 录入机构
    ,inputdate date -- 录入日期
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,updatedate date -- 更新日期
    ,isreliever varchar2(10) -- 是否解除
    ,updateorgid varchar2(64) -- 更新机构
    ,status varchar2(32) -- 状态
    ,endstatus varchar2(32) -- 结束状态
    ,serialno varchar2(64) -- 流水号
    ,inputuserid varchar2(64) -- 录入人
    ,updateuserid varchar2(64) -- 更新用户
    ,alerttype varchar2(32) -- 警示类型
    ,contrtolmeasure varchar2(4000) -- 风险控制措施
    ,itemvalue varchar2(4) -- 对象值
    ,signlevel varchar2(32) -- 警示层级
    ,urgentalarm varchar2(4) -- 紧急预警
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
grant select on ${iol_schema}.icms_alert_data to ${iml_schema};
grant select on ${iol_schema}.icms_alert_data to ${icl_schema};
grant select on ${iol_schema}.icms_alert_data to ${idl_schema};
grant select on ${iol_schema}.icms_alert_data to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_alert_data is '警示数据';
comment on column ${iol_schema}.icms_alert_data.customerid is '客户号';
comment on column ${iol_schema}.icms_alert_data.objecttype is '对象类型';
comment on column ${iol_schema}.icms_alert_data.objectno is '对象号';
comment on column ${iol_schema}.icms_alert_data.signid is '警示号';
comment on column ${iol_schema}.icms_alert_data.signdescribe is '警示描述';
comment on column ${iol_schema}.icms_alert_data.confirmstatus is '确认状态';
comment on column ${iol_schema}.icms_alert_data.confirmconment is '预警信号认定说明';
comment on column ${iol_schema}.icms_alert_data.relieverexplain is '解除说明';
comment on column ${iol_schema}.icms_alert_data.remark is '备注';
comment on column ${iol_schema}.icms_alert_data.inputorgid is '录入机构';
comment on column ${iol_schema}.icms_alert_data.inputdate is '录入日期';
comment on column ${iol_schema}.icms_alert_data.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_alert_data.updatedate is '更新日期';
comment on column ${iol_schema}.icms_alert_data.isreliever is '是否解除';
comment on column ${iol_schema}.icms_alert_data.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_alert_data.status is '状态';
comment on column ${iol_schema}.icms_alert_data.endstatus is '结束状态';
comment on column ${iol_schema}.icms_alert_data.serialno is '流水号';
comment on column ${iol_schema}.icms_alert_data.inputuserid is '录入人';
comment on column ${iol_schema}.icms_alert_data.updateuserid is '更新用户';
comment on column ${iol_schema}.icms_alert_data.alerttype is '警示类型';
comment on column ${iol_schema}.icms_alert_data.contrtolmeasure is '风险控制措施';
comment on column ${iol_schema}.icms_alert_data.itemvalue is '对象值';
comment on column ${iol_schema}.icms_alert_data.signlevel is '警示层级';
comment on column ${iol_schema}.icms_alert_data.urgentalarm is '紧急预警';
comment on column ${iol_schema}.icms_alert_data.start_dt is '开始时间';
comment on column ${iol_schema}.icms_alert_data.end_dt is '结束时间';
comment on column ${iol_schema}.icms_alert_data.id_mark is '增删标志';
comment on column ${iol_schema}.icms_alert_data.etl_timestamp is 'ETL处理时间戳';
