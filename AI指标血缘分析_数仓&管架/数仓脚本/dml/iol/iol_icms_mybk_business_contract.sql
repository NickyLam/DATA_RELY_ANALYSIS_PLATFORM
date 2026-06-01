/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_mybk_business_contract
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
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.icms_mybk_business_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_mybk_business_contract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybk_business_contract_op purge;
drop table ${iol_schema}.icms_mybk_business_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_business_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybk_business_contract where 0=1;

create table ${iol_schema}.icms_mybk_business_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybk_business_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_mybk_business_contract_cl(
            serialno -- 合同编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,businessflag -- 额度/业务标志
            ,applytype -- 申请类型
            ,occurdate -- 签订日期
            ,currency -- 额度/业务币种
            ,businesssum -- 合同金额
            ,putoutsum -- 实际放款金额
            ,putoutdate -- 放款日期
            ,productid -- 产品编号
            ,productclassify -- 产品所属大类
            ,termmonth -- 期限(月)
            ,startdate -- 合同开始日期
            ,maturity -- 合同到期日期
            ,baseratetype -- 基准利率类型
            ,rateadjusttype -- 利率调整方式
            ,vouchtype -- 主担保方式
            ,othervouchtype -- 其他担保方式
            ,repaytype -- 还款方式
            ,repaydate -- 指定还款日
            ,purpose -- 用途
            ,balance -- 合同贷款余额
            ,status -- 合同状态
            ,finishdate -- 终结日期
            ,approvestatus -- 审批状态
            ,operateuserid -- 业务经办人编号
            ,operateorgid -- 经办机构
            ,operatedate -- 经办日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,loanusetype -- 贷款用途
            ,loanaccountname -- 贷款入账(收款账户)账户名
            ,loanaccountorgid -- 贷款入账(收款账户)账户开户机构
            ,effectdate -- 合同签订日期
            ,executerate -- 执行利率
            ,baserialno -- 授信申请流水号
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_mybk_business_contract_op(
            serialno -- 合同编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,businessflag -- 额度/业务标志
            ,applytype -- 申请类型
            ,occurdate -- 签订日期
            ,currency -- 额度/业务币种
            ,businesssum -- 合同金额
            ,putoutsum -- 实际放款金额
            ,putoutdate -- 放款日期
            ,productid -- 产品编号
            ,productclassify -- 产品所属大类
            ,termmonth -- 期限(月)
            ,startdate -- 合同开始日期
            ,maturity -- 合同到期日期
            ,baseratetype -- 基准利率类型
            ,rateadjusttype -- 利率调整方式
            ,vouchtype -- 主担保方式
            ,othervouchtype -- 其他担保方式
            ,repaytype -- 还款方式
            ,repaydate -- 指定还款日
            ,purpose -- 用途
            ,balance -- 合同贷款余额
            ,status -- 合同状态
            ,finishdate -- 终结日期
            ,approvestatus -- 审批状态
            ,operateuserid -- 业务经办人编号
            ,operateorgid -- 经办机构
            ,operatedate -- 经办日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,loanusetype -- 贷款用途
            ,loanaccountname -- 贷款入账(收款账户)账户名
            ,loanaccountorgid -- 贷款入账(收款账户)账户开户机构
            ,effectdate -- 合同签订日期
            ,executerate -- 执行利率
            ,baserialno -- 授信申请流水号
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 合同编号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.businessflag, o.businessflag) as businessflag -- 额度/业务标志
    ,nvl(n.applytype, o.applytype) as applytype -- 申请类型
    ,nvl(n.occurdate, o.occurdate) as occurdate -- 签订日期
    ,nvl(n.currency, o.currency) as currency -- 额度/业务币种
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 合同金额
    ,nvl(n.putoutsum, o.putoutsum) as putoutsum -- 实际放款金额
    ,nvl(n.putoutdate, o.putoutdate) as putoutdate -- 放款日期
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.productclassify, o.productclassify) as productclassify -- 产品所属大类
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 期限(月)
    ,nvl(n.startdate, o.startdate) as startdate -- 合同开始日期
    ,nvl(n.maturity, o.maturity) as maturity -- 合同到期日期
    ,nvl(n.baseratetype, o.baseratetype) as baseratetype -- 基准利率类型
    ,nvl(n.rateadjusttype, o.rateadjusttype) as rateadjusttype -- 利率调整方式
    ,nvl(n.vouchtype, o.vouchtype) as vouchtype -- 主担保方式
    ,nvl(n.othervouchtype, o.othervouchtype) as othervouchtype -- 其他担保方式
    ,nvl(n.repaytype, o.repaytype) as repaytype -- 还款方式
    ,nvl(n.repaydate, o.repaydate) as repaydate -- 指定还款日
    ,nvl(n.purpose, o.purpose) as purpose -- 用途
    ,nvl(n.balance, o.balance) as balance -- 合同贷款余额
    ,nvl(n.status, o.status) as status -- 合同状态
    ,nvl(n.finishdate, o.finishdate) as finishdate -- 终结日期
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.operateuserid, o.operateuserid) as operateuserid -- 业务经办人编号
    ,nvl(n.operateorgid, o.operateorgid) as operateorgid -- 经办机构
    ,nvl(n.operatedate, o.operatedate) as operatedate -- 经办日期
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.loanusetype, o.loanusetype) as loanusetype -- 贷款用途
    ,nvl(n.loanaccountname, o.loanaccountname) as loanaccountname -- 贷款入账(收款账户)账户名
    ,nvl(n.loanaccountorgid, o.loanaccountorgid) as loanaccountorgid -- 贷款入账(收款账户)账户开户机构
    ,nvl(n.effectdate, o.effectdate) as effectdate -- 合同签订日期
    ,nvl(n.executerate, o.executerate) as executerate -- 执行利率
    ,nvl(n.baserialno, o.baserialno) as baserialno -- 授信申请流水号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crs rcr ilc upl
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_mybk_business_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_mybk_business_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.businessflag <> n.businessflag
        or o.applytype <> n.applytype
        or o.occurdate <> n.occurdate
        or o.currency <> n.currency
        or o.businesssum <> n.businesssum
        or o.putoutsum <> n.putoutsum
        or o.putoutdate <> n.putoutdate
        or o.productid <> n.productid
        or o.productclassify <> n.productclassify
        or o.termmonth <> n.termmonth
        or o.startdate <> n.startdate
        or o.maturity <> n.maturity
        or o.baseratetype <> n.baseratetype
        or o.rateadjusttype <> n.rateadjusttype
        or o.vouchtype <> n.vouchtype
        or o.othervouchtype <> n.othervouchtype
        or o.repaytype <> n.repaytype
        or o.repaydate <> n.repaydate
        or o.purpose <> n.purpose
        or o.balance <> n.balance
        or o.status <> n.status
        or o.finishdate <> n.finishdate
        or o.approvestatus <> n.approvestatus
        or o.operateuserid <> n.operateuserid
        or o.operateorgid <> n.operateorgid
        or o.operatedate <> n.operatedate
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.loanusetype <> n.loanusetype
        or o.loanaccountname <> n.loanaccountname
        or o.loanaccountorgid <> n.loanaccountorgid
        or o.effectdate <> n.effectdate
        or o.executerate <> n.executerate
        or o.baserialno <> n.baserialno
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_mybk_business_contract_cl(
            serialno -- 合同编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,businessflag -- 额度/业务标志
            ,applytype -- 申请类型
            ,occurdate -- 签订日期
            ,currency -- 额度/业务币种
            ,businesssum -- 合同金额
            ,putoutsum -- 实际放款金额
            ,putoutdate -- 放款日期
            ,productid -- 产品编号
            ,productclassify -- 产品所属大类
            ,termmonth -- 期限(月)
            ,startdate -- 合同开始日期
            ,maturity -- 合同到期日期
            ,baseratetype -- 基准利率类型
            ,rateadjusttype -- 利率调整方式
            ,vouchtype -- 主担保方式
            ,othervouchtype -- 其他担保方式
            ,repaytype -- 还款方式
            ,repaydate -- 指定还款日
            ,purpose -- 用途
            ,balance -- 合同贷款余额
            ,status -- 合同状态
            ,finishdate -- 终结日期
            ,approvestatus -- 审批状态
            ,operateuserid -- 业务经办人编号
            ,operateorgid -- 经办机构
            ,operatedate -- 经办日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,loanusetype -- 贷款用途
            ,loanaccountname -- 贷款入账(收款账户)账户名
            ,loanaccountorgid -- 贷款入账(收款账户)账户开户机构
            ,effectdate -- 合同签订日期
            ,executerate -- 执行利率
            ,baserialno -- 授信申请流水号
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_mybk_business_contract_op(
            serialno -- 合同编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,businessflag -- 额度/业务标志
            ,applytype -- 申请类型
            ,occurdate -- 签订日期
            ,currency -- 额度/业务币种
            ,businesssum -- 合同金额
            ,putoutsum -- 实际放款金额
            ,putoutdate -- 放款日期
            ,productid -- 产品编号
            ,productclassify -- 产品所属大类
            ,termmonth -- 期限(月)
            ,startdate -- 合同开始日期
            ,maturity -- 合同到期日期
            ,baseratetype -- 基准利率类型
            ,rateadjusttype -- 利率调整方式
            ,vouchtype -- 主担保方式
            ,othervouchtype -- 其他担保方式
            ,repaytype -- 还款方式
            ,repaydate -- 指定还款日
            ,purpose -- 用途
            ,balance -- 合同贷款余额
            ,status -- 合同状态
            ,finishdate -- 终结日期
            ,approvestatus -- 审批状态
            ,operateuserid -- 业务经办人编号
            ,operateorgid -- 经办机构
            ,operatedate -- 经办日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,loanusetype -- 贷款用途
            ,loanaccountname -- 贷款入账(收款账户)账户名
            ,loanaccountorgid -- 贷款入账(收款账户)账户开户机构
            ,effectdate -- 合同签订日期
            ,executerate -- 执行利率
            ,baserialno -- 授信申请流水号
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 合同编号
    ,o.customerid -- 客户编号
    ,o.customername -- 客户名称
    ,o.businessflag -- 额度/业务标志
    ,o.applytype -- 申请类型
    ,o.occurdate -- 签订日期
    ,o.currency -- 额度/业务币种
    ,o.businesssum -- 合同金额
    ,o.putoutsum -- 实际放款金额
    ,o.putoutdate -- 放款日期
    ,o.productid -- 产品编号
    ,o.productclassify -- 产品所属大类
    ,o.termmonth -- 期限(月)
    ,o.startdate -- 合同开始日期
    ,o.maturity -- 合同到期日期
    ,o.baseratetype -- 基准利率类型
    ,o.rateadjusttype -- 利率调整方式
    ,o.vouchtype -- 主担保方式
    ,o.othervouchtype -- 其他担保方式
    ,o.repaytype -- 还款方式
    ,o.repaydate -- 指定还款日
    ,o.purpose -- 用途
    ,o.balance -- 合同贷款余额
    ,o.status -- 合同状态
    ,o.finishdate -- 终结日期
    ,o.approvestatus -- 审批状态
    ,o.operateuserid -- 业务经办人编号
    ,o.operateorgid -- 经办机构
    ,o.operatedate -- 经办日期
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.loanusetype -- 贷款用途
    ,o.loanaccountname -- 贷款入账(收款账户)账户名
    ,o.loanaccountorgid -- 贷款入账(收款账户)账户开户机构
    ,o.effectdate -- 合同签订日期
    ,o.executerate -- 执行利率
    ,o.baserialno -- 授信申请流水号
    ,o.migtflag -- 迁移标志：crs rcr ilc upl
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_mybk_business_contract_bk o
    left join ${iol_schema}.icms_mybk_business_contract_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_mybk_business_contract_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_mybk_business_contract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_mybk_business_contract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_mybk_business_contract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_mybk_business_contract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_mybk_business_contract exchange partition p_${batch_date} with table ${iol_schema}.icms_mybk_business_contract_cl;
alter table ${iol_schema}.icms_mybk_business_contract exchange partition p_20991231 with table ${iol_schema}.icms_mybk_business_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_mybk_business_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybk_business_contract_op purge;
drop table ${iol_schema}.icms_mybk_business_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_mybk_business_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_mybk_business_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
