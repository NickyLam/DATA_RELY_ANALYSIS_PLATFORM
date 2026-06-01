/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_ops_transfer_flow
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_ops_transfer_flow_ex purge;
alter table ${iol_schema}.osbs_ops_transfer_flow add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.osbs_ops_transfer_flow truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.osbs_ops_transfer_flow_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_ops_transfer_flow where 0=1;

insert /*+ append */ into ${iol_schema}.osbs_ops_transfer_flow_ex(
    otf_trade_flowno -- 主流水号，与主流水表关联
    ,otf_tran_seqno -- 交易流水号
    ,otf_global_seqno -- 全局流水号
    ,otf_transcode -- 交易代码
    ,otf_transdate -- 交易日期
    ,otf_payeraccountnumber -- 付款人账号
    ,otf_payeraccountname -- 付款人账户户名
    ,otf_payeraccounttype -- 付款人账户类型  1=企业；2=个人；
    ,otf_payerpartyid -- 付款人交易机构/行号
    ,otf_payeeaccountnumber -- 收款人账号
    ,otf_payeeaccountname -- 收款人账户户名
    ,otf_payeeaccounttype -- 收款人账户类型  1=企业；2=个人；
    ,otf_currency -- 订单币种
    ,otf_amount -- 金额
    ,otf_fee -- 手续费
    ,otf_rcvbankid -- 收款人银行代码
    ,otf_rcvbankname -- 收款人银行名称
    ,otf_rcvbankbranch -- 收款网点号
    ,otf_rcvbankbranchname -- 收款网点名
    ,otf_provincecode -- 收款省份代码
    ,otf_provincename -- 收款省份名称
    ,otf_citycode -- 收款城市代码
    ,otf_cityname -- 收款城市名称
    ,otf_rcvmobile -- 收款人手机号
    ,otf_rcvsms -- 附言
    ,otf_transuse -- 交易用途（摘要码）ET=网银转账 F1=手续费 RI=还息 M1=工资 F5=电费 F6=水费 ZZ=其他
    ,otf_securitytype -- 安全认证方式  1=U盾 2=短信验证码 5=人脸 6=短信+人脸 7=云盾
    ,otf_limitattribute -- 限额属性 BPMOBILETRANSFER=手机银行限额 BPTRANSFER=网银限额 BPMOBILETRANSFERPAYEEFIXED=定向转账限额 BPMOBILENOPAY=手机号码转账 BPMOBILECROSSTRANSFER=跨行清算网银借记限额
    ,otf_optype -- 操作类型 00=计划新增 01=跑批流水 02=取消计划 03=一站式转行 04=定向转账 05=亲密付计划新增 06=亲密付跑批流水 07=亲密付取消计划 08=亲密付普通转账
    ,otf_pathid -- 通道编号
    ,otf_msgtemplate -- 短信模板
    ,otf_isnextday -- 是否次日到账 Y=是 N=否
    ,otf_transpaycode -- 转账交易码 0101=同行同名转账,0102=同行非同名转账,0103=同行现金转账,0104=跨行现金转账,0105=跨行非现金转账
    ,otf_savercv -- 保存收款人标志
    ,otf_routeid -- 汇路编号
    ,otf_routename -- 汇路名称
    ,otf_transfermobile -- 转账手机号
    ,otf_sysflag -- 行内外转账标识 0=行内 1=行外
    ,otf_transtype -- 交易类型 BANKINNERTRANSFER=本行转账,TRANSFER=跨行转账,UNITYPAYTRANSFER=跨行转账,NICKNAMETRANSFER=亲密付(即时),定向转账=TRANSFERPAYEEFIXED
    ,otf_orderid -- 订单标识
    ,tx_seq_num -- 交易订单号
    ,chain_way_track_no -- 链路跟踪号
    ,biz_seq_num -- 系统内流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    otf_trade_flowno -- 主流水号，与主流水表关联
    ,otf_tran_seqno -- 交易流水号
    ,otf_global_seqno -- 全局流水号
    ,otf_transcode -- 交易代码
    ,otf_transdate -- 交易日期
    ,otf_payeraccountnumber -- 付款人账号
    ,otf_payeraccountname -- 付款人账户户名
    ,otf_payeraccounttype -- 付款人账户类型  1=企业；2=个人；
    ,otf_payerpartyid -- 付款人交易机构/行号
    ,otf_payeeaccountnumber -- 收款人账号
    ,otf_payeeaccountname -- 收款人账户户名
    ,otf_payeeaccounttype -- 收款人账户类型  1=企业；2=个人；
    ,otf_currency -- 订单币种
    ,otf_amount -- 金额
    ,otf_fee -- 手续费
    ,otf_rcvbankid -- 收款人银行代码
    ,otf_rcvbankname -- 收款人银行名称
    ,otf_rcvbankbranch -- 收款网点号
    ,otf_rcvbankbranchname -- 收款网点名
    ,otf_provincecode -- 收款省份代码
    ,otf_provincename -- 收款省份名称
    ,otf_citycode -- 收款城市代码
    ,otf_cityname -- 收款城市名称
    ,otf_rcvmobile -- 收款人手机号
    ,otf_rcvsms -- 附言
    ,otf_transuse -- 交易用途（摘要码）ET=网银转账 F1=手续费 RI=还息 M1=工资 F5=电费 F6=水费 ZZ=其他
    ,otf_securitytype -- 安全认证方式  1=U盾 2=短信验证码 5=人脸 6=短信+人脸 7=云盾
    ,otf_limitattribute -- 限额属性 BPMOBILETRANSFER=手机银行限额 BPTRANSFER=网银限额 BPMOBILETRANSFERPAYEEFIXED=定向转账限额 BPMOBILENOPAY=手机号码转账 BPMOBILECROSSTRANSFER=跨行清算网银借记限额
    ,otf_optype -- 操作类型 00=计划新增 01=跑批流水 02=取消计划 03=一站式转行 04=定向转账 05=亲密付计划新增 06=亲密付跑批流水 07=亲密付取消计划 08=亲密付普通转账
    ,otf_pathid -- 通道编号
    ,otf_msgtemplate -- 短信模板
    ,otf_isnextday -- 是否次日到账 Y=是 N=否
    ,otf_transpaycode -- 转账交易码 0101=同行同名转账,0102=同行非同名转账,0103=同行现金转账,0104=跨行现金转账,0105=跨行非现金转账
    ,otf_savercv -- 保存收款人标志
    ,otf_routeid -- 汇路编号
    ,otf_routename -- 汇路名称
    ,otf_transfermobile -- 转账手机号
    ,otf_sysflag -- 行内外转账标识 0=行内 1=行外
    ,otf_transtype -- 交易类型 BANKINNERTRANSFER=本行转账,TRANSFER=跨行转账,UNITYPAYTRANSFER=跨行转账,NICKNAMETRANSFER=亲密付(即时),定向转账=TRANSFERPAYEEFIXED
    ,otf_orderid -- 订单标识
    ,tx_seq_num -- 交易订单号
    ,chain_way_track_no -- 链路跟踪号
    ,biz_seq_num -- 系统内流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.osbs_ops_transfer_flow
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.osbs_ops_transfer_flow exchange partition p_${batch_date} with table ${iol_schema}.osbs_ops_transfer_flow_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_ops_transfer_flow to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.osbs_ops_transfer_flow_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_ops_transfer_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);