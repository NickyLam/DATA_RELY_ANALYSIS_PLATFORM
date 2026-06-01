/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_myjb_acc_loan
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
create table ${iol_schema}.icms_myjb_acc_loan_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_myjb_acc_loan
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_myjb_acc_loan_op purge;
drop table ${iol_schema}.icms_myjb_acc_loan_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_myjb_acc_loan_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.icms_myjb_acc_loan where 0=1;

create table ${iol_schema}.icms_myjb_acc_loan_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.icms_myjb_acc_loan where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.icms_myjb_acc_loan_op(
        billno -- 借据号
        ,loanstatus -- 贷款状态
        ,repayacctno -- 还款帐号
        ,accruedstatus -- 应计非应计标识
        ,unclearterms -- 未结清期数
        ,lpr -- LPR
        ,fundseqno -- 放款资金流水号
        ,applydate -- 申请支用时间
        ,prinrepayfrequency -- 本金还款频率
        ,ratefloatmode -- 利率浮动方式
        ,iswhite -- 是否白名单
        ,certtype -- 证件类型
        ,certcode -- 客户证件号码
        ,loanstartdate -- 贷款起息日
        ,dayrate -- 贷款日利率，保留6位小数
        ,creditno -- 授信编号
        ,repayaccttype -- 还款帐号类型
        ,ratetype -- 利率类型
        ,nextrepaydate -- 下一还款日期
        ,encashdate -- 放款日期
        ,applyno -- 贷款申请单号
        ,capoverduedays -- 利息逾期天数
        ,normalbalance -- 正常本金余额
        ,ovdintbal -- 逾期利息余额
        ,ovdintpnltbal -- 逾期利息罚息余额
        ,execrate -- 执行年利率，借呗推送日利率X360
        ,assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
        ,encashaccttype -- 收款帐号类型
        ,modeltype -- 数据来源
        ,migtflag -- 迁移标志：crsrcrilcupl
        ,inputdate -- 操作时间
        ,ovdterms -- 逾期期次数
        ,writeoff -- 核销标识，已核销为Y，否则为N
        ,currency -- 币种，默认为CNY
        ,accountstatus -- 合约状态
        ,ovdprinpnltbal -- 逾期本金罚息余额
        ,cusid -- 客户号
        ,ratelprtype -- 利率类型1基准2lpr
        ,biztype -- 业务种类
        ,loanenddate -- 贷款到期日
        ,intrepayfrequency -- 利息还款频率
        ,encashacctno -- 收款帐号
        ,overduebalance -- 逾期本金余额
        ,usearea -- 贷款资金使用位置
        ,loanamount -- 放款金额
        ,guaranteetype -- 担保类型
        ,floatratebp -- 利率浮动点差BP
        ,isbankrel -- 是否关联人1是2否
        ,repaymode -- 还款方式
        ,graceday -- 宽限期天数
        ,prdcode -- 产品编号
        ,cleardate -- 结清日期
        ,assetclass -- 五级分类标识
        ,cusname -- 客户真实姓名
        ,totalterms -- 贷款期次数
        ,loanuse -- 贷款用途
        ,settledate -- 会计日期
        ,intbal -- 正常利息余额
        ,prinovddays -- 本金逾期天数
        ,cusmgr -- 客户经理
        ,classifyresult -- 五级分类标识(信贷)
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.billno -- 借据号
    ,n.loanstatus -- 贷款状态
    ,n.repayacctno -- 还款帐号
    ,n.accruedstatus -- 应计非应计标识
    ,n.unclearterms -- 未结清期数
    ,n.lpr -- LPR
    ,n.fundseqno -- 放款资金流水号
    ,n.applydate -- 申请支用时间
    ,n.prinrepayfrequency -- 本金还款频率
    ,n.ratefloatmode -- 利率浮动方式
    ,n.iswhite -- 是否白名单
    ,n.certtype -- 证件类型
    ,n.certcode -- 客户证件号码
    ,n.loanstartdate -- 贷款起息日
    ,n.dayrate -- 贷款日利率，保留6位小数
    ,n.creditno -- 授信编号
    ,n.repayaccttype -- 还款帐号类型
    ,n.ratetype -- 利率类型
    ,n.nextrepaydate -- 下一还款日期
    ,n.encashdate -- 放款日期
    ,n.applyno -- 贷款申请单号
    ,n.capoverduedays -- 利息逾期天数
    ,n.normalbalance -- 正常本金余额
    ,n.ovdintbal -- 逾期利息余额
    ,n.ovdintpnltbal -- 逾期利息罚息余额
    ,n.execrate -- 执行年利率，借呗推送日利率X360
    ,n.assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
    ,n.encashaccttype -- 收款帐号类型
    ,n.modeltype -- 数据来源
    ,n.migtflag -- 迁移标志：crsrcrilcupl
    ,n.inputdate -- 操作时间
    ,n.ovdterms -- 逾期期次数
    ,n.writeoff -- 核销标识，已核销为Y，否则为N
    ,n.currency -- 币种，默认为CNY
    ,n.accountstatus -- 合约状态
    ,n.ovdprinpnltbal -- 逾期本金罚息余额
    ,n.cusid -- 客户号
    ,n.ratelprtype -- 利率类型1基准2lpr
    ,n.biztype -- 业务种类
    ,n.loanenddate -- 贷款到期日
    ,n.intrepayfrequency -- 利息还款频率
    ,n.encashacctno -- 收款帐号
    ,n.overduebalance -- 逾期本金余额
    ,n.usearea -- 贷款资金使用位置
    ,n.loanamount -- 放款金额
    ,n.guaranteetype -- 担保类型
    ,n.floatratebp -- 利率浮动点差BP
    ,n.isbankrel -- 是否关联人1是2否
    ,n.repaymode -- 还款方式
    ,n.graceday -- 宽限期天数
    ,n.prdcode -- 产品编号
    ,n.cleardate -- 结清日期
    ,n.assetclass -- 五级分类标识
    ,n.cusname -- 客户真实姓名
    ,n.totalterms -- 贷款期次数
    ,n.loanuse -- 贷款用途
    ,n.settledate -- 会计日期
    ,n.intbal -- 正常利息余额
    ,n.prinovddays -- 本金逾期天数
    ,n.cusmgr -- 客户经理
    ,n.classifyresult -- 五级分类标识(信贷)
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_myjb_acc_loan_bk o
    right join (select * from ${itl_schema}.icms_myjb_acc_loan where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.billno = n.billno
where (
        o.billno is null
    )
    or (
        o.loanstatus <> n.loanstatus
        or o.repayacctno <> n.repayacctno
        or o.accruedstatus <> n.accruedstatus
        or o.unclearterms <> n.unclearterms
        or o.lpr <> n.lpr
        or o.fundseqno <> n.fundseqno
        or o.applydate <> n.applydate
        or o.prinrepayfrequency <> n.prinrepayfrequency
        or o.ratefloatmode <> n.ratefloatmode
        or o.iswhite <> n.iswhite
        or o.certtype <> n.certtype
        or o.certcode <> n.certcode
        or o.loanstartdate <> n.loanstartdate
        or o.dayrate <> n.dayrate
        or o.creditno <> n.creditno
        or o.repayaccttype <> n.repayaccttype
        or o.ratetype <> n.ratetype
        or o.nextrepaydate <> n.nextrepaydate
        or o.encashdate <> n.encashdate
        or o.applyno <> n.applyno
        or o.capoverduedays <> n.capoverduedays
        or o.normalbalance <> n.normalbalance
        or o.ovdintbal <> n.ovdintbal
        or o.ovdintpnltbal <> n.ovdintpnltbal
        or o.execrate <> n.execrate
        or o.assetthreetypecd <> n.assetthreetypecd
        or o.encashaccttype <> n.encashaccttype
        or o.modeltype <> n.modeltype
        or o.migtflag <> n.migtflag
        or o.inputdate <> n.inputdate
        or o.ovdterms <> n.ovdterms
        or o.writeoff <> n.writeoff
        or o.currency <> n.currency
        or o.accountstatus <> n.accountstatus
        or o.ovdprinpnltbal <> n.ovdprinpnltbal
        or o.cusid <> n.cusid
        or o.ratelprtype <> n.ratelprtype
        or o.biztype <> n.biztype
        or o.loanenddate <> n.loanenddate
        or o.intrepayfrequency <> n.intrepayfrequency
        or o.encashacctno <> n.encashacctno
        or o.overduebalance <> n.overduebalance
        or o.usearea <> n.usearea
        or o.loanamount <> n.loanamount
        or o.guaranteetype <> n.guaranteetype
        or o.floatratebp <> n.floatratebp
        or o.isbankrel <> n.isbankrel
        or o.repaymode <> n.repaymode
        or o.graceday <> n.graceday
        or o.prdcode <> n.prdcode
        or o.cleardate <> n.cleardate
        or o.assetclass <> n.assetclass
        or o.cusname <> n.cusname
        or o.totalterms <> n.totalterms
        or o.loanuse <> n.loanuse
        or o.settledate <> n.settledate
        or o.intbal <> n.intbal
        or o.prinovddays <> n.prinovddays
        or o.cusmgr <> n.cusmgr
        or o.classifyresult <> n.classifyresult
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_myjb_acc_loan_cl(
            billno -- 借据号
        ,loanstatus -- 贷款状态
        ,repayacctno -- 还款帐号
        ,accruedstatus -- 应计非应计标识
        ,unclearterms -- 未结清期数
        ,lpr -- LPR
        ,fundseqno -- 放款资金流水号
        ,applydate -- 申请支用时间
        ,prinrepayfrequency -- 本金还款频率
        ,ratefloatmode -- 利率浮动方式
        ,iswhite -- 是否白名单
        ,certtype -- 证件类型
        ,certcode -- 客户证件号码
        ,loanstartdate -- 贷款起息日
        ,dayrate -- 贷款日利率，保留6位小数
        ,creditno -- 授信编号
        ,repayaccttype -- 还款帐号类型
        ,ratetype -- 利率类型
        ,nextrepaydate -- 下一还款日期
        ,encashdate -- 放款日期
        ,applyno -- 贷款申请单号
        ,capoverduedays -- 利息逾期天数
        ,normalbalance -- 正常本金余额
        ,ovdintbal -- 逾期利息余额
        ,ovdintpnltbal -- 逾期利息罚息余额
        ,execrate -- 执行年利率，借呗推送日利率X360
        ,assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
        ,encashaccttype -- 收款帐号类型
        ,modeltype -- 数据来源
        ,migtflag -- 迁移标志：crsrcrilcupl
        ,inputdate -- 操作时间
        ,ovdterms -- 逾期期次数
        ,writeoff -- 核销标识，已核销为Y，否则为N
        ,currency -- 币种，默认为CNY
        ,accountstatus -- 合约状态
        ,ovdprinpnltbal -- 逾期本金罚息余额
        ,cusid -- 客户号
        ,ratelprtype -- 利率类型1基准2lpr
        ,biztype -- 业务种类
        ,loanenddate -- 贷款到期日
        ,intrepayfrequency -- 利息还款频率
        ,encashacctno -- 收款帐号
        ,overduebalance -- 逾期本金余额
        ,usearea -- 贷款资金使用位置
        ,loanamount -- 放款金额
        ,guaranteetype -- 担保类型
        ,floatratebp -- 利率浮动点差BP
        ,isbankrel -- 是否关联人1是2否
        ,repaymode -- 还款方式
        ,graceday -- 宽限期天数
        ,prdcode -- 产品编号
        ,cleardate -- 结清日期
        ,assetclass -- 五级分类标识
        ,cusname -- 客户真实姓名
        ,totalterms -- 贷款期次数
        ,loanuse -- 贷款用途
        ,settledate -- 会计日期
        ,intbal -- 正常利息余额
        ,prinovddays -- 本金逾期天数
        ,cusmgr -- 客户经理
        ,classifyresult -- 五级分类标识(信贷)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_myjb_acc_loan_op(
            billno -- 借据号
        ,loanstatus -- 贷款状态
        ,repayacctno -- 还款帐号
        ,accruedstatus -- 应计非应计标识
        ,unclearterms -- 未结清期数
        ,lpr -- LPR
        ,fundseqno -- 放款资金流水号
        ,applydate -- 申请支用时间
        ,prinrepayfrequency -- 本金还款频率
        ,ratefloatmode -- 利率浮动方式
        ,iswhite -- 是否白名单
        ,certtype -- 证件类型
        ,certcode -- 客户证件号码
        ,loanstartdate -- 贷款起息日
        ,dayrate -- 贷款日利率，保留6位小数
        ,creditno -- 授信编号
        ,repayaccttype -- 还款帐号类型
        ,ratetype -- 利率类型
        ,nextrepaydate -- 下一还款日期
        ,encashdate -- 放款日期
        ,applyno -- 贷款申请单号
        ,capoverduedays -- 利息逾期天数
        ,normalbalance -- 正常本金余额
        ,ovdintbal -- 逾期利息余额
        ,ovdintpnltbal -- 逾期利息罚息余额
        ,execrate -- 执行年利率，借呗推送日利率X360
        ,assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
        ,encashaccttype -- 收款帐号类型
        ,modeltype -- 数据来源
        ,migtflag -- 迁移标志：crsrcrilcupl
        ,inputdate -- 操作时间
        ,ovdterms -- 逾期期次数
        ,writeoff -- 核销标识，已核销为Y，否则为N
        ,currency -- 币种，默认为CNY
        ,accountstatus -- 合约状态
        ,ovdprinpnltbal -- 逾期本金罚息余额
        ,cusid -- 客户号
        ,ratelprtype -- 利率类型1基准2lpr
        ,biztype -- 业务种类
        ,loanenddate -- 贷款到期日
        ,intrepayfrequency -- 利息还款频率
        ,encashacctno -- 收款帐号
        ,overduebalance -- 逾期本金余额
        ,usearea -- 贷款资金使用位置
        ,loanamount -- 放款金额
        ,guaranteetype -- 担保类型
        ,floatratebp -- 利率浮动点差BP
        ,isbankrel -- 是否关联人1是2否
        ,repaymode -- 还款方式
        ,graceday -- 宽限期天数
        ,prdcode -- 产品编号
        ,cleardate -- 结清日期
        ,assetclass -- 五级分类标识
        ,cusname -- 客户真实姓名
        ,totalterms -- 贷款期次数
        ,loanuse -- 贷款用途
        ,settledate -- 会计日期
        ,intbal -- 正常利息余额
        ,prinovddays -- 本金逾期天数
        ,cusmgr -- 客户经理
        ,classifyresult -- 五级分类标识(信贷)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.billno -- 借据号
    ,o.loanstatus -- 贷款状态
    ,o.repayacctno -- 还款帐号
    ,o.accruedstatus -- 应计非应计标识
    ,o.unclearterms -- 未结清期数
    ,o.lpr -- LPR
    ,o.fundseqno -- 放款资金流水号
    ,o.applydate -- 申请支用时间
    ,o.prinrepayfrequency -- 本金还款频率
    ,o.ratefloatmode -- 利率浮动方式
    ,o.iswhite -- 是否白名单
    ,o.certtype -- 证件类型
    ,o.certcode -- 客户证件号码
    ,o.loanstartdate -- 贷款起息日
    ,o.dayrate -- 贷款日利率，保留6位小数
    ,o.creditno -- 授信编号
    ,o.repayaccttype -- 还款帐号类型
    ,o.ratetype -- 利率类型
    ,o.nextrepaydate -- 下一还款日期
    ,o.encashdate -- 放款日期
    ,o.applyno -- 贷款申请单号
    ,o.capoverduedays -- 利息逾期天数
    ,o.normalbalance -- 正常本金余额
    ,o.ovdintbal -- 逾期利息余额
    ,o.ovdintpnltbal -- 逾期利息罚息余额
    ,o.execrate -- 执行年利率，借呗推送日利率X360
    ,o.assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
    ,o.encashaccttype -- 收款帐号类型
    ,o.modeltype -- 数据来源
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.inputdate -- 操作时间
    ,o.ovdterms -- 逾期期次数
    ,o.writeoff -- 核销标识，已核销为Y，否则为N
    ,o.currency -- 币种，默认为CNY
    ,o.accountstatus -- 合约状态
    ,o.ovdprinpnltbal -- 逾期本金罚息余额
    ,o.cusid -- 客户号
    ,o.ratelprtype -- 利率类型1基准2lpr
    ,o.biztype -- 业务种类
    ,o.loanenddate -- 贷款到期日
    ,o.intrepayfrequency -- 利息还款频率
    ,o.encashacctno -- 收款帐号
    ,o.overduebalance -- 逾期本金余额
    ,o.usearea -- 贷款资金使用位置
    ,o.loanamount -- 放款金额
    ,o.guaranteetype -- 担保类型
    ,o.floatratebp -- 利率浮动点差BP
    ,o.isbankrel -- 是否关联人1是2否
    ,o.repaymode -- 还款方式
    ,o.graceday -- 宽限期天数
    ,o.prdcode -- 产品编号
    ,o.cleardate -- 结清日期
    ,o.assetclass -- 五级分类标识
    ,o.cusname -- 客户真实姓名
    ,o.totalterms -- 贷款期次数
    ,o.loanuse -- 贷款用途
    ,o.settledate -- 会计日期
    ,o.intbal -- 正常利息余额
    ,o.prinovddays -- 本金逾期天数
    ,o.cusmgr -- 客户经理
    ,o.classifyresult -- 五级分类标识(信贷)
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
from ${iol_schema}.icms_myjb_acc_loan_bk o
    left join ${iol_schema}.icms_myjb_acc_loan_op n
        on
            o.billno = n.billno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_myjb_acc_loan;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_myjb_acc_loan') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_myjb_acc_loan drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_myjb_acc_loan add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_myjb_acc_loan exchange partition p_${batch_date} with table ${iol_schema}.icms_myjb_acc_loan_cl;
alter table ${iol_schema}.icms_myjb_acc_loan exchange partition p_20991231 with table ${iol_schema}.icms_myjb_acc_loan_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_myjb_acc_loan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_myjb_acc_loan_op purge;
drop table ${iol_schema}.icms_myjb_acc_loan_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_myjb_acc_loan_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_myjb_acc_loan',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
