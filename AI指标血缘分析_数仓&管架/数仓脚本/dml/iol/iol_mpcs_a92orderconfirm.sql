/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a92orderconfirm
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
drop table ${iol_schema}.mpcs_a92orderconfirm_ex purge;
alter table ${iol_schema}.mpcs_a92orderconfirm add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a92orderconfirm truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a92orderconfirm_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a92orderconfirm where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a92orderconfirm_ex(
    filena -- 文件名
    ,dtlseqid -- 序号
    ,brokeruserid -- 用户账户ID
    ,accountid -- 盈米账户ID
    ,brokerorderno -- 订单流水号
    ,orderid -- 盈米订单号
    ,paymentmethodid -- 支付方式ID
    ,ordercreatedon -- 下单时间
    ,ordertradedate -- 订单交易日
    ,orderconfirmdate -- 订单确认日
    ,fundcode -- 基金代码
    ,sharetype -- 收费类型A-前端收费  B-后端收费 C-C类收费
    ,busitype -- 业务类型022-申购020-认购024-赎回036-转换039-定投申购029-修改分红方式134-非交易过户转入确认135-非交易过户转出确认142-强制赎回144-强行调增145-强行调减
    ,destfundcode -- 转入基金代码
    ,destsharetype -- 转入基金收费类型
    ,tradeamount -- 申请金额
    ,tradeshare -- 申请份额
    ,tradestat -- 支付状态
    ,confirmstat -- 确认状态
    ,orderdetail -- 订单详情
    ,succamount -- 成功金额
    ,succshare -- 成功份额
    ,succinamount -- 转入成功金额
    ,succinshare -- 转入成功份额
    ,totfee -- 总手续费
    ,taconfirmid -- TA确认流水号
    ,pocode -- 组合代码
    ,errmsg -- 错误信息
    ,accountdate -- 资金到账日期
    ,tradenav -- 成交净值
    ,destnav -- 目标基金成交净值
    ,status -- 状态
    ,reserve1 -- 备用字段1
    ,reserve2 -- 备用字段2
    ,reserve3 -- 备用字段3
    ,reserve4 -- 备用字段4
    ,reserve5 -- 备用字段5
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    filena -- 文件名
    ,dtlseqid -- 序号
    ,brokeruserid -- 用户账户ID
    ,accountid -- 盈米账户ID
    ,brokerorderno -- 订单流水号
    ,orderid -- 盈米订单号
    ,paymentmethodid -- 支付方式ID
    ,ordercreatedon -- 下单时间
    ,ordertradedate -- 订单交易日
    ,orderconfirmdate -- 订单确认日
    ,fundcode -- 基金代码
    ,sharetype -- 收费类型A-前端收费  B-后端收费 C-C类收费
    ,busitype -- 业务类型022-申购020-认购024-赎回036-转换039-定投申购029-修改分红方式134-非交易过户转入确认135-非交易过户转出确认142-强制赎回144-强行调增145-强行调减
    ,destfundcode -- 转入基金代码
    ,destsharetype -- 转入基金收费类型
    ,tradeamount -- 申请金额
    ,tradeshare -- 申请份额
    ,tradestat -- 支付状态
    ,confirmstat -- 确认状态
    ,orderdetail -- 订单详情
    ,succamount -- 成功金额
    ,succshare -- 成功份额
    ,succinamount -- 转入成功金额
    ,succinshare -- 转入成功份额
    ,totfee -- 总手续费
    ,taconfirmid -- TA确认流水号
    ,pocode -- 组合代码
    ,errmsg -- 错误信息
    ,accountdate -- 资金到账日期
    ,tradenav -- 成交净值
    ,destnav -- 目标基金成交净值
    ,status -- 状态
    ,reserve1 -- 备用字段1
    ,reserve2 -- 备用字段2
    ,reserve3 -- 备用字段3
    ,reserve4 -- 备用字段4
    ,reserve5 -- 备用字段5
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a92orderconfirm
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a92orderconfirm exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a92orderconfirm_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a92orderconfirm to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a92orderconfirm_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a92orderconfirm',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);