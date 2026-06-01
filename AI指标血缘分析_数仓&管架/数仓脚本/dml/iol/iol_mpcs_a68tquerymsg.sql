/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a68tquerymsg
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
drop table ${iol_schema}.mpcs_a68tquerymsg_ex purge;
alter table ${iol_schema}.mpcs_a68tquerymsg add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.mpcs_a68tquerymsg;

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a68tquerymsg_ex nologging
compress
as
select * from ${iol_schema}.mpcs_a68tquerymsg where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a68tquerymsg_ex(
    mainseq -- 行内中台流水号
    ,transdt -- 交易日期
    ,cnsdt -- 委托日期  委托日期（登记人行日期）
    ,txid -- 退回申请号  报文标识号
    ,txtpcd -- 业务类型
    ,instgpty -- 发起参与机构  发起直接参与机构号
    ,instdpty -- 接收参与机构  接收直接参与机构号
    ,sndbrn -- 发起行行号
    ,iotype -- 往来标志
    ,qrytp -- 查询方式  0:单笔查询 1: 批量单笔查询
    ,status -- 处理状态
    ,payacct -- 付款人账号
    ,payname -- 付款人名称
    ,rcvacct -- 收款人账号
    ,rcvname -- 收款人名称
    ,orgnlcnsdt -- 原委托日期
    ,orgnltxtpcd -- 原业务类型
    ,orgnltxid -- 原支付交易序号  原报文标识号
    ,orgnlinstgpty -- 原发起方参与机构  委托机构
    ,orgnltransamt -- 原交易金额
    ,orgnlcrcycd -- 原币种
    ,orgnldttxid -- 原明细标识号
    ,orgnldttransamt -- 原明细金额
    ,orgnldtcrcycd -- 原明细币种
    ,sndtlr -- 发送柜员
    ,magebrn -- 处理机构
    ,dotime -- 发送日期  中台日期
    ,reqtime -- 申请时间
    ,rettime -- 应答时间
    ,rspcnsdt -- 应答日期
    ,rsptxid -- 应答标识号
    ,rspinstgpty -- 应答委托参与机构
    ,rspinstdpty -- 应答接收参与机构
    ,sts -- 中心返回状态
    ,rspncd -- 中心返回码
    ,rspninf -- 中心返回信息
    ,rtncd -- 银行返回码
    ,rtninf -- 银行返回信息
    ,info -- 附言
    ,info2 -- 附言2
    ,sndbrnname -- 付款行行名
    ,rcvbrnname -- 收款行行名
    ,sndbrnnm -- 发起行行名
    ,dbtrid -- 付款行行行号
    ,cdtrid -- 收款行行行号
    ,rsptxtpcd -- 应答业务类型
    ,rspsndbrn -- 应答发起行
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    mainseq -- 行内中台流水号
    ,transdt -- 交易日期
    ,cnsdt -- 委托日期  委托日期（登记人行日期）
    ,txid -- 退回申请号  报文标识号
    ,txtpcd -- 业务类型
    ,instgpty -- 发起参与机构  发起直接参与机构号
    ,instdpty -- 接收参与机构  接收直接参与机构号
    ,sndbrn -- 发起行行号
    ,iotype -- 往来标志
    ,qrytp -- 查询方式  0:单笔查询 1: 批量单笔查询
    ,status -- 处理状态
    ,payacct -- 付款人账号
    ,payname -- 付款人名称
    ,rcvacct -- 收款人账号
    ,rcvname -- 收款人名称
    ,orgnlcnsdt -- 原委托日期
    ,orgnltxtpcd -- 原业务类型
    ,orgnltxid -- 原支付交易序号  原报文标识号
    ,orgnlinstgpty -- 原发起方参与机构  委托机构
    ,orgnltransamt -- 原交易金额
    ,orgnlcrcycd -- 原币种
    ,orgnldttxid -- 原明细标识号
    ,orgnldttransamt -- 原明细金额
    ,orgnldtcrcycd -- 原明细币种
    ,sndtlr -- 发送柜员
    ,magebrn -- 处理机构
    ,dotime -- 发送日期  中台日期
    ,reqtime -- 申请时间
    ,rettime -- 应答时间
    ,rspcnsdt -- 应答日期
    ,rsptxid -- 应答标识号
    ,rspinstgpty -- 应答委托参与机构
    ,rspinstdpty -- 应答接收参与机构
    ,sts -- 中心返回状态
    ,rspncd -- 中心返回码
    ,rspninf -- 中心返回信息
    ,rtncd -- 银行返回码
    ,rtninf -- 银行返回信息
    ,info -- 附言
    ,info2 -- 附言2
    ,sndbrnname -- 付款行行名
    ,rcvbrnname -- 收款行行名
    ,sndbrnnm -- 发起行行名
    ,dbtrid -- 付款行行行号
    ,cdtrid -- 收款行行行号
    ,rsptxtpcd -- 应答业务类型
    ,rspsndbrn -- 应答发起行
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a68tquerymsg
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a68tquerymsg exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a68tquerymsg_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a68tquerymsg to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a68tquerymsg_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a68tquerymsg',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);