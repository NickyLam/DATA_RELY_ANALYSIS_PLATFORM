/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_psp_bill_list
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
create table ${iol_schema}.icms_psp_bill_list_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_psp_bill_list
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_psp_bill_list_op purge;
drop table ${iol_schema}.icms_psp_bill_list_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_psp_bill_list_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_psp_bill_list where 0=1;

create table ${iol_schema}.icms_psp_bill_list_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_psp_bill_list where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_psp_bill_list_cl(
            serialno -- 主键
            ,inputbrid -- 所属分行
            ,overduereceint -- 逾期应收
            ,firstdisbdate -- 首次放款日期
            ,contamt -- 业务合同金额
            ,loanamount -- 出账金额
            ,loanenddate -- 到期日
            ,finabrid -- 账务机构
            ,prdtype -- 产品类别
            ,repaymentmode -- 还款方式
            ,billno -- 借据编号
            ,loanbalance -- 本期余额
            ,cla -- 上期风险分类
            ,offint -- 表外利息
            ,assuremeansmain -- 主担保方式
            ,openamt -- 敞口金额
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,doubtfulbalance -- 呆账贷款余额(元)
            ,currencytype -- 币种
            ,type -- 借据类别：1、借款人2、保证人
            ,contno -- 合同编号
            ,defaultflag -- 违约标志
            ,offintcumu -- 表外欠息
            ,prdname -- 产品名称
            ,riskopenamt -- 备用主键
            ,loanform -- 贷款形式
            ,innerintcumu -- 表内欠息
            ,compoundint -- 利息复息
            ,biztype -- 贷款品种
            ,inneroffint -- 表内转表外利息
            ,cusid -- 客户代码
            ,cusmanager -- 客户经理
            ,factuse -- 实际用途
            ,loanstartdate -- 出帐日
            ,innerreceint -- 表内应收
            ,serno -- 任务编号
            ,prdpk -- 产品主键
            ,delayintcumu -- 欠息累计
            ,overduebalance -- 逾期贷款余额(元)
            ,cusname -- 客户名称
            ,sluggishbalance -- 呆滞贷款余额(元)
            ,cladate -- 五级分类日期
            ,biztypesub -- 业务品种细分
            ,realityirm -- 执行月利率
            ,loanform4 -- 四级分类标志
            ,normalbalance -- 正常贷款余额(元)
            ,appltype -- 业务类型
            ,riskamt -- 敞口余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_psp_bill_list_op(
            serialno -- 主键
            ,inputbrid -- 所属分行
            ,overduereceint -- 逾期应收
            ,firstdisbdate -- 首次放款日期
            ,contamt -- 业务合同金额
            ,loanamount -- 出账金额
            ,loanenddate -- 到期日
            ,finabrid -- 账务机构
            ,prdtype -- 产品类别
            ,repaymentmode -- 还款方式
            ,billno -- 借据编号
            ,loanbalance -- 本期余额
            ,cla -- 上期风险分类
            ,offint -- 表外利息
            ,assuremeansmain -- 主担保方式
            ,openamt -- 敞口金额
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,doubtfulbalance -- 呆账贷款余额(元)
            ,currencytype -- 币种
            ,type -- 借据类别：1、借款人2、保证人
            ,contno -- 合同编号
            ,defaultflag -- 违约标志
            ,offintcumu -- 表外欠息
            ,prdname -- 产品名称
            ,riskopenamt -- 备用主键
            ,loanform -- 贷款形式
            ,innerintcumu -- 表内欠息
            ,compoundint -- 利息复息
            ,biztype -- 贷款品种
            ,inneroffint -- 表内转表外利息
            ,cusid -- 客户代码
            ,cusmanager -- 客户经理
            ,factuse -- 实际用途
            ,loanstartdate -- 出帐日
            ,innerreceint -- 表内应收
            ,serno -- 任务编号
            ,prdpk -- 产品主键
            ,delayintcumu -- 欠息累计
            ,overduebalance -- 逾期贷款余额(元)
            ,cusname -- 客户名称
            ,sluggishbalance -- 呆滞贷款余额(元)
            ,cladate -- 五级分类日期
            ,biztypesub -- 业务品种细分
            ,realityirm -- 执行月利率
            ,loanform4 -- 四级分类标志
            ,normalbalance -- 正常贷款余额(元)
            ,appltype -- 业务类型
            ,riskamt -- 敞口余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 主键
    ,nvl(n.inputbrid, o.inputbrid) as inputbrid -- 所属分行
    ,nvl(n.overduereceint, o.overduereceint) as overduereceint -- 逾期应收
    ,nvl(n.firstdisbdate, o.firstdisbdate) as firstdisbdate -- 首次放款日期
    ,nvl(n.contamt, o.contamt) as contamt -- 业务合同金额
    ,nvl(n.loanamount, o.loanamount) as loanamount -- 出账金额
    ,nvl(n.loanenddate, o.loanenddate) as loanenddate -- 到期日
    ,nvl(n.finabrid, o.finabrid) as finabrid -- 账务机构
    ,nvl(n.prdtype, o.prdtype) as prdtype -- 产品类别
    ,nvl(n.repaymentmode, o.repaymentmode) as repaymentmode -- 还款方式
    ,nvl(n.billno, o.billno) as billno -- 借据编号
    ,nvl(n.loanbalance, o.loanbalance) as loanbalance -- 本期余额
    ,nvl(n.cla, o.cla) as cla -- 上期风险分类
    ,nvl(n.offint, o.offint) as offint -- 表外利息
    ,nvl(n.assuremeansmain, o.assuremeansmain) as assuremeansmain -- 主担保方式
    ,nvl(n.openamt, o.openamt) as openamt -- 敞口金额
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.doubtfulbalance, o.doubtfulbalance) as doubtfulbalance -- 呆账贷款余额(元)
    ,nvl(n.currencytype, o.currencytype) as currencytype -- 币种
    ,nvl(n.type, o.type) as type -- 借据类别：1、借款人2、保证人
    ,nvl(n.contno, o.contno) as contno -- 合同编号
    ,nvl(n.defaultflag, o.defaultflag) as defaultflag -- 违约标志
    ,nvl(n.offintcumu, o.offintcumu) as offintcumu -- 表外欠息
    ,nvl(n.prdname, o.prdname) as prdname -- 产品名称
    ,nvl(n.riskopenamt, o.riskopenamt) as riskopenamt -- 备用主键
    ,nvl(n.loanform, o.loanform) as loanform -- 贷款形式
    ,nvl(n.innerintcumu, o.innerintcumu) as innerintcumu -- 表内欠息
    ,nvl(n.compoundint, o.compoundint) as compoundint -- 利息复息
    ,nvl(n.biztype, o.biztype) as biztype -- 贷款品种
    ,nvl(n.inneroffint, o.inneroffint) as inneroffint -- 表内转表外利息
    ,nvl(n.cusid, o.cusid) as cusid -- 客户代码
    ,nvl(n.cusmanager, o.cusmanager) as cusmanager -- 客户经理
    ,nvl(n.factuse, o.factuse) as factuse -- 实际用途
    ,nvl(n.loanstartdate, o.loanstartdate) as loanstartdate -- 出帐日
    ,nvl(n.innerreceint, o.innerreceint) as innerreceint -- 表内应收
    ,nvl(n.serno, o.serno) as serno -- 任务编号
    ,nvl(n.prdpk, o.prdpk) as prdpk -- 产品主键
    ,nvl(n.delayintcumu, o.delayintcumu) as delayintcumu -- 欠息累计
    ,nvl(n.overduebalance, o.overduebalance) as overduebalance -- 逾期贷款余额(元)
    ,nvl(n.cusname, o.cusname) as cusname -- 客户名称
    ,nvl(n.sluggishbalance, o.sluggishbalance) as sluggishbalance -- 呆滞贷款余额(元)
    ,nvl(n.cladate, o.cladate) as cladate -- 五级分类日期
    ,nvl(n.biztypesub, o.biztypesub) as biztypesub -- 业务品种细分
    ,nvl(n.realityirm, o.realityirm) as realityirm -- 执行月利率
    ,nvl(n.loanform4, o.loanform4) as loanform4 -- 四级分类标志
    ,nvl(n.normalbalance, o.normalbalance) as normalbalance -- 正常贷款余额(元)
    ,nvl(n.appltype, o.appltype) as appltype -- 业务类型
    ,nvl(n.riskamt, o.riskamt) as riskamt -- 敞口余额
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
from (select * from ${iol_schema}.icms_psp_bill_list_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_psp_bill_list where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.inputbrid <> n.inputbrid
        or o.overduereceint <> n.overduereceint
        or o.firstdisbdate <> n.firstdisbdate
        or o.contamt <> n.contamt
        or o.loanamount <> n.loanamount
        or o.loanenddate <> n.loanenddate
        or o.finabrid <> n.finabrid
        or o.prdtype <> n.prdtype
        or o.repaymentmode <> n.repaymentmode
        or o.billno <> n.billno
        or o.loanbalance <> n.loanbalance
        or o.cla <> n.cla
        or o.offint <> n.offint
        or o.assuremeansmain <> n.assuremeansmain
        or o.openamt <> n.openamt
        or o.migtflag <> n.migtflag
        or o.doubtfulbalance <> n.doubtfulbalance
        or o.currencytype <> n.currencytype
        or o.type <> n.type
        or o.contno <> n.contno
        or o.defaultflag <> n.defaultflag
        or o.offintcumu <> n.offintcumu
        or o.prdname <> n.prdname
        or o.riskopenamt <> n.riskopenamt
        or o.loanform <> n.loanform
        or o.innerintcumu <> n.innerintcumu
        or o.compoundint <> n.compoundint
        or o.biztype <> n.biztype
        or o.inneroffint <> n.inneroffint
        or o.cusid <> n.cusid
        or o.cusmanager <> n.cusmanager
        or o.factuse <> n.factuse
        or o.loanstartdate <> n.loanstartdate
        or o.innerreceint <> n.innerreceint
        or o.serno <> n.serno
        or o.prdpk <> n.prdpk
        or o.delayintcumu <> n.delayintcumu
        or o.overduebalance <> n.overduebalance
        or o.cusname <> n.cusname
        or o.sluggishbalance <> n.sluggishbalance
        or o.cladate <> n.cladate
        or o.biztypesub <> n.biztypesub
        or o.realityirm <> n.realityirm
        or o.loanform4 <> n.loanform4
        or o.normalbalance <> n.normalbalance
        or o.appltype <> n.appltype
        or o.riskamt <> n.riskamt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_psp_bill_list_cl(
            serialno -- 主键
            ,inputbrid -- 所属分行
            ,overduereceint -- 逾期应收
            ,firstdisbdate -- 首次放款日期
            ,contamt -- 业务合同金额
            ,loanamount -- 出账金额
            ,loanenddate -- 到期日
            ,finabrid -- 账务机构
            ,prdtype -- 产品类别
            ,repaymentmode -- 还款方式
            ,billno -- 借据编号
            ,loanbalance -- 本期余额
            ,cla -- 上期风险分类
            ,offint -- 表外利息
            ,assuremeansmain -- 主担保方式
            ,openamt -- 敞口金额
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,doubtfulbalance -- 呆账贷款余额(元)
            ,currencytype -- 币种
            ,type -- 借据类别：1、借款人2、保证人
            ,contno -- 合同编号
            ,defaultflag -- 违约标志
            ,offintcumu -- 表外欠息
            ,prdname -- 产品名称
            ,riskopenamt -- 备用主键
            ,loanform -- 贷款形式
            ,innerintcumu -- 表内欠息
            ,compoundint -- 利息复息
            ,biztype -- 贷款品种
            ,inneroffint -- 表内转表外利息
            ,cusid -- 客户代码
            ,cusmanager -- 客户经理
            ,factuse -- 实际用途
            ,loanstartdate -- 出帐日
            ,innerreceint -- 表内应收
            ,serno -- 任务编号
            ,prdpk -- 产品主键
            ,delayintcumu -- 欠息累计
            ,overduebalance -- 逾期贷款余额(元)
            ,cusname -- 客户名称
            ,sluggishbalance -- 呆滞贷款余额(元)
            ,cladate -- 五级分类日期
            ,biztypesub -- 业务品种细分
            ,realityirm -- 执行月利率
            ,loanform4 -- 四级分类标志
            ,normalbalance -- 正常贷款余额(元)
            ,appltype -- 业务类型
            ,riskamt -- 敞口余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_psp_bill_list_op(
            serialno -- 主键
            ,inputbrid -- 所属分行
            ,overduereceint -- 逾期应收
            ,firstdisbdate -- 首次放款日期
            ,contamt -- 业务合同金额
            ,loanamount -- 出账金额
            ,loanenddate -- 到期日
            ,finabrid -- 账务机构
            ,prdtype -- 产品类别
            ,repaymentmode -- 还款方式
            ,billno -- 借据编号
            ,loanbalance -- 本期余额
            ,cla -- 上期风险分类
            ,offint -- 表外利息
            ,assuremeansmain -- 主担保方式
            ,openamt -- 敞口金额
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,doubtfulbalance -- 呆账贷款余额(元)
            ,currencytype -- 币种
            ,type -- 借据类别：1、借款人2、保证人
            ,contno -- 合同编号
            ,defaultflag -- 违约标志
            ,offintcumu -- 表外欠息
            ,prdname -- 产品名称
            ,riskopenamt -- 备用主键
            ,loanform -- 贷款形式
            ,innerintcumu -- 表内欠息
            ,compoundint -- 利息复息
            ,biztype -- 贷款品种
            ,inneroffint -- 表内转表外利息
            ,cusid -- 客户代码
            ,cusmanager -- 客户经理
            ,factuse -- 实际用途
            ,loanstartdate -- 出帐日
            ,innerreceint -- 表内应收
            ,serno -- 任务编号
            ,prdpk -- 产品主键
            ,delayintcumu -- 欠息累计
            ,overduebalance -- 逾期贷款余额(元)
            ,cusname -- 客户名称
            ,sluggishbalance -- 呆滞贷款余额(元)
            ,cladate -- 五级分类日期
            ,biztypesub -- 业务品种细分
            ,realityirm -- 执行月利率
            ,loanform4 -- 四级分类标志
            ,normalbalance -- 正常贷款余额(元)
            ,appltype -- 业务类型
            ,riskamt -- 敞口余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 主键
    ,o.inputbrid -- 所属分行
    ,o.overduereceint -- 逾期应收
    ,o.firstdisbdate -- 首次放款日期
    ,o.contamt -- 业务合同金额
    ,o.loanamount -- 出账金额
    ,o.loanenddate -- 到期日
    ,o.finabrid -- 账务机构
    ,o.prdtype -- 产品类别
    ,o.repaymentmode -- 还款方式
    ,o.billno -- 借据编号
    ,o.loanbalance -- 本期余额
    ,o.cla -- 上期风险分类
    ,o.offint -- 表外利息
    ,o.assuremeansmain -- 主担保方式
    ,o.openamt -- 敞口金额
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.doubtfulbalance -- 呆账贷款余额(元)
    ,o.currencytype -- 币种
    ,o.type -- 借据类别：1、借款人2、保证人
    ,o.contno -- 合同编号
    ,o.defaultflag -- 违约标志
    ,o.offintcumu -- 表外欠息
    ,o.prdname -- 产品名称
    ,o.riskopenamt -- 备用主键
    ,o.loanform -- 贷款形式
    ,o.innerintcumu -- 表内欠息
    ,o.compoundint -- 利息复息
    ,o.biztype -- 贷款品种
    ,o.inneroffint -- 表内转表外利息
    ,o.cusid -- 客户代码
    ,o.cusmanager -- 客户经理
    ,o.factuse -- 实际用途
    ,o.loanstartdate -- 出帐日
    ,o.innerreceint -- 表内应收
    ,o.serno -- 任务编号
    ,o.prdpk -- 产品主键
    ,o.delayintcumu -- 欠息累计
    ,o.overduebalance -- 逾期贷款余额(元)
    ,o.cusname -- 客户名称
    ,o.sluggishbalance -- 呆滞贷款余额(元)
    ,o.cladate -- 五级分类日期
    ,o.biztypesub -- 业务品种细分
    ,o.realityirm -- 执行月利率
    ,o.loanform4 -- 四级分类标志
    ,o.normalbalance -- 正常贷款余额(元)
    ,o.appltype -- 业务类型
    ,o.riskamt -- 敞口余额
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
from ${iol_schema}.icms_psp_bill_list_bk o
    left join ${iol_schema}.icms_psp_bill_list_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_psp_bill_list_cl d
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
--truncate table ${iol_schema}.icms_psp_bill_list;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_psp_bill_list') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_psp_bill_list drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_psp_bill_list add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_psp_bill_list exchange partition p_${batch_date} with table ${iol_schema}.icms_psp_bill_list_cl;
alter table ${iol_schema}.icms_psp_bill_list exchange partition p_20991231 with table ${iol_schema}.icms_psp_bill_list_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_psp_bill_list to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_psp_bill_list_op purge;
drop table ${iol_schema}.icms_psp_bill_list_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_psp_bill_list_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_psp_bill_list',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
