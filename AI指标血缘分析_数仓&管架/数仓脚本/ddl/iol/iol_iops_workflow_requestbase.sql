/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iops_workflow_requestbase
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iops_workflow_requestbase
whenever sqlerror continue none;
drop table ${iol_schema}.iops_workflow_requestbase purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iops_workflow_requestbase(
    requestid number(38,0) -- 
    ,workflowid number(38,0) -- 
    ,lastnodeid number(38,0) -- 
    ,lastnodetype varchar2(300) -- 
    ,currentnodeid number(38,0) -- 
    ,currentnodetype varchar2(300) -- 
    ,status varchar2(4000) -- 
    ,passedgroups number(38,0) -- 
    ,totalgroups number(38,0) -- 
    ,requestname varchar2(4000) -- 
    ,creater number(38,0) -- 
    ,createdate varchar2(500) -- 
    ,createtime varchar2(500) -- 
    ,lastoperator number(38,0) -- 
    ,lastoperatedate varchar2(500) -- 
    ,lastoperatetime varchar2(500) -- 
    ,deleted number(38,0) -- 
    ,creatertype number(38,0) -- 
    ,lastoperatortype number(38,0) -- 
    ,nodepasstime number(38,12) -- 
    ,nodelefttime number(38,12) -- 
    ,docids varchar2(4000) -- 
    ,crmids varchar2(4000) -- 
    ,hrmids_temp varchar2(4000) -- 
    ,prjids varchar2(4000) -- 
    ,cptids varchar2(4000) -- 
    ,requestlevel number(38,0) -- 
    ,requestmark varchar2(4000) -- 
    ,messagetype number(38,0) -- 
    ,mainrequestid number(38,0) -- 
    ,currentstatus number(38,0) -- 
    ,laststatus varchar2(4000) -- 
    ,ismultiprint number(38,0) -- 
    ,chatstype number(38,0) -- 
    ,ecology_pinyin_search varchar2(4000) -- 
    ,hrmids varchar2(4000) -- 
    ,requestnamenew varchar2(4000) -- 
    ,formsignaturemd5 varchar2(4000) -- 
    ,dataaggregated varchar2(300) -- 
    ,seclevel varchar2(300) -- 
    ,secdocid varchar2(4000) -- 
    ,remindtypes varchar2(4000) -- 
    ,lastfeedbackdate varchar2(500) -- 
    ,lastfeedbacktime varchar2(500) -- 
    ,lastfeedbackoperator number(38,0) -- 
    ,requestnamehtmlnew varchar2(4000) -- 
    ,secvalidity varchar2(4000) -- 
    ,secenckey varchar2(4000) -- 
    ,seccrc varchar2(4000) -- 
    ,fwbh varchar2(4000) -- 
    ,draftpeople varchar2(4000) -- 
    ,draftorg varchar2(4000) -- 
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
grant select on ${iol_schema}.iops_workflow_requestbase to ${iml_schema};
grant select on ${iol_schema}.iops_workflow_requestbase to ${icl_schema};
grant select on ${iol_schema}.iops_workflow_requestbase to ${idl_schema};
grant select on ${iol_schema}.iops_workflow_requestbase to ${iel_schema};

-- comment
comment on table ${iol_schema}.iops_workflow_requestbase is '';
comment on column ${iol_schema}.iops_workflow_requestbase.requestid is '';
comment on column ${iol_schema}.iops_workflow_requestbase.workflowid is '';
comment on column ${iol_schema}.iops_workflow_requestbase.lastnodeid is '';
comment on column ${iol_schema}.iops_workflow_requestbase.lastnodetype is '';
comment on column ${iol_schema}.iops_workflow_requestbase.currentnodeid is '';
comment on column ${iol_schema}.iops_workflow_requestbase.currentnodetype is '';
comment on column ${iol_schema}.iops_workflow_requestbase.status is '';
comment on column ${iol_schema}.iops_workflow_requestbase.passedgroups is '';
comment on column ${iol_schema}.iops_workflow_requestbase.totalgroups is '';
comment on column ${iol_schema}.iops_workflow_requestbase.requestname is '';
comment on column ${iol_schema}.iops_workflow_requestbase.creater is '';
comment on column ${iol_schema}.iops_workflow_requestbase.createdate is '';
comment on column ${iol_schema}.iops_workflow_requestbase.createtime is '';
comment on column ${iol_schema}.iops_workflow_requestbase.lastoperator is '';
comment on column ${iol_schema}.iops_workflow_requestbase.lastoperatedate is '';
comment on column ${iol_schema}.iops_workflow_requestbase.lastoperatetime is '';
comment on column ${iol_schema}.iops_workflow_requestbase.deleted is '';
comment on column ${iol_schema}.iops_workflow_requestbase.creatertype is '';
comment on column ${iol_schema}.iops_workflow_requestbase.lastoperatortype is '';
comment on column ${iol_schema}.iops_workflow_requestbase.nodepasstime is '';
comment on column ${iol_schema}.iops_workflow_requestbase.nodelefttime is '';
comment on column ${iol_schema}.iops_workflow_requestbase.docids is '';
comment on column ${iol_schema}.iops_workflow_requestbase.crmids is '';
comment on column ${iol_schema}.iops_workflow_requestbase.hrmids_temp is '';
comment on column ${iol_schema}.iops_workflow_requestbase.prjids is '';
comment on column ${iol_schema}.iops_workflow_requestbase.cptids is '';
comment on column ${iol_schema}.iops_workflow_requestbase.requestlevel is '';
comment on column ${iol_schema}.iops_workflow_requestbase.requestmark is '';
comment on column ${iol_schema}.iops_workflow_requestbase.messagetype is '';
comment on column ${iol_schema}.iops_workflow_requestbase.mainrequestid is '';
comment on column ${iol_schema}.iops_workflow_requestbase.currentstatus is '';
comment on column ${iol_schema}.iops_workflow_requestbase.laststatus is '';
comment on column ${iol_schema}.iops_workflow_requestbase.ismultiprint is '';
comment on column ${iol_schema}.iops_workflow_requestbase.chatstype is '';
comment on column ${iol_schema}.iops_workflow_requestbase.ecology_pinyin_search is '';
comment on column ${iol_schema}.iops_workflow_requestbase.hrmids is '';
comment on column ${iol_schema}.iops_workflow_requestbase.requestnamenew is '';
comment on column ${iol_schema}.iops_workflow_requestbase.formsignaturemd5 is '';
comment on column ${iol_schema}.iops_workflow_requestbase.dataaggregated is '';
comment on column ${iol_schema}.iops_workflow_requestbase.seclevel is '';
comment on column ${iol_schema}.iops_workflow_requestbase.secdocid is '';
comment on column ${iol_schema}.iops_workflow_requestbase.remindtypes is '';
comment on column ${iol_schema}.iops_workflow_requestbase.lastfeedbackdate is '';
comment on column ${iol_schema}.iops_workflow_requestbase.lastfeedbacktime is '';
comment on column ${iol_schema}.iops_workflow_requestbase.lastfeedbackoperator is '';
comment on column ${iol_schema}.iops_workflow_requestbase.requestnamehtmlnew is '';
comment on column ${iol_schema}.iops_workflow_requestbase.secvalidity is '';
comment on column ${iol_schema}.iops_workflow_requestbase.secenckey is '';
comment on column ${iol_schema}.iops_workflow_requestbase.seccrc is '';
comment on column ${iol_schema}.iops_workflow_requestbase.fwbh is '';
comment on column ${iol_schema}.iops_workflow_requestbase.draftpeople is '';
comment on column ${iol_schema}.iops_workflow_requestbase.draftorg is '';
comment on column ${iol_schema}.iops_workflow_requestbase.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.iops_workflow_requestbase.etl_timestamp is 'ETL处理时间戳';
