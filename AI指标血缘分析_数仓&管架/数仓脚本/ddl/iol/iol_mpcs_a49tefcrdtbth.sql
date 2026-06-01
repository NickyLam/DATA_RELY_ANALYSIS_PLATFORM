/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a49tefcrdtbth
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a49tefcrdtbth
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a49tefcrdtbth purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a49tefcrdtbth(
    bachdt varchar2(12) -- 批次日期
    ,bachsq varchar2(12) -- 批次流水
    ,entrustdate varchar2(12) -- 委托日期
    ,msgid varchar2(30) -- 信息序号(支付报单号)
    ,iotype varchar2(2) -- 往来标识
    ,cntrno varchar2(120) -- 合同(协议)号
    ,filena varchar2(120) -- 批次文件名
    ,rspfile varchar2(120) -- 响应文件名
    ,bachtp varchar2(3) -- 交易类型
    ,totlan number(22) -- 总笔数
    ,totlam number(18,2) -- 总金额
    ,succnt number(22) -- 成功笔数
    ,sucamt number(18,2) -- 成功总金额
    ,failct number(22) -- 失败笔数
    ,failam number(18,2) -- 失败总金额
    ,acctno varchar2(53) -- 账号
    ,acctna varchar2(120) -- 账户名称
    ,colldate varchar2(12) -- 对账日期
    ,hostdt varchar2(12) -- 主机日期
    ,hostsq varchar2(105) -- 主机流水号
    ,userid varchar2(15) -- 录入柜员
    ,brchno varchar2(15) -- 录入机构
    ,ckbrus varchar2(15) -- 复核柜员
    ,ckbrno varchar2(15) -- 复核机构
    ,txnid varchar2(30) -- 中心受理号
    ,txndate varchar2(12) -- 清算日期
    ,txnround varchar2(3) -- 清算场次
    ,status varchar2(2) -- 状态
    ,msgcode varchar2(30) -- 错误代码
    ,msgtext varchar2(150) -- 错误信息
    ,obthdt varchar2(12) -- 原批次日期
    ,obthsq varchar2(12) -- 原批次流水
    ,tolfile number(22) -- 应该发送文件总数
    ,sendct number(22) -- 上传文件数
    ,recvct number(22) -- 接收文件数
    ,hzflag varchar2(2) -- 代收付，定期借记来账回执状态标记(0-未回执 1-已回执)
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
grant select on ${iol_schema}.mpcs_a49tefcrdtbth to ${iml_schema};
grant select on ${iol_schema}.mpcs_a49tefcrdtbth to ${icl_schema};
grant select on ${iol_schema}.mpcs_a49tefcrdtbth to ${idl_schema};
grant select on ${iol_schema}.mpcs_a49tefcrdtbth to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a49tefcrdtbth is '金融服务平台EFT定期借货记批次表';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.bachdt is '批次日期';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.bachsq is '批次流水';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.entrustdate is '委托日期';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.msgid is '信息序号(支付报单号)';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.iotype is '往来标识';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.cntrno is '合同(协议)号';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.filena is '批次文件名';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.rspfile is '响应文件名';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.bachtp is '交易类型';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.totlan is '总笔数';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.totlam is '总金额';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.succnt is '成功笔数';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.sucamt is '成功总金额';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.failct is '失败笔数';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.failam is '失败总金额';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.acctno is '账号';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.acctna is '账户名称';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.colldate is '对账日期';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.hostdt is '主机日期';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.hostsq is '主机流水号';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.userid is '录入柜员';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.brchno is '录入机构';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.ckbrus is '复核柜员';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.ckbrno is '复核机构';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.txnid is '中心受理号';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.txndate is '清算日期';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.txnround is '清算场次';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.status is '状态';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.msgcode is '错误代码';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.msgtext is '错误信息';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.obthdt is '原批次日期';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.obthsq is '原批次流水';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.tolfile is '应该发送文件总数';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.sendct is '上传文件数';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.recvct is '接收文件数';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.hzflag is '代收付，定期借记来账回执状态标记(0-未回执 1-已回执)';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a49tefcrdtbth.etl_timestamp is 'ETL处理时间戳';
