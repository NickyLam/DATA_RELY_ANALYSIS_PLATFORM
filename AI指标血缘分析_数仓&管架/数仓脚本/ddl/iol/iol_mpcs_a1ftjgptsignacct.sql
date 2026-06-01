/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1ftjgptsignacct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1ftjgptsignacct
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1ftjgptsignacct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1ftjgptsignacct(
    syscd varchar2(15) -- 系统编号
    ,account varchar2(75) -- 监管账号
    ,accountname varchar2(150) -- 监管账号户名
    ,updt varchar2(21) -- 最后修改时间
    ,status varchar2(2) -- 签约状态
    ,signdate varchar2(12) -- 签约日期
    ,signtime varchar2(15) -- 签约时间
    ,offdate varchar2(12) -- 解约日期
    ,offtime varchar2(15) -- 解约时间
    ,oprbrn varchar2(9) -- 交易机构
    ,oprtlr varchar2(15) -- 交易柜员
    ,chkbrn varchar2(9) -- 复核机构
    ,chktlr varchar2(9) -- 复核柜员
    ,autbrn varchar2(9) -- 授权机构
    ,auttlr varchar2(15) -- 授权柜员
    ,companyname varchar2(300) -- 单位名称
    ,projectname varchar2(300) -- 项目名称
    ,contactnum varchar2(300) -- 联系人
    ,telphome varchar2(450) -- 联系人电话
    ,opbankname varchar2(300) -- 开户行
    ,remarks varchar2(450) -- 备注
    ,accountstatus varchar2(3) -- 监管状态
    ,errmsg varchar2(75) -- 错误信息
    ,sndflag varchar2(3) -- 发送状态
    ,returncode varchar2(5) -- 表示操作结果信息
    ,reason varchar2(300) -- 返回信息
    ,openbrn varchar2(9) -- 开户机构
    ,historicalflag varchar2(3) -- 历史数据标志
    ,opendate varchar2(15) -- 开户日期
    ,xzqhbm varchar2(9) -- 行政区划编码
    ,globseqnum varchar2(60) -- 全局流水号
    ,uniqueseqnum varchar2(60) -- 业务流水号
    ,srvtrxseq varchar2(60) -- 系统内流水号
    ,ztstrnseqno varchar2(60) -- 系统内流水号
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
grant select on ${iol_schema}.mpcs_a1ftjgptsignacct to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1ftjgptsignacct to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1ftjgptsignacct to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1ftjgptsignacct to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1ftjgptsignacct is '监管账号签约信息';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.syscd is '系统编号';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.account is '监管账号';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.accountname is '监管账号户名';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.updt is '最后修改时间';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.status is '签约状态';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.signdate is '签约日期';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.signtime is '签约时间';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.offdate is '解约日期';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.offtime is '解约时间';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.oprbrn is '交易机构';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.oprtlr is '交易柜员';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.chkbrn is '复核机构';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.chktlr is '复核柜员';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.autbrn is '授权机构';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.auttlr is '授权柜员';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.companyname is '单位名称';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.projectname is '项目名称';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.contactnum is '联系人';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.telphome is '联系人电话';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.opbankname is '开户行';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.remarks is '备注';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.accountstatus is '监管状态';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.errmsg is '错误信息';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.sndflag is '发送状态';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.returncode is '表示操作结果信息';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.reason is '返回信息';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.openbrn is '开户机构';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.historicalflag is '历史数据标志';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.opendate is '开户日期';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.xzqhbm is '行政区划编码';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.globseqnum is '全局流水号';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.uniqueseqnum is '业务流水号';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.srvtrxseq is '系统内流水号';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.ztstrnseqno is '系统内流水号';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a1ftjgptsignacct.etl_timestamp is 'ETL处理时间戳';
