/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_alertclear_wastebook
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_alertclear_wastebook
whenever sqlerror continue none;
drop table ${iol_schema}.icms_alertclear_wastebook purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_alertclear_wastebook(
    serialno varchar2(64) -- 流水号
    ,status varchar2(32) -- 状态
    ,updateuserid varchar2(64) -- 更新人
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,confirmstatus varchar2(18) -- 确认状态
    ,updateorgid varchar2(64) -- 更新机构
    ,orgid varchar2(64) -- 机构号
    ,balance number(24,6) -- 余额
    ,alertserialno varchar2(32) -- 预警编号
    ,inputorgid varchar2(64) -- 登记机构
    ,customertype varchar2(32) -- 客户类型
    ,updatedate date -- 更新日期
    ,inputuserid varchar2(64) -- 登记人
    ,customername varchar2(80) -- 客户名
    ,endstatus varchar2(32) -- 结束状态
    ,delstatus varchar2(10) -- 处理状态
    ,approvestatus varchar2(10) -- 流程状态
    ,alerttype varchar2(32) -- 警示类型
    ,certid varchar2(32) -- 证件编号
    ,remark varchar2(32) -- 备注
    ,clearlevel varchar2(10) -- 预警级别
    ,accountmonth varchar2(10) -- 会计月份
    ,finishdate date -- 完成日期
    ,customerid varchar2(64) -- 客户号
    ,effectflag varchar2(32) -- 生效标志
    ,relativeserialno varchar2(64) -- 关联流水号
    ,inputdate date -- 登记日期
    ,certtype varchar2(32) -- 证件类型
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
grant select on ${iol_schema}.icms_alertclear_wastebook to ${iml_schema};
grant select on ${iol_schema}.icms_alertclear_wastebook to ${icl_schema};
grant select on ${iol_schema}.icms_alertclear_wastebook to ${idl_schema};
grant select on ${iol_schema}.icms_alertclear_wastebook to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_alertclear_wastebook is '风险预警解除';
comment on column ${iol_schema}.icms_alertclear_wastebook.serialno is '流水号';
comment on column ${iol_schema}.icms_alertclear_wastebook.status is '状态';
comment on column ${iol_schema}.icms_alertclear_wastebook.updateuserid is '更新人';
comment on column ${iol_schema}.icms_alertclear_wastebook.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_alertclear_wastebook.confirmstatus is '确认状态';
comment on column ${iol_schema}.icms_alertclear_wastebook.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_alertclear_wastebook.orgid is '机构号';
comment on column ${iol_schema}.icms_alertclear_wastebook.balance is '余额';
comment on column ${iol_schema}.icms_alertclear_wastebook.alertserialno is '预警编号';
comment on column ${iol_schema}.icms_alertclear_wastebook.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_alertclear_wastebook.customertype is '客户类型';
comment on column ${iol_schema}.icms_alertclear_wastebook.updatedate is '更新日期';
comment on column ${iol_schema}.icms_alertclear_wastebook.inputuserid is '登记人';
comment on column ${iol_schema}.icms_alertclear_wastebook.customername is '客户名';
comment on column ${iol_schema}.icms_alertclear_wastebook.endstatus is '结束状态';
comment on column ${iol_schema}.icms_alertclear_wastebook.delstatus is '处理状态';
comment on column ${iol_schema}.icms_alertclear_wastebook.approvestatus is '流程状态';
comment on column ${iol_schema}.icms_alertclear_wastebook.alerttype is '警示类型';
comment on column ${iol_schema}.icms_alertclear_wastebook.certid is '证件编号';
comment on column ${iol_schema}.icms_alertclear_wastebook.remark is '备注';
comment on column ${iol_schema}.icms_alertclear_wastebook.clearlevel is '预警级别';
comment on column ${iol_schema}.icms_alertclear_wastebook.accountmonth is '会计月份';
comment on column ${iol_schema}.icms_alertclear_wastebook.finishdate is '完成日期';
comment on column ${iol_schema}.icms_alertclear_wastebook.customerid is '客户号';
comment on column ${iol_schema}.icms_alertclear_wastebook.effectflag is '生效标志';
comment on column ${iol_schema}.icms_alertclear_wastebook.relativeserialno is '关联流水号';
comment on column ${iol_schema}.icms_alertclear_wastebook.inputdate is '登记日期';
comment on column ${iol_schema}.icms_alertclear_wastebook.certtype is '证件类型';
comment on column ${iol_schema}.icms_alertclear_wastebook.start_dt is '开始时间';
comment on column ${iol_schema}.icms_alertclear_wastebook.end_dt is '结束时间';
comment on column ${iol_schema}.icms_alertclear_wastebook.id_mark is '增删标志';
comment on column ${iol_schema}.icms_alertclear_wastebook.etl_timestamp is 'ETL处理时间戳';
