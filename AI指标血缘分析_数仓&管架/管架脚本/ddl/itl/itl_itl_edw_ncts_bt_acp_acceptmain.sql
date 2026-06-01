/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_ncts_bt_acp_acceptmain
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain(
    tradeserno varchar2(16) -- 预受理编号
    ,oldtradeserno varchar2(16) -- 原预受理编号
    ,biztype varchar2(10) -- 业务类型
    ,status varchar2(6) -- 状态
    ,busiserno varchar2(50) -- 交易流水
    ,channelcode varchar2(20) -- 发起渠道
    ,acctno varchar2(32) -- 账号
    ,acctname varchar2(100) -- 户名
    ,custno varchar2(32) -- 客户号
    ,idtype varchar2(10) -- 证件类型
    ,idno varchar2(32) -- 证据号码
    ,idname varchar2(100) -- 证件名称
    ,agentidtype varchar2(10) -- 代理人证件类型
    ,agentidno varchar2(32) -- 代理人证件号码
    ,agentidname varchar2(100) -- 代理人证件名称
    ,remark varchar2(1000) -- 备注|预审结论
    ,createdate date -- 创建日期
    ,createtime varchar2(6) -- 创建时间
    ,createby varchar2(50) -- 创建柜员
    ,updatedate date -- 更新日期
    ,updatetime varchar2(6) -- 更新时间
    ,updateby varchar2(50) -- 更新柜员
    ,reftradeserno varchar2(32) -- 流程银行受理流水号
    ,applydate varchar2(8) -- 申请日期
    ,applybrno varchar2(20) -- 申请机构
    ,phone varchar2(20) -- 手机号码
    ,reserv_id varchar2(40) -- 预约编号
    ,tellerphone varchar2(20) -- 柜员手机号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain is '普通预受理表';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.tradeserno is '预受理编号';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.oldtradeserno is '原预受理编号';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.biztype is '业务类型';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.status is '状态';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.busiserno is '交易流水';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.channelcode is '发起渠道';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.acctno is '账号';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.acctname is '户名';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.custno is '客户号';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.idtype is '证件类型';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.idno is '证据号码';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.idname is '证件名称';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.agentidtype is '代理人证件类型';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.agentidno is '代理人证件号码';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.agentidname is '代理人证件名称';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.remark is '备注|预审结论';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.createdate is '创建日期';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.createtime is '创建时间';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.createby is '创建柜员';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.updatedate is '更新日期';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.updatetime is '更新时间';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.updateby is '更新柜员';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.reftradeserno is '流程银行受理流水号';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.applydate is '申请日期';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.applybrno is '申请机构';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.phone is '手机号码';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.reserv_id is '预约编号';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.tellerphone is '柜员手机号';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.start_dt is '开始时间';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.end_dt is '结束时间';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.id_mark is '增删标志';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain.etl_timestamp is 'ETL处理时间戳';