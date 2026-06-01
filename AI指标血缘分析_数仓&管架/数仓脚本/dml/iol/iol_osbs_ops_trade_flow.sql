/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_ops_trade_flow
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
drop table ${iol_schema}.osbs_ops_trade_flow_ex purge;
alter table ${iol_schema}.osbs_ops_trade_flow add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.osbs_ops_trade_flow truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.osbs_ops_trade_flow_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_ops_trade_flow where 0=1;

insert /*+ append */ into ${iol_schema}.osbs_ops_trade_flow_ex(
    otf_trade_flowno -- 主流水号
    ,otf_tran_seqno -- 交易流水号
    ,otf_global_seqno -- 全局流水号
    ,otf_ecifno -- 全行统一客户号
    ,otf_ecifname -- 客户姓名
    ,otf_userno -- 用户顺序号
    ,otf_transcode -- 交易代码
    ,otf_transcategory -- 业务大类
    ,otf_transtype -- 业务类型
    ,otf_transdate -- 交易日期
    ,otf_transtime -- 交易时间
    ,otf_accno -- 交易账号
    ,otf_currency -- 交易币种
    ,otf_amonut -- 交易金额
    ,otf_fee -- 手续费
    ,otf_sysid -- 系统编号，如NMB,NPB,OGW
    ,otf_sourcesysid -- 源系统编号，如NMB,NPB,OGW
    ,otf_channelcode -- 4位渠道码
    ,otf_state -- 交易状态(90:操作成功;99:操作失败;33:结果未明;)
    ,otf_returncode -- 交易错误代码
    ,otf_returnmsg -- 交易错误原因
    ,otf_hostflowno -- 核心交易流水号
    ,otf_host_returntime -- 核心交易日期
    ,otf_accessflowno -- 访问流水号
    ,otf_relflowno -- 关联流水号
    ,otf_serverip -- 处理服务器IP
    ,otf_sessionid -- 登陆SESSIONID
    ,otf_accesstoken -- 分步交易TOKEN，例如网银预订单的TOKEN；二类户开户分步交易中使用的TOKEN
    ,otf_trade_abstract -- 例如：“您发起了一笔转账，付款账号尾数为XXX，金额为YYY，收款账号为ZZZ”。
    ,otf_trstype -- 交易类型：网银操作日志查询场景使用
    ,otf_menuid -- 功能菜单ID：网银操作日志查询场景使用
    ,otf_clientip -- 客户端IP
    ,otf_clientmac -- 客户端MAC
    ,otf_deviceno -- 设备号
    ,otf_brand -- 设备品牌
    ,otf_model -- 设备型号
    ,otf_browsertype -- 浏览器类型
    ,otf_browserversion -- 浏览器版本号
    ,otf_longitude -- 经度
    ,otf_latitude -- 维度
    ,otf_tellerid -- 柜员号
    ,otf_tellerdeptid -- 柜员所属机构
    ,otf_reqtime -- 交易请求时间(yyyyMMddhhmmss)
    ,otf_resptime -- 交易响应时间(yyyyMMddhhmmss)
    ,otf_logthreadno -- 日志线程号
    ,otf_moveflag -- 迁移标识
    ,otf_fingerprint_id -- 设备指纹
    ,tx_seq_num -- 交易订单号
    ,chain_way_track_no -- 链路跟踪号
    ,biz_seq_num -- 系统内流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    otf_trade_flowno -- 主流水号
    ,otf_tran_seqno -- 交易流水号
    ,otf_global_seqno -- 全局流水号
    ,otf_ecifno -- 全行统一客户号
    ,otf_ecifname -- 客户姓名
    ,otf_userno -- 用户顺序号
    ,otf_transcode -- 交易代码
    ,otf_transcategory -- 业务大类
    ,otf_transtype -- 业务类型
    ,otf_transdate -- 交易日期
    ,otf_transtime -- 交易时间
    ,otf_accno -- 交易账号
    ,otf_currency -- 交易币种
    ,otf_amonut -- 交易金额
    ,otf_fee -- 手续费
    ,otf_sysid -- 系统编号，如NMB,NPB,OGW
    ,otf_sourcesysid -- 源系统编号，如NMB,NPB,OGW
    ,otf_channelcode -- 4位渠道码
    ,otf_state -- 交易状态(90:操作成功;99:操作失败;33:结果未明;)
    ,otf_returncode -- 交易错误代码
    ,otf_returnmsg -- 交易错误原因
    ,otf_hostflowno -- 核心交易流水号
    ,otf_host_returntime -- 核心交易日期
    ,otf_accessflowno -- 访问流水号
    ,otf_relflowno -- 关联流水号
    ,otf_serverip -- 处理服务器IP
    ,otf_sessionid -- 登陆SESSIONID
    ,otf_accesstoken -- 分步交易TOKEN，例如网银预订单的TOKEN；二类户开户分步交易中使用的TOKEN
    ,otf_trade_abstract -- 例如：“您发起了一笔转账，付款账号尾数为XXX，金额为YYY，收款账号为ZZZ”。
    ,otf_trstype -- 交易类型：网银操作日志查询场景使用
    ,otf_menuid -- 功能菜单ID：网银操作日志查询场景使用
    ,otf_clientip -- 客户端IP
    ,otf_clientmac -- 客户端MAC
    ,otf_deviceno -- 设备号
    ,otf_brand -- 设备品牌
    ,otf_model -- 设备型号
    ,otf_browsertype -- 浏览器类型
    ,otf_browserversion -- 浏览器版本号
    ,otf_longitude -- 经度
    ,otf_latitude -- 维度
    ,otf_tellerid -- 柜员号
    ,otf_tellerdeptid -- 柜员所属机构
    ,otf_reqtime -- 交易请求时间(yyyyMMddhhmmss)
    ,otf_resptime -- 交易响应时间(yyyyMMddhhmmss)
    ,otf_logthreadno -- 日志线程号
    ,otf_moveflag -- 迁移标识
    ,otf_fingerprint_id -- 设备指纹
    ,tx_seq_num -- 交易订单号
    ,chain_way_track_no -- 链路跟踪号
    ,biz_seq_num -- 系统内流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.osbs_ops_trade_flow
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.osbs_ops_trade_flow exchange partition p_${batch_date} with table ${iol_schema}.osbs_ops_trade_flow_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_ops_trade_flow to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.osbs_ops_trade_flow_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_ops_trade_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);