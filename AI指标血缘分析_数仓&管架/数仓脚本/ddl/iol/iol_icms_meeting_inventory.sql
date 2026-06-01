/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_meeting_inventory
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_meeting_inventory
whenever sqlerror continue none;
drop table ${iol_schema}.icms_meeting_inventory purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_meeting_inventory(
    serialno varchar2(64) -- 会议上会清单流水号
    ,meetingserialno varchar2(64) -- 关联会议流水号
    ,businessapplyserialno varchar2(64) -- 关联授信流水号
    ,declarationorg varchar2(64) -- 申报机构
    ,customerid varchar2(16) -- 客户编号
    ,customername varchar2(200) -- 客户名称
    ,ownershiptype varchar2(10) -- 所有制形式
    ,occurtype varchar2(4) -- 授信性质
    ,productid varchar2(32) -- 额度类型
    ,vouchtype varchar2(32) -- 担保方式
    ,businesssum number(24,6) -- 提交上会额度金额
    ,totalsum number(24,6) -- 提交上会敞口金额
    ,termmonth number(38,0) -- 期限
    ,meetingtype varchar2(10) -- 会议类型  1-大会 2-小会
    ,firstappruser varchar2(64) -- 初审员
    ,reviewuser varchar2(64) -- 复审员
    ,attachmentnum number(38,0) -- 附件数量
    ,isonlinevoting varchar2(2) -- 是否在线表决
    ,issubmit varchar2(2) -- 提交上会
    ,votingstatus varchar2(2) -- 表决状态 码表：VotingStatus
    ,submitstatus varchar2(2) -- 上会状态 1-待上会 2-已上会
    ,apprconclusion varchar2(4000) -- 审议结论
    ,remark varchar2(4000) -- 文字备注
    ,issurestatus varchar2(2) -- 确认状态
    ,opinion1 varchar2(4000) -- 报告汇总意见
    ,opinion2 varchar2(4000) -- 报告审议意见
    ,meetbelongdept varchar2(10) -- 上会业务条线 码值：MeetBelongDept
    ,inputuserid varchar2(8) -- 登记人
    ,inputorgid varchar2(12) -- 登记机构
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(8) -- 更新人
    ,updateorgid varchar2(12) -- 更新机构
    ,updatedate date -- 更新时间
    ,meetingpoolserialno varchar2(64) -- 关联任务池流水号
    ,isonlinemeeting varchar2(10) -- 是否现场会议（1-是，0-否）
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
grant select on ${iol_schema}.icms_meeting_inventory to ${iml_schema};
grant select on ${iol_schema}.icms_meeting_inventory to ${icl_schema};
grant select on ${iol_schema}.icms_meeting_inventory to ${idl_schema};
grant select on ${iol_schema}.icms_meeting_inventory to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_meeting_inventory is '会议上会清单表';
comment on column ${iol_schema}.icms_meeting_inventory.serialno is '会议上会清单流水号';
comment on column ${iol_schema}.icms_meeting_inventory.meetingserialno is '关联会议流水号';
comment on column ${iol_schema}.icms_meeting_inventory.businessapplyserialno is '关联授信流水号';
comment on column ${iol_schema}.icms_meeting_inventory.declarationorg is '申报机构';
comment on column ${iol_schema}.icms_meeting_inventory.customerid is '客户编号';
comment on column ${iol_schema}.icms_meeting_inventory.customername is '客户名称';
comment on column ${iol_schema}.icms_meeting_inventory.ownershiptype is '所有制形式';
comment on column ${iol_schema}.icms_meeting_inventory.occurtype is '授信性质';
comment on column ${iol_schema}.icms_meeting_inventory.productid is '额度类型';
comment on column ${iol_schema}.icms_meeting_inventory.vouchtype is '担保方式';
comment on column ${iol_schema}.icms_meeting_inventory.businesssum is '提交上会额度金额';
comment on column ${iol_schema}.icms_meeting_inventory.totalsum is '提交上会敞口金额';
comment on column ${iol_schema}.icms_meeting_inventory.termmonth is '期限';
comment on column ${iol_schema}.icms_meeting_inventory.meetingtype is '会议类型  1-大会 2-小会';
comment on column ${iol_schema}.icms_meeting_inventory.firstappruser is '初审员';
comment on column ${iol_schema}.icms_meeting_inventory.reviewuser is '复审员';
comment on column ${iol_schema}.icms_meeting_inventory.attachmentnum is '附件数量';
comment on column ${iol_schema}.icms_meeting_inventory.isonlinevoting is '是否在线表决';
comment on column ${iol_schema}.icms_meeting_inventory.issubmit is '提交上会';
comment on column ${iol_schema}.icms_meeting_inventory.votingstatus is '表决状态 码表：VotingStatus';
comment on column ${iol_schema}.icms_meeting_inventory.submitstatus is '上会状态 1-待上会 2-已上会';
comment on column ${iol_schema}.icms_meeting_inventory.apprconclusion is '审议结论';
comment on column ${iol_schema}.icms_meeting_inventory.remark is '文字备注';
comment on column ${iol_schema}.icms_meeting_inventory.issurestatus is '确认状态';
comment on column ${iol_schema}.icms_meeting_inventory.opinion1 is '报告汇总意见';
comment on column ${iol_schema}.icms_meeting_inventory.opinion2 is '报告审议意见';
comment on column ${iol_schema}.icms_meeting_inventory.meetbelongdept is '上会业务条线 码值：MeetBelongDept';
comment on column ${iol_schema}.icms_meeting_inventory.inputuserid is '登记人';
comment on column ${iol_schema}.icms_meeting_inventory.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_meeting_inventory.inputdate is '登记时间';
comment on column ${iol_schema}.icms_meeting_inventory.updateuserid is '更新人';
comment on column ${iol_schema}.icms_meeting_inventory.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_meeting_inventory.updatedate is '更新时间';
comment on column ${iol_schema}.icms_meeting_inventory.meetingpoolserialno is '关联任务池流水号';
comment on column ${iol_schema}.icms_meeting_inventory.isonlinemeeting is '是否现场会议（1-是，0-否）';
comment on column ${iol_schema}.icms_meeting_inventory.start_dt is '开始时间';
comment on column ${iol_schema}.icms_meeting_inventory.end_dt is '结束时间';
comment on column ${iol_schema}.icms_meeting_inventory.id_mark is '增删标志';
comment on column ${iol_schema}.icms_meeting_inventory.etl_timestamp is 'ETL处理时间戳';
