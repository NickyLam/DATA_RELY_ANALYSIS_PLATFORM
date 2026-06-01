/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_online_tiexian
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
create table ${iol_schema}.icms_online_tiexian_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_online_tiexian
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_online_tiexian_op purge;
drop table ${iol_schema}.icms_online_tiexian_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_online_tiexian_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_online_tiexian where 0=1;

create table ${iol_schema}.icms_online_tiexian_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_online_tiexian where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_online_tiexian_cl(
            serialno -- 在线贴现申请流水号
            ,mfcustomerid -- 核心客户号
            ,purchaser -- 买方
            ,solution -- 争议解决方式
            ,belongorgid -- 
            ,partyaprincipal -- 贴现人负责人(新增)
            ,afeerate -- 贴现利率
            ,partyacopies -- 甲方执合同份数
            ,totalcopies -- 合同总份数
            ,partyaduty -- 贴现人负责人职务(新增)
            ,partybname -- 申请人名称(新增)
            ,partybaddress -- 申请人地址(新增)
            ,notarizationflag -- 是否强制执行公证
            ,jfaddress -- 甲方送达地址
            ,partyaphone -- 贴现人电话(新增)
            ,isautobusi -- 秒贴业务标记,码值：是1否2(新增)
            ,partybduty -- 申请人法定代表人职务(新增)
            ,status -- 贴现申请状态:01-待处理02-审批中03-已放款04-已驳回
            ,jyseriano -- 交易门户唯一标识
            ,certdn -- 用户秘钥
            ,partyblegalperson -- 申请人法定代表人(新增)
            ,errormsg -- 秒贴业务错误信息(新增)
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,othersolution -- 其他争议解决方式
            ,arbitration -- 仲裁机构
            ,purchaserpercent -- 买方承担比例
            ,contractno -- 关联合同流水号
            ,acceptinttype -- 贴现利息承担方式
            ,partyaaddress -- 贴现人地址(新增)
            ,yfaddress -- 交易门户唯一标识
            ,isnoedflow -- 是否无额度银承
            ,partybphone -- 申请人电话(新增)
            ,partybfax -- 申请人传真(新增)
            ,bargainorpercent -- 卖方承担比例
            ,inputtime -- 申请发起时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_online_tiexian_op(
            serialno -- 在线贴现申请流水号
            ,mfcustomerid -- 核心客户号
            ,purchaser -- 买方
            ,solution -- 争议解决方式
            ,belongorgid -- 
            ,partyaprincipal -- 贴现人负责人(新增)
            ,afeerate -- 贴现利率
            ,partyacopies -- 甲方执合同份数
            ,totalcopies -- 合同总份数
            ,partyaduty -- 贴现人负责人职务(新增)
            ,partybname -- 申请人名称(新增)
            ,partybaddress -- 申请人地址(新增)
            ,notarizationflag -- 是否强制执行公证
            ,jfaddress -- 甲方送达地址
            ,partyaphone -- 贴现人电话(新增)
            ,isautobusi -- 秒贴业务标记,码值：是1否2(新增)
            ,partybduty -- 申请人法定代表人职务(新增)
            ,status -- 贴现申请状态:01-待处理02-审批中03-已放款04-已驳回
            ,jyseriano -- 交易门户唯一标识
            ,certdn -- 用户秘钥
            ,partyblegalperson -- 申请人法定代表人(新增)
            ,errormsg -- 秒贴业务错误信息(新增)
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,othersolution -- 其他争议解决方式
            ,arbitration -- 仲裁机构
            ,purchaserpercent -- 买方承担比例
            ,contractno -- 关联合同流水号
            ,acceptinttype -- 贴现利息承担方式
            ,partyaaddress -- 贴现人地址(新增)
            ,yfaddress -- 交易门户唯一标识
            ,isnoedflow -- 是否无额度银承
            ,partybphone -- 申请人电话(新增)
            ,partybfax -- 申请人传真(新增)
            ,bargainorpercent -- 卖方承担比例
            ,inputtime -- 申请发起时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 在线贴现申请流水号
    ,nvl(n.mfcustomerid, o.mfcustomerid) as mfcustomerid -- 核心客户号
    ,nvl(n.purchaser, o.purchaser) as purchaser -- 买方
    ,nvl(n.solution, o.solution) as solution -- 争议解决方式
    ,nvl(n.belongorgid, o.belongorgid) as belongorgid -- 
    ,nvl(n.partyaprincipal, o.partyaprincipal) as partyaprincipal -- 贴现人负责人(新增)
    ,nvl(n.afeerate, o.afeerate) as afeerate -- 贴现利率
    ,nvl(n.partyacopies, o.partyacopies) as partyacopies -- 甲方执合同份数
    ,nvl(n.totalcopies, o.totalcopies) as totalcopies -- 合同总份数
    ,nvl(n.partyaduty, o.partyaduty) as partyaduty -- 贴现人负责人职务(新增)
    ,nvl(n.partybname, o.partybname) as partybname -- 申请人名称(新增)
    ,nvl(n.partybaddress, o.partybaddress) as partybaddress -- 申请人地址(新增)
    ,nvl(n.notarizationflag, o.notarizationflag) as notarizationflag -- 是否强制执行公证
    ,nvl(n.jfaddress, o.jfaddress) as jfaddress -- 甲方送达地址
    ,nvl(n.partyaphone, o.partyaphone) as partyaphone -- 贴现人电话(新增)
    ,nvl(n.isautobusi, o.isautobusi) as isautobusi -- 秒贴业务标记,码值：是1否2(新增)
    ,nvl(n.partybduty, o.partybduty) as partybduty -- 申请人法定代表人职务(新增)
    ,nvl(n.status, o.status) as status -- 贴现申请状态:01-待处理02-审批中03-已放款04-已驳回
    ,nvl(n.jyseriano, o.jyseriano) as jyseriano -- 交易门户唯一标识
    ,nvl(n.certdn, o.certdn) as certdn -- 用户秘钥
    ,nvl(n.partyblegalperson, o.partyblegalperson) as partyblegalperson -- 申请人法定代表人(新增)
    ,nvl(n.errormsg, o.errormsg) as errormsg -- 秒贴业务错误信息(新增)
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.othersolution, o.othersolution) as othersolution -- 其他争议解决方式
    ,nvl(n.arbitration, o.arbitration) as arbitration -- 仲裁机构
    ,nvl(n.purchaserpercent, o.purchaserpercent) as purchaserpercent -- 买方承担比例
    ,nvl(n.contractno, o.contractno) as contractno -- 关联合同流水号
    ,nvl(n.acceptinttype, o.acceptinttype) as acceptinttype -- 贴现利息承担方式
    ,nvl(n.partyaaddress, o.partyaaddress) as partyaaddress -- 贴现人地址(新增)
    ,nvl(n.yfaddress, o.yfaddress) as yfaddress -- 交易门户唯一标识
    ,nvl(n.isnoedflow, o.isnoedflow) as isnoedflow -- 是否无额度银承
    ,nvl(n.partybphone, o.partybphone) as partybphone -- 申请人电话(新增)
    ,nvl(n.partybfax, o.partybfax) as partybfax -- 申请人传真(新增)
    ,nvl(n.bargainorpercent, o.bargainorpercent) as bargainorpercent -- 卖方承担比例
    ,nvl(n.inputtime, o.inputtime) as inputtime -- 申请发起时间
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
from (select * from ${iol_schema}.icms_online_tiexian_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_online_tiexian where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.mfcustomerid <> n.mfcustomerid
        or o.purchaser <> n.purchaser
        or o.solution <> n.solution
        or o.belongorgid <> n.belongorgid
        or o.partyaprincipal <> n.partyaprincipal
        or o.afeerate <> n.afeerate
        or o.partyacopies <> n.partyacopies
        or o.totalcopies <> n.totalcopies
        or o.partyaduty <> n.partyaduty
        or o.partybname <> n.partybname
        or o.partybaddress <> n.partybaddress
        or o.notarizationflag <> n.notarizationflag
        or o.jfaddress <> n.jfaddress
        or o.partyaphone <> n.partyaphone
        or o.isautobusi <> n.isautobusi
        or o.partybduty <> n.partybduty
        or o.status <> n.status
        or o.jyseriano <> n.jyseriano
        or o.certdn <> n.certdn
        or o.partyblegalperson <> n.partyblegalperson
        or o.errormsg <> n.errormsg
        or o.migtflag <> n.migtflag
        or o.othersolution <> n.othersolution
        or o.arbitration <> n.arbitration
        or o.purchaserpercent <> n.purchaserpercent
        or o.contractno <> n.contractno
        or o.acceptinttype <> n.acceptinttype
        or o.partyaaddress <> n.partyaaddress
        or o.yfaddress <> n.yfaddress
        or o.isnoedflow <> n.isnoedflow
        or o.partybphone <> n.partybphone
        or o.partybfax <> n.partybfax
        or o.bargainorpercent <> n.bargainorpercent
        or o.inputtime <> n.inputtime
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_online_tiexian_cl(
            serialno -- 在线贴现申请流水号
            ,mfcustomerid -- 核心客户号
            ,purchaser -- 买方
            ,solution -- 争议解决方式
            ,belongorgid -- 
            ,partyaprincipal -- 贴现人负责人(新增)
            ,afeerate -- 贴现利率
            ,partyacopies -- 甲方执合同份数
            ,totalcopies -- 合同总份数
            ,partyaduty -- 贴现人负责人职务(新增)
            ,partybname -- 申请人名称(新增)
            ,partybaddress -- 申请人地址(新增)
            ,notarizationflag -- 是否强制执行公证
            ,jfaddress -- 甲方送达地址
            ,partyaphone -- 贴现人电话(新增)
            ,isautobusi -- 秒贴业务标记,码值：是1否2(新增)
            ,partybduty -- 申请人法定代表人职务(新增)
            ,status -- 贴现申请状态:01-待处理02-审批中03-已放款04-已驳回
            ,jyseriano -- 交易门户唯一标识
            ,certdn -- 用户秘钥
            ,partyblegalperson -- 申请人法定代表人(新增)
            ,errormsg -- 秒贴业务错误信息(新增)
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,othersolution -- 其他争议解决方式
            ,arbitration -- 仲裁机构
            ,purchaserpercent -- 买方承担比例
            ,contractno -- 关联合同流水号
            ,acceptinttype -- 贴现利息承担方式
            ,partyaaddress -- 贴现人地址(新增)
            ,yfaddress -- 交易门户唯一标识
            ,isnoedflow -- 是否无额度银承
            ,partybphone -- 申请人电话(新增)
            ,partybfax -- 申请人传真(新增)
            ,bargainorpercent -- 卖方承担比例
            ,inputtime -- 申请发起时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_online_tiexian_op(
            serialno -- 在线贴现申请流水号
            ,mfcustomerid -- 核心客户号
            ,purchaser -- 买方
            ,solution -- 争议解决方式
            ,belongorgid -- 
            ,partyaprincipal -- 贴现人负责人(新增)
            ,afeerate -- 贴现利率
            ,partyacopies -- 甲方执合同份数
            ,totalcopies -- 合同总份数
            ,partyaduty -- 贴现人负责人职务(新增)
            ,partybname -- 申请人名称(新增)
            ,partybaddress -- 申请人地址(新增)
            ,notarizationflag -- 是否强制执行公证
            ,jfaddress -- 甲方送达地址
            ,partyaphone -- 贴现人电话(新增)
            ,isautobusi -- 秒贴业务标记,码值：是1否2(新增)
            ,partybduty -- 申请人法定代表人职务(新增)
            ,status -- 贴现申请状态:01-待处理02-审批中03-已放款04-已驳回
            ,jyseriano -- 交易门户唯一标识
            ,certdn -- 用户秘钥
            ,partyblegalperson -- 申请人法定代表人(新增)
            ,errormsg -- 秒贴业务错误信息(新增)
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,othersolution -- 其他争议解决方式
            ,arbitration -- 仲裁机构
            ,purchaserpercent -- 买方承担比例
            ,contractno -- 关联合同流水号
            ,acceptinttype -- 贴现利息承担方式
            ,partyaaddress -- 贴现人地址(新增)
            ,yfaddress -- 交易门户唯一标识
            ,isnoedflow -- 是否无额度银承
            ,partybphone -- 申请人电话(新增)
            ,partybfax -- 申请人传真(新增)
            ,bargainorpercent -- 卖方承担比例
            ,inputtime -- 申请发起时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 在线贴现申请流水号
    ,o.mfcustomerid -- 核心客户号
    ,o.purchaser -- 买方
    ,o.solution -- 争议解决方式
    ,o.belongorgid -- 
    ,o.partyaprincipal -- 贴现人负责人(新增)
    ,o.afeerate -- 贴现利率
    ,o.partyacopies -- 甲方执合同份数
    ,o.totalcopies -- 合同总份数
    ,o.partyaduty -- 贴现人负责人职务(新增)
    ,o.partybname -- 申请人名称(新增)
    ,o.partybaddress -- 申请人地址(新增)
    ,o.notarizationflag -- 是否强制执行公证
    ,o.jfaddress -- 甲方送达地址
    ,o.partyaphone -- 贴现人电话(新增)
    ,o.isautobusi -- 秒贴业务标记,码值：是1否2(新增)
    ,o.partybduty -- 申请人法定代表人职务(新增)
    ,o.status -- 贴现申请状态:01-待处理02-审批中03-已放款04-已驳回
    ,o.jyseriano -- 交易门户唯一标识
    ,o.certdn -- 用户秘钥
    ,o.partyblegalperson -- 申请人法定代表人(新增)
    ,o.errormsg -- 秒贴业务错误信息(新增)
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.othersolution -- 其他争议解决方式
    ,o.arbitration -- 仲裁机构
    ,o.purchaserpercent -- 买方承担比例
    ,o.contractno -- 关联合同流水号
    ,o.acceptinttype -- 贴现利息承担方式
    ,o.partyaaddress -- 贴现人地址(新增)
    ,o.yfaddress -- 交易门户唯一标识
    ,o.isnoedflow -- 是否无额度银承
    ,o.partybphone -- 申请人电话(新增)
    ,o.partybfax -- 申请人传真(新增)
    ,o.bargainorpercent -- 卖方承担比例
    ,o.inputtime -- 申请发起时间
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
from ${iol_schema}.icms_online_tiexian_bk o
    left join ${iol_schema}.icms_online_tiexian_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_online_tiexian_cl d
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
--truncate table ${iol_schema}.icms_online_tiexian;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_online_tiexian') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_online_tiexian drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_online_tiexian add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_online_tiexian exchange partition p_${batch_date} with table ${iol_schema}.icms_online_tiexian_cl;
alter table ${iol_schema}.icms_online_tiexian exchange partition p_20991231 with table ${iol_schema}.icms_online_tiexian_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_online_tiexian to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_online_tiexian_op purge;
drop table ${iol_schema}.icms_online_tiexian_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_online_tiexian_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_online_tiexian',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
