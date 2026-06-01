/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ccdb_log_tran_com
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.ccdb_log_tran_com_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ccdb_log_tran_com;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ccdb_log_tran_com_op purge;
drop table ${iol_schema}.ccdb_log_tran_com_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ccdb_log_tran_com_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.ccdb_log_tran_com where 0=1;

create table ${iol_schema}.ccdb_log_tran_com_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.ccdb_log_tran_com where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.ccdb_log_tran_com_op(
        trans_service_id -- 服务流水号
        ,cc_jour_seq -- 渠道请求流水号
        ,connect_id -- 呼叫流水号
        ,tran_code -- 交易码
        ,host_tran_code -- 主机交易码（前置）
        ,return_code -- 返回码
        ,trunk_id -- 中继接入号
        ,paper_id -- 证件号
        ,paper_type -- 证件类型
        ,card_no -- 账号
        ,card_type -- 账号类型
        ,currency -- 币种
        ,call_no -- 呼入号码
        ,operator_code -- 操作员工号
        ,cust_name -- 客户姓名
        ,channel_code -- 渠道编码（c/i）
        ,ivr_line_no -- ivr通道号
        ,channel_send_date -- 渠道开始代理日期
        ,trans_date -- 交易时间
        ,permission_code -- 功能编号
        ,return_message -- 返回信息
        ,host_return_code -- 主机返回码
        ,host_return_message -- 主机返回信息
        ,business_type -- 业务类型（信用卡、个人、对公等）
        ,service_sign -- 服务标识  1：查询，2：操作，0：自动
        ,sum_no -- 来电小结编号
        ,aexpinfo -- 附加信息
        ,cust_type -- 客户类型
        ,code -- 主键
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.trans_service_id -- 服务流水号
    ,n.cc_jour_seq -- 渠道请求流水号
    ,n.connect_id -- 呼叫流水号
    ,n.tran_code -- 交易码
    ,n.host_tran_code -- 主机交易码（前置）
    ,n.return_code -- 返回码
    ,n.trunk_id -- 中继接入号
    ,n.paper_id -- 证件号
    ,n.paper_type -- 证件类型
    ,n.card_no -- 账号
    ,n.card_type -- 账号类型
    ,n.currency -- 币种
    ,n.call_no -- 呼入号码
    ,n.operator_code -- 操作员工号
    ,n.cust_name -- 客户姓名
    ,n.channel_code -- 渠道编码（c/i）
    ,n.ivr_line_no -- ivr通道号
    ,n.channel_send_date -- 渠道开始代理日期
    ,n.trans_date -- 交易时间
    ,n.permission_code -- 功能编号
    ,n.return_message -- 返回信息
    ,n.host_return_code -- 主机返回码
    ,n.host_return_message -- 主机返回信息
    ,n.business_type -- 业务类型（信用卡、个人、对公等）
    ,n.service_sign -- 服务标识  1：查询，2：操作，0：自动
    ,n.sum_no -- 来电小结编号
    ,n.aexpinfo -- 附加信息
    ,n.cust_type -- 客户类型
    ,n.code -- 主键
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ccdb_log_tran_com_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    right join (select * from ${itl_schema}.ccdb_log_tran_com where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.code = n.code
where (
        o.code is null
    )
    or (
        o.trans_service_id <> n.trans_service_id
        or o.cc_jour_seq <> n.cc_jour_seq
        or o.connect_id <> n.connect_id
        or o.tran_code <> n.tran_code
        or o.host_tran_code <> n.host_tran_code
        or o.return_code <> n.return_code
        or o.trunk_id <> n.trunk_id
        or o.paper_id <> n.paper_id
        or o.paper_type <> n.paper_type
        or o.card_no <> n.card_no
        or o.card_type <> n.card_type
        or o.currency <> n.currency
        or o.call_no <> n.call_no
        or o.operator_code <> n.operator_code
        or o.cust_name <> n.cust_name
        or o.channel_code <> n.channel_code
        or o.ivr_line_no <> n.ivr_line_no
        or o.channel_send_date <> n.channel_send_date
        or o.trans_date <> n.trans_date
        or o.permission_code <> n.permission_code
        or o.return_message <> n.return_message
        or o.host_return_code <> n.host_return_code
        or o.host_return_message <> n.host_return_message
        or o.business_type <> n.business_type
        or o.service_sign <> n.service_sign
        or o.sum_no <> n.sum_no
        or o.aexpinfo <> n.aexpinfo
        or o.cust_type <> n.cust_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ccdb_log_tran_com_cl(
            trans_service_id -- 服务流水号
        ,cc_jour_seq -- 渠道请求流水号
        ,connect_id -- 呼叫流水号
        ,tran_code -- 交易码
        ,host_tran_code -- 主机交易码（前置）
        ,return_code -- 返回码
        ,trunk_id -- 中继接入号
        ,paper_id -- 证件号
        ,paper_type -- 证件类型
        ,card_no -- 账号
        ,card_type -- 账号类型
        ,currency -- 币种
        ,call_no -- 呼入号码
        ,operator_code -- 操作员工号
        ,cust_name -- 客户姓名
        ,channel_code -- 渠道编码（c/i）
        ,ivr_line_no -- ivr通道号
        ,channel_send_date -- 渠道开始代理日期
        ,trans_date -- 交易时间
        ,permission_code -- 功能编号
        ,return_message -- 返回信息
        ,host_return_code -- 主机返回码
        ,host_return_message -- 主机返回信息
        ,business_type -- 业务类型（信用卡、个人、对公等）
        ,service_sign -- 服务标识  1：查询，2：操作，0：自动
        ,sum_no -- 来电小结编号
        ,aexpinfo -- 附加信息
        ,cust_type -- 客户类型
        ,code -- 主键
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ccdb_log_tran_com_op(
            trans_service_id -- 服务流水号
        ,cc_jour_seq -- 渠道请求流水号
        ,connect_id -- 呼叫流水号
        ,tran_code -- 交易码
        ,host_tran_code -- 主机交易码（前置）
        ,return_code -- 返回码
        ,trunk_id -- 中继接入号
        ,paper_id -- 证件号
        ,paper_type -- 证件类型
        ,card_no -- 账号
        ,card_type -- 账号类型
        ,currency -- 币种
        ,call_no -- 呼入号码
        ,operator_code -- 操作员工号
        ,cust_name -- 客户姓名
        ,channel_code -- 渠道编码（c/i）
        ,ivr_line_no -- ivr通道号
        ,channel_send_date -- 渠道开始代理日期
        ,trans_date -- 交易时间
        ,permission_code -- 功能编号
        ,return_message -- 返回信息
        ,host_return_code -- 主机返回码
        ,host_return_message -- 主机返回信息
        ,business_type -- 业务类型（信用卡、个人、对公等）
        ,service_sign -- 服务标识  1：查询，2：操作，0：自动
        ,sum_no -- 来电小结编号
        ,aexpinfo -- 附加信息
        ,cust_type -- 客户类型
        ,code -- 主键
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.trans_service_id -- 服务流水号
    ,o.cc_jour_seq -- 渠道请求流水号
    ,o.connect_id -- 呼叫流水号
    ,o.tran_code -- 交易码
    ,o.host_tran_code -- 主机交易码（前置）
    ,o.return_code -- 返回码
    ,o.trunk_id -- 中继接入号
    ,o.paper_id -- 证件号
    ,o.paper_type -- 证件类型
    ,o.card_no -- 账号
    ,o.card_type -- 账号类型
    ,o.currency -- 币种
    ,o.call_no -- 呼入号码
    ,o.operator_code -- 操作员工号
    ,o.cust_name -- 客户姓名
    ,o.channel_code -- 渠道编码（c/i）
    ,o.ivr_line_no -- ivr通道号
    ,o.channel_send_date -- 渠道开始代理日期
    ,o.trans_date -- 交易时间
    ,o.permission_code -- 功能编号
    ,o.return_message -- 返回信息
    ,o.host_return_code -- 主机返回码
    ,o.host_return_message -- 主机返回信息
    ,o.business_type -- 业务类型（信用卡、个人、对公等）
    ,o.service_sign -- 服务标识  1：查询，2：操作，0：自动
    ,o.sum_no -- 来电小结编号
    ,o.aexpinfo -- 附加信息
    ,o.cust_type -- 客户类型
    ,o.code -- 主键
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ccdb_log_tran_com_bk o
    left join ${iol_schema}.ccdb_log_tran_com_op n
        on
            o.code = n.code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ccdb_log_tran_com;

-- 4.2 exchange partition
alter table ${iol_schema}.ccdb_log_tran_com exchange partition p_19000101 with table ${iol_schema}.ccdb_log_tran_com_cl;
alter table ${iol_schema}.ccdb_log_tran_com exchange partition p_20991231 with table ${iol_schema}.ccdb_log_tran_com_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ccdb_log_tran_com to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ccdb_log_tran_com_op purge;
drop table ${iol_schema}.ccdb_log_tran_com_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ccdb_log_tran_com_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ccdb_log_tran_com',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
