/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a89transjour
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
drop table ${iol_schema}.mpcs_a89transjour_ex purge;
alter table ${iol_schema}.mpcs_a89transjour add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.mpcs_a89transjour;

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a89transjour_ex nologging
compress
as
select * from ${iol_schema}.mpcs_a89transjour where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a89transjour_ex(
    srcseqno -- 前端请求流水号
    ,trmseqnum -- 终端交易流水号
    ,transcode -- 光大交易码
    ,trncd -- 中台交易码
    ,transdate -- 交易日期
    ,transtime -- 交易时间
    ,paysys -- 商户简称
    ,instid -- 商户机构号
    ,channel -- 请求渠道号
    ,version -- 版本号
    ,billkey -- 机表号
    ,companyid -- 收费单位标示号
    ,billno -- 缴费单的流水号
    ,paydate -- 缴费单支付日期
    ,beginnum -- 起始笔数
    ,querynum -- 查询笔数
    ,filed1 -- 备用字段Input2
    ,filed2 -- 备用字段Input3
    ,filed3 -- 备用字段Item1
    ,filed4 -- 备用字段Item2
    ,customername -- 客户姓名
    ,payaccount -- 缴费账号
    ,pin -- 卡密码
    ,payamount -- 缴费金额
    ,feeamount -- 手续费
    ,actype -- 账户类型
    ,contractno -- 合同号
    ,workcode -- 核心交易码
    ,payeracct -- 转出方账户
    ,payername -- 转出方户名
    ,payeropbk -- 转出方行号
    ,payeeacct -- 转入方账户
    ,payeename -- 转入方户名
    ,payeeopbk -- 转入方行号
    ,ccy -- 币种
    ,cbstrace -- 核心记账请求流水号
    ,settldate -- 清算日期
    ,dataid -- 中台记账标识号
    ,status -- 交易状态：0-初始；1-核心记账成功；2-核心记账失败;3-已冲正;4-光大记账成功;5-核心超时;6-请求光大成功;7-请求光大失败；8-冲正超时
    ,czflg -- 冲正状态：0-未知/超时；1-冲正成功；2-冲正失败
    ,tzflg -- 交易标志：0-联机交易，1-调账交易，2-退款交易
    ,rspcode -- 中台应前端返回码
    ,rspmsg -- 中台应前端返回信息
    ,hostdate -- 核心返回交易日期
    ,hosttrace -- 核心返回交易流水
    ,resseqno -- 甲方异步应答流水号
    ,bankbillno -- 光大银行端处理流水
    ,receiptno -- 打印凭证号码
    ,acctdate -- 银行端帐务日期
    ,errorcode -- 错误代码
    ,errormessage -- 错误描述
    ,errordetail -- 详细错误信息
    ,czsystrace -- 冲正中台流水号
    ,czhostdate -- 冲正核心返回交易日期
    ,czhostnbr -- 冲正核心返回交易流水
    ,totalnum -- 总笔数
    ,item1 -- 备用字段Output2
    ,item2 -- 备用字段Output3
    ,item3 -- 备用字段Item1
    ,item4 -- 备用字段Item2
    ,item5 -- 备用字段Item3
    ,item6 -- 备用字段Item4
    ,item7 -- 备用字段Item5
    ,reserve1 -- 保留域1
    ,reserve2 -- 保留域2
    ,reserve3 -- 保留域3
    ,reserve4 -- 保留域4
    ,reserve5 -- 保留域5
    ,reserve6 -- 
    ,reserve7 -- 
    ,reserve8 -- 
    ,reserve9 -- 
    ,reserve10 -- 
    ,checkflag -- 对账标志 是否已对账：N:否(初始)，Y：是
    ,itemname -- 缴费项目名称
    ,company -- 收费事业单位名称
    ,customno -- 客户号
    ,busiid -- 缴费种类
    ,cityno -- 缴费地区，999-全国，广东省-000
    ,cityname -- 缴费地区名称
    ,balance -- 余额
    ,begindate -- 起始日期
    ,enddate -- 截至日期
    ,qbirfiled1 -- 查询应答备用字段
    ,qbirfiled2 -- 查询应答备用字段
    ,qbirfiled3 -- 查询应答备用字段
    ,qbirfiled4 -- 查询应答备用字段
    ,qbirfiled5 -- 查询应答备用字段
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    srcseqno -- 前端请求流水号
    ,trmseqnum -- 终端交易流水号
    ,transcode -- 光大交易码
    ,trncd -- 中台交易码
    ,transdate -- 交易日期
    ,transtime -- 交易时间
    ,paysys -- 商户简称
    ,instid -- 商户机构号
    ,channel -- 请求渠道号
    ,version -- 版本号
    ,billkey -- 机表号
    ,companyid -- 收费单位标示号
    ,billno -- 缴费单的流水号
    ,paydate -- 缴费单支付日期
    ,beginnum -- 起始笔数
    ,querynum -- 查询笔数
    ,filed1 -- 备用字段Input2
    ,filed2 -- 备用字段Input3
    ,filed3 -- 备用字段Item1
    ,filed4 -- 备用字段Item2
    ,customername -- 客户姓名
    ,payaccount -- 缴费账号
    ,pin -- 卡密码
    ,payamount -- 缴费金额
    ,feeamount -- 手续费
    ,actype -- 账户类型
    ,contractno -- 合同号
    ,workcode -- 核心交易码
    ,payeracct -- 转出方账户
    ,payername -- 转出方户名
    ,payeropbk -- 转出方行号
    ,payeeacct -- 转入方账户
    ,payeename -- 转入方户名
    ,payeeopbk -- 转入方行号
    ,ccy -- 币种
    ,cbstrace -- 核心记账请求流水号
    ,settldate -- 清算日期
    ,dataid -- 中台记账标识号
    ,status -- 交易状态：0-初始；1-核心记账成功；2-核心记账失败;3-已冲正;4-光大记账成功;5-核心超时;6-请求光大成功;7-请求光大失败；8-冲正超时
    ,czflg -- 冲正状态：0-未知/超时；1-冲正成功；2-冲正失败
    ,tzflg -- 交易标志：0-联机交易，1-调账交易，2-退款交易
    ,rspcode -- 中台应前端返回码
    ,rspmsg -- 中台应前端返回信息
    ,hostdate -- 核心返回交易日期
    ,hosttrace -- 核心返回交易流水
    ,resseqno -- 甲方异步应答流水号
    ,bankbillno -- 光大银行端处理流水
    ,receiptno -- 打印凭证号码
    ,acctdate -- 银行端帐务日期
    ,errorcode -- 错误代码
    ,errormessage -- 错误描述
    ,errordetail -- 详细错误信息
    ,czsystrace -- 冲正中台流水号
    ,czhostdate -- 冲正核心返回交易日期
    ,czhostnbr -- 冲正核心返回交易流水
    ,totalnum -- 总笔数
    ,item1 -- 备用字段Output2
    ,item2 -- 备用字段Output3
    ,item3 -- 备用字段Item1
    ,item4 -- 备用字段Item2
    ,item5 -- 备用字段Item3
    ,item6 -- 备用字段Item4
    ,item7 -- 备用字段Item5
    ,reserve1 -- 保留域1
    ,reserve2 -- 保留域2
    ,reserve3 -- 保留域3
    ,reserve4 -- 保留域4
    ,reserve5 -- 保留域5
    ,reserve6 -- 
    ,reserve7 -- 
    ,reserve8 -- 
    ,reserve9 -- 
    ,reserve10 -- 
    ,checkflag -- 对账标志 是否已对账：N:否(初始)，Y：是
    ,itemname -- 缴费项目名称
    ,company -- 收费事业单位名称
    ,customno -- 客户号
    ,busiid -- 缴费种类
    ,cityno -- 缴费地区，999-全国，广东省-000
    ,cityname -- 缴费地区名称
    ,balance -- 余额
    ,begindate -- 起始日期
    ,enddate -- 截至日期
    ,qbirfiled1 -- 查询应答备用字段
    ,qbirfiled2 -- 查询应答备用字段
    ,qbirfiled3 -- 查询应答备用字段
    ,qbirfiled4 -- 查询应答备用字段
    ,qbirfiled5 -- 查询应答备用字段
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a89transjour
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a89transjour exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a89transjour_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a89transjour to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a89transjour_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a89transjour',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);