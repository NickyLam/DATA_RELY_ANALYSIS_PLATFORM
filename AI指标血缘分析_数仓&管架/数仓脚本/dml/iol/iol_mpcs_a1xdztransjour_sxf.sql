/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1xdztransjour_sxf
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
drop table ${iol_schema}.mpcs_a1xdztransjour_sxf_ex purge;
alter table ${iol_schema}.mpcs_a1xdztransjour_sxf add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a1xdztransjour_sxf truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a1xdztransjour_sxf_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1xdztransjour_sxf where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a1xdztransjour_sxf_ex(
    transdate -- 清算日期
    ,keyid -- 流水唯一KEY
    ,accptrid -- 商户编号
    ,orderid -- 商户交易流水号
    ,payno -- 平台交易流水号
    ,transtime -- 交易时间
    ,productno -- 产品 ONFC-线上外卡
    ,paycategory -- 交易类型 SALE：消费 REFUND：退款
    ,paychannel -- 支付渠道 international_card：国际卡
    ,paytype -- 支付方式 card_entry：银行卡
    ,currency -- 订单币种
    ,amount -- 订单金额
    ,paycurrency -- 本地币种
    ,payamount -- 本地金额
    ,payfee -- 本地商户手续费(收)
    ,payfeerate -- 交易手续费率(%)
    ,discountamount -- 优惠金额
    ,refundamount -- 已退款金额
    ,refundfee -- 本地已退款商户手续费(返)
    ,szltflag -- 是否收支两条线标识 00：是 01：否
    ,szltrecfeeamt -- 后收手续费
    ,cappingfee -- 银联二维码1000以上借记卡手续费封顶值
    ,oriorderid -- 原商户交易流水号
    ,oripayno -- 原平台交易流水号
    ,priacct -- 卡号(脱敏)
    ,drtype -- 借贷标识 1：借记卡 2：贷记卡 3：其他
    ,oversea -- 境内外标识
    ,cardorg -- 卡组织 01：VISA卡 02：万事达卡 03：美运卡
    ,sncode -- 设备SN
    ,storeno -- 平台门店编号
    ,auth3ds -- 是否3DS 01：是 00：否
    ,status -- 对账标识 0-未对过账 1-已对过账 N-正常交易 C-交易被撤销 R-交易被冲正
    ,remakr1 -- 备用1
    ,remakr2 -- 备用2
    ,remakr3 -- 备用3
    ,remakr4 -- 备用4
    ,remakr5 -- 备用5
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    transdate -- 清算日期
    ,keyid -- 流水唯一KEY
    ,accptrid -- 商户编号
    ,orderid -- 商户交易流水号
    ,payno -- 平台交易流水号
    ,transtime -- 交易时间
    ,productno -- 产品 ONFC-线上外卡
    ,paycategory -- 交易类型 SALE：消费 REFUND：退款
    ,paychannel -- 支付渠道 international_card：国际卡
    ,paytype -- 支付方式 card_entry：银行卡
    ,currency -- 订单币种
    ,amount -- 订单金额
    ,paycurrency -- 本地币种
    ,payamount -- 本地金额
    ,payfee -- 本地商户手续费(收)
    ,payfeerate -- 交易手续费率(%)
    ,discountamount -- 优惠金额
    ,refundamount -- 已退款金额
    ,refundfee -- 本地已退款商户手续费(返)
    ,szltflag -- 是否收支两条线标识 00：是 01：否
    ,szltrecfeeamt -- 后收手续费
    ,cappingfee -- 银联二维码1000以上借记卡手续费封顶值
    ,oriorderid -- 原商户交易流水号
    ,oripayno -- 原平台交易流水号
    ,priacct -- 卡号(脱敏)
    ,drtype -- 借贷标识 1：借记卡 2：贷记卡 3：其他
    ,oversea -- 境内外标识
    ,cardorg -- 卡组织 01：VISA卡 02：万事达卡 03：美运卡
    ,sncode -- 设备SN
    ,storeno -- 平台门店编号
    ,auth3ds -- 是否3DS 01：是 00：否
    ,status -- 对账标识 0-未对过账 1-已对过账 N-正常交易 C-交易被撤销 R-交易被冲正
    ,remakr1 -- 备用1
    ,remakr2 -- 备用2
    ,remakr3 -- 备用3
    ,remakr4 -- 备用4
    ,remakr5 -- 备用5
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a1xdztransjour_sxf
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a1xdztransjour_sxf exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a1xdztransjour_sxf_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1xdztransjour_sxf to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a1xdztransjour_sxf_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1xdztransjour_sxf',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);