/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_tps_trandetail_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_tps_trandetail_flow
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_tps_trandetail_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_tps_trandetail_flow(
    tdf_detail_flowno varchar2(64) -- 明细流水号(23位全局流水号+9位序列号)
    ,tdf_ecifno varchar2(32) -- 全行统一客户号
    ,tdf_userno varchar2(32) -- 用户顺序号
    ,tdf_transtime varchar2(17) -- 交易时间
    ,tdf_transcode varchar2(64) -- 交易码
    ,tdf_optype varchar2(2) -- 操作类型00计划新增 01跑批流水 02取消计划 03一站式转行 04定向转账 05亲密付计划新增 06亲密付跑批流水 07亲密付取消计划 08亲密付普通转账
    ,tdf_returncode varchar2(64) -- 交易返回码
    ,tdf_returnmsg varchar2(256) -- 失败原因
    ,tdf_amonut number(15,2) -- 交易金额
    ,tdf_currency varchar2(3) -- 币种
    ,tdf_fee number(15,2) -- 手续费
    ,tdf_payaccno varchar2(32) -- 付款账号
    ,tdf_payaccname varchar2(200) -- 付款账户名称
    ,tdf_payacctype varchar2(4) -- 付款账户类型
    ,tdf_rcvaccno varchar2(32) -- 收款账号
    ,tdf_rcvaccname varchar2(128) -- 收款账号名称
    ,tdf_rcvacctype varchar2(4) -- 收款账户类型
    ,tdf_rcvbankid varchar2(16) -- 收款人银行代码
    ,tdf_rcvbankname varchar2(200) -- 收款人银行名称
    ,tdf_provincecode varchar2(16) -- 收款人省份
    ,tdf_provincename varchar2(64) -- 收款人省份名称
    ,tdf_citycode varchar2(16) -- 收款人城市代码
    ,tdf_cityname varchar2(128) -- 收款人城市名称
    ,tdf_submittime varchar2(17) -- 计划制定时间
    ,tdf_type varchar2(1) -- 计划类型
    ,tdf_tranfreq varchar2(1) -- 交易频率
    ,tdf_nextexedate varchar2(14) -- 下一次执行日期
    ,tdf_state varchar2(1) -- 预约计划状态
    ,tdf_begindate varchar2(14) -- 定时或定频起始日期
    ,tdf_enddate varchar2(14) -- 截止日期
    ,tdf_limitname varchar2(32) -- 限额属性
    ,tdf_securitytype varchar2(1) -- 安全认证方式
    ,tdf_remark varchar2(128) -- 附言
    ,tdf_use varchar2(128) -- 用途
    ,tdf_trade_flowno varchar2(64) -- 流水号(关联PUB_TRADE_FLOW.PTF_TRADE_FLOWNO)
    ,tdf_rcvaccnickname varchar2(64) -- 收款人昵称
    ,tdf_deviceid varchar2(60) -- ATM设备号
    ,tdf_rcvmobile varchar2(20) -- 短信通知手机号码
    ,tdf_branchno varchar2(32) -- 网点号
    ,tdf_branchname varchar2(200) -- 网点名称
    ,tdf_deptid varchar2(2) -- 
    ,tdf_pathid varchar2(20) -- 转出路由
    ,tdf_routeid varchar2(20) -- 汇路ID
    ,tdf_routename varchar2(30) -- 汇路名称
    ,tdf_isnextday varchar2(1) -- 是否次日转出
    ,tdf_mobileno varchar2(15) -- 转账手机号码
    ,tdf_iscreditrepay varchar2(1) -- 是否属信用卡还款  0-是，1-否，不传默认1
    ,tx_seq_num varchar2(33) -- 交易订单号
    ,chain_way_track_no varchar2(128) -- 链路跟踪号
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
grant select on ${iol_schema}.osbs_tps_trandetail_flow to ${iml_schema};
grant select on ${iol_schema}.osbs_tps_trandetail_flow to ${icl_schema};
grant select on ${iol_schema}.osbs_tps_trandetail_flow to ${idl_schema};
grant select on ${iol_schema}.osbs_tps_trandetail_flow to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_tps_trandetail_flow is '交易明细表';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_detail_flowno is '明细流水号(23位全局流水号+9位序列号)';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_ecifno is '全行统一客户号';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_userno is '用户顺序号';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_transtime is '交易时间';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_transcode is '交易码';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_optype is '操作类型00计划新增 01跑批流水 02取消计划 03一站式转行 04定向转账 05亲密付计划新增 06亲密付跑批流水 07亲密付取消计划 08亲密付普通转账';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_returncode is '交易返回码';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_returnmsg is '失败原因';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_amonut is '交易金额';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_currency is '币种';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_fee is '手续费';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_payaccno is '付款账号';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_payaccname is '付款账户名称';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_payacctype is '付款账户类型';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_rcvaccno is '收款账号';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_rcvaccname is '收款账号名称';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_rcvacctype is '收款账户类型';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_rcvbankid is '收款人银行代码';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_rcvbankname is '收款人银行名称';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_provincecode is '收款人省份';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_provincename is '收款人省份名称';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_citycode is '收款人城市代码';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_cityname is '收款人城市名称';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_submittime is '计划制定时间';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_type is '计划类型';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_tranfreq is '交易频率';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_nextexedate is '下一次执行日期';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_state is '预约计划状态';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_begindate is '定时或定频起始日期';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_enddate is '截止日期';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_limitname is '限额属性';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_securitytype is '安全认证方式';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_remark is '附言';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_use is '用途';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_trade_flowno is '流水号(关联PUB_TRADE_FLOW.PTF_TRADE_FLOWNO)';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_rcvaccnickname is '收款人昵称';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_deviceid is 'ATM设备号';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_rcvmobile is '短信通知手机号码';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_branchno is '网点号';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_branchname is '网点名称';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_deptid is '';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_pathid is '转出路由';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_routeid is '汇路ID';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_routename is '汇路名称';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_isnextday is '是否次日转出';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_mobileno is '转账手机号码';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tdf_iscreditrepay is '是否属信用卡还款  0-是，1-否，不传默认1';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.tx_seq_num is '交易订单号';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.chain_way_track_no is '链路跟踪号';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.osbs_tps_trandetail_flow.etl_timestamp is 'ETL处理时间戳';
