/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_online_liudai
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
create table ${iol_schema}.icms_online_liudai_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_online_liudai
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_online_liudai_op purge;
drop table ${iol_schema}.icms_online_liudai_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_online_liudai_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_online_liudai where 0=1;

create table ${iol_schema}.icms_online_liudai_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_online_liudai where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_online_liudai_cl(
            serialno -- 在线贴现申请流水号
            ,purchaserpercent -- 买方承担比例
            ,otherpayment -- 流贷其他支付方式
            ,totalcopies -- 合同总份数
            ,yfaddress -- 乙方送达地址
            ,certdn -- 用户秘钥
            ,bargainorpercent -- 卖方承担比例
            ,inputtime -- 申请发起时间
            ,partsum -- 受托支付起始金额
            ,otherloancondition -- 流贷其他贷款发放条件
            ,migtflag -- 
            ,status -- 流贷申请状态:01-待处理02-审批中03-已放款04-已驳回
            ,notarizationflag -- 是否强制执行公证
            ,partybduty -- 流贷借款人法定代表人职务
            ,loancondition -- 流贷：1本合同生效后2本合同已经生效，并且相关的担保合同已经签署，需要办理登记或备案、公证手续的，相关手续已经办妥3其他
            ,afeerate -- 承兑手续费
            ,term -- 流贷贷款期限（格式：2017/04/21）
            ,partyacopies -- 甲方执合同份数
            ,contractname -- 流贷借新还旧合同名称
            ,businesssum -- 流贷贷款金额
            ,otherpurpose -- 流贷其他贷款用途
            ,othersolution -- 其他争议解决方式
            ,electronpurpose -- 流贷电子合同中贷款用途选项Purpose
            ,payment -- 流贷：1全额受托支付2部分受托支付3全额自主支付4其他
            ,jyseriano -- 唯一标识
            ,arbitration -- 仲裁机构
            ,otherpaymentcondition -- 流贷其他支付条件
            ,mfcustomerid -- 核心客户号
            ,acceptinttype -- 贴现利息承担方式
            ,informcycle -- 流贷支付情况告知周期
            ,purchaser -- 买方
            ,solution -- 争议解决方式
            ,contractno -- 关联合同流水号
            ,contractno1 -- 流贷借新还旧合同编号
            ,otherpaymentchangecondition -- 流贷其他支付方式变更条件
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_online_liudai_op(
            serialno -- 在线贴现申请流水号
            ,purchaserpercent -- 买方承担比例
            ,otherpayment -- 流贷其他支付方式
            ,totalcopies -- 合同总份数
            ,yfaddress -- 乙方送达地址
            ,certdn -- 用户秘钥
            ,bargainorpercent -- 卖方承担比例
            ,inputtime -- 申请发起时间
            ,partsum -- 受托支付起始金额
            ,otherloancondition -- 流贷其他贷款发放条件
            ,migtflag -- 
            ,status -- 流贷申请状态:01-待处理02-审批中03-已放款04-已驳回
            ,notarizationflag -- 是否强制执行公证
            ,partybduty -- 流贷借款人法定代表人职务
            ,loancondition -- 流贷：1本合同生效后2本合同已经生效，并且相关的担保合同已经签署，需要办理登记或备案、公证手续的，相关手续已经办妥3其他
            ,afeerate -- 承兑手续费
            ,term -- 流贷贷款期限（格式：2017/04/21）
            ,partyacopies -- 甲方执合同份数
            ,contractname -- 流贷借新还旧合同名称
            ,businesssum -- 流贷贷款金额
            ,otherpurpose -- 流贷其他贷款用途
            ,othersolution -- 其他争议解决方式
            ,electronpurpose -- 流贷电子合同中贷款用途选项Purpose
            ,payment -- 流贷：1全额受托支付2部分受托支付3全额自主支付4其他
            ,jyseriano -- 唯一标识
            ,arbitration -- 仲裁机构
            ,otherpaymentcondition -- 流贷其他支付条件
            ,mfcustomerid -- 核心客户号
            ,acceptinttype -- 贴现利息承担方式
            ,informcycle -- 流贷支付情况告知周期
            ,purchaser -- 买方
            ,solution -- 争议解决方式
            ,contractno -- 关联合同流水号
            ,contractno1 -- 流贷借新还旧合同编号
            ,otherpaymentchangecondition -- 流贷其他支付方式变更条件
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 在线贴现申请流水号
    ,nvl(n.purchaserpercent, o.purchaserpercent) as purchaserpercent -- 买方承担比例
    ,nvl(n.otherpayment, o.otherpayment) as otherpayment -- 流贷其他支付方式
    ,nvl(n.totalcopies, o.totalcopies) as totalcopies -- 合同总份数
    ,nvl(n.yfaddress, o.yfaddress) as yfaddress -- 乙方送达地址
    ,nvl(n.certdn, o.certdn) as certdn -- 用户秘钥
    ,nvl(n.bargainorpercent, o.bargainorpercent) as bargainorpercent -- 卖方承担比例
    ,nvl(n.inputtime, o.inputtime) as inputtime -- 申请发起时间
    ,nvl(n.partsum, o.partsum) as partsum -- 受托支付起始金额
    ,nvl(n.otherloancondition, o.otherloancondition) as otherloancondition -- 流贷其他贷款发放条件
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.status, o.status) as status -- 流贷申请状态:01-待处理02-审批中03-已放款04-已驳回
    ,nvl(n.notarizationflag, o.notarizationflag) as notarizationflag -- 是否强制执行公证
    ,nvl(n.partybduty, o.partybduty) as partybduty -- 流贷借款人法定代表人职务
    ,nvl(n.loancondition, o.loancondition) as loancondition -- 流贷：1本合同生效后2本合同已经生效，并且相关的担保合同已经签署，需要办理登记或备案、公证手续的，相关手续已经办妥3其他
    ,nvl(n.afeerate, o.afeerate) as afeerate -- 承兑手续费
    ,nvl(n.term, o.term) as term -- 流贷贷款期限（格式：2017/04/21）
    ,nvl(n.partyacopies, o.partyacopies) as partyacopies -- 甲方执合同份数
    ,nvl(n.contractname, o.contractname) as contractname -- 流贷借新还旧合同名称
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 流贷贷款金额
    ,nvl(n.otherpurpose, o.otherpurpose) as otherpurpose -- 流贷其他贷款用途
    ,nvl(n.othersolution, o.othersolution) as othersolution -- 其他争议解决方式
    ,nvl(n.electronpurpose, o.electronpurpose) as electronpurpose -- 流贷电子合同中贷款用途选项Purpose
    ,nvl(n.payment, o.payment) as payment -- 流贷：1全额受托支付2部分受托支付3全额自主支付4其他
    ,nvl(n.jyseriano, o.jyseriano) as jyseriano -- 唯一标识
    ,nvl(n.arbitration, o.arbitration) as arbitration -- 仲裁机构
    ,nvl(n.otherpaymentcondition, o.otherpaymentcondition) as otherpaymentcondition -- 流贷其他支付条件
    ,nvl(n.mfcustomerid, o.mfcustomerid) as mfcustomerid -- 核心客户号
    ,nvl(n.acceptinttype, o.acceptinttype) as acceptinttype -- 贴现利息承担方式
    ,nvl(n.informcycle, o.informcycle) as informcycle -- 流贷支付情况告知周期
    ,nvl(n.purchaser, o.purchaser) as purchaser -- 买方
    ,nvl(n.solution, o.solution) as solution -- 争议解决方式
    ,nvl(n.contractno, o.contractno) as contractno -- 关联合同流水号
    ,nvl(n.contractno1, o.contractno1) as contractno1 -- 流贷借新还旧合同编号
    ,nvl(n.otherpaymentchangecondition, o.otherpaymentchangecondition) as otherpaymentchangecondition -- 流贷其他支付方式变更条件
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
from (select * from ${iol_schema}.icms_online_liudai_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_online_liudai where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.purchaserpercent <> n.purchaserpercent
        or o.otherpayment <> n.otherpayment
        or o.totalcopies <> n.totalcopies
        or o.yfaddress <> n.yfaddress
        or o.certdn <> n.certdn
        or o.bargainorpercent <> n.bargainorpercent
        or o.inputtime <> n.inputtime
        or o.partsum <> n.partsum
        or o.otherloancondition <> n.otherloancondition
        or o.migtflag <> n.migtflag
        or o.status <> n.status
        or o.notarizationflag <> n.notarizationflag
        or o.partybduty <> n.partybduty
        or o.loancondition <> n.loancondition
        or o.afeerate <> n.afeerate
        or o.term <> n.term
        or o.partyacopies <> n.partyacopies
        or o.contractname <> n.contractname
        or o.businesssum <> n.businesssum
        or o.otherpurpose <> n.otherpurpose
        or o.othersolution <> n.othersolution
        or o.electronpurpose <> n.electronpurpose
        or o.payment <> n.payment
        or o.jyseriano <> n.jyseriano
        or o.arbitration <> n.arbitration
        or o.otherpaymentcondition <> n.otherpaymentcondition
        or o.mfcustomerid <> n.mfcustomerid
        or o.acceptinttype <> n.acceptinttype
        or o.informcycle <> n.informcycle
        or o.purchaser <> n.purchaser
        or o.solution <> n.solution
        or o.contractno <> n.contractno
        or o.contractno1 <> n.contractno1
        or o.otherpaymentchangecondition <> n.otherpaymentchangecondition
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_online_liudai_cl(
            serialno -- 在线贴现申请流水号
            ,purchaserpercent -- 买方承担比例
            ,otherpayment -- 流贷其他支付方式
            ,totalcopies -- 合同总份数
            ,yfaddress -- 乙方送达地址
            ,certdn -- 用户秘钥
            ,bargainorpercent -- 卖方承担比例
            ,inputtime -- 申请发起时间
            ,partsum -- 受托支付起始金额
            ,otherloancondition -- 流贷其他贷款发放条件
            ,migtflag -- 
            ,status -- 流贷申请状态:01-待处理02-审批中03-已放款04-已驳回
            ,notarizationflag -- 是否强制执行公证
            ,partybduty -- 流贷借款人法定代表人职务
            ,loancondition -- 流贷：1本合同生效后2本合同已经生效，并且相关的担保合同已经签署，需要办理登记或备案、公证手续的，相关手续已经办妥3其他
            ,afeerate -- 承兑手续费
            ,term -- 流贷贷款期限（格式：2017/04/21）
            ,partyacopies -- 甲方执合同份数
            ,contractname -- 流贷借新还旧合同名称
            ,businesssum -- 流贷贷款金额
            ,otherpurpose -- 流贷其他贷款用途
            ,othersolution -- 其他争议解决方式
            ,electronpurpose -- 流贷电子合同中贷款用途选项Purpose
            ,payment -- 流贷：1全额受托支付2部分受托支付3全额自主支付4其他
            ,jyseriano -- 唯一标识
            ,arbitration -- 仲裁机构
            ,otherpaymentcondition -- 流贷其他支付条件
            ,mfcustomerid -- 核心客户号
            ,acceptinttype -- 贴现利息承担方式
            ,informcycle -- 流贷支付情况告知周期
            ,purchaser -- 买方
            ,solution -- 争议解决方式
            ,contractno -- 关联合同流水号
            ,contractno1 -- 流贷借新还旧合同编号
            ,otherpaymentchangecondition -- 流贷其他支付方式变更条件
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_online_liudai_op(
            serialno -- 在线贴现申请流水号
            ,purchaserpercent -- 买方承担比例
            ,otherpayment -- 流贷其他支付方式
            ,totalcopies -- 合同总份数
            ,yfaddress -- 乙方送达地址
            ,certdn -- 用户秘钥
            ,bargainorpercent -- 卖方承担比例
            ,inputtime -- 申请发起时间
            ,partsum -- 受托支付起始金额
            ,otherloancondition -- 流贷其他贷款发放条件
            ,migtflag -- 
            ,status -- 流贷申请状态:01-待处理02-审批中03-已放款04-已驳回
            ,notarizationflag -- 是否强制执行公证
            ,partybduty -- 流贷借款人法定代表人职务
            ,loancondition -- 流贷：1本合同生效后2本合同已经生效，并且相关的担保合同已经签署，需要办理登记或备案、公证手续的，相关手续已经办妥3其他
            ,afeerate -- 承兑手续费
            ,term -- 流贷贷款期限（格式：2017/04/21）
            ,partyacopies -- 甲方执合同份数
            ,contractname -- 流贷借新还旧合同名称
            ,businesssum -- 流贷贷款金额
            ,otherpurpose -- 流贷其他贷款用途
            ,othersolution -- 其他争议解决方式
            ,electronpurpose -- 流贷电子合同中贷款用途选项Purpose
            ,payment -- 流贷：1全额受托支付2部分受托支付3全额自主支付4其他
            ,jyseriano -- 唯一标识
            ,arbitration -- 仲裁机构
            ,otherpaymentcondition -- 流贷其他支付条件
            ,mfcustomerid -- 核心客户号
            ,acceptinttype -- 贴现利息承担方式
            ,informcycle -- 流贷支付情况告知周期
            ,purchaser -- 买方
            ,solution -- 争议解决方式
            ,contractno -- 关联合同流水号
            ,contractno1 -- 流贷借新还旧合同编号
            ,otherpaymentchangecondition -- 流贷其他支付方式变更条件
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 在线贴现申请流水号
    ,o.purchaserpercent -- 买方承担比例
    ,o.otherpayment -- 流贷其他支付方式
    ,o.totalcopies -- 合同总份数
    ,o.yfaddress -- 乙方送达地址
    ,o.certdn -- 用户秘钥
    ,o.bargainorpercent -- 卖方承担比例
    ,o.inputtime -- 申请发起时间
    ,o.partsum -- 受托支付起始金额
    ,o.otherloancondition -- 流贷其他贷款发放条件
    ,o.migtflag -- 
    ,o.status -- 流贷申请状态:01-待处理02-审批中03-已放款04-已驳回
    ,o.notarizationflag -- 是否强制执行公证
    ,o.partybduty -- 流贷借款人法定代表人职务
    ,o.loancondition -- 流贷：1本合同生效后2本合同已经生效，并且相关的担保合同已经签署，需要办理登记或备案、公证手续的，相关手续已经办妥3其他
    ,o.afeerate -- 承兑手续费
    ,o.term -- 流贷贷款期限（格式：2017/04/21）
    ,o.partyacopies -- 甲方执合同份数
    ,o.contractname -- 流贷借新还旧合同名称
    ,o.businesssum -- 流贷贷款金额
    ,o.otherpurpose -- 流贷其他贷款用途
    ,o.othersolution -- 其他争议解决方式
    ,o.electronpurpose -- 流贷电子合同中贷款用途选项Purpose
    ,o.payment -- 流贷：1全额受托支付2部分受托支付3全额自主支付4其他
    ,o.jyseriano -- 唯一标识
    ,o.arbitration -- 仲裁机构
    ,o.otherpaymentcondition -- 流贷其他支付条件
    ,o.mfcustomerid -- 核心客户号
    ,o.acceptinttype -- 贴现利息承担方式
    ,o.informcycle -- 流贷支付情况告知周期
    ,o.purchaser -- 买方
    ,o.solution -- 争议解决方式
    ,o.contractno -- 关联合同流水号
    ,o.contractno1 -- 流贷借新还旧合同编号
    ,o.otherpaymentchangecondition -- 流贷其他支付方式变更条件
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
from ${iol_schema}.icms_online_liudai_bk o
    left join ${iol_schema}.icms_online_liudai_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_online_liudai_cl d
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
--truncate table ${iol_schema}.icms_online_liudai;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_online_liudai') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_online_liudai drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_online_liudai add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_online_liudai exchange partition p_${batch_date} with table ${iol_schema}.icms_online_liudai_cl;
alter table ${iol_schema}.icms_online_liudai exchange partition p_20991231 with table ${iol_schema}.icms_online_liudai_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_online_liudai to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_online_liudai_op purge;
drop table ${iol_schema}.icms_online_liudai_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_online_liudai_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_online_liudai',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
