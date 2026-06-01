/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a51ubcollacctlist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a51ubcollacctlist
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a51ubcollacctlist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a51ubcollacctlist(
    acqinstid varchar2(17) -- 受理方标识码
    ,fwdinstid varchar2(17) -- 发送方标识码
    ,systrace varchar2(9) -- 系统跟踪号
    ,transtime varchar2(15) -- 交易时间(mmddhhmmss)
    ,transcode varchar2(12) -- 交易码
    ,transdate varchar2(12) -- 前置交易日期
    ,channels varchar2(5) -- 渠道
    ,msgtype varchar2(6) -- 消息类型
    ,priacct varchar2(53) -- 主账户号
    ,procecode varchar2(9) -- 处理码
    ,transamt number(15,2) -- 交易金额
    ,localtime varchar2(9) -- 受理方所在地时间
    ,localdate varchar2(9) -- 受理方所在地日期
    ,settlmtdate varchar2(6) -- 清算日期
    ,mchnttype varchar2(6) -- 商户类型
    ,retrivarefnum varchar2(18) -- 检索参考号
    ,authridresp varchar2(9) -- 授权标识应答码
    ,respcode varchar2(3) -- 响应码
    ,acptermnlid varchar2(12) -- 受理终端标识码
    ,accptrid varchar2(23) -- 受理商户代码
    ,accttrnameloc varchar2(60) -- 受理方名称/地址
    ,addtnlrespcd varchar2(38) -- 附加响应数据
    ,privatedate varchar2(768) -- 附加私有数据
    ,currcycode varchar2(5) -- 交易货币代码
    ,oldacqinstid varchar2(17) -- 原受理方标识码
    ,oldfwdinstid varchar2(17) -- 原发送方标识码
    ,oldsystrace varchar2(9) -- 原系统跟踪号
    ,oldtranstime varchar2(15) -- 原交易时间(mmddhhmmss)
    ,outacctnbr varchar2(53) -- 支出帐号
    ,inacctnbr varchar2(53) -- 存入账号
    ,atmctrace varchar2(12) -- atmc交易流水号
    ,status varchar2(2) -- 状态1 : 银联有,行内无(他代本) 2 : 银联无,行内有(他代本) 3 : 银联有,行内有,金额不对(他代本) 4 : atmc有,核心无(本代本) 5 : atmc无,核心有(本代本) 6 : atmc有,核心有金额不对(本代本) 7 : 银联有,核心有,atmc无(本代他) 8 : 银联有,核心无,atmc无(本代他) 9 : 银联有,核心无,atmc有(本代他) a : 银联无,核心有,atmc无(本代他) b : 银联无,核心有,atmc有(本代他) c : 银联无,核心无,atmc有(本代他) d : 银联有,核心无(柜面通) e : 银联无,核心有(柜面通) f : 贷记卡对账失败
    ,transt varchar2(2) -- 0 : 未处理1 : 已处理(核心记账)2 : 已处理(核心不记账)
    ,newfwdinstid varchar2(30) -- 发送机构号(f33实际值)（添加处理主键重复）
    ,hostnbr varchar2(96) -- 调账主机流水
    ,trnseq varchar2(96) -- 调账交易流水
    ,outacctno varchar2(48) -- 调账转出账号
    ,inacctno varchar2(48) -- 调账转入账号
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
grant select on ${iol_schema}.mpcs_a51ubcollacctlist to ${iml_schema};
grant select on ${iol_schema}.mpcs_a51ubcollacctlist to ${icl_schema};
grant select on ${iol_schema}.mpcs_a51ubcollacctlist to ${idl_schema};
grant select on ${iol_schema}.mpcs_a51ubcollacctlist to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a51ubcollacctlist is '对账结果表';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.acqinstid is '受理方标识码';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.fwdinstid is '发送方标识码';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.systrace is '系统跟踪号';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.transtime is '交易时间(mmddhhmmss)';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.transcode is '交易码';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.transdate is '前置交易日期';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.channels is '渠道';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.msgtype is '消息类型';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.priacct is '主账户号';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.procecode is '处理码';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.transamt is '交易金额';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.localtime is '受理方所在地时间';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.localdate is '受理方所在地日期';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.settlmtdate is '清算日期';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.mchnttype is '商户类型';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.retrivarefnum is '检索参考号';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.authridresp is '授权标识应答码';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.respcode is '响应码';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.acptermnlid is '受理终端标识码';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.accptrid is '受理商户代码';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.accttrnameloc is '受理方名称/地址';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.addtnlrespcd is '附加响应数据';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.privatedate is '附加私有数据';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.currcycode is '交易货币代码';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.oldacqinstid is '原受理方标识码';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.oldfwdinstid is '原发送方标识码';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.oldsystrace is '原系统跟踪号';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.oldtranstime is '原交易时间(mmddhhmmss)';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.outacctnbr is '支出帐号';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.inacctnbr is '存入账号';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.atmctrace is 'atmc交易流水号';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.status is '状态1 : 银联有,行内无(他代本) 2 : 银联无,行内有(他代本) 3 : 银联有,行内有,金额不对(他代本) 4 : atmc有,核心无(本代本) 5 : atmc无,核心有(本代本) 6 : atmc有,核心有金额不对(本代本) 7 : 银联有,核心有,atmc无(本代他) 8 : 银联有,核心无,atmc无(本代他) 9 : 银联有,核心无,atmc有(本代他) a : 银联无,核心有,atmc无(本代他) b : 银联无,核心有,atmc有(本代他) c : 银联无,核心无,atmc有(本代他) d : 银联有,核心无(柜面通) e : 银联无,核心有(柜面通) f : 贷记卡对账失败';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.transt is '0 : 未处理1 : 已处理(核心记账)2 : 已处理(核心不记账)';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.newfwdinstid is '发送机构号(f33实际值)（添加处理主键重复）';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.hostnbr is '调账主机流水';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.trnseq is '调账交易流水';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.outacctno is '调账转出账号';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.inacctno is '调账转入账号';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a51ubcollacctlist.etl_timestamp is 'ETL处理时间戳';
