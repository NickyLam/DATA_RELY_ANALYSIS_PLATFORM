/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a50ubtrsamtlimit
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
drop table ${iol_schema}.mpcs_a50ubtrsamtlimit_ex purge;
alter table ${iol_schema}.mpcs_a50ubtrsamtlimit add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.mpcs_a50ubtrsamtlimit;

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a50ubtrsamtlimit_ex nologging
compress
as
select * from ${iol_schema}.mpcs_a50ubtrsamtlimit where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a50ubtrsamtlimit_ex(
    chnlid -- 交易渠道
    ,product -- 产品类型 YLDOI:银联二维码
    ,custno -- 客户号
    ,custname -- 客户名
    ,tokenid -- 虚拟卡号（如云卡）
    ,acctno -- 实体卡账户
    ,acctopbk -- 实体卡所属行号
    ,acctopbkname -- 实体卡所属行行名
    ,accttype -- 实体卡类型 00未知 01借记账户 02贷记账户 03准贷记账户 04借贷合一账户 05预付费账户 06半开放预付费账户
    ,addtime -- 绑卡时间
    ,seqno -- 绑定流水号
    ,onemamt -- 小额免密单笔限额
    ,datemamt -- 小额免密日累计限额
    ,ispwd -- 免密开关 0-验密 1-免密
    ,maxonetamt -- 单笔最大交易限额
    ,maxdatetamt -- 单日累计最大交易限额
    ,maxmonthtamt -- 单月累计最大交易限额
    ,status -- 绑卡状态  0-解绑 1-绑定
    ,ghbflag -- 跨行标志 0-本行 1-他行
    ,tlrno -- 交易柜员
    ,brchno -- 交易机构
    ,issinscode -- 发卡机构代码
    ,ispaycard -- 默认支付卡标志 1-默认支付卡
    ,msggrade -- 数据等级 0-客户级 1-账户级
    ,trid -- 标记请求者id
    ,tokenlevel -- 标记担保级别
    ,tokenbegin -- 标记生效时间
    ,tokenend -- 标记失效时间
    ,tokentype -- 标记类型
    ,updatetime -- 变更时间
    ,updateseq -- 最新更新流水
    ,reserve1 -- 保留域1
    ,reserve2 -- 保留域2
    ,reserve3 -- 保留域3
    ,reserve4 -- 保留域4
    ,reserve5 -- 保留域5
    ,reserve6 -- 保留域6
    ,reserve7 -- 保留域7
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    chnlid -- 交易渠道
    ,product -- 产品类型 YLDOI:银联二维码
    ,custno -- 客户号
    ,custname -- 客户名
    ,tokenid -- 虚拟卡号（如云卡）
    ,acctno -- 实体卡账户
    ,acctopbk -- 实体卡所属行号
    ,acctopbkname -- 实体卡所属行行名
    ,accttype -- 实体卡类型 00未知 01借记账户 02贷记账户 03准贷记账户 04借贷合一账户 05预付费账户 06半开放预付费账户
    ,addtime -- 绑卡时间
    ,seqno -- 绑定流水号
    ,onemamt -- 小额免密单笔限额
    ,datemamt -- 小额免密日累计限额
    ,ispwd -- 免密开关 0-验密 1-免密
    ,maxonetamt -- 单笔最大交易限额
    ,maxdatetamt -- 单日累计最大交易限额
    ,maxmonthtamt -- 单月累计最大交易限额
    ,status -- 绑卡状态  0-解绑 1-绑定
    ,ghbflag -- 跨行标志 0-本行 1-他行
    ,tlrno -- 交易柜员
    ,brchno -- 交易机构
    ,issinscode -- 发卡机构代码
    ,ispaycard -- 默认支付卡标志 1-默认支付卡
    ,msggrade -- 数据等级 0-客户级 1-账户级
    ,trid -- 标记请求者id
    ,tokenlevel -- 标记担保级别
    ,tokenbegin -- 标记生效时间
    ,tokenend -- 标记失效时间
    ,tokentype -- 标记类型
    ,updatetime -- 变更时间
    ,updateseq -- 最新更新流水
    ,reserve1 -- 保留域1
    ,reserve2 -- 保留域2
    ,reserve3 -- 保留域3
    ,reserve4 -- 保留域4
    ,reserve5 -- 保留域5
    ,reserve6 -- 保留域6
    ,reserve7 -- 保留域7
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a50ubtrsamtlimit
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a50ubtrsamtlimit exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a50ubtrsamtlimit_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a50ubtrsamtlimit to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a50ubtrsamtlimit_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a50ubtrsamtlimit',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);