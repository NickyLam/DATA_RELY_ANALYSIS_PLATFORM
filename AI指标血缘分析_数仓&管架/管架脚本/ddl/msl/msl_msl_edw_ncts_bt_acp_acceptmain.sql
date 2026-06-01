/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_ncts_bt_acp_acceptmain
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain(
    ETL_DT DATE
    ,TRADESERNO VARCHAR2(16)
    ,OLDTRADESERNO VARCHAR2(16)
    ,BIZTYPE VARCHAR2(10)
    ,STATUS VARCHAR2(6)
    ,BUSISERNO VARCHAR2(50)
    ,CHANNELCODE VARCHAR2(20)
    ,ACCTNO VARCHAR2(32)
    ,ACCTNAME VARCHAR2(100)
    ,CUSTNO VARCHAR2(32)
    ,IDTYPE VARCHAR2(10)
    ,IDNO VARCHAR2(32)
    ,IDNAME VARCHAR2(100)
    ,AGENTIDTYPE VARCHAR2(10)
    ,AGENTIDNO VARCHAR2(32)
    ,AGENTIDNAME VARCHAR2(100)
    ,REMARK VARCHAR2(1000)
    ,CREATEDATE DATE
    ,CREATETIME VARCHAR2(6)
    ,CREATEBY VARCHAR2(50)
    ,UPDATEDATE DATE
    ,UPDATETIME VARCHAR2(6)
    ,UPDATEBY VARCHAR2(50)
    ,REFTRADESERNO VARCHAR2(32)
    ,APPLYDATE VARCHAR2(8)
    ,APPLYBRNO VARCHAR2(20)
    ,PHONE VARCHAR2(20)
    ,RESERV_ID VARCHAR2(40)
    ,TELLERPHONE VARCHAR2(20)
    ,START_DT DATE
    ,END_DT DATE
    ,ID_MARK VARCHAR2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain is '普通预受理表';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.TRADESERNO is '预受理编号';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.OLDTRADESERNO is '原预受理编号';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.BIZTYPE is '业务类型';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.STATUS is '状态';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.BUSISERNO is '交易流水';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.CHANNELCODE is '发起渠道';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.ACCTNO is '账号';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.ACCTNAME is '户名';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.CUSTNO is '客户号';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.IDTYPE is '证件类型';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.IDNO is '证据号码';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.IDNAME is '证件名称';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.AGENTIDTYPE is '代理人证件类型';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.AGENTIDNO is '代理人证件号码';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.AGENTIDNAME is '代理人证件名称';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.REMARK is '备注|预审结论';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.CREATEDATE is '创建日期';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.CREATETIME is '创建时间';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.CREATEBY is '创建柜员';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.UPDATEDATE is '更新日期';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.UPDATETIME is '更新时间';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.UPDATEBY is '更新柜员';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.REFTRADESERNO is '流程银行受理流水号';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.APPLYDATE is '申请日期';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.APPLYBRNO is '申请机构';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.PHONE is '手机号码';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.RESERV_ID is '预约编号';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.TELLERPHONE is '柜员手机号';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.START_DT is '开始时间';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.END_DT is '结束时间';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain.ID_MARK is '增删标志';
