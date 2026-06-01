/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_afterloan_relative
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
create table ${iol_schema}.icms_ap_afterloan_relative_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_afterloan_relative
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_afterloan_relative_op purge;
drop table ${iol_schema}.icms_ap_afterloan_relative_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_afterloan_relative_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_afterloan_relative where 0=1;

create table ${iol_schema}.icms_ap_afterloan_relative_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_afterloan_relative where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_afterloan_relative_cl(
            balance -- 减免前本金汇总(本金汇总)
            ,classify -- 本次资产分类
            ,completeflag -- 完善标识
            ,disposalplan -- 处置计划及进展
            ,hangseqno -- 挂账账户序列号(不良转让核心成功后返回，分期回款需要用到)
            ,inputdate -- 登记时间
            ,inputorgid -- 登记人所属机构
            ,inputuserid -- 登记人
            ,lfbusinesssum -- 减免本金(正常本金)
            ,lfjtcompoundintratio -- 减免计提复利(计提复利)
            ,lfjtintamt -- 减免计提利息(计提利息)
            ,lfjtodpamt -- 减免计提罚息(计提罚息)
            ,lfoverduebalance -- 减免逾期本金(逾期本金)
            ,lfserate -- 减免利率
            ,lfsjcompoundintratio -- 减免实欠复利(实欠复利)
            ,lfsjintamt -- 减免实欠利息(实欠利息)
            ,lfsqodpamt -- 减免实欠罚息(实欠罚息)
            ,loanstatus -- 核算状态
            ,objecttype -- 业务类型
            ,oldclassify -- 上次资产分类
            ,propertyclue -- 资产线索
            ,relserialno -- 关联流水号
            ,remark -- 其他需要说明的情况
            ,responsecode -- 核心返回结果
            ,responsemessage -- 核心返回结果
            ,returnedaftermoney -- 本次回款后应收款金额
            ,returnedbeforemoney -- 本次回款前应收款金额
            ,returnedmoneysum -- 累计回款金额
            ,reversal -- 冲正标识(冲正状态)
            ,serialno -- 流水号
            ,ssjz -- 诉讼进展
            ,transferprice -- 分配转让价格
            ,transfersqprice -- 分配转让首期价格
            ,transferyskprice -- 分配转让应收款价格
            ,updatedate -- 更新日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,wrnddfyamt -- 核销代垫费用
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_afterloan_relative_op(
            balance -- 减免前本金汇总(本金汇总)
            ,classify -- 本次资产分类
            ,completeflag -- 完善标识
            ,disposalplan -- 处置计划及进展
            ,hangseqno -- 挂账账户序列号(不良转让核心成功后返回，分期回款需要用到)
            ,inputdate -- 登记时间
            ,inputorgid -- 登记人所属机构
            ,inputuserid -- 登记人
            ,lfbusinesssum -- 减免本金(正常本金)
            ,lfjtcompoundintratio -- 减免计提复利(计提复利)
            ,lfjtintamt -- 减免计提利息(计提利息)
            ,lfjtodpamt -- 减免计提罚息(计提罚息)
            ,lfoverduebalance -- 减免逾期本金(逾期本金)
            ,lfserate -- 减免利率
            ,lfsjcompoundintratio -- 减免实欠复利(实欠复利)
            ,lfsjintamt -- 减免实欠利息(实欠利息)
            ,lfsqodpamt -- 减免实欠罚息(实欠罚息)
            ,loanstatus -- 核算状态
            ,objecttype -- 业务类型
            ,oldclassify -- 上次资产分类
            ,propertyclue -- 资产线索
            ,relserialno -- 关联流水号
            ,remark -- 其他需要说明的情况
            ,responsecode -- 核心返回结果
            ,responsemessage -- 核心返回结果
            ,returnedaftermoney -- 本次回款后应收款金额
            ,returnedbeforemoney -- 本次回款前应收款金额
            ,returnedmoneysum -- 累计回款金额
            ,reversal -- 冲正标识(冲正状态)
            ,serialno -- 流水号
            ,ssjz -- 诉讼进展
            ,transferprice -- 分配转让价格
            ,transfersqprice -- 分配转让首期价格
            ,transferyskprice -- 分配转让应收款价格
            ,updatedate -- 更新日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,wrnddfyamt -- 核销代垫费用
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.balance, o.balance) as balance -- 减免前本金汇总(本金汇总)
    ,nvl(n.classify, o.classify) as classify -- 本次资产分类
    ,nvl(n.completeflag, o.completeflag) as completeflag -- 完善标识
    ,nvl(n.disposalplan, o.disposalplan) as disposalplan -- 处置计划及进展
    ,nvl(n.hangseqno, o.hangseqno) as hangseqno -- 挂账账户序列号(不良转让核心成功后返回，分期回款需要用到)
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记人所属机构
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.lfbusinesssum, o.lfbusinesssum) as lfbusinesssum -- 减免本金(正常本金)
    ,nvl(n.lfjtcompoundintratio, o.lfjtcompoundintratio) as lfjtcompoundintratio -- 减免计提复利(计提复利)
    ,nvl(n.lfjtintamt, o.lfjtintamt) as lfjtintamt -- 减免计提利息(计提利息)
    ,nvl(n.lfjtodpamt, o.lfjtodpamt) as lfjtodpamt -- 减免计提罚息(计提罚息)
    ,nvl(n.lfoverduebalance, o.lfoverduebalance) as lfoverduebalance -- 减免逾期本金(逾期本金)
    ,nvl(n.lfserate, o.lfserate) as lfserate -- 减免利率
    ,nvl(n.lfsjcompoundintratio, o.lfsjcompoundintratio) as lfsjcompoundintratio -- 减免实欠复利(实欠复利)
    ,nvl(n.lfsjintamt, o.lfsjintamt) as lfsjintamt -- 减免实欠利息(实欠利息)
    ,nvl(n.lfsqodpamt, o.lfsqodpamt) as lfsqodpamt -- 减免实欠罚息(实欠罚息)
    ,nvl(n.loanstatus, o.loanstatus) as loanstatus -- 核算状态
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 业务类型
    ,nvl(n.oldclassify, o.oldclassify) as oldclassify -- 上次资产分类
    ,nvl(n.propertyclue, o.propertyclue) as propertyclue -- 资产线索
    ,nvl(n.relserialno, o.relserialno) as relserialno -- 关联流水号
    ,nvl(n.remark, o.remark) as remark -- 其他需要说明的情况
    ,nvl(n.responsecode, o.responsecode) as responsecode -- 核心返回结果
    ,nvl(n.responsemessage, o.responsemessage) as responsemessage -- 核心返回结果
    ,nvl(n.returnedaftermoney, o.returnedaftermoney) as returnedaftermoney -- 本次回款后应收款金额
    ,nvl(n.returnedbeforemoney, o.returnedbeforemoney) as returnedbeforemoney -- 本次回款前应收款金额
    ,nvl(n.returnedmoneysum, o.returnedmoneysum) as returnedmoneysum -- 累计回款金额
    ,nvl(n.reversal, o.reversal) as reversal -- 冲正标识(冲正状态)
    ,nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.ssjz, o.ssjz) as ssjz -- 诉讼进展
    ,nvl(n.transferprice, o.transferprice) as transferprice -- 分配转让价格
    ,nvl(n.transfersqprice, o.transfersqprice) as transfersqprice -- 分配转让首期价格
    ,nvl(n.transferyskprice, o.transferyskprice) as transferyskprice -- 分配转让应收款价格
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.wrnddfyamt, o.wrnddfyamt) as wrnddfyamt -- 核销代垫费用
    ,case when
            n.objecttype is null
            and n.relserialno is null
            and n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.objecttype is null
            and n.relserialno is null
            and n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.objecttype is null
            and n.relserialno is null
            and n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_afterloan_relative_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_afterloan_relative where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.objecttype = n.objecttype
            and o.relserialno = n.relserialno
            and o.serialno = n.serialno
