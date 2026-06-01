/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a60projdf_sign_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a60projdf_sign_detail
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a60projdf_sign_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a60projdf_sign_detail(
    summsq varchar2(15) -- 批扣流水
    ,trandt varchar2(12) -- 交易日期
    ,transq varchar2(12) -- 交易流水
    ,cntidx number(22) -- 扣款序号
    ,acctno varchar2(30) -- 账号
    ,acctna varchar2(120) -- 账户所有人姓名
    ,pytram number(15,2) -- 金额
    ,accpcd varchar2(11) -- 账号响应码,cmb0000代表成功
    ,accmsg varchar2(150) -- 账号错误信息 交易成功：空
    ,hostsq varchar2(75) -- 主机交易流水号
    ,hostdt varchar2(12) -- 主机交易日期
    ,respcd varchar2(11) -- 响应码,cmb0000代表成功
    ,rspmsg varchar2(1200) -- 响应信息 交易成功：空
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
grant select on ${iol_schema}.mpcs_a60projdf_sign_detail to ${iml_schema};
grant select on ${iol_schema}.mpcs_a60projdf_sign_detail to ${icl_schema};
grant select on ${iol_schema}.mpcs_a60projdf_sign_detail to ${idl_schema};
grant select on ${iol_schema}.mpcs_a60projdf_sign_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a60projdf_sign_detail is '批次明细表';
comment on column ${iol_schema}.mpcs_a60projdf_sign_detail.summsq is '批扣流水';
comment on column ${iol_schema}.mpcs_a60projdf_sign_detail.trandt is '交易日期';
comment on column ${iol_schema}.mpcs_a60projdf_sign_detail.transq is '交易流水';
comment on column ${iol_schema}.mpcs_a60projdf_sign_detail.cntidx is '扣款序号';
comment on column ${iol_schema}.mpcs_a60projdf_sign_detail.acctno is '账号';
comment on column ${iol_schema}.mpcs_a60projdf_sign_detail.acctna is '账户所有人姓名';
comment on column ${iol_schema}.mpcs_a60projdf_sign_detail.pytram is '金额';
comment on column ${iol_schema}.mpcs_a60projdf_sign_detail.accpcd is '账号响应码,cmb0000代表成功';
comment on column ${iol_schema}.mpcs_a60projdf_sign_detail.accmsg is '账号错误信息 交易成功：空';
comment on column ${iol_schema}.mpcs_a60projdf_sign_detail.hostsq is '主机交易流水号';
comment on column ${iol_schema}.mpcs_a60projdf_sign_detail.hostdt is '主机交易日期';
comment on column ${iol_schema}.mpcs_a60projdf_sign_detail.respcd is '响应码,cmb0000代表成功';
comment on column ${iol_schema}.mpcs_a60projdf_sign_detail.rspmsg is '响应信息 交易成功：空';
comment on column ${iol_schema}.mpcs_a60projdf_sign_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a60projdf_sign_detail.etl_timestamp is 'ETL处理时间戳';
