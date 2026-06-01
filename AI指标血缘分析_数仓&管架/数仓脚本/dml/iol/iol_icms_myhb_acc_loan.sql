/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_myhb_acc_loan
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.icms_myhb_acc_loan_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_myhb_acc_loan
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_myhb_acc_loan_op purge;
drop table ${iol_schema}.icms_myhb_acc_loan_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_myhb_acc_loan_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.icms_myhb_acc_loan where 0=1;

create table ${iol_schema}.icms_myhb_acc_loan_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.icms_myhb_acc_loan where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.icms_myhb_acc_loan_op(
        billno -- 借据号
        ,isbankrel -- 是否关联人1是2否
        ,ratetype -- 利率类型
        ,agreementno -- 贷款合同号
        ,settledate -- 会计日期
        ,ovdprinbal -- 逾期本金余额
        ,floatratebp -- 利率浮动点差BP
        ,ratelprtype -- lpr利率类型
        ,prinrepayfrequency -- 本金还款频率
        ,intrepayfrequency -- 利息还款频率
        ,encashaccttype -- 收款帐号类型
        ,cleardate -- 结清日期
        ,assetclass -- 五级分类标识
        ,ovdintbal -- 逾期利息余额
        ,creditcode -- 额度类型
        ,applydate -- 申请支用时间
        ,encashamt -- 放款金额
        ,totalterms -- 贷款期次数
        ,migtflag -- 
        ,iswhite -- 是否白户
        ,loanuse -- 贷款用途
        ,repayaccttype -- 还款帐号类型
        ,prinbal -- 正常本金余额
        ,ovdprinpnltbal -- 逾期本金罚息余额
        ,regioncode -- 行政区划代码
        ,certtype -- 证件类型
        ,loanstatus -- 贷款状态
        ,guaranteetype -- 担保类型
        ,applyno -- 贷款申请单号
        ,encashacctnobak -- 收款帐号2
        ,usearea -- 贷款资金使用位置
        ,startdate -- 贷款起息日
        ,graceday -- 宽限期天数
        ,ovdterms -- 逾期期次数
        ,intovddays -- 利息逾期天数
        ,encashacctno -- 收款帐号
        ,writeoff -- 核销标识，已核销为Y，否则为N
        ,prodcode -- 产品码
        ,internaltransfertag -- 内部结转标识
        ,cusmgr -- 客户经理
        ,beginprin -- 贷款原始本金
        ,repayacctnobak -- 还款帐号2
        ,enddate -- 贷款到期日
        ,totalfeerate -- 分期总手续费率
        ,dayrate -- 贷款日利率
        ,assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
        ,intbal -- 正常利息余额
        ,ovdintpnltbal -- 逾期利息罚息余额
        ,ratefloatmode -- 利率浮动方式
        ,currency -- 币种
        ,creditno -- 授信编号
        ,accruedstatus -- 应计非应计标识
        ,contracttype -- 借据类型
        ,certno -- 客户证件号码
        ,cusid -- 客户号
        ,encashdate -- 放款日期
        ,repayacctno -- 还款帐号
        ,status -- 合约状态
        ,lpr -- LPR
        ,name -- 客户真实姓名
        ,repaymode -- 还款方式
        ,prinovddays -- 本金逾期天数
        ,biztype -- 产品编号
        ,fundseqno -- 放款资金流水号
        ,nextrepaydate -- 下一还款日期
        ,unclearterms -- 未结清期数
        ,execrate -- 执行年利率，推送日利率X360
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.billno -- 借据号
    ,n.isbankrel -- 是否关联人1是2否
    ,n.ratetype -- 利率类型
    ,n.agreementno -- 贷款合同号
    ,n.settledate -- 会计日期
    ,n.ovdprinbal -- 逾期本金余额
    ,n.floatratebp -- 利率浮动点差BP
    ,n.ratelprtype -- lpr利率类型
    ,n.prinrepayfrequency -- 本金还款频率
    ,n.intrepayfrequency -- 利息还款频率
    ,n.encashaccttype -- 收款帐号类型
    ,n.cleardate -- 结清日期
    ,n.assetclass -- 五级分类标识
    ,n.ovdintbal -- 逾期利息余额
    ,n.creditcode -- 额度类型
    ,n.applydate -- 申请支用时间
    ,n.encashamt -- 放款金额
    ,n.totalterms -- 贷款期次数
    ,n.migtflag -- 
    ,n.iswhite -- 是否白户
    ,n.loanuse -- 贷款用途
    ,n.repayaccttype -- 还款帐号类型
    ,n.prinbal -- 正常本金余额
    ,n.ovdprinpnltbal -- 逾期本金罚息余额
    ,n.regioncode -- 行政区划代码
    ,n.certtype -- 证件类型
    ,n.loanstatus -- 贷款状态
    ,n.guaranteetype -- 担保类型
    ,n.applyno -- 贷款申请单号
    ,n.encashacctnobak -- 收款帐号2
    ,n.usearea -- 贷款资金使用位置
    ,n.startdate -- 贷款起息日
    ,n.graceday -- 宽限期天数
    ,n.ovdterms -- 逾期期次数
    ,n.intovddays -- 利息逾期天数
    ,n.encashacctno -- 收款帐号
    ,n.writeoff -- 核销标识，已核销为Y，否则为N
    ,n.prodcode -- 产品码
    ,n.internaltransfertag -- 内部结转标识
    ,n.cusmgr -- 客户经理
    ,n.beginprin -- 贷款原始本金
    ,n.repayacctnobak -- 还款帐号2
    ,n.enddate -- 贷款到期日
    ,n.totalfeerate -- 分期总手续费率
    ,n.dayrate -- 贷款日利率
    ,n.assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
    ,n.intbal -- 正常利息余额
    ,n.ovdintpnltbal -- 逾期利息罚息余额
    ,n.ratefloatmode -- 利率浮动方式
    ,n.currency -- 币种
    ,n.creditno -- 授信编号
    ,n.accruedstatus -- 应计非应计标识
    ,n.contracttype -- 借据类型
    ,n.certno -- 客户证件号码
    ,n.cusid -- 客户号
    ,n.encashdate -- 放款日期
    ,n.repayacctno -- 还款帐号
    ,n.status -- 合约状态
    ,n.lpr -- LPR
    ,n.name -- 客户真实姓名
    ,n.repaymode -- 还款方式
    ,n.prinovddays -- 本金逾期天数
    ,n.biztype -- 产品编号
    ,n.fundseqno -- 放款资金流水号
    ,n.nextrepaydate -- 下一还款日期
    ,n.unclearterms -- 未结清期数
    ,n.execrate -- 执行年利率，推送日利率X360
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_myhb_acc_loan_bk o
    right join (select * from ${itl_schema}.icms_myhb_acc_loan where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.billno = n.billno
where (
        o.billno is null
    )
    or (
        o.isbankrel <> n.isbankrel
        or o.ratetype <> n.ratetype
        or o.agreementno <> n.agreementno
        or o.settledate <> n.settledate
        or o.ovdprinbal <> n.ovdprinbal
        or o.floatratebp <> n.floatratebp
        or o.ratelprtype <> n.ratelprtype
        or o.prinrepayfrequency <> n.prinrepayfrequency
        or o.intrepayfrequency <> n.intrepayfrequency
        or o.encashaccttype <> n.encashaccttype
        or o.cleardate <> n.cleardate
        or o.assetclass <> n.assetclass
        or o.ovdintbal <> n.ovdintbal
        or o.creditcode <> n.creditcode
        or o.applydate <> n.applydate
        or o.encashamt <> n.encashamt
        or o.totalterms <> n.totalterms
        or o.migtflag <> n.migtflag
        or o.iswhite <> n.iswhite
        or o.loanuse <> n.loanuse
        or o.repayaccttype <> n.repayaccttype
        or o.prinbal <> n.prinbal
        or o.ovdprinpnltbal <> n.ovdprinpnltbal
        or o.regioncode <> n.regioncode
        or o.certtype <> n.certtype
        or o.loanstatus <> n.loanstatus
        or o.guaranteetype <> n.guaranteetype
        or o.applyno <> n.applyno
        or o.encashacctnobak <> n.encashacctnobak
        or o.usearea <> n.usearea
        or o.startdate <> n.startdate
        or o.graceday <> n.graceday
        or o.ovdterms <> n.ovdterms
        or o.intovddays <> n.intovddays
        or o.encashacctno <> n.encashacctno
        or o.writeoff <> n.writeoff
        or o.prodcode <> n.prodcode
        or o.internaltransfertag <> n.internaltransfertag
        or o.cusmgr <> n.cusmgr
        or o.beginprin <> n.beginprin
        or o.repayacctnobak <> n.repayacctnobak
        or o.enddate <> n.enddate
        or o.totalfeerate <> n.totalfeerate
        or o.dayrate <> n.dayrate
        or o.assetthreetypecd <> n.assetthreetypecd
        or o.intbal <> n.intbal
        or o.ovdintpnltbal <> n.ovdintpnltbal
        or o.ratefloatmode <> n.ratefloatmode
        or o.currency <> n.currency
        or o.creditno <> n.creditno
        or o.accruedstatus <> n.accruedstatus
        or o.contracttype <> n.contracttype
        or o.certno <> n.certno
        or o.cusid <> n.cusid
        or o.encashdate <> n.encashdate
        or o.repayacctno <> n.repayacctno
        or o.status <> n.status
        or o.lpr <> n.lpr
        or o.name <> n.name
        or o.repaymode <> n.repaymode
        or o.prinovddays <> n.prinovddays
        or o.biztype <> n.biztype
        or o.fundseqno <> n.fundseqno
        or o.nextrepaydate <> n.nextrepaydate
        or o.unclearterms <> n.unclearterms
        or o.execrate <> n.execrate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_myhb_acc_loan_cl(
            billno -- 借据号
        ,isbankrel -- 是否关联人1是2否
        ,ratetype -- 利率类型
        ,agreementno -- 贷款合同号
        ,settledate -- 会计日期
        ,ovdprinbal -- 逾期本金余额
        ,floatratebp -- 利率浮动点差BP
        ,ratelprtype -- lpr利率类型
        ,prinrepayfrequency -- 本金还款频率
        ,intrepayfrequency -- 利息还款频率
        ,encashaccttype -- 收款帐号类型
        ,cleardate -- 结清日期
        ,assetclass -- 五级分类标识
        ,ovdintbal -- 逾期利息余额
        ,creditcode -- 额度类型
        ,applydate -- 申请支用时间
        ,encashamt -- 放款金额
        ,totalterms -- 贷款期次数
        ,migtflag -- 
        ,iswhite -- 是否白户
        ,loanuse -- 贷款用途
        ,repayaccttype -- 还款帐号类型
        ,prinbal -- 正常本金余额
        ,ovdprinpnltbal -- 逾期本金罚息余额
        ,regioncode -- 行政区划代码
        ,certtype -- 证件类型
        ,loanstatus -- 贷款状态
        ,guaranteetype -- 担保类型
        ,applyno -- 贷款申请单号
        ,encashacctnobak -- 收款帐号2
        ,usearea -- 贷款资金使用位置
        ,startdate -- 贷款起息日
        ,graceday -- 宽限期天数
        ,ovdterms -- 逾期期次数
        ,intovddays -- 利息逾期天数
        ,encashacctno -- 收款帐号
        ,writeoff -- 核销标识，已核销为Y，否则为N
        ,prodcode -- 产品码
        ,internaltransfertag -- 内部结转标识
        ,cusmgr -- 客户经理
        ,beginprin -- 贷款原始本金
        ,repayacctnobak -- 还款帐号2
        ,enddate -- 贷款到期日
        ,totalfeerate -- 分期总手续费率
        ,dayrate -- 贷款日利率
        ,assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
        ,intbal -- 正常利息余额
        ,ovdintpnltbal -- 逾期利息罚息余额
        ,ratefloatmode -- 利率浮动方式
        ,currency -- 币种
        ,creditno -- 授信编号
        ,accruedstatus -- 应计非应计标识
        ,contracttype -- 借据类型
        ,certno -- 客户证件号码
        ,cusid -- 客户号
        ,encashdate -- 放款日期
        ,repayacctno -- 还款帐号
        ,status -- 合约状态
        ,lpr -- LPR
        ,name -- 客户真实姓名
        ,repaymode -- 还款方式
        ,prinovddays -- 本金逾期天数
        ,biztype -- 产品编号
        ,fundseqno -- 放款资金流水号
        ,nextrepaydate -- 下一还款日期
        ,unclearterms -- 未结清期数
        ,execrate -- 执行年利率，推送日利率X360
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_myhb_acc_loan_op(
            billno -- 借据号
        ,isbankrel -- 是否关联人1是2否
        ,ratetype -- 利率类型
        ,agreementno -- 贷款合同号
        ,settledate -- 会计日期
        ,ovdprinbal -- 逾期本金余额
        ,floatratebp -- 利率浮动点差BP
        ,ratelprtype -- lpr利率类型
        ,prinrepayfrequency -- 本金还款频率
        ,intrepayfrequency -- 利息还款频率
        ,encashaccttype -- 收款帐号类型
        ,cleardate -- 结清日期
        ,assetclass -- 五级分类标识
        ,ovdintbal -- 逾期利息余额
        ,creditcode -- 额度类型
        ,applydate -- 申请支用时间
        ,encashamt -- 放款金额
        ,totalterms -- 贷款期次数
        ,migtflag -- 
        ,iswhite -- 是否白户
        ,loanuse -- 贷款用途
        ,repayaccttype -- 还款帐号类型
        ,prinbal -- 正常本金余额
        ,ovdprinpnltbal -- 逾期本金罚息余额
        ,regioncode -- 行政区划代码
        ,certtype -- 证件类型
        ,loanstatus -- 贷款状态
        ,guaranteetype -- 担保类型
        ,applyno -- 贷款申请单号
        ,encashacctnobak -- 收款帐号2
        ,usearea -- 贷款资金使用位置
        ,startdate -- 贷款起息日
        ,graceday -- 宽限期天数
        ,ovdterms -- 逾期期次数
        ,intovddays -- 利息逾期天数
        ,encashacctno -- 收款帐号
        ,writeoff -- 核销标识，已核销为Y，否则为N
        ,prodcode -- 产品码
        ,internaltransfertag -- 内部结转标识
        ,cusmgr -- 客户经理
        ,beginprin -- 贷款原始本金
        ,repayacctnobak -- 还款帐号2
        ,enddate -- 贷款到期日
        ,totalfeerate -- 分期总手续费率
        ,dayrate -- 贷款日利率
        ,assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
        ,intbal -- 正常利息余额
        ,ovdintpnltbal -- 逾期利息罚息余额
        ,ratefloatmode -- 利率浮动方式
        ,currency -- 币种
        ,creditno -- 授信编号
        ,accruedstatus -- 应计非应计标识
        ,contracttype -- 借据类型
        ,certno -- 客户证件号码
        ,cusid -- 客户号
        ,encashdate -- 放款日期
        ,repayacctno -- 还款帐号
        ,status -- 合约状态
        ,lpr -- LPR
        ,name -- 客户真实姓名
        ,repaymode -- 还款方式
        ,prinovddays -- 本金逾期天数
        ,biztype -- 产品编号
        ,fundseqno -- 放款资金流水号
        ,nextrepaydate -- 下一还款日期
        ,unclearterms -- 未结清期数
        ,execrate -- 执行年利率，推送日利率X360
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.billno -- 借据号
    ,o.isbankrel -- 是否关联人1是2否
    ,o.ratetype -- 利率类型
    ,o.agreementno -- 贷款合同号
    ,o.settledate -- 会计日期
    ,o.ovdprinbal -- 逾期本金余额
    ,o.floatratebp -- 利率浮动点差BP
    ,o.ratelprtype -- lpr利率类型
    ,o.prinrepayfrequency -- 本金还款频率
    ,o.intrepayfrequency -- 利息还款频率
    ,o.encashaccttype -- 收款帐号类型
    ,o.cleardate -- 结清日期
    ,o.assetclass -- 五级分类标识
    ,o.ovdintbal -- 逾期利息余额
    ,o.creditcode -- 额度类型
    ,o.applydate -- 申请支用时间
    ,o.encashamt -- 放款金额
    ,o.totalterms -- 贷款期次数
    ,o.migtflag -- 
    ,o.iswhite -- 是否白户
    ,o.loanuse -- 贷款用途
    ,o.repayaccttype -- 还款帐号类型
    ,o.prinbal -- 正常本金余额
    ,o.ovdprinpnltbal -- 逾期本金罚息余额
    ,o.regioncode -- 行政区划代码
    ,o.certtype -- 证件类型
    ,o.loanstatus -- 贷款状态
    ,o.guaranteetype -- 担保类型
    ,o.applyno -- 贷款申请单号
    ,o.encashacctnobak -- 收款帐号2
    ,o.usearea -- 贷款资金使用位置
    ,o.startdate -- 贷款起息日
    ,o.graceday -- 宽限期天数
    ,o.ovdterms -- 逾期期次数
    ,o.intovddays -- 利息逾期天数
    ,o.encashacctno -- 收款帐号
    ,o.writeoff -- 核销标识，已核销为Y，否则为N
    ,o.prodcode -- 产品码
    ,o.internaltransfertag -- 内部结转标识
    ,o.cusmgr -- 客户经理
    ,o.beginprin -- 贷款原始本金
    ,o.repayacctnobak -- 还款帐号2
    ,o.enddate -- 贷款到期日
    ,o.totalfeerate -- 分期总手续费率
    ,o.dayrate -- 贷款日利率
    ,o.assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
    ,o.intbal -- 正常利息余额
    ,o.ovdintpnltbal -- 逾期利息罚息余额
    ,o.ratefloatmode -- 利率浮动方式
    ,o.currency -- 币种
    ,o.creditno -- 授信编号
    ,o.accruedstatus -- 应计非应计标识
    ,o.contracttype -- 借据类型
    ,o.certno -- 客户证件号码
    ,o.cusid -- 客户号
    ,o.encashdate -- 放款日期
    ,o.repayacctno -- 还款帐号
    ,o.status -- 合约状态
    ,o.lpr -- LPR
    ,o.name -- 客户真实姓名
    ,o.repaymode -- 还款方式
    ,o.prinovddays -- 本金逾期天数
    ,o.biztype -- 产品编号
    ,o.fundseqno -- 放款资金流水号
    ,o.nextrepaydate -- 下一还款日期
    ,o.unclearterms -- 未结清期数
    ,o.execrate -- 执行年利率，推送日利率X360
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_myhb_acc_loan_bk o
    left join ${iol_schema}.icms_myhb_acc_loan_op n
        on
            o.billno = n.billno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_myhb_acc_loan;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_myhb_acc_loan') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_myhb_acc_loan drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_myhb_acc_loan add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_myhb_acc_loan exchange partition p_${batch_date} with table ${iol_schema}.icms_myhb_acc_loan_cl;
alter table ${iol_schema}.icms_myhb_acc_loan exchange partition p_20991231 with table ${iol_schema}.icms_myhb_acc_loan_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_myhb_acc_loan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_myhb_acc_loan_op purge;
drop table ${iol_schema}.icms_myhb_acc_loan_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_myhb_acc_loan_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_myhb_acc_loan',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
