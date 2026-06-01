/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icms_bat_repayment
CreateDate: 20250509
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.icms_bat_repayment drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icms_bat_repayment add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icms_bat_repayment (
etl_dt  --数据日期
,serialno  --流水号
,duebillno  --借据号
,transdate  --交易日期
,customerid  --客户编号
,customername  --客户名称
,certtype  --证件类型
,certid  --证件编号
,currency  --币种
,schedulepayment  --应还金额
,actualpayment  --实际还款金额
,payaccountno  --扣款帐号
,payserialno  --还款交易流水号
,paymenttype  --支付方式
,status  --状态
,relaobjecttype  --关联对象类型
,relaobjectno  --关联对象编号
,batserialno  --批次流水号
,transserialno  --交易流水号(核算)
,grouptype  --分组类型;分组类型(code:01-正常数据，02-异常数据-未匹配)
,remark  --备注
,inputuserid  --登记人
,inputorgid  --登记机构
,inputdate  --登记日期
,updateuserid  --更新人
,updateorgid  --更新机构
,updatedate  --更新日期
,completeflag  --完整性标示
,priamt  --实还本金
,intamt  --实还利息
,odpamt  --实还罚息
,odiamt  --实还复利
,remamt  --剩余本金
,stageno  --还款期数
,reasoncode  --代偿标志
,receipttype  --还款类型
,migtflag  --迁移标志：crs rcr ilc upl
,reversal  --冲正标识
,receiptno  --回收单号
,channel  --渠道号
,srcinitsysid  --发起系统

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno --流水号
,replace(replace(t1.duebillno,chr(13),''),chr(10),'') as duebillno --借据号
,t1.transdate as transdate --交易日期
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid --客户编号
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername --客户名称
,replace(replace(t1.certtype,chr(13),''),chr(10),'') as certtype --证件类型
,replace(replace(t1.certid,chr(13),''),chr(10),'') as certid --证件编号
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency --币种
,t1.schedulepayment as schedulepayment --应还金额
,t1.actualpayment as actualpayment --实际还款金额
,replace(replace(t1.payaccountno,chr(13),''),chr(10),'') as payaccountno --扣款帐号
,replace(replace(t1.payserialno,chr(13),''),chr(10),'') as payserialno --还款交易流水号
,replace(replace(t1.paymenttype,chr(13),''),chr(10),'') as paymenttype --支付方式
,replace(replace(t1.status,chr(13),''),chr(10),'') as status --状态
,replace(replace(t1.relaobjecttype,chr(13),''),chr(10),'') as relaobjecttype --关联对象类型
,replace(replace(t1.relaobjectno,chr(13),''),chr(10),'') as relaobjectno --关联对象编号
,replace(replace(t1.batserialno,chr(13),''),chr(10),'') as batserialno --批次流水号
,replace(replace(t1.transserialno,chr(13),''),chr(10),'') as transserialno --交易流水号(核算)
,replace(replace(t1.grouptype,chr(13),''),chr(10),'') as grouptype --分组类型;分组类型(code:01-正常数据，02-异常数据-未匹配)
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark --备注
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid --登记人
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid --登记机构
,t1.inputdate as inputdate --登记日期
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid --更新人
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid --更新机构
,t1.updatedate as updatedate --更新日期
,replace(replace(t1.completeflag,chr(13),''),chr(10),'') as completeflag --完整性标示
,t1.priamt as priamt --实还本金
,t1.intamt as intamt --实还利息
,t1.odpamt as odpamt --实还罚息
,t1.odiamt as odiamt --实还复利
,t1.remamt as remamt --剩余本金
,t1.stageno as stageno --还款期数
,replace(replace(t1.reasoncode,chr(13),''),chr(10),'') as reasoncode --代偿标志
,replace(replace(t1.receipttype,chr(13),''),chr(10),'') as receipttype --还款类型
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag --迁移标志：crs rcr ilc upl
,replace(replace(t1.reversal,chr(13),''),chr(10),'') as reversal --冲正标识
,replace(replace(t1.receiptno,chr(13),''),chr(10),'') as receiptno --回收单号
,replace(replace(t1.channel,chr(13),''),chr(10),'') as channel --渠道号
,replace(replace(t1.srcinitsysid,chr(13),''),chr(10),'') as srcinitsysid --发起系统
from ${iol_schema}.icms_bat_repayment t1    --还款信息表
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icms_bat_repayment',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
