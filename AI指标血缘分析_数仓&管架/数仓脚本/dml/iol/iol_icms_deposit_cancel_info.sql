/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_deposit_cancel_info
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
create table ${iol_schema}.icms_deposit_cancel_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_deposit_cancel_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_deposit_cancel_info_op purge;
drop table ${iol_schema}.icms_deposit_cancel_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_deposit_cancel_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_deposit_cancel_info where 0=1;

create table ${iol_schema}.icms_deposit_cancel_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_deposit_cancel_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_deposit_cancel_info_cl(
            serialno -- 申请流水号
            ,exchangetime -- 交易时间
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,approvestatus -- 审批状态
            ,migtflag -- 
            ,exchangestate -- 交易状态
            ,cusid -- 客户ID
            ,putoutno -- 出账流水号
            ,hascancel -- 是否已撤销Y是N否默认可以为空
            ,inputdate -- 登记日期
            ,matudt -- 到期日期票据到期日
            ,inputuserid -- 登记人
            ,exchangeserialno -- 交易流水号
            ,initexchangedate -- 原交易日期
            ,dataid -- 唯一标识若为票据系统签发的承兑，则上送票据系统交易唯一标识 若为核心系统签发的承兑，则上送承兑协议号 若为保函，则上送保函合同号
            ,exchangedate -- 交易日期
            ,grtetp -- 保证金类型/备款类型1--关联合同号 2--关联票据号 (保函与票据系统不用上送，默认为1)
            ,businesstype -- 转出业务类型
            ,cntrtp -- 协议类型1--承兑汇票协议 2–保函合同
            ,acctno -- 转出账号
            ,updateorgid -- 更新机构
            ,grteac -- 保证金帐号
            ,initexchangeserialno -- 原交易流水号
            ,objectno -- 被撤销的保证金申请的流水号
            ,remark -- 解止说明
            ,termcd -- 存期000活期 203三个月 206六个月 301一年 302二年 303三年 305五年
            ,subaccountam -- 保证金子账号余额
            ,updateuserid -- 更新人
            ,cusname -- 客户名称
            ,opertp -- 操作类型1--建立保证金对应关系 2–追加保证金
            ,subaccount -- 子户号
            ,contractno -- 合同流水号
            ,tranam -- 金额
            ,pigeonholedate -- 归档日期
            ,unfreezeam -- 解止金额
            ,acptno -- 票据号码此字段针对承兑（若grtetp为2时此字段不能为空）
            ,crcycd -- 币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_deposit_cancel_info_op(
            serialno -- 申请流水号
            ,exchangetime -- 交易时间
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,approvestatus -- 审批状态
            ,migtflag -- 
            ,exchangestate -- 交易状态
            ,cusid -- 客户ID
            ,putoutno -- 出账流水号
            ,hascancel -- 是否已撤销Y是N否默认可以为空
            ,inputdate -- 登记日期
            ,matudt -- 到期日期票据到期日
            ,inputuserid -- 登记人
            ,exchangeserialno -- 交易流水号
            ,initexchangedate -- 原交易日期
            ,dataid -- 唯一标识若为票据系统签发的承兑，则上送票据系统交易唯一标识 若为核心系统签发的承兑，则上送承兑协议号 若为保函，则上送保函合同号
            ,exchangedate -- 交易日期
            ,grtetp -- 保证金类型/备款类型1--关联合同号 2--关联票据号 (保函与票据系统不用上送，默认为1)
            ,businesstype -- 转出业务类型
            ,cntrtp -- 协议类型1--承兑汇票协议 2–保函合同
            ,acctno -- 转出账号
            ,updateorgid -- 更新机构
            ,grteac -- 保证金帐号
            ,initexchangeserialno -- 原交易流水号
            ,objectno -- 被撤销的保证金申请的流水号
            ,remark -- 解止说明
            ,termcd -- 存期000活期 203三个月 206六个月 301一年 302二年 303三年 305五年
            ,subaccountam -- 保证金子账号余额
            ,updateuserid -- 更新人
            ,cusname -- 客户名称
            ,opertp -- 操作类型1--建立保证金对应关系 2–追加保证金
            ,subaccount -- 子户号
            ,contractno -- 合同流水号
            ,tranam -- 金额
            ,pigeonholedate -- 归档日期
            ,unfreezeam -- 解止金额
            ,acptno -- 票据号码此字段针对承兑（若grtetp为2时此字段不能为空）
            ,crcycd -- 币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 申请流水号
    ,nvl(n.exchangetime, o.exchangetime) as exchangetime -- 交易时间
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.exchangestate, o.exchangestate) as exchangestate -- 交易状态
    ,nvl(n.cusid, o.cusid) as cusid -- 客户ID
    ,nvl(n.putoutno, o.putoutno) as putoutno -- 出账流水号
    ,nvl(n.hascancel, o.hascancel) as hascancel -- 是否已撤销Y是N否默认可以为空
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.matudt, o.matudt) as matudt -- 到期日期票据到期日
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.exchangeserialno, o.exchangeserialno) as exchangeserialno -- 交易流水号
    ,nvl(n.initexchangedate, o.initexchangedate) as initexchangedate -- 原交易日期
    ,nvl(n.dataid, o.dataid) as dataid -- 唯一标识若为票据系统签发的承兑，则上送票据系统交易唯一标识 若为核心系统签发的承兑，则上送承兑协议号 若为保函，则上送保函合同号
    ,nvl(n.exchangedate, o.exchangedate) as exchangedate -- 交易日期
    ,nvl(n.grtetp, o.grtetp) as grtetp -- 保证金类型/备款类型1--关联合同号 2--关联票据号 (保函与票据系统不用上送，默认为1)
    ,nvl(n.businesstype, o.businesstype) as businesstype -- 转出业务类型
    ,nvl(n.cntrtp, o.cntrtp) as cntrtp -- 协议类型1--承兑汇票协议 2–保函合同
    ,nvl(n.acctno, o.acctno) as acctno -- 转出账号
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.grteac, o.grteac) as grteac -- 保证金帐号
    ,nvl(n.initexchangeserialno, o.initexchangeserialno) as initexchangeserialno -- 原交易流水号
    ,nvl(n.objectno, o.objectno) as objectno -- 被撤销的保证金申请的流水号
    ,nvl(n.remark, o.remark) as remark -- 解止说明
    ,nvl(n.termcd, o.termcd) as termcd -- 存期000活期 203三个月 206六个月 301一年 302二年 303三年 305五年
    ,nvl(n.subaccountam, o.subaccountam) as subaccountam -- 保证金子账号余额
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.cusname, o.cusname) as cusname -- 客户名称
    ,nvl(n.opertp, o.opertp) as opertp -- 操作类型1--建立保证金对应关系 2–追加保证金
    ,nvl(n.subaccount, o.subaccount) as subaccount -- 子户号
    ,nvl(n.contractno, o.contractno) as contractno -- 合同流水号
    ,nvl(n.tranam, o.tranam) as tranam -- 金额
    ,nvl(n.pigeonholedate, o.pigeonholedate) as pigeonholedate -- 归档日期
    ,nvl(n.unfreezeam, o.unfreezeam) as unfreezeam -- 解止金额
    ,nvl(n.acptno, o.acptno) as acptno -- 票据号码此字段针对承兑（若grtetp为2时此字段不能为空）
    ,nvl(n.crcycd, o.crcycd) as crcycd -- 币种
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
from (select * from ${iol_schema}.icms_deposit_cancel_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_deposit_cancel_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.exchangetime <> n.exchangetime
        or o.inputorgid <> n.inputorgid
        or o.updatedate <> n.updatedate
        or o.approvestatus <> n.approvestatus
        or o.migtflag <> n.migtflag
        or o.exchangestate <> n.exchangestate
        or o.cusid <> n.cusid
        or o.putoutno <> n.putoutno
        or o.hascancel <> n.hascancel
        or o.inputdate <> n.inputdate
        or o.matudt <> n.matudt
        or o.inputuserid <> n.inputuserid
        or o.exchangeserialno <> n.exchangeserialno
        or o.initexchangedate <> n.initexchangedate
        or o.dataid <> n.dataid
        or o.exchangedate <> n.exchangedate
        or o.grtetp <> n.grtetp
        or o.businesstype <> n.businesstype
        or o.cntrtp <> n.cntrtp
        or o.acctno <> n.acctno
        or o.updateorgid <> n.updateorgid
        or o.grteac <> n.grteac
        or o.initexchangeserialno <> n.initexchangeserialno
        or o.objectno <> n.objectno
        or o.remark <> n.remark
        or o.termcd <> n.termcd
        or o.subaccountam <> n.subaccountam
        or o.updateuserid <> n.updateuserid
        or o.cusname <> n.cusname
        or o.opertp <> n.opertp
        or o.subaccount <> n.subaccount
        or o.contractno <> n.contractno
        or o.tranam <> n.tranam
        or o.pigeonholedate <> n.pigeonholedate
        or o.unfreezeam <> n.unfreezeam
        or o.acptno <> n.acptno
        or o.crcycd <> n.crcycd
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_deposit_cancel_info_cl(
            serialno -- 申请流水号
            ,exchangetime -- 交易时间
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,approvestatus -- 审批状态
            ,migtflag -- 
            ,exchangestate -- 交易状态
            ,cusid -- 客户ID
            ,putoutno -- 出账流水号
            ,hascancel -- 是否已撤销Y是N否默认可以为空
            ,inputdate -- 登记日期
            ,matudt -- 到期日期票据到期日
            ,inputuserid -- 登记人
            ,exchangeserialno -- 交易流水号
            ,initexchangedate -- 原交易日期
            ,dataid -- 唯一标识若为票据系统签发的承兑，则上送票据系统交易唯一标识 若为核心系统签发的承兑，则上送承兑协议号 若为保函，则上送保函合同号
            ,exchangedate -- 交易日期
            ,grtetp -- 保证金类型/备款类型1--关联合同号 2--关联票据号 (保函与票据系统不用上送，默认为1)
            ,businesstype -- 转出业务类型
            ,cntrtp -- 协议类型1--承兑汇票协议 2–保函合同
            ,acctno -- 转出账号
            ,updateorgid -- 更新机构
            ,grteac -- 保证金帐号
            ,initexchangeserialno -- 原交易流水号
            ,objectno -- 被撤销的保证金申请的流水号
            ,remark -- 解止说明
            ,termcd -- 存期000活期 203三个月 206六个月 301一年 302二年 303三年 305五年
            ,subaccountam -- 保证金子账号余额
            ,updateuserid -- 更新人
            ,cusname -- 客户名称
            ,opertp -- 操作类型1--建立保证金对应关系 2–追加保证金
            ,subaccount -- 子户号
            ,contractno -- 合同流水号
            ,tranam -- 金额
            ,pigeonholedate -- 归档日期
            ,unfreezeam -- 解止金额
            ,acptno -- 票据号码此字段针对承兑（若grtetp为2时此字段不能为空）
            ,crcycd -- 币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_deposit_cancel_info_op(
            serialno -- 申请流水号
            ,exchangetime -- 交易时间
            ,inputorgid -- 登记机构
            ,updatedate -- 更新日期
            ,approvestatus -- 审批状态
            ,migtflag -- 
            ,exchangestate -- 交易状态
            ,cusid -- 客户ID
            ,putoutno -- 出账流水号
            ,hascancel -- 是否已撤销Y是N否默认可以为空
            ,inputdate -- 登记日期
            ,matudt -- 到期日期票据到期日
            ,inputuserid -- 登记人
            ,exchangeserialno -- 交易流水号
            ,initexchangedate -- 原交易日期
            ,dataid -- 唯一标识若为票据系统签发的承兑，则上送票据系统交易唯一标识 若为核心系统签发的承兑，则上送承兑协议号 若为保函，则上送保函合同号
            ,exchangedate -- 交易日期
            ,grtetp -- 保证金类型/备款类型1--关联合同号 2--关联票据号 (保函与票据系统不用上送，默认为1)
            ,businesstype -- 转出业务类型
            ,cntrtp -- 协议类型1--承兑汇票协议 2–保函合同
            ,acctno -- 转出账号
            ,updateorgid -- 更新机构
            ,grteac -- 保证金帐号
            ,initexchangeserialno -- 原交易流水号
            ,objectno -- 被撤销的保证金申请的流水号
            ,remark -- 解止说明
            ,termcd -- 存期000活期 203三个月 206六个月 301一年 302二年 303三年 305五年
            ,subaccountam -- 保证金子账号余额
            ,updateuserid -- 更新人
            ,cusname -- 客户名称
            ,opertp -- 操作类型1--建立保证金对应关系 2–追加保证金
            ,subaccount -- 子户号
            ,contractno -- 合同流水号
            ,tranam -- 金额
            ,pigeonholedate -- 归档日期
            ,unfreezeam -- 解止金额
            ,acptno -- 票据号码此字段针对承兑（若grtetp为2时此字段不能为空）
            ,crcycd -- 币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 申请流水号
    ,o.exchangetime -- 交易时间
    ,o.inputorgid -- 登记机构
    ,o.updatedate -- 更新日期
    ,o.approvestatus -- 审批状态
    ,o.migtflag -- 
    ,o.exchangestate -- 交易状态
    ,o.cusid -- 客户ID
    ,o.putoutno -- 出账流水号
    ,o.hascancel -- 是否已撤销Y是N否默认可以为空
    ,o.inputdate -- 登记日期
    ,o.matudt -- 到期日期票据到期日
    ,o.inputuserid -- 登记人
    ,o.exchangeserialno -- 交易流水号
    ,o.initexchangedate -- 原交易日期
    ,o.dataid -- 唯一标识若为票据系统签发的承兑，则上送票据系统交易唯一标识 若为核心系统签发的承兑，则上送承兑协议号 若为保函，则上送保函合同号
    ,o.exchangedate -- 交易日期
    ,o.grtetp -- 保证金类型/备款类型1--关联合同号 2--关联票据号 (保函与票据系统不用上送，默认为1)
    ,o.businesstype -- 转出业务类型
    ,o.cntrtp -- 协议类型1--承兑汇票协议 2–保函合同
    ,o.acctno -- 转出账号
    ,o.updateorgid -- 更新机构
    ,o.grteac -- 保证金帐号
    ,o.initexchangeserialno -- 原交易流水号
    ,o.objectno -- 被撤销的保证金申请的流水号
    ,o.remark -- 解止说明
    ,o.termcd -- 存期000活期 203三个月 206六个月 301一年 302二年 303三年 305五年
    ,o.subaccountam -- 保证金子账号余额
    ,o.updateuserid -- 更新人
    ,o.cusname -- 客户名称
    ,o.opertp -- 操作类型1--建立保证金对应关系 2–追加保证金
    ,o.subaccount -- 子户号
    ,o.contractno -- 合同流水号
    ,o.tranam -- 金额
    ,o.pigeonholedate -- 归档日期
    ,o.unfreezeam -- 解止金额
    ,o.acptno -- 票据号码此字段针对承兑（若grtetp为2时此字段不能为空）
    ,o.crcycd -- 币种
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
from ${iol_schema}.icms_deposit_cancel_info_bk o
    left join ${iol_schema}.icms_deposit_cancel_info_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_deposit_cancel_info_cl d
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
--truncate table ${iol_schema}.icms_deposit_cancel_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_deposit_cancel_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_deposit_cancel_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_deposit_cancel_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_deposit_cancel_info exchange partition p_${batch_date} with table ${iol_schema}.icms_deposit_cancel_info_cl;
alter table ${iol_schema}.icms_deposit_cancel_info exchange partition p_20991231 with table ${iol_schema}.icms_deposit_cancel_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_deposit_cancel_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_deposit_cancel_info_op purge;
drop table ${iol_schema}.icms_deposit_cancel_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_deposit_cancel_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_deposit_cancel_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
