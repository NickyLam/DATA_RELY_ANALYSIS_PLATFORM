/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ccdb_log_tran_com_money
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
create table ${iol_schema}.ccdb_log_tran_com_money_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ccdb_log_tran_com_money;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ccdb_log_tran_com_money_op purge;
drop table ${iol_schema}.ccdb_log_tran_com_money_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ccdb_log_tran_com_money_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.ccdb_log_tran_com_money where 0=1;

create table ${iol_schema}.ccdb_log_tran_com_money_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.ccdb_log_tran_com_money where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.ccdb_log_tran_com_money_op(
        code -- 主键
        ,connect_id -- 呼叫流水号
        ,call_no -- 呼入号码
        ,channel_code -- 渠道编码（c/i）
        ,tran_code -- 交易码
        ,trans_date -- 交易时间
        ,permission_code -- 功能编号
        ,return_code -- 返回码
        ,return_message -- 返回信息
        ,cust_name -- 客户姓名
        ,card_no -- 转出账号
        ,open_bank_code -- 转出开户行
        ,open_bank_name -- 转出转出开户行名
        ,to_card_no -- 转入账号
        ,to_cust_name -- 转入方户名
        ,to_open_bank_code -- 转入开户行号
        ,to_open_bank_name -- 转入开户行名
        ,trans_type -- 转账方式（1实时，2普通，3次日转账4加急实时）
        ,trans_money -- 交易金额
        ,trans_free -- 手续费
        ,currency -- 币种
        ,trans_channel -- 大小额渠道（ibps实时，beps小额，hvps加急实时debit_card借记卡）
        ,deposit_name -- 存期
        ,transfer_flag -- 转存标记(0否，1是)
        ,operator_code -- 操作员工号
        ,sign_nework -- 签约网点
        ,deposit_code -- 存期代码
        ,dispost_type -- 储蓄种类
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.code -- 主键
    ,n.connect_id -- 呼叫流水号
    ,n.call_no -- 呼入号码
    ,n.channel_code -- 渠道编码（c/i）
    ,n.tran_code -- 交易码
    ,n.trans_date -- 交易时间
    ,n.permission_code -- 功能编号
    ,n.return_code -- 返回码
    ,n.return_message -- 返回信息
    ,n.cust_name -- 客户姓名
    ,n.card_no -- 转出账号
    ,n.open_bank_code -- 转出开户行
    ,n.open_bank_name -- 转出转出开户行名
    ,n.to_card_no -- 转入账号
    ,n.to_cust_name -- 转入方户名
    ,n.to_open_bank_code -- 转入开户行号
    ,n.to_open_bank_name -- 转入开户行名
    ,n.trans_type -- 转账方式（1实时，2普通，3次日转账4加急实时）
    ,n.trans_money -- 交易金额
    ,n.trans_free -- 手续费
    ,n.currency -- 币种
    ,n.trans_channel -- 大小额渠道（ibps实时，beps小额，hvps加急实时debit_card借记卡）
    ,n.deposit_name -- 存期
    ,n.transfer_flag -- 转存标记(0否，1是)
    ,n.operator_code -- 操作员工号
    ,n.sign_nework -- 签约网点
    ,n.deposit_code -- 存期代码
    ,n.dispost_type -- 储蓄种类
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ccdb_log_tran_com_money_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    right join (select * from ${itl_schema}.ccdb_log_tran_com_money where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.code = n.code
where (
        o.code is null
    )
    or (
        o.connect_id <> n.connect_id
        or o.call_no <> n.call_no
        or o.channel_code <> n.channel_code
        or o.tran_code <> n.tran_code
        or o.trans_date <> n.trans_date
        or o.permission_code <> n.permission_code
        or o.return_code <> n.return_code
        or o.return_message <> n.return_message
        or o.cust_name <> n.cust_name
        or o.card_no <> n.card_no
        or o.open_bank_code <> n.open_bank_code
        or o.open_bank_name <> n.open_bank_name
        or o.to_card_no <> n.to_card_no
        or o.to_cust_name <> n.to_cust_name
        or o.to_open_bank_code <> n.to_open_bank_code
        or o.to_open_bank_name <> n.to_open_bank_name
        or o.trans_type <> n.trans_type
        or o.trans_money <> n.trans_money
        or o.trans_free <> n.trans_free
        or o.currency <> n.currency
        or o.trans_channel <> n.trans_channel
        or o.deposit_name <> n.deposit_name
        or o.transfer_flag <> n.transfer_flag
        or o.operator_code <> n.operator_code
        or o.sign_nework <> n.sign_nework
        or o.deposit_code <> n.deposit_code
        or o.dispost_type <> n.dispost_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ccdb_log_tran_com_money_cl(
            code -- 主键
        ,connect_id -- 呼叫流水号
        ,call_no -- 呼入号码
        ,channel_code -- 渠道编码（c/i）
        ,tran_code -- 交易码
        ,trans_date -- 交易时间
        ,permission_code -- 功能编号
        ,return_code -- 返回码
        ,return_message -- 返回信息
        ,cust_name -- 客户姓名
        ,card_no -- 转出账号
        ,open_bank_code -- 转出开户行
        ,open_bank_name -- 转出转出开户行名
        ,to_card_no -- 转入账号
        ,to_cust_name -- 转入方户名
        ,to_open_bank_code -- 转入开户行号
        ,to_open_bank_name -- 转入开户行名
        ,trans_type -- 转账方式（1实时，2普通，3次日转账4加急实时）
        ,trans_money -- 交易金额
        ,trans_free -- 手续费
        ,currency -- 币种
        ,trans_channel -- 大小额渠道（ibps实时，beps小额，hvps加急实时debit_card借记卡）
        ,deposit_name -- 存期
        ,transfer_flag -- 转存标记(0否，1是)
        ,operator_code -- 操作员工号
        ,sign_nework -- 签约网点
        ,deposit_code -- 存期代码
        ,dispost_type -- 储蓄种类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ccdb_log_tran_com_money_op(
            code -- 主键
        ,connect_id -- 呼叫流水号
        ,call_no -- 呼入号码
        ,channel_code -- 渠道编码（c/i）
        ,tran_code -- 交易码
        ,trans_date -- 交易时间
        ,permission_code -- 功能编号
        ,return_code -- 返回码
        ,return_message -- 返回信息
        ,cust_name -- 客户姓名
        ,card_no -- 转出账号
        ,open_bank_code -- 转出开户行
        ,open_bank_name -- 转出转出开户行名
        ,to_card_no -- 转入账号
        ,to_cust_name -- 转入方户名
        ,to_open_bank_code -- 转入开户行号
        ,to_open_bank_name -- 转入开户行名
        ,trans_type -- 转账方式（1实时，2普通，3次日转账4加急实时）
        ,trans_money -- 交易金额
        ,trans_free -- 手续费
        ,currency -- 币种
        ,trans_channel -- 大小额渠道（ibps实时，beps小额，hvps加急实时debit_card借记卡）
        ,deposit_name -- 存期
        ,transfer_flag -- 转存标记(0否，1是)
        ,operator_code -- 操作员工号
        ,sign_nework -- 签约网点
        ,deposit_code -- 存期代码
        ,dispost_type -- 储蓄种类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.code -- 主键
    ,o.connect_id -- 呼叫流水号
    ,o.call_no -- 呼入号码
    ,o.channel_code -- 渠道编码（c/i）
    ,o.tran_code -- 交易码
    ,o.trans_date -- 交易时间
    ,o.permission_code -- 功能编号
    ,o.return_code -- 返回码
    ,o.return_message -- 返回信息
    ,o.cust_name -- 客户姓名
    ,o.card_no -- 转出账号
    ,o.open_bank_code -- 转出开户行
    ,o.open_bank_name -- 转出转出开户行名
    ,o.to_card_no -- 转入账号
    ,o.to_cust_name -- 转入方户名
    ,o.to_open_bank_code -- 转入开户行号
    ,o.to_open_bank_name -- 转入开户行名
    ,o.trans_type -- 转账方式（1实时，2普通，3次日转账4加急实时）
    ,o.trans_money -- 交易金额
    ,o.trans_free -- 手续费
    ,o.currency -- 币种
    ,o.trans_channel -- 大小额渠道（ibps实时，beps小额，hvps加急实时debit_card借记卡）
    ,o.deposit_name -- 存期
    ,o.transfer_flag -- 转存标记(0否，1是)
    ,o.operator_code -- 操作员工号
    ,o.sign_nework -- 签约网点
    ,o.deposit_code -- 存期代码
    ,o.dispost_type -- 储蓄种类
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
from ${iol_schema}.ccdb_log_tran_com_money_bk o
    left join ${iol_schema}.ccdb_log_tran_com_money_op n
        on
            o.code = n.code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ccdb_log_tran_com_money;

-- 4.2 exchange partition
alter table ${iol_schema}.ccdb_log_tran_com_money exchange partition p_19000101 with table ${iol_schema}.ccdb_log_tran_com_money_cl;
alter table ${iol_schema}.ccdb_log_tran_com_money exchange partition p_20991231 with table ${iol_schema}.ccdb_log_tran_com_money_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ccdb_log_tran_com_money to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ccdb_log_tran_com_money_op purge;
drop table ${iol_schema}.ccdb_log_tran_com_money_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ccdb_log_tran_com_money_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ccdb_log_tran_com_money',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
