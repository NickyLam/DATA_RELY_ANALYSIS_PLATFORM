/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_resell_duebill
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
create table ${iol_schema}.icms_resell_duebill_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_resell_duebill
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_resell_duebill_op purge;
drop table ${iol_schema}.icms_resell_duebill_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_resell_duebill_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_resell_duebill where 0=1;

create table ${iol_schema}.icms_resell_duebill_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_resell_duebill where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_resell_duebill_cl(
            serialno -- 申请流水号
            ,reselltype -- 01境内转让、02行内转让、03跨境转让
            ,businesscurrency -- 币种
            ,balance -- 借据余额
            ,businesstype -- 业务品种
            ,openbankname -- 开证行
            ,inputdate -- 申请时间
            ,transferflag -- 转让标识字段(SUCCESS已转让)
            ,repayaccountno -- 还款账号
            ,transferdate -- 转让时间
            ,businesssum -- 借据金额
            ,duebillno -- 借据号
            ,tempsaveflag -- 暂存标志
            ,repayment -- 还款金额
            ,buybankname -- 包买行
            ,putoutno -- 核心出账流水号
            ,importcharges -- 汇入手续费支出
            ,masterserialno -- 主表流水号
            ,updatedate -- 更新时间
            ,salematurity -- 转卖到期日
            ,remnan -- 待摊金额(剩余利息摊销金额)
            ,inputuserid -- 申请人
            ,updateuserid -- 更新人
            ,customername -- 客户名
            ,bankhavesum -- 我行持有期间利息
            ,saleminsum -- 转出机构转让中间业务损益
            ,saleratio -- 卖出利率
            ,updateorgid -- 更新机构
            ,migtflag -- 
            ,customerid -- 客户号
            ,insaleminsum -- 转入机构转让中间业务损益
            ,putoutserialno -- 出账表出账流水号
            ,boughtsum -- 转卖收款金额
            ,inputorgid -- 申请机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_resell_duebill_op(
            serialno -- 申请流水号
            ,reselltype -- 01境内转让、02行内转让、03跨境转让
            ,businesscurrency -- 币种
            ,balance -- 借据余额
            ,businesstype -- 业务品种
            ,openbankname -- 开证行
            ,inputdate -- 申请时间
            ,transferflag -- 转让标识字段(SUCCESS已转让)
            ,repayaccountno -- 还款账号
            ,transferdate -- 转让时间
            ,businesssum -- 借据金额
            ,duebillno -- 借据号
            ,tempsaveflag -- 暂存标志
            ,repayment -- 还款金额
            ,buybankname -- 包买行
            ,putoutno -- 核心出账流水号
            ,importcharges -- 汇入手续费支出
            ,masterserialno -- 主表流水号
            ,updatedate -- 更新时间
            ,salematurity -- 转卖到期日
            ,remnan -- 待摊金额(剩余利息摊销金额)
            ,inputuserid -- 申请人
            ,updateuserid -- 更新人
            ,customername -- 客户名
            ,bankhavesum -- 我行持有期间利息
            ,saleminsum -- 转出机构转让中间业务损益
            ,saleratio -- 卖出利率
            ,updateorgid -- 更新机构
            ,migtflag -- 
            ,customerid -- 客户号
            ,insaleminsum -- 转入机构转让中间业务损益
            ,putoutserialno -- 出账表出账流水号
            ,boughtsum -- 转卖收款金额
            ,inputorgid -- 申请机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 申请流水号
    ,nvl(n.reselltype, o.reselltype) as reselltype -- 01境内转让、02行内转让、03跨境转让
    ,nvl(n.businesscurrency, o.businesscurrency) as businesscurrency -- 币种
    ,nvl(n.balance, o.balance) as balance -- 借据余额
    ,nvl(n.businesstype, o.businesstype) as businesstype -- 业务品种
    ,nvl(n.openbankname, o.openbankname) as openbankname -- 开证行
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 申请时间
    ,nvl(n.transferflag, o.transferflag) as transferflag -- 转让标识字段(SUCCESS已转让)
    ,nvl(n.repayaccountno, o.repayaccountno) as repayaccountno -- 还款账号
    ,nvl(n.transferdate, o.transferdate) as transferdate -- 转让时间
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 借据金额
    ,nvl(n.duebillno, o.duebillno) as duebillno -- 借据号
    ,nvl(n.tempsaveflag, o.tempsaveflag) as tempsaveflag -- 暂存标志
    ,nvl(n.repayment, o.repayment) as repayment -- 还款金额
    ,nvl(n.buybankname, o.buybankname) as buybankname -- 包买行
    ,nvl(n.putoutno, o.putoutno) as putoutno -- 核心出账流水号
    ,nvl(n.importcharges, o.importcharges) as importcharges -- 汇入手续费支出
    ,nvl(n.masterserialno, o.masterserialno) as masterserialno -- 主表流水号
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,nvl(n.salematurity, o.salematurity) as salematurity -- 转卖到期日
    ,nvl(n.remnan, o.remnan) as remnan -- 待摊金额(剩余利息摊销金额)
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 申请人
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.customername, o.customername) as customername -- 客户名
    ,nvl(n.bankhavesum, o.bankhavesum) as bankhavesum -- 我行持有期间利息
    ,nvl(n.saleminsum, o.saleminsum) as saleminsum -- 转出机构转让中间业务损益
    ,nvl(n.saleratio, o.saleratio) as saleratio -- 卖出利率
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.insaleminsum, o.insaleminsum) as insaleminsum -- 转入机构转让中间业务损益
    ,nvl(n.putoutserialno, o.putoutserialno) as putoutserialno -- 出账表出账流水号
    ,nvl(n.boughtsum, o.boughtsum) as boughtsum -- 转卖收款金额
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 申请机构
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
from (select * from ${iol_schema}.icms_resell_duebill_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_resell_duebill where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.reselltype <> n.reselltype
        or o.businesscurrency <> n.businesscurrency
        or o.balance <> n.balance
        or o.businesstype <> n.businesstype
        or o.openbankname <> n.openbankname
        or o.inputdate <> n.inputdate
        or o.transferflag <> n.transferflag
        or o.repayaccountno <> n.repayaccountno
        or o.transferdate <> n.transferdate
        or o.businesssum <> n.businesssum
        or o.duebillno <> n.duebillno
        or o.tempsaveflag <> n.tempsaveflag
        or o.repayment <> n.repayment
        or o.buybankname <> n.buybankname
        or o.putoutno <> n.putoutno
        or o.importcharges <> n.importcharges
        or o.masterserialno <> n.masterserialno
        or o.updatedate <> n.updatedate
        or o.salematurity <> n.salematurity
        or o.remnan <> n.remnan
        or o.inputuserid <> n.inputuserid
        or o.updateuserid <> n.updateuserid
        or o.customername <> n.customername
        or o.bankhavesum <> n.bankhavesum
        or o.saleminsum <> n.saleminsum
        or o.saleratio <> n.saleratio
        or o.updateorgid <> n.updateorgid
        or o.migtflag <> n.migtflag
        or o.customerid <> n.customerid
        or o.insaleminsum <> n.insaleminsum
        or o.putoutserialno <> n.putoutserialno
        or o.boughtsum <> n.boughtsum
        or o.inputorgid <> n.inputorgid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_resell_duebill_cl(
            serialno -- 申请流水号
            ,reselltype -- 01境内转让、02行内转让、03跨境转让
            ,businesscurrency -- 币种
            ,balance -- 借据余额
            ,businesstype -- 业务品种
            ,openbankname -- 开证行
            ,inputdate -- 申请时间
            ,transferflag -- 转让标识字段(SUCCESS已转让)
            ,repayaccountno -- 还款账号
            ,transferdate -- 转让时间
            ,businesssum -- 借据金额
            ,duebillno -- 借据号
            ,tempsaveflag -- 暂存标志
            ,repayment -- 还款金额
            ,buybankname -- 包买行
            ,putoutno -- 核心出账流水号
            ,importcharges -- 汇入手续费支出
            ,masterserialno -- 主表流水号
            ,updatedate -- 更新时间
            ,salematurity -- 转卖到期日
            ,remnan -- 待摊金额(剩余利息摊销金额)
            ,inputuserid -- 申请人
            ,updateuserid -- 更新人
            ,customername -- 客户名
            ,bankhavesum -- 我行持有期间利息
            ,saleminsum -- 转出机构转让中间业务损益
            ,saleratio -- 卖出利率
            ,updateorgid -- 更新机构
            ,migtflag -- 
            ,customerid -- 客户号
            ,insaleminsum -- 转入机构转让中间业务损益
            ,putoutserialno -- 出账表出账流水号
            ,boughtsum -- 转卖收款金额
            ,inputorgid -- 申请机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_resell_duebill_op(
            serialno -- 申请流水号
            ,reselltype -- 01境内转让、02行内转让、03跨境转让
            ,businesscurrency -- 币种
            ,balance -- 借据余额
            ,businesstype -- 业务品种
            ,openbankname -- 开证行
            ,inputdate -- 申请时间
            ,transferflag -- 转让标识字段(SUCCESS已转让)
            ,repayaccountno -- 还款账号
            ,transferdate -- 转让时间
            ,businesssum -- 借据金额
            ,duebillno -- 借据号
            ,tempsaveflag -- 暂存标志
            ,repayment -- 还款金额
            ,buybankname -- 包买行
            ,putoutno -- 核心出账流水号
            ,importcharges -- 汇入手续费支出
            ,masterserialno -- 主表流水号
            ,updatedate -- 更新时间
            ,salematurity -- 转卖到期日
            ,remnan -- 待摊金额(剩余利息摊销金额)
            ,inputuserid -- 申请人
            ,updateuserid -- 更新人
            ,customername -- 客户名
            ,bankhavesum -- 我行持有期间利息
            ,saleminsum -- 转出机构转让中间业务损益
            ,saleratio -- 卖出利率
            ,updateorgid -- 更新机构
            ,migtflag -- 
            ,customerid -- 客户号
            ,insaleminsum -- 转入机构转让中间业务损益
            ,putoutserialno -- 出账表出账流水号
            ,boughtsum -- 转卖收款金额
            ,inputorgid -- 申请机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 申请流水号
    ,o.reselltype -- 01境内转让、02行内转让、03跨境转让
    ,o.businesscurrency -- 币种
    ,o.balance -- 借据余额
    ,o.businesstype -- 业务品种
    ,o.openbankname -- 开证行
    ,o.inputdate -- 申请时间
    ,o.transferflag -- 转让标识字段(SUCCESS已转让)
    ,o.repayaccountno -- 还款账号
    ,o.transferdate -- 转让时间
    ,o.businesssum -- 借据金额
    ,o.duebillno -- 借据号
    ,o.tempsaveflag -- 暂存标志
    ,o.repayment -- 还款金额
    ,o.buybankname -- 包买行
    ,o.putoutno -- 核心出账流水号
    ,o.importcharges -- 汇入手续费支出
    ,o.masterserialno -- 主表流水号
    ,o.updatedate -- 更新时间
    ,o.salematurity -- 转卖到期日
    ,o.remnan -- 待摊金额(剩余利息摊销金额)
    ,o.inputuserid -- 申请人
    ,o.updateuserid -- 更新人
    ,o.customername -- 客户名
    ,o.bankhavesum -- 我行持有期间利息
    ,o.saleminsum -- 转出机构转让中间业务损益
    ,o.saleratio -- 卖出利率
    ,o.updateorgid -- 更新机构
    ,o.migtflag -- 
    ,o.customerid -- 客户号
    ,o.insaleminsum -- 转入机构转让中间业务损益
    ,o.putoutserialno -- 出账表出账流水号
    ,o.boughtsum -- 转卖收款金额
    ,o.inputorgid -- 申请机构
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
from ${iol_schema}.icms_resell_duebill_bk o
    left join ${iol_schema}.icms_resell_duebill_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_resell_duebill_cl d
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
--truncate table ${iol_schema}.icms_resell_duebill;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_resell_duebill') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_resell_duebill drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_resell_duebill add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_resell_duebill exchange partition p_${batch_date} with table ${iol_schema}.icms_resell_duebill_cl;
alter table ${iol_schema}.icms_resell_duebill exchange partition p_20991231 with table ${iol_schema}.icms_resell_duebill_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_resell_duebill to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_resell_duebill_op purge;
drop table ${iol_schema}.icms_resell_duebill_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_resell_duebill_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_resell_duebill',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
