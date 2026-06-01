/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_meeting_fillinvote
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_meeting_fillinvote
whenever sqlerror continue none;
drop table ${iol_schema}.icms_meeting_fillinvote purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_meeting_fillinvote(
    serialno varchar2(64) -- 表决流水号
    ,meetingserialno varchar2(64) -- 关联会议流水号
    ,meetinginveno varchar2(64) -- 关联上会业务流水号
    ,customerid varchar2(64) -- 客户编号
    ,isthreecategories varchar2(2) -- 是否属于三类项目
    ,cuslevel varchar2(64) -- 客户评级
    ,classifylevel varchar2(64) -- 债项评级
    ,evaluatefl varchar2(64) -- 风险定价分类
    ,opintion varchar2(4000) -- 审议意见
    ,allopinion varchar2(400) -- 整体意见
    ,allsyopinion1 varchar2(1000) -- 整体审议意见
    ,saveflage varchar2(2) -- 完整性标识
    ,confirmopiniontype varchar2(10) -- 确认意见类型（1-同意，0-否决）
    ,confirmopinion1 varchar2(1000) -- 确认意见
    ,secretaryuserid varchar2(64) -- 贷审会秘书用户编号
    ,leaderuserid varchar2(64) -- 分行分管风险行领导用户编号
    ,confirmopiniondate date -- 汇总日期
    ,allsyopinion varchar2(4000) -- 整体审议意见
    ,confirmopinion varchar2(4000) -- 确认意见
    ,vetoopinion varchar2(4000) -- 一票否决签署意见
    ,vetoopiniontype varchar2(10) -- 一票否决签署意见类型
    ,presidentuserid varchar2(64) -- 分行行长用户编号
    ,submitdate date -- 提交日期
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
grant select on ${iol_schema}.icms_meeting_fillinvote to ${iml_schema};
grant select on ${iol_schema}.icms_meeting_fillinvote to ${icl_schema};
grant select on ${iol_schema}.icms_meeting_fillinvote to ${idl_schema};
grant select on ${iol_schema}.icms_meeting_fillinvote to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_meeting_fillinvote is '贷审会填写表决表';
comment on column ${iol_schema}.icms_meeting_fillinvote.serialno is '表决流水号';
comment on column ${iol_schema}.icms_meeting_fillinvote.meetingserialno is '关联会议流水号';
comment on column ${iol_schema}.icms_meeting_fillinvote.meetinginveno is '关联上会业务流水号';
comment on column ${iol_schema}.icms_meeting_fillinvote.customerid is '客户编号';
comment on column ${iol_schema}.icms_meeting_fillinvote.isthreecategories is '是否属于三类项目';
comment on column ${iol_schema}.icms_meeting_fillinvote.cuslevel is '客户评级';
comment on column ${iol_schema}.icms_meeting_fillinvote.classifylevel is '债项评级';
comment on column ${iol_schema}.icms_meeting_fillinvote.evaluatefl is '风险定价分类';
comment on column ${iol_schema}.icms_meeting_fillinvote.opintion is '审议意见';
comment on column ${iol_schema}.icms_meeting_fillinvote.allopinion is '整体意见';
comment on column ${iol_schema}.icms_meeting_fillinvote.allsyopinion1 is '整体审议意见';
comment on column ${iol_schema}.icms_meeting_fillinvote.saveflage is '完整性标识';
comment on column ${iol_schema}.icms_meeting_fillinvote.confirmopiniontype is '确认意见类型（1-同意，0-否决）';
comment on column ${iol_schema}.icms_meeting_fillinvote.confirmopinion1 is '确认意见';
comment on column ${iol_schema}.icms_meeting_fillinvote.secretaryuserid is '贷审会秘书用户编号';
comment on column ${iol_schema}.icms_meeting_fillinvote.leaderuserid is '分行分管风险行领导用户编号';
comment on column ${iol_schema}.icms_meeting_fillinvote.confirmopiniondate is '汇总日期';
comment on column ${iol_schema}.icms_meeting_fillinvote.allsyopinion is '整体审议意见';
comment on column ${iol_schema}.icms_meeting_fillinvote.confirmopinion is '确认意见';
comment on column ${iol_schema}.icms_meeting_fillinvote.vetoopinion is '一票否决签署意见';
comment on column ${iol_schema}.icms_meeting_fillinvote.vetoopiniontype is '一票否决签署意见类型';
comment on column ${iol_schema}.icms_meeting_fillinvote.presidentuserid is '分行行长用户编号';
comment on column ${iol_schema}.icms_meeting_fillinvote.submitdate is '提交日期';
comment on column ${iol_schema}.icms_meeting_fillinvote.start_dt is '开始时间';
comment on column ${iol_schema}.icms_meeting_fillinvote.end_dt is '结束时间';
comment on column ${iol_schema}.icms_meeting_fillinvote.id_mark is '增删标志';
comment on column ${iol_schema}.icms_meeting_fillinvote.etl_timestamp is 'ETL处理时间戳';
