/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_tps_batch_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_tps_batch_detail
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_tps_batch_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_tps_batch_detail(
    tbd_batchno varchar2(32) -- 批次号
    ,tbd_detailno varchar2(64) -- 明细流水号
    ,tbd_flowno varchar2(32) -- 流水号
    ,tbd_payeracno varchar2(32) -- 付款账号
    ,tbd_payeracname varchar2(128) -- 付款账号名称
    ,tbd_payerbankactype varchar2(4) -- 付款账号账户类型
    ,tbd_currency varchar2(3) -- 币种
    ,tbd_payerdeptid varchar2(16) -- 付款部门ID
    ,tbd_payercrflag varchar2(1) -- 付款钞汇标志(C-现钞,R-现汇,X-不适用)
    ,tbd_payersubacno varchar2(40) -- 付款子账户
    ,tbd_payersubactype varchar2(4) -- 付款子账户账户类型
    ,tbd_payersubacseq varchar2(32) -- 付款子账号顺序号
    ,tbd_payeeacno varchar2(40) -- 收款账户
    ,tbd_payeeacname varchar2(200) -- 收款账户名称
    ,tbd_payeebankactype varchar2(50) -- 收款账户账户类型(1-个人,2-企业)
    ,tbd_payeecurrency varchar2(3) -- 收款币种
    ,tbd_payeecrflag varchar2(1) -- 收款钞汇标志
    ,tbd_payeeciftype varchar2(1) -- 收款客户类型
    ,tbd_payeebankid varchar2(32) -- 收款银行号
    ,tbd_payeebankname varchar2(128) -- 收款银行名
    ,tbd_payeeprovincecode varchar2(6) -- 收款省份号码
    ,tbd_payeeprovincename varchar2(64) -- 收款省份名称
    ,tbd_payeecitycode varchar2(6) -- 收款城市号
    ,tbd_payeecityname varchar2(128) -- 收款城市名
    ,tbd_payeeuniondeptid varchar2(20) -- 收款网点ID
    ,tbd_payeeuniondeptname varchar2(255) -- 收款网点名称
    ,tbd_payeeclearbankid varchar2(12) -- 收款清算行ID
    ,tbd_payeercbcitycode varchar2(32) -- 收款RCB城市号
    ,tbd_rcbpost varchar2(1) -- RCB邮政编码
    ,tbd_payeemobile varchar2(16) -- 收款手机号
    ,tbd_payeesms varchar2(16) -- 收款SMS
    ,tbd_amount number(15,2) -- 金额
    ,tbd_fee number(15,2) -- 收费
    ,tbd_notecode varchar2(60) -- 附言
    ,tbd_remark varchar2(128) -- 备注
    ,tbd_transcode varchar2(32) -- 交易码(Transfer-跨行转账,BankInnerTransfer-行内转账)
    ,tbd_transdate varchar2(14) -- 交易日期
    ,tbd_transtime varchar2(14) -- 交易时间
    ,tbd_savepayeeflag varchar2(1) -- 是否保存收款人(0-否,1-是)
    ,tbd_notifypayeeflag varchar2(1) -- 是否通知收款人(0-否,1-是)
    ,tbd_detailstate varchar2(1) -- I-入库，等待跑批,L-结果未明，正在跑批,S-转账成功,U-结果未明,F-转账失败,C-批量预约已撤销
    ,tbd_returncode varchar2(1024) -- 返回码
    ,tbd_returnmsg varchar2(1024) -- 返回信息
    ,tbd_processstarttime varchar2(14) -- 处理开始时间
    ,tbd_processendtime varchar2(14) -- 处理结束时间
    ,tbd_processjnlno varchar2(64) -- 处理流水号
    ,tbd_routerjnlno varchar2(64) -- 路由流水号
    ,tbd_hostjnlno varchar2(64) -- 核心流水号
    ,tbd_validatemsg varchar2(256) -- 校验信息
    ,tbd_discountrate number(15,2) -- 折扣率
    ,tbd_parentfee number(15,2) -- 上层收费
    ,tbd_hostdate varchar2(14) -- 主机日期
    ,tbd_transfertype varchar2(30) -- 转出方式
    ,tbd_transferdate varchar2(8) -- 转出日期
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
grant select on ${iol_schema}.osbs_tps_batch_detail to ${iml_schema};
grant select on ${iol_schema}.osbs_tps_batch_detail to ${icl_schema};
grant select on ${iol_schema}.osbs_tps_batch_detail to ${idl_schema};
grant select on ${iol_schema}.osbs_tps_batch_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_tps_batch_detail is '协议信息表';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_batchno is '批次号';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_detailno is '明细流水号';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_flowno is '流水号';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_payeracno is '付款账号';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_payeracname is '付款账号名称';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_payerbankactype is '付款账号账户类型';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_currency is '币种';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_payerdeptid is '付款部门ID';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_payercrflag is '付款钞汇标志(C-现钞,R-现汇,X-不适用)';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_payersubacno is '付款子账户';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_payersubactype is '付款子账户账户类型';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_payersubacseq is '付款子账号顺序号';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_payeeacno is '收款账户';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_payeeacname is '收款账户名称';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_payeebankactype is '收款账户账户类型(1-个人,2-企业)';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_payeecurrency is '收款币种';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_payeecrflag is '收款钞汇标志';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_payeeciftype is '收款客户类型';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_payeebankid is '收款银行号';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_payeebankname is '收款银行名';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_payeeprovincecode is '收款省份号码';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_payeeprovincename is '收款省份名称';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_payeecitycode is '收款城市号';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_payeecityname is '收款城市名';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_payeeuniondeptid is '收款网点ID';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_payeeuniondeptname is '收款网点名称';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_payeeclearbankid is '收款清算行ID';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_payeercbcitycode is '收款RCB城市号';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_rcbpost is 'RCB邮政编码';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_payeemobile is '收款手机号';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_payeesms is '收款SMS';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_amount is '金额';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_fee is '收费';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_notecode is '附言';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_remark is '备注';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_transcode is '交易码(Transfer-跨行转账,BankInnerTransfer-行内转账)';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_transdate is '交易日期';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_transtime is '交易时间';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_savepayeeflag is '是否保存收款人(0-否,1-是)';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_notifypayeeflag is '是否通知收款人(0-否,1-是)';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_detailstate is 'I-入库，等待跑批,L-结果未明，正在跑批,S-转账成功,U-结果未明,F-转账失败,C-批量预约已撤销';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_returncode is '返回码';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_returnmsg is '返回信息';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_processstarttime is '处理开始时间';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_processendtime is '处理结束时间';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_processjnlno is '处理流水号';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_routerjnlno is '路由流水号';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_hostjnlno is '核心流水号';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_validatemsg is '校验信息';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_discountrate is '折扣率';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_parentfee is '上层收费';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_hostdate is '主机日期';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_transfertype is '转出方式';
comment on column ${iol_schema}.osbs_tps_batch_detail.tbd_transferdate is '转出日期';
comment on column ${iol_schema}.osbs_tps_batch_detail.start_dt is '开始时间';
comment on column ${iol_schema}.osbs_tps_batch_detail.end_dt is '结束时间';
comment on column ${iol_schema}.osbs_tps_batch_detail.id_mark is '增删标志';
comment on column ${iol_schema}.osbs_tps_batch_detail.etl_timestamp is 'ETL处理时间戳';
