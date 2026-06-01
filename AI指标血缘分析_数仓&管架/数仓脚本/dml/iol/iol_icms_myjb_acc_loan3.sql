/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_myjb_acc_loan3
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
create table ${iol_schema}.icms_myjb_acc_loan3_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_myjb_acc_loan3
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_myjb_acc_loan3_op purge;
drop table ${iol_schema}.icms_myjb_acc_loan3_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_myjb_acc_loan3_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.icms_myjb_acc_loan3 where 0=1;

create table ${iol_schema}.icms_myjb_acc_loan3_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.icms_myjb_acc_loan3 where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.icms_myjb_acc_loan3_op(
        billno -- 借据号
        ,accountstatus -- 合约状态，正常NORMAL,逾期OVD,结清CLEAR
        ,ovdprinpnltbal -- 逾期本金罚息余额（单位分），汇总所有期次的逾本罚余额
        ,isbankrel -- 是否关联人1是2否
        ,cusname -- 客户名称
        ,prinovddays -- 本金逾期天数
        ,ratelprtype -- 利率类型1基准2lpr
        ,prdcode -- 产品编号
        ,loanstartdate -- 贷款起息日
        ,intbal -- 正常利息余额（单位分），汇总所有正常期次的利息余额
        ,loanstatus -- 贷款状态
        ,nextrepaydate -- 下一还款日期，格式：yyyyMMdd
        ,ovdterms -- 逾期期次数
        ,execrate -- 执行年利率，借呗推送日利率X360
        ,certtype -- 证件类型
        ,usearea -- 贷款资金使用位置
        ,intrepayfrequency -- 利息还款频率
        ,applyno -- 贷款申请单号
        ,biztype -- 业务种类
        ,fundseqno -- 放款资金流水号
        ,ovdintbal -- 逾期利息余额（单位分），汇总所有逾期期次的利息余额
        ,applydate -- 申请支用时间
        ,encashacctno -- 收款帐号
        ,accruedstatus -- 应计非应计标识，应计0，非应计1
        ,unclearterms -- 未结清期数
        ,loanamount -- 放款金额
        ,encashaccttype -- 收款帐号类型
        ,encashdate -- 放款日期
        ,prinrepayfrequency -- 本金还款频率
        ,overduebalance -- 逾期本金余额（单位分），汇总所有逾期期次的本金余额
        ,floatratebp -- 利率浮动点差BP
        ,modeltype -- 产品模块
        ,certcode -- 证件号码
        ,graceday -- 宽限期天数
        ,dayrate -- 贷款日利率
        ,writeoff -- 核销标识，已核销为Y，否则为N
        ,guaranteetype -- 担保类型
        ,creditno -- 授信编号
        ,repayacctno -- 还款帐号
        ,ovdintpnltbal -- 逾期利息罚息余额（单位分），汇总所有期次的逾利罚余额
        ,loanuse -- 贷款用途
        ,assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
        ,inputdate -- 数据日期
        ,currency -- 币种
        ,loanenddate -- 贷款到期日
        ,normalbalance -- 正常本金余额（单位分），汇总所有正常期次的本金余额
        ,ratefloatmode -- 利率浮动方式
        ,totalterms -- 贷款期次数
        ,repayaccttype -- 还款帐号类型
        ,cleardate -- 结清日期，格式：yyyyMMdd
        ,lpr -- LPR
        ,assetclass -- 五级分类标识，正常1，关注2，次级3，可疑4，损失5
        ,cusid -- 客户号
        ,iswhite -- 是否白名单
        ,repaymode -- 还款方式
        ,ratetype -- 利率类型
        ,settledate -- 会计日期，格式：YYYYMMdd
        ,capoverduedays -- 利息逾期天数
        ,cusmgr -- 客户经理
        ,classifyresult -- 五级分类标识(信贷)
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.billno -- 借据号
    ,n.accountstatus -- 合约状态，正常NORMAL,逾期OVD,结清CLEAR
    ,n.ovdprinpnltbal -- 逾期本金罚息余额（单位分），汇总所有期次的逾本罚余额
    ,n.isbankrel -- 是否关联人1是2否
    ,n.cusname -- 客户名称
    ,n.prinovddays -- 本金逾期天数
    ,n.ratelprtype -- 利率类型1基准2lpr
    ,n.prdcode -- 产品编号
    ,n.loanstartdate -- 贷款起息日
    ,n.intbal -- 正常利息余额（单位分），汇总所有正常期次的利息余额
    ,n.loanstatus -- 贷款状态
    ,n.nextrepaydate -- 下一还款日期，格式：yyyyMMdd
    ,n.ovdterms -- 逾期期次数
    ,n.execrate -- 执行年利率，借呗推送日利率X360
    ,n.certtype -- 证件类型
    ,n.usearea -- 贷款资金使用位置
    ,n.intrepayfrequency -- 利息还款频率
    ,n.applyno -- 贷款申请单号
    ,n.biztype -- 业务种类
    ,n.fundseqno -- 放款资金流水号
    ,n.ovdintbal -- 逾期利息余额（单位分），汇总所有逾期期次的利息余额
    ,n.applydate -- 申请支用时间
    ,n.encashacctno -- 收款帐号
    ,n.accruedstatus -- 应计非应计标识，应计0，非应计1
    ,n.unclearterms -- 未结清期数
    ,n.loanamount -- 放款金额
    ,n.encashaccttype -- 收款帐号类型
    ,n.encashdate -- 放款日期
    ,n.prinrepayfrequency -- 本金还款频率
    ,n.overduebalance -- 逾期本金余额（单位分），汇总所有逾期期次的本金余额
    ,n.floatratebp -- 利率浮动点差BP
    ,n.modeltype -- 产品模块
    ,n.certcode -- 证件号码
    ,n.graceday -- 宽限期天数
    ,n.dayrate -- 贷款日利率
    ,n.writeoff -- 核销标识，已核销为Y，否则为N
    ,n.guaranteetype -- 担保类型
    ,n.creditno -- 授信编号
    ,n.repayacctno -- 还款帐号
    ,n.ovdintpnltbal -- 逾期利息罚息余额（单位分），汇总所有期次的逾利罚余额
    ,n.loanuse -- 贷款用途
    ,n.assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
    ,n.inputdate -- 数据日期
    ,n.currency -- 币种
    ,n.loanenddate -- 贷款到期日
    ,n.normalbalance -- 正常本金余额（单位分），汇总所有正常期次的本金余额
    ,n.ratefloatmode -- 利率浮动方式
    ,n.totalterms -- 贷款期次数
    ,n.repayaccttype -- 还款帐号类型
    ,n.cleardate -- 结清日期，格式：yyyyMMdd
    ,n.lpr -- LPR
    ,n.assetclass -- 五级分类标识，正常1，关注2，次级3，可疑4，损失5
    ,n.cusid -- 客户号
    ,n.iswhite -- 是否白名单
    ,n.repaymode -- 还款方式
    ,n.ratetype -- 利率类型
    ,n.settledate -- 会计日期，格式：YYYYMMdd
    ,n.capoverduedays -- 利息逾期天数
    ,n.cusmgr -- 客户经理
    ,n.classifyresult -- 五级分类标识(信贷)
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_myjb_acc_loan3_bk o
    right join (select * from ${itl_schema}.icms_myjb_acc_loan3 where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.billno = n.billno
where (
        o.billno is null
    )
    or (
        o.accountstatus <> n.accountstatus
        or o.ovdprinpnltbal <> n.ovdprinpnltbal
        or o.isbankrel <> n.isbankrel
        or o.cusname <> n.cusname
        or o.prinovddays <> n.prinovddays
        or o.ratelprtype <> n.ratelprtype
        or o.prdcode <> n.prdcode
        or o.loanstartdate <> n.loanstartdate
        or o.intbal <> n.intbal
        or o.loanstatus <> n.loanstatus
        or o.nextrepaydate <> n.nextrepaydate
        or o.ovdterms <> n.ovdterms
        or o.execrate <> n.execrate
        or o.certtype <> n.certtype
        or o.usearea <> n.usearea
        or o.intrepayfrequency <> n.intrepayfrequency
        or o.applyno <> n.applyno
        or o.biztype <> n.biztype
        or o.fundseqno <> n.fundseqno
        or o.ovdintbal <> n.ovdintbal
        or o.applydate <> n.applydate
        or o.encashacctno <> n.encashacctno
        or o.accruedstatus <> n.accruedstatus
        or o.unclearterms <> n.unclearterms
        or o.loanamount <> n.loanamount
        or o.encashaccttype <> n.encashaccttype
        or o.encashdate <> n.encashdate
        or o.prinrepayfrequency <> n.prinrepayfrequency
        or o.overduebalance <> n.overduebalance
        or o.floatratebp <> n.floatratebp
        or o.modeltype <> n.modeltype
        or o.certcode <> n.certcode
        or o.graceday <> n.graceday
        or o.dayrate <> n.dayrate
        or o.writeoff <> n.writeoff
        or o.guaranteetype <> n.guaranteetype
        or o.creditno <> n.creditno
        or o.repayacctno <> n.repayacctno
        or o.ovdintpnltbal <> n.ovdintpnltbal
        or o.loanuse <> n.loanuse
        or o.assetthreetypecd <> n.assetthreetypecd
        or o.inputdate <> n.inputdate
        or o.currency <> n.currency
        or o.loanenddate <> n.loanenddate
        or o.normalbalance <> n.normalbalance
        or o.ratefloatmode <> n.ratefloatmode
        or o.totalterms <> n.totalterms
        or o.repayaccttype <> n.repayaccttype
        or o.cleardate <> n.cleardate
        or o.lpr <> n.lpr
        or o.assetclass <> n.assetclass
        or o.cusid <> n.cusid
        or o.iswhite <> n.iswhite
        or o.repaymode <> n.repaymode
        or o.ratetype <> n.ratetype
        or o.settledate <> n.settledate
        or o.capoverduedays <> n.capoverduedays
        or o.cusmgr <> n.cusmgr
        or o.classifyresult <> n.classifyresult
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_myjb_acc_loan3_cl(
            billno -- 借据号
        ,accountstatus -- 合约状态，正常NORMAL,逾期OVD,结清CLEAR
        ,ovdprinpnltbal -- 逾期本金罚息余额（单位分），汇总所有期次的逾本罚余额
        ,isbankrel -- 是否关联人1是2否
        ,cusname -- 客户名称
        ,prinovddays -- 本金逾期天数
        ,ratelprtype -- 利率类型1基准2lpr
        ,prdcode -- 产品编号
        ,loanstartdate -- 贷款起息日
        ,intbal -- 正常利息余额（单位分），汇总所有正常期次的利息余额
        ,loanstatus -- 贷款状态
        ,nextrepaydate -- 下一还款日期，格式：yyyyMMdd
        ,ovdterms -- 逾期期次数
        ,execrate -- 执行年利率，借呗推送日利率X360
        ,certtype -- 证件类型
        ,usearea -- 贷款资金使用位置
        ,intrepayfrequency -- 利息还款频率
        ,applyno -- 贷款申请单号
        ,biztype -- 业务种类
        ,fundseqno -- 放款资金流水号
        ,ovdintbal -- 逾期利息余额（单位分），汇总所有逾期期次的利息余额
        ,applydate -- 申请支用时间
        ,encashacctno -- 收款帐号
        ,accruedstatus -- 应计非应计标识，应计0，非应计1
        ,unclearterms -- 未结清期数
        ,loanamount -- 放款金额
        ,encashaccttype -- 收款帐号类型
        ,encashdate -- 放款日期
        ,prinrepayfrequency -- 本金还款频率
        ,overduebalance -- 逾期本金余额（单位分），汇总所有逾期期次的本金余额
        ,floatratebp -- 利率浮动点差BP
        ,modeltype -- 产品模块
        ,certcode -- 证件号码
        ,graceday -- 宽限期天数
        ,dayrate -- 贷款日利率
        ,writeoff -- 核销标识，已核销为Y，否则为N
        ,guaranteetype -- 担保类型
        ,creditno -- 授信编号
        ,repayacctno -- 还款帐号
        ,ovdintpnltbal -- 逾期利息罚息余额（单位分），汇总所有期次的逾利罚余额
        ,loanuse -- 贷款用途
        ,assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
        ,inputdate -- 数据日期
        ,currency -- 币种
        ,loanenddate -- 贷款到期日
        ,normalbalance -- 正常本金余额（单位分），汇总所有正常期次的本金余额
        ,ratefloatmode -- 利率浮动方式
        ,totalterms -- 贷款期次数
        ,repayaccttype -- 还款帐号类型
        ,cleardate -- 结清日期，格式：yyyyMMdd
        ,lpr -- LPR
        ,assetclass -- 五级分类标识，正常1，关注2，次级3，可疑4，损失5
        ,cusid -- 客户号
        ,iswhite -- 是否白名单
        ,repaymode -- 还款方式
        ,ratetype -- 利率类型
        ,settledate -- 会计日期，格式：YYYYMMdd
        ,capoverduedays -- 利息逾期天数
        ,cusmgr -- 客户经理
        ,classifyresult -- 五级分类标识(信贷)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_myjb_acc_loan3_op(
            billno -- 借据号
        ,accountstatus -- 合约状态，正常NORMAL,逾期OVD,结清CLEAR
        ,ovdprinpnltbal -- 逾期本金罚息余额（单位分），汇总所有期次的逾本罚余额
        ,isbankrel -- 是否关联人1是2否
        ,cusname -- 客户名称
        ,prinovddays -- 本金逾期天数
        ,ratelprtype -- 利率类型1基准2lpr
        ,prdcode -- 产品编号
        ,loanstartdate -- 贷款起息日
        ,intbal -- 正常利息余额（单位分），汇总所有正常期次的利息余额
        ,loanstatus -- 贷款状态
        ,nextrepaydate -- 下一还款日期，格式：yyyyMMdd
        ,ovdterms -- 逾期期次数
        ,execrate -- 执行年利率，借呗推送日利率X360
        ,certtype -- 证件类型
        ,usearea -- 贷款资金使用位置
        ,intrepayfrequency -- 利息还款频率
        ,applyno -- 贷款申请单号
        ,biztype -- 业务种类
        ,fundseqno -- 放款资金流水号
        ,ovdintbal -- 逾期利息余额（单位分），汇总所有逾期期次的利息余额
        ,applydate -- 申请支用时间
        ,encashacctno -- 收款帐号
        ,accruedstatus -- 应计非应计标识，应计0，非应计1
        ,unclearterms -- 未结清期数
        ,loanamount -- 放款金额
        ,encashaccttype -- 收款帐号类型
        ,encashdate -- 放款日期
        ,prinrepayfrequency -- 本金还款频率
        ,overduebalance -- 逾期本金余额（单位分），汇总所有逾期期次的本金余额
        ,floatratebp -- 利率浮动点差BP
        ,modeltype -- 产品模块
        ,certcode -- 证件号码
        ,graceday -- 宽限期天数
        ,dayrate -- 贷款日利率
        ,writeoff -- 核销标识，已核销为Y，否则为N
        ,guaranteetype -- 担保类型
        ,creditno -- 授信编号
        ,repayacctno -- 还款帐号
        ,ovdintpnltbal -- 逾期利息罚息余额（单位分），汇总所有期次的逾利罚余额
        ,loanuse -- 贷款用途
        ,assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
        ,inputdate -- 数据日期
        ,currency -- 币种
        ,loanenddate -- 贷款到期日
        ,normalbalance -- 正常本金余额（单位分），汇总所有正常期次的本金余额
        ,ratefloatmode -- 利率浮动方式
        ,totalterms -- 贷款期次数
        ,repayaccttype -- 还款帐号类型
        ,cleardate -- 结清日期，格式：yyyyMMdd
        ,lpr -- LPR
        ,assetclass -- 五级分类标识，正常1，关注2，次级3，可疑4，损失5
        ,cusid -- 客户号
        ,iswhite -- 是否白名单
        ,repaymode -- 还款方式
        ,ratetype -- 利率类型
        ,settledate -- 会计日期，格式：YYYYMMdd
        ,capoverduedays -- 利息逾期天数
        ,cusmgr -- 客户经理
        ,classifyresult -- 五级分类标识(信贷)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.billno -- 借据号
    ,o.accountstatus -- 合约状态，正常NORMAL,逾期OVD,结清CLEAR
    ,o.ovdprinpnltbal -- 逾期本金罚息余额（单位分），汇总所有期次的逾本罚余额
    ,o.isbankrel -- 是否关联人1是2否
    ,o.cusname -- 客户名称
    ,o.prinovddays -- 本金逾期天数
    ,o.ratelprtype -- 利率类型1基准2lpr
    ,o.prdcode -- 产品编号
    ,o.loanstartdate -- 贷款起息日
    ,o.intbal -- 正常利息余额（单位分），汇总所有正常期次的利息余额
    ,o.loanstatus -- 贷款状态
    ,o.nextrepaydate -- 下一还款日期，格式：yyyyMMdd
    ,o.ovdterms -- 逾期期次数
    ,o.execrate -- 执行年利率，借呗推送日利率X360
    ,o.certtype -- 证件类型
    ,o.usearea -- 贷款资金使用位置
    ,o.intrepayfrequency -- 利息还款频率
    ,o.applyno -- 贷款申请单号
    ,o.biztype -- 业务种类
    ,o.fundseqno -- 放款资金流水号
    ,o.ovdintbal -- 逾期利息余额（单位分），汇总所有逾期期次的利息余额
    ,o.applydate -- 申请支用时间
    ,o.encashacctno -- 收款帐号
    ,o.accruedstatus -- 应计非应计标识，应计0，非应计1
    ,o.unclearterms -- 未结清期数
    ,o.loanamount -- 放款金额
    ,o.encashaccttype -- 收款帐号类型
    ,o.encashdate -- 放款日期
    ,o.prinrepayfrequency -- 本金还款频率
    ,o.overduebalance -- 逾期本金余额（单位分），汇总所有逾期期次的本金余额
    ,o.floatratebp -- 利率浮动点差BP
    ,o.modeltype -- 产品模块
    ,o.certcode -- 证件号码
    ,o.graceday -- 宽限期天数
    ,o.dayrate -- 贷款日利率
    ,o.writeoff -- 核销标识，已核销为Y，否则为N
    ,o.guaranteetype -- 担保类型
    ,o.creditno -- 授信编号
    ,o.repayacctno -- 还款帐号
    ,o.ovdintpnltbal -- 逾期利息罚息余额（单位分），汇总所有期次的逾利罚余额
    ,o.loanuse -- 贷款用途
    ,o.assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
    ,o.inputdate -- 数据日期
    ,o.currency -- 币种
    ,o.loanenddate -- 贷款到期日
    ,o.normalbalance -- 正常本金余额（单位分），汇总所有正常期次的本金余额
    ,o.ratefloatmode -- 利率浮动方式
    ,o.totalterms -- 贷款期次数
    ,o.repayaccttype -- 还款帐号类型
    ,o.cleardate -- 结清日期，格式：yyyyMMdd
    ,o.lpr -- LPR
    ,o.assetclass -- 五级分类标识，正常1，关注2，次级3，可疑4，损失5
    ,o.cusid -- 客户号
    ,o.iswhite -- 是否白名单
    ,o.repaymode -- 还款方式
    ,o.ratetype -- 利率类型
    ,o.settledate -- 会计日期，格式：YYYYMMdd
    ,o.capoverduedays -- 利息逾期天数
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
from ${iol_schema}.icms_myjb_acc_loan3_bk o
    left join ${iol_schema}.icms_myjb_acc_loan3_op n
        on
            o.billno = n.billno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_myjb_acc_loan3;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_myjb_acc_loan3') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_myjb_acc_loan3 drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_myjb_acc_loan3 add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_myjb_acc_loan3 exchange partition p_${batch_date} with table ${iol_schema}.icms_myjb_acc_loan3_cl;
alter table ${iol_schema}.icms_myjb_acc_loan3 exchange partition p_20991231 with table ${iol_schema}.icms_myjb_acc_loan3_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_myjb_acc_loan3 to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_myjb_acc_loan3_op purge;
drop table ${iol_schema}.icms_myjb_acc_loan3_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_myjb_acc_loan3_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_myjb_acc_loan3',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
