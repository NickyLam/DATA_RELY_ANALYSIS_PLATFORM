/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_pbs_verify_channel_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_pbs_verify_channel_flow
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_pbs_verify_channel_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_pbs_verify_channel_flow(
    pvc_transdate varchar2(8) -- 交易日期yyyyMMdd
    ,pvc_transtime varchar2(17) -- 交易时间yyyyMMddHHmmssSSS
    ,pvc_branchname varchar2(128) -- 分行名称
    ,pvc_branchcode varchar2(3) -- 分行号
    ,pvc_sub_branchname varchar2(128) -- 支行/网点
    ,pvc_sub_branchcode varchar2(12) -- 支行号/网点号
    ,pvc_ecifno varchar2(16) -- 客户号
    ,pvc_channel varchar2(6) -- 交易渠道：NMB-手机银行；MPP-微银行小程序；XFA-零售贷款小程序；
    ,pvc_scene varchar2(64) -- 场景
    ,pvc_verify_channel varchar2(12) -- 鉴权通道:深金结SZFESC；城银清CBPS；银联CUPS；人行CBAC；CFCA；
    ,pvc_bankno varchar2(12) -- 联行号
    ,pvc_bankname varchar2(128) -- 行名
    ,pvc_cardno varchar2(32) -- 卡号
    ,pvc_mobile varchar2(11) -- 手机号
    ,pvc_result varchar2(12) -- 鉴权结果：0成功；1失败；
    ,pvc_errorcode varchar2(13) -- 响应码
    ,pvc_errormsg varchar2(1024) -- 响应信息
    ,pvc_token varchar2(64) -- 交易token
    ,pvc_ecifname varchar2(128) -- 客户名称
    ,pvc_acctno varchar2(32) -- 账户
    ,pvc_acct_class varchar2(2) -- 账户类型；1-类户；2二类户；3三类户
    ,pvc_idno varchar2(18) -- 证件号码
    ,pvc_idtype varchar2(4) -- 证件类型
    ,pvc_transflow varchar2(64) -- 交易流水
    ,pvc_extend1 varchar2(64) -- 备用字段1
    ,pvc_extend2 varchar2(128) -- 备用字段2
    ,pvc_extend3 varchar2(256) -- 备用字段3
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
grant select on ${iol_schema}.osbs_pbs_verify_channel_flow to ${iml_schema};
grant select on ${iol_schema}.osbs_pbs_verify_channel_flow to ${icl_schema};
grant select on ${iol_schema}.osbs_pbs_verify_channel_flow to ${idl_schema};
grant select on ${iol_schema}.osbs_pbs_verify_channel_flow to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_pbs_verify_channel_flow is '鉴权通道数据表';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_transdate is '交易日期yyyyMMdd';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_transtime is '交易时间yyyyMMddHHmmssSSS';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_branchname is '分行名称';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_branchcode is '分行号';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_sub_branchname is '支行/网点';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_sub_branchcode is '支行号/网点号';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_ecifno is '客户号';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_channel is '交易渠道：NMB-手机银行；MPP-微银行小程序；XFA-零售贷款小程序；';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_scene is '场景';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_verify_channel is '鉴权通道:深金结SZFESC；城银清CBPS；银联CUPS；人行CBAC；CFCA；';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_bankno is '联行号';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_bankname is '行名';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_cardno is '卡号';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_mobile is '手机号';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_result is '鉴权结果：0成功；1失败；';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_errorcode is '响应码';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_errormsg is '响应信息';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_token is '交易token';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_ecifname is '客户名称';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_acctno is '账户';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_acct_class is '账户类型；1-类户；2二类户；3三类户';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_idno is '证件号码';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_idtype is '证件类型';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_transflow is '交易流水';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_extend1 is '备用字段1';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_extend2 is '备用字段2';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.pvc_extend3 is '备用字段3';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.osbs_pbs_verify_channel_flow.etl_timestamp is 'ETL处理时间戳';