where (
        o.objecttype is null
        and o.relserialno is null
        and o.serialno is null
    )
    or (
        n.objecttype is null
        and n.relserialno is null
        and n.serialno is null
    )
    or (
        o.balance <> n.balance
        or o.classify <> n.classify
        or o.completeflag <> n.completeflag
        or o.disposalplan <> n.disposalplan
        or o.hangseqno <> n.hangseqno
        or o.inputdate <> n.inputdate
        or o.inputorgid <> n.inputorgid
        or o.inputuserid <> n.inputuserid
        or o.lfbusinesssum <> n.lfbusinesssum
        or o.lfjtcompoundintratio <> n.lfjtcompoundintratio
        or o.lfjtintamt <> n.lfjtintamt
        or o.lfjtodpamt <> n.lfjtodpamt
        or o.lfoverduebalance <> n.lfoverduebalance
        or o.lfserate <> n.lfserate
        or o.lfsjcompoundintratio <> n.lfsjcompoundintratio
        or o.lfsjintamt <> n.lfsjintamt
        or o.lfsqodpamt <> n.lfsqodpamt
        or o.loanstatus <> n.loanstatus
        or o.oldclassify <> n.oldclassify
        or o.propertyclue <> n.propertyclue
        or o.remark <> n.remark
        or o.responsecode <> n.responsecode
        or o.responsemessage <> n.responsemessage
        or o.returnedaftermoney <> n.returnedaftermoney
        or o.returnedbeforemoney <> n.returnedbeforemoney
        or o.returnedmoneysum <> n.returnedmoneysum
        or o.reversal <> n.reversal
        or o.ssjz <> n.ssjz
        or o.transferprice <> n.transferprice
        or o.transfersqprice <> n.transfersqprice
        or o.transferyskprice <> n.transferyskprice
        or o.updatedate <> n.updatedate
        or o.updateorgid <> n.updateorgid
        or o.updateuserid <> n.updateuserid
        or o.wrnddfyamt <> n.wrnddfyamt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_afterloan_relative_cl(
            balance -- 减免前本金汇总(本金汇总)
            ,classify -- 本次资产分类
            ,completeflag -- 完善标识
            ,disposalplan -- 处置计划及进展
            ,hangseqno -- 挂账账户序列号(不良转让核心成功后返回，分期回款需要用到)
            ,inputdate -- 登记时间
            ,inputorgid -- 登记人所属机构
            ,inputuserid -- 登记人
            ,lfbusinesssum -- 减免本金(正常本金)
            ,lfjtcompoundintratio -- 减免计提复利(计提复利)
            ,lfjtintamt -- 减免计提利息(计提利息)
            ,lfjtodpamt -- 减免计提罚息(计提罚息)
            ,lfoverduebalance -- 减免逾期本金(逾期本金)
            ,lfserate -- 减免利率
            ,lfsjcompoundintratio -- 减免实欠复利(实欠复利)
            ,lfsjintamt -- 减免实欠利息(实欠利息)
            ,lfsqodpamt -- 减免实欠罚息(实欠罚息)
            ,loanstatus -- 核算状态
            ,objecttype -- 业务类型
            ,oldclassify -- 上次资产分类
            ,propertyclue -- 资产线索
            ,relserialno -- 关联流水号
            ,remark -- 其他需要说明的情况
            ,responsecode -- 核心返回结果
            ,responsemessage -- 核心返回结果
            ,returnedaftermoney -- 本次回款后应收款金额
            ,returnedbeforemoney -- 本次回款前应收款金额
            ,returnedmoneysum -- 累计回款金额
            ,reversal -- 冲正标识(冲正状态)
            ,serialno -- 流水号
            ,ssjz -- 诉讼进展
            ,transferprice -- 分配转让价格
            ,transfersqprice -- 分配转让首期价格
            ,transferyskprice -- 分配转让应收款价格
            ,updatedate -- 更新日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,wrnddfyamt -- 核销代垫费用
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_afterloan_relative_op(
            balance -- 减免前本金汇总(本金汇总)
            ,classify -- 本次资产分类
            ,completeflag -- 完善标识
            ,disposalplan -- 处置计划及进展
            ,hangseqno -- 挂账账户序列号(不良转让核心成功后返回，分期回款需要用到)
            ,inputdate -- 登记时间
            ,inputorgid -- 登记人所属机构
            ,inputuserid -- 登记人
            ,lfbusinesssum -- 减免本金(正常本金)
            ,lfjtcompoundintratio -- 减免计提复利(计提复利)
            ,lfjtintamt -- 减免计提利息(计提利息)
            ,lfjtodpamt -- 减免计提罚息(计提罚息)
            ,lfoverduebalance -- 减免逾期本金(逾期本金)
            ,lfserate -- 减免利率
            ,lfsjcompoundintratio -- 减免实欠复利(实欠复利)
            ,lfsjintamt -- 减免实欠利息(实欠利息)
            ,lfsqodpamt -- 减免实欠罚息(实欠罚息)
            ,loanstatus -- 核算状态
            ,objecttype -- 业务类型
            ,oldclassify -- 上次资产分类
            ,propertyclue -- 资产线索
            ,relserialno -- 关联流水号
            ,remark -- 其他需要说明的情况
            ,responsecode -- 核心返回结果
            ,responsemessage -- 核心返回结果
            ,returnedaftermoney -- 本次回款后应收款金额
            ,returnedbeforemoney -- 本次回款前应收款金额
            ,returnedmoneysum -- 累计回款金额
            ,reversal -- 冲正标识(冲正状态)
            ,serialno -- 流水号
            ,ssjz -- 诉讼进展
            ,transferprice -- 分配转让价格
            ,transfersqprice -- 分配转让首期价格
            ,transferyskprice -- 分配转让应收款价格
            ,updatedate -- 更新日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,wrnddfyamt -- 核销代垫费用
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.balance -- 减免前本金汇总(本金汇总)
    ,o.classify -- 本次资产分类
    ,o.completeflag -- 完善标识
    ,o.disposalplan -- 处置计划及进展
    ,o.hangseqno -- 挂账账户序列号(不良转让核心成功后返回，分期回款需要用到)
    ,o.inputdate -- 登记时间
    ,o.inputorgid -- 登记人所属机构
    ,o.inputuserid -- 登记人
    ,o.lfbusinesssum -- 减免本金(正常本金)
    ,o.lfjtcompoundintratio -- 减免计提复利(计提复利)
    ,o.lfjtintamt -- 减免计提利息(计提利息)
    ,o.lfjtodpamt -- 减免计提罚息(计提罚息)
    ,o.lfoverduebalance -- 减免逾期本金(逾期本金)
    ,o.lfserate -- 减免利率
    ,o.lfsjcompoundintratio -- 减免实欠复利(实欠复利)
    ,o.lfsjintamt -- 减免实欠利息(实欠利息)
    ,o.lfsqodpamt -- 减免实欠罚息(实欠罚息)
    ,o.loanstatus -- 核算状态
    ,o.objecttype -- 业务类型
    ,o.oldclassify -- 上次资产分类
    ,o.propertyclue -- 资产线索
    ,o.relserialno -- 关联流水号
    ,o.remark -- 其他需要说明的情况
    ,o.responsecode -- 核心返回结果
    ,o.responsemessage -- 核心返回结果
    ,o.returnedaftermoney -- 本次回款后应收款金额
    ,o.returnedbeforemoney -- 本次回款前应收款金额
    ,o.returnedmoneysum -- 累计回款金额
    ,o.reversal -- 冲正标识(冲正状态)
    ,o.serialno -- 流水号
    ,o.ssjz -- 诉讼进展
    ,o.transferprice -- 分配转让价格
    ,o.transfersqprice -- 分配转让首期价格
    ,o.transferyskprice -- 分配转让应收款价格
    ,o.updatedate -- 更新日期
    ,o.updateorgid -- 更新机构
    ,o.updateuserid -- 更新人
    ,o.wrnddfyamt -- 核销代垫费用
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
from ${iol_schema}.icms_ap_afterloan_relative_bk o
    left join ${iol_schema}.icms_ap_afterloan_relative_op n
        on
            o.objecttype = n.objecttype
            and o.relserialno = n.relserialno
            and o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_afterloan_relative_cl d
        on
            o.objecttype = d.objecttype
            and o.relserialno = d.relserialno
            and o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_afterloan_relative;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_afterloan_relative') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_afterloan_relative drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_afterloan_relative add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_afterloan_relative exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_afterloan_relative_cl;
alter table ${iol_schema}.icms_ap_afterloan_relative exchange partition p_20991231 with table ${iol_schema}.icms_ap_afterloan_relative_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_afterloan_relative to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_afterloan_relative_op purge;
drop table ${iol_schema}.icms_ap_afterloan_relative_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_afterloan_relative_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_afterloan_relative',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
