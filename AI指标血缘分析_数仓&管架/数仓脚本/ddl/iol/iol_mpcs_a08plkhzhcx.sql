/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a08plkhzhcx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a08plkhzhcx
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a08plkhzhcx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08plkhzhcx(
    ptkype varchar2(30) -- 
    ,transseq varchar2(53) -- 报文标识号
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
    ,acctopenbrn varchar2(21) -- 开户银行行号
    ,id varchar2(75) -- 身份证号
    ,tel varchar2(45) -- 电话/电挂
    ,transt varchar2(3) -- 处理状态 0-初始登记 01-已发送 02-发送失败 03-已手动处理 11-查询账户状态成功 12-查询账户状态失败 13-我行拒绝 e-已发送人行,人行返回失败 t-人行处理成功 j-人行拒绝
    ,accountstatus varchar2(8) -- 账户状态
    ,accountlevel varchar2(2) -- 账号等级 1：Ⅰ类 2：Ⅱ类 3：Ⅲ类
    ,contactcertificatetypeid varchar2(15) -- 证件类型
    ,infostring varchar2(75) -- 证件号
    ,mobilephone varchar2(45) -- 预留手机号
    ,iotype varchar2(2) -- 往来标识 0-往帐 1-来帐
    ,processcode varchar2(6) -- 人行处理结果 pr00-处理成功 pr09-已拒绝
    ,advest varchar2(6) -- 业务拒绝码
    ,rjctinf varchar2(150) -- 业务拒绝信息
    ,obaldt varchar2(12) -- 人行日期
    ,prccd varchar2(12) -- 业务处理码
    ,globalseqno varchar2(96) -- 
    ,channlid varchar2(15) -- 
    ,refmsgno varchar2(48) -- 
    ,openbrn varchar2(12) -- 开户机构
    ,checkdept varchar2(3) -- 核查部门
    ,srcsysid varchar2(6) -- 源渠道码
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
grant select on ${iol_schema}.mpcs_a08plkhzhcx to ${iml_schema};
grant select on ${iol_schema}.mpcs_a08plkhzhcx to ${icl_schema};
grant select on ${iol_schema}.mpcs_a08plkhzhcx to ${idl_schema};
grant select on ${iol_schema}.mpcs_a08plkhzhcx to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a08plkhzhcx is '';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.ptkype is '';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.transseq is '报文标识号';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.transdt is '中台交易日期';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.transtm is '中台交易时间';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.transmitdt is '报文发送时间';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.sndupbrn is '发起直接参与机构';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.sndbrn is '发起参与机构';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.rcvupbrn is '接收直接参与机构';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.rcvbrn is '接收参与机构';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.syscd is '系统编号';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.note is '备注';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.qryacctcnt is '查询账户数目';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.no is '序号';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.acctno is '账户账号(卡号)';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.acctname is '账户名称';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.acctopenbrn is '开户银行行号';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.id is '身份证号';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.tel is '电话/电挂';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.transt is '处理状态 0-初始登记 01-已发送 02-发送失败 03-已手动处理 11-查询账户状态成功 12-查询账户状态失败 13-我行拒绝 e-已发送人行,人行返回失败 t-人行处理成功 j-人行拒绝';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.accountstatus is '账户状态';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.accountlevel is '账号等级 1：Ⅰ类 2：Ⅱ类 3：Ⅲ类';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.contactcertificatetypeid is '证件类型';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.infostring is '证件号';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.mobilephone is '预留手机号';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.iotype is '往来标识 0-往帐 1-来帐';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.processcode is '人行处理结果 pr00-处理成功 pr09-已拒绝';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.advest is '业务拒绝码';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.rjctinf is '业务拒绝信息';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.obaldt is '人行日期';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.prccd is '业务处理码';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.globalseqno is '';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.channlid is '';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.refmsgno is '';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.openbrn is '开户机构';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.checkdept is '核查部门';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.srcsysid is '源渠道码';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a08plkhzhcx.etl_timestamp is 'ETL处理时间戳';
