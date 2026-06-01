/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a08plkhzhyd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a08plkhzhyd
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a08plkhzhyd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08plkhzhyd(
    ptkype varchar2(30) -- 发送报文类型
    ,transseq varchar2(53) -- 报文标识号
    ,orgtransseq varchar2(53) -- 原报文标识号
    ,transdt varchar2(12) -- 中台交易日期
    ,transtm varchar2(9) -- 中台交易时间
    ,transmitdt varchar2(30) -- 报文发送时间
    ,sndupbrn varchar2(21) -- 发起直接参与机构
    ,sndbrn varchar2(21) -- 发起参与机构
    ,rcvupbrn varchar2(21) -- 接收直接参与机构
    ,rcvbrn varchar2(21) -- 接收参与机构
    ,syscd varchar2(6) -- 系统编号
    ,note varchar2(384) -- 备注
    ,qryacctcnt varchar2(18) -- 查询账户数目
    ,no varchar2(18) -- 序号
    ,acctno varchar2(48) -- 账户账号(卡号)
    ,acctname varchar2(90) -- 账户名称
    ,acctstatus varchar2(6) -- 账户状态 as00:待开户;as02:待销户;as03:已销户;as04：借记控制;as05:贷记控制;as06:冻结;as07：已开户为Ⅰ类户;as08:已开户为Ⅱ类户;as09: 已开户为Ⅲ类户;as10:无此户
    ,idrslt varchar2(6) -- 身份号码校验结果
    ,telrslt varchar2(6) -- 电话/电挂校验结果
    ,acctopenbrn varchar2(21) -- 开户银行行号
    ,transt varchar2(3) -- 处理状态 0-初始登记 01-已发送 02-发送失败 03-已手动处理 11-查询账户状态成功 12-查询账户状态失败 13-我行拒绝 e-已发送人行,人行返回失败 t-人行处理成功 j-人行拒绝
    ,processcode varchar2(6) -- 人行处理结果 pr00-已转发,pr09-已拒绝
    ,iotype varchar2(2) -- 往来标识 0-往帐 1-来帐
    ,advest varchar2(6) -- 业务拒绝码
    ,rjctinf varchar2(158) -- 业务拒绝信息
    ,obaldt varchar2(12) -- 人行处理日期
    ,prccd varchar2(12) -- 业务处理码
    ,processcode1 varchar2(12) -- 业务状态
    ,rejectcode varchar2(12) -- 业务拒绝处理码
    ,rejectinfo varchar2(315) -- 业务拒绝信息
    ,osbtranseqno varchar2(75) -- osb交易流水
    ,osbretcd varchar2(30) -- osb返回码
    ,osbretmsg varchar2(600) -- osb返回信息
    ,osbretst varchar2(30) -- osb返回状态
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
grant select on ${iol_schema}.mpcs_a08plkhzhyd to ${iml_schema};
grant select on ${iol_schema}.mpcs_a08plkhzhyd to ${icl_schema};
grant select on ${iol_schema}.mpcs_a08plkhzhyd to ${idl_schema};
grant select on ${iol_schema}.mpcs_a08plkhzhyd to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a08plkhzhyd is '';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.ptkype is '发送报文类型';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.transseq is '报文标识号';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.orgtransseq is '原报文标识号';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.transdt is '中台交易日期';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.transtm is '中台交易时间';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.transmitdt is '报文发送时间';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.sndupbrn is '发起直接参与机构';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.sndbrn is '发起参与机构';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.rcvupbrn is '接收直接参与机构';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.rcvbrn is '接收参与机构';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.syscd is '系统编号';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.note is '备注';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.qryacctcnt is '查询账户数目';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.no is '序号';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.acctno is '账户账号(卡号)';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.acctname is '账户名称';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.acctstatus is '账户状态 as00:待开户;as02:待销户;as03:已销户;as04：借记控制;as05:贷记控制;as06:冻结;as07：已开户为Ⅰ类户;as08:已开户为Ⅱ类户;as09: 已开户为Ⅲ类户;as10:无此户';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.idrslt is '身份号码校验结果';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.telrslt is '电话/电挂校验结果';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.acctopenbrn is '开户银行行号';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.transt is '处理状态 0-初始登记 01-已发送 02-发送失败 03-已手动处理 11-查询账户状态成功 12-查询账户状态失败 13-我行拒绝 e-已发送人行,人行返回失败 t-人行处理成功 j-人行拒绝';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.processcode is '人行处理结果 pr00-已转发,pr09-已拒绝';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.iotype is '往来标识 0-往帐 1-来帐';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.advest is '业务拒绝码';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.rjctinf is '业务拒绝信息';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.obaldt is '人行处理日期';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.prccd is '业务处理码';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.processcode1 is '业务状态';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.rejectcode is '业务拒绝处理码';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.rejectinfo is '业务拒绝信息';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.osbtranseqno is 'osb交易流水';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.osbretcd is 'osb返回码';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.osbretmsg is 'osb返回信息';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.osbretst is 'osb返回状态';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a08plkhzhyd.etl_timestamp is 'ETL处理时间戳';
