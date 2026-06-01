/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_ncts_bt_acp_acceptmain_new
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new(
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
    ,CUSTNAME VARCHAR2(500)
    ,IDTYPE VARCHAR2(10)
    ,IDNO VARCHAR2(32)
    ,IDNAME VARCHAR2(100)
    ,IS_PORXY VARCHAR2(2)
    ,AGENTIDTYPE VARCHAR2(10)
    ,AGENTIDNO VARCHAR2(32)
    ,AGENTIDNAME VARCHAR2(100)
    ,AGENTPHONE VARCHAR2(15)
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
    ,APPLY_REMARK VARCHAR2(10)
    ,OTHER_REMARK VARCHAR2(500)
    ,VOUCHERS VARCHAR2(100)
    ,VOUCHERS_AMT VARCHAR2(500)
    ,APPLY_CCY VARCHAR2(20)
    ,APPLY_AMT VARCHAR2(32)
    ,APPLY_TYPE VARCHAR2(2)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new is '大额现金预受理表';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.TRADESERNO is '预受理编号';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.OLDTRADESERNO is '原预受理编号';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.BIZTYPE is '业务类型';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.STATUS is '状态';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.BUSISERNO is '交易流水';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.CHANNELCODE is '发起渠道';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.ACCTNO is '账号';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.ACCTNAME is '户名';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.CUSTNO is '客户号';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.CUSTNAME is '客户名称';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.IDTYPE is '证件类型';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.IDNO is '证据号码';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.IDNAME is '证件名称';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.IS_PORXY is '是否代理(0-否,1-是)';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.AGENTIDTYPE is '代理人证件类型';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.AGENTIDNO is '代理人证件号码';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.AGENTIDNAME is '代理人证件名称';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.AGENTPHONE is '代理人联系方式';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.REMARK is '备注|预审结论';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.CREATEDATE is '创建日期';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.CREATETIME is '创建时间';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.CREATEBY is '创建柜员';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.UPDATEDATE is '更新日期';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.UPDATETIME is '更新时间';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.UPDATEBY is '更新柜员';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.REFTRADESERNO is '流程银行受理流水号';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.APPLYDATE is '申请日期';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.APPLYBRNO is '申请机构';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.PHONE is '手机号码';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.RESERV_ID is '预约编号';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.APPLY_REMARK is '提现用途及理由';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.OTHER_REMARK is '其他用途';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.VOUCHERS is '券别';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.VOUCHERS_AMT is '券别金额';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.APPLY_CCY is '币种';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.APPLY_AMT is '提现金额';
comment on column ${msl_schema}.msl_edw_ncts_bt_acp_acceptmain_new.APPLY_TYPE is '交易类型（2对公单位，1个人）';
