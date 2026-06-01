/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_ops_transfer_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_ops_transfer_flow
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_ops_transfer_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_ops_transfer_flow(
    otf_trade_flowno varchar2(64) -- 主流水号，与主流水表关联
    ,otf_tran_seqno varchar2(128) -- 交易流水号
    ,otf_global_seqno varchar2(66) -- 全局流水号
    ,otf_transcode varchar2(128) -- 交易代码
    ,otf_transdate varchar2(16) -- 交易日期
    ,otf_payeraccountnumber varchar2(64) -- 付款人账号
    ,otf_payeraccountname varchar2(256) -- 付款人账户户名
    ,otf_payeraccounttype varchar2(4) -- 付款人账户类型  1=企业；2=个人；
    ,otf_payerpartyid varchar2(60) -- 付款人交易机构/行号
    ,otf_payeeaccountnumber varchar2(64) -- 收款人账号
    ,otf_payeeaccountname varchar2(256) -- 收款人账户户名
    ,otf_payeeaccounttype varchar2(4) -- 收款人账户类型  1=企业；2=个人；
    ,otf_currency varchar2(6) -- 订单币种
    ,otf_amount number(15,2) -- 金额
    ,otf_fee number(15,2) -- 手续费
    ,otf_rcvbankid varchar2(60) -- 收款人银行代码
    ,otf_rcvbankname varchar2(400) -- 收款人银行名称
    ,otf_rcvbankbranch varchar2(60) -- 收款网点号
    ,otf_rcvbankbranchname varchar2(400) -- 收款网点名
    ,otf_provincecode varchar2(16) -- 收款省份代码
    ,otf_provincename varchar2(128) -- 收款省份名称
    ,otf_citycode varchar2(16) -- 收款城市代码
    ,otf_cityname varchar2(256) -- 收款城市名称
    ,otf_rcvmobile varchar2(32) -- 收款人手机号
    ,otf_rcvsms varchar2(400) -- 附言
    ,otf_transuse varchar2(16) -- 交易用途（摘要码）ET=网银转账 F1=手续费 RI=还息 M1=工资 F5=电费 F6=水费 ZZ=其他
    ,otf_securitytype varchar2(4) -- 安全认证方式  1=U盾 2=短信验证码 5=人脸 6=短信+人脸 7=云盾
    ,otf_limitattribute varchar2(64) -- 限额属性 BPMOBILETRANSFER=手机银行限额 BPTRANSFER=网银限额 BPMOBILETRANSFERPAYEEFIXED=定向转账限额 BPMOBILENOPAY=手机号码转账 BPMOBILECROSSTRANSFER=跨行清算网银借记限额
    ,otf_optype varchar2(8) -- 操作类型 00=计划新增 01=跑批流水 02=取消计划 03=一站式转行 04=定向转账 05=亲密付计划新增 06=亲密付跑批流水 07=亲密付取消计划 08=亲密付普通转账
    ,otf_pathid varchar2(128) -- 通道编号
    ,otf_msgtemplate varchar2(240) -- 短信模板
    ,otf_isnextday varchar2(8) -- 是否次日到账 Y=是 N=否
    ,otf_transpaycode varchar2(32) -- 转账交易码 0101=同行同名转账,0102=同行非同名转账,0103=同行现金转账,0104=跨行现金转账,0105=跨行非现金转账
    ,otf_savercv varchar2(2) -- 保存收款人标志
    ,otf_routeid varchar2(48) -- 汇路编号
    ,otf_routename varchar2(128) -- 汇路名称
    ,otf_transfermobile varchar2(32) -- 转账手机号
    ,otf_sysflag varchar2(2) -- 行内外转账标识 0=行内 1=行外
    ,otf_transtype varchar2(128) -- 交易类型 BANKINNERTRANSFER=本行转账,TRANSFER=跨行转账,UNITYPAYTRANSFER=跨行转账,NICKNAMETRANSFER=亲密付(即时),定向转账=TRANSFERPAYEEFIXED
    ,otf_orderid varchar2(128) -- 订单标识
    ,tx_seq_num varchar2(66) -- 交易订单号
    ,chain_way_track_no varchar2(256) -- 链路跟踪号
    ,biz_seq_num varchar2(128) -- 系统内流水号
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
grant select on ${iol_schema}.osbs_ops_transfer_flow to ${iml_schema};
grant select on ${iol_schema}.osbs_ops_transfer_flow to ${icl_schema};
grant select on ${iol_schema}.osbs_ops_transfer_flow to ${idl_schema};
grant select on ${iol_schema}.osbs_ops_transfer_flow to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_ops_transfer_flow is '操作日志转账汇款类流水详情表';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_trade_flowno is '主流水号，与主流水表关联';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_tran_seqno is '交易流水号';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_global_seqno is '全局流水号';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_transcode is '交易代码';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_transdate is '交易日期';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_payeraccountnumber is '付款人账号';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_payeraccountname is '付款人账户户名';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_payeraccounttype is '付款人账户类型  1=企业；2=个人；';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_payerpartyid is '付款人交易机构/行号';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_payeeaccountnumber is '收款人账号';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_payeeaccountname is '收款人账户户名';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_payeeaccounttype is '收款人账户类型  1=企业；2=个人；';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_currency is '订单币种';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_amount is '金额';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_fee is '手续费';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_rcvbankid is '收款人银行代码';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_rcvbankname is '收款人银行名称';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_rcvbankbranch is '收款网点号';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_rcvbankbranchname is '收款网点名';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_provincecode is '收款省份代码';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_provincename is '收款省份名称';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_citycode is '收款城市代码';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_cityname is '收款城市名称';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_rcvmobile is '收款人手机号';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_rcvsms is '附言';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_transuse is '交易用途（摘要码）ET=网银转账 F1=手续费 RI=还息 M1=工资 F5=电费 F6=水费 ZZ=其他';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_securitytype is '安全认证方式  1=U盾 2=短信验证码 5=人脸 6=短信+人脸 7=云盾';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_limitattribute is '限额属性 BPMOBILETRANSFER=手机银行限额 BPTRANSFER=网银限额 BPMOBILETRANSFERPAYEEFIXED=定向转账限额 BPMOBILENOPAY=手机号码转账 BPMOBILECROSSTRANSFER=跨行清算网银借记限额';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_optype is '操作类型 00=计划新增 01=跑批流水 02=取消计划 03=一站式转行 04=定向转账 05=亲密付计划新增 06=亲密付跑批流水 07=亲密付取消计划 08=亲密付普通转账';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_pathid is '通道编号';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_msgtemplate is '短信模板';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_isnextday is '是否次日到账 Y=是 N=否';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_transpaycode is '转账交易码 0101=同行同名转账,0102=同行非同名转账,0103=同行现金转账,0104=跨行现金转账,0105=跨行非现金转账';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_savercv is '保存收款人标志';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_routeid is '汇路编号';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_routename is '汇路名称';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_transfermobile is '转账手机号';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_sysflag is '行内外转账标识 0=行内 1=行外';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_transtype is '交易类型 BANKINNERTRANSFER=本行转账,TRANSFER=跨行转账,UNITYPAYTRANSFER=跨行转账,NICKNAMETRANSFER=亲密付(即时),定向转账=TRANSFERPAYEEFIXED';
comment on column ${iol_schema}.osbs_ops_transfer_flow.otf_orderid is '订单标识';
comment on column ${iol_schema}.osbs_ops_transfer_flow.tx_seq_num is '交易订单号';
comment on column ${iol_schema}.osbs_ops_transfer_flow.chain_way_track_no is '链路跟踪号';
comment on column ${iol_schema}.osbs_ops_transfer_flow.biz_seq_num is '系统内流水号';
comment on column ${iol_schema}.osbs_ops_transfer_flow.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.osbs_ops_transfer_flow.etl_timestamp is 'ETL处理时间戳';
