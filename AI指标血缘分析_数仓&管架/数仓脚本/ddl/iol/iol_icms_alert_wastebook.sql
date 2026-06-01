/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_alert_wastebook
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_alert_wastebook
whenever sqlerror continue none;
drop table ${iol_schema}.icms_alert_wastebook purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_alert_wastebook(
    serialno varchar2(64) -- 流水号
    ,updatedate date -- 更新日期
    ,delstatus varchar2(10) -- 状态
    ,cutdate date -- 任务截止日期
    ,isoutfinish varchar2(2) -- 是否过期未完成
    ,confirmstatus varchar2(18) -- 确认状态
    ,effectflag varchar2(32) -- 生效标志
    ,updateorgid varchar2(64) -- 更新机构
    ,relativeserialno varchar2(64) -- 关联流水号
    ,certid varchar2(32) -- 证件编号
    ,customertype varchar2(32) -- 客户类型
    ,accountmonth varchar2(10) -- 会计月份
    ,orgid varchar2(64) -- 机构号
    ,certtype varchar2(32) -- 证件类型
    ,buildtype varchar2(32) -- 预警发起方式
    ,isoverdue varchar2(2) -- 是否过期
    ,alerttype varchar2(32) -- 警示类型
    ,finishdate date -- 完成日期
    ,approvestatus varchar2(10) -- 流程状态
    ,migtflag varchar2(80) -- 
    ,customername varchar2(200) -- 客户名
    ,endstatus varchar2(32) -- 结束状态
    ,balance number(24,6) -- 余额
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,customerid varchar2(64) -- 客户号
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,alertcontent varchar2(4000) -- 预警内容
    ,alertinfosource varchar2(18) -- 预警信息来源
    ,remark1 varchar2(1000) -- 客户经理失效原因
    ,remark2 varchar2(1000) -- 风险经理失效原因
    ,remark3 varchar2(1000) -- 总经理室失效原因
    ,remark4 varchar2(1000) -- 客户经理生效原因
    ,belongdept varchar2(32) -- 
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
grant select on ${iol_schema}.icms_alert_wastebook to ${iml_schema};
grant select on ${iol_schema}.icms_alert_wastebook to ${icl_schema};
grant select on ${iol_schema}.icms_alert_wastebook to ${idl_schema};
grant select on ${iol_schema}.icms_alert_wastebook to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_alert_wastebook is '风险预警信息表';
comment on column ${iol_schema}.icms_alert_wastebook.serialno is '流水号';
comment on column ${iol_schema}.icms_alert_wastebook.updatedate is '更新日期';
comment on column ${iol_schema}.icms_alert_wastebook.delstatus is '状态';
comment on column ${iol_schema}.icms_alert_wastebook.cutdate is '任务截止日期';
comment on column ${iol_schema}.icms_alert_wastebook.isoutfinish is '是否过期未完成';
comment on column ${iol_schema}.icms_alert_wastebook.confirmstatus is '确认状态';
comment on column ${iol_schema}.icms_alert_wastebook.effectflag is '生效标志';
comment on column ${iol_schema}.icms_alert_wastebook.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_alert_wastebook.relativeserialno is '关联流水号';
comment on column ${iol_schema}.icms_alert_wastebook.certid is '证件编号';
comment on column ${iol_schema}.icms_alert_wastebook.customertype is '客户类型';
comment on column ${iol_schema}.icms_alert_wastebook.accountmonth is '会计月份';
comment on column ${iol_schema}.icms_alert_wastebook.orgid is '机构号';
comment on column ${iol_schema}.icms_alert_wastebook.certtype is '证件类型';
comment on column ${iol_schema}.icms_alert_wastebook.buildtype is '预警发起方式';
comment on column ${iol_schema}.icms_alert_wastebook.isoverdue is '是否过期';
comment on column ${iol_schema}.icms_alert_wastebook.alerttype is '警示类型';
comment on column ${iol_schema}.icms_alert_wastebook.finishdate is '完成日期';
comment on column ${iol_schema}.icms_alert_wastebook.approvestatus is '流程状态';
comment on column ${iol_schema}.icms_alert_wastebook.migtflag is '';
comment on column ${iol_schema}.icms_alert_wastebook.customername is '客户名';
comment on column ${iol_schema}.icms_alert_wastebook.endstatus is '结束状态';
comment on column ${iol_schema}.icms_alert_wastebook.balance is '余额';
comment on column ${iol_schema}.icms_alert_wastebook.inputuserid is '登记人';
comment on column ${iol_schema}.icms_alert_wastebook.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_alert_wastebook.customerid is '客户号';
comment on column ${iol_schema}.icms_alert_wastebook.inputdate is '登记日期';
comment on column ${iol_schema}.icms_alert_wastebook.updateuserid is '更新人';
comment on column ${iol_schema}.icms_alert_wastebook.alertcontent is '预警内容';
comment on column ${iol_schema}.icms_alert_wastebook.alertinfosource is '预警信息来源';
comment on column ${iol_schema}.icms_alert_wastebook.remark1 is '客户经理失效原因';
comment on column ${iol_schema}.icms_alert_wastebook.remark2 is '风险经理失效原因';
comment on column ${iol_schema}.icms_alert_wastebook.remark3 is '总经理室失效原因';
comment on column ${iol_schema}.icms_alert_wastebook.remark4 is '客户经理生效原因';
comment on column ${iol_schema}.icms_alert_wastebook.belongdept is '';
comment on column ${iol_schema}.icms_alert_wastebook.start_dt is '开始时间';
comment on column ${iol_schema}.icms_alert_wastebook.end_dt is '结束时间';
comment on column ${iol_schema}.icms_alert_wastebook.id_mark is '增删标志';
comment on column ${iol_schema}.icms_alert_wastebook.etl_timestamp is 'ETL处理时间戳';
