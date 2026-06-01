/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a92accinfo
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
create table ${iol_schema}.mpcs_a92accinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a92accinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a92accinfo_op purge;
drop table ${iol_schema}.mpcs_a92accinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a92accinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a92accinfo where 0=1;

create table ${iol_schema}.mpcs_a92accinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a92accinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a92accinfo_cl(
            trandt -- 银行交易日期
            ,trantm -- 银行交易时间
            ,paysys -- 交易渠道 YM
            ,transeqno -- 交易流水号
            ,brokercode -- 商户唯一编号
            ,accountname -- 姓名
            ,identitytype -- 证件类型0-身份证
            ,identityno -- 证件号码
            ,custno -- 客户号
            ,accountid -- 盈米财富ID
            ,phone -- 电话号码
            ,mobile -- 手机号码
            ,zipcd -- 邮政编码
            ,addr -- 通讯地址
            ,email -- 电子邮件
            ,manager -- 客户经理
            ,isbill -- 是否寄送账单
            ,billtype -- 账单寄送方式
            ,riskgrade -- 风险等级 5-激进型,4-进取型,3-稳健型,2-谨慎型,1-保守型 0-未评级
            ,stat -- 状态 1-开户 2-销户
            ,upddt -- 更新日期
            ,updtm -- 更新时间
            ,reserve1 -- 预留1
            ,reserve2 -- 预留2
            ,reserve3 -- 预留3
            ,reserve4 -- 预留4
            ,custlevel -- 投资级别 普通投资者-0；专业投资者-1
            ,infoready -- 销售适当性信息是否完整 0-不完整;1-完整
            ,levelexpirydate -- 专业投资者有效期 单位：天
            ,levelbegindate -- 专业投资者有效期开始日
            ,levelenddate -- 专业投资者有效期到期日
            ,idenddate -- 证件到期日
            ,career -- 职业
            ,nationality -- 国籍
            ,investorname -- 实际控制投资者姓名
            ,investoridtype -- 实际控制投资者证件类型
            ,investoridinfo -- 实际控制投资者证件号
            ,investoridenddate -- 实际控制投资者证件到期日
            ,benefyname -- 投资受益人姓名
            ,benefyidtype -- 投资受益人证件类型
            ,benefyidinfo -- 投资受益人证件号
            ,benefyidenddate -- 投资受益人证件到期日
            ,terminalip -- 终端IP地址
            ,terminaltype -- 终端类型
            ,terminalinfo -- 终端相关信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a92accinfo_op(
            trandt -- 银行交易日期
            ,trantm -- 银行交易时间
            ,paysys -- 交易渠道 YM
            ,transeqno -- 交易流水号
            ,brokercode -- 商户唯一编号
            ,accountname -- 姓名
            ,identitytype -- 证件类型0-身份证
            ,identityno -- 证件号码
            ,custno -- 客户号
            ,accountid -- 盈米财富ID
            ,phone -- 电话号码
            ,mobile -- 手机号码
            ,zipcd -- 邮政编码
            ,addr -- 通讯地址
            ,email -- 电子邮件
            ,manager -- 客户经理
            ,isbill -- 是否寄送账单
            ,billtype -- 账单寄送方式
            ,riskgrade -- 风险等级 5-激进型,4-进取型,3-稳健型,2-谨慎型,1-保守型 0-未评级
            ,stat -- 状态 1-开户 2-销户
            ,upddt -- 更新日期
            ,updtm -- 更新时间
            ,reserve1 -- 预留1
            ,reserve2 -- 预留2
            ,reserve3 -- 预留3
            ,reserve4 -- 预留4
            ,custlevel -- 投资级别 普通投资者-0；专业投资者-1
            ,infoready -- 销售适当性信息是否完整 0-不完整;1-完整
            ,levelexpirydate -- 专业投资者有效期 单位：天
            ,levelbegindate -- 专业投资者有效期开始日
            ,levelenddate -- 专业投资者有效期到期日
            ,idenddate -- 证件到期日
            ,career -- 职业
            ,nationality -- 国籍
            ,investorname -- 实际控制投资者姓名
            ,investoridtype -- 实际控制投资者证件类型
            ,investoridinfo -- 实际控制投资者证件号
            ,investoridenddate -- 实际控制投资者证件到期日
            ,benefyname -- 投资受益人姓名
            ,benefyidtype -- 投资受益人证件类型
            ,benefyidinfo -- 投资受益人证件号
            ,benefyidenddate -- 投资受益人证件到期日
            ,terminalip -- 终端IP地址
            ,terminaltype -- 终端类型
            ,terminalinfo -- 终端相关信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.trandt, o.trandt) as trandt -- 银行交易日期
    ,nvl(n.trantm, o.trantm) as trantm -- 银行交易时间
    ,nvl(n.paysys, o.paysys) as paysys -- 交易渠道 YM
    ,nvl(n.transeqno, o.transeqno) as transeqno -- 交易流水号
    ,nvl(n.brokercode, o.brokercode) as brokercode -- 商户唯一编号
    ,nvl(n.accountname, o.accountname) as accountname -- 姓名
    ,nvl(n.identitytype, o.identitytype) as identitytype -- 证件类型0-身份证
    ,nvl(n.identityno, o.identityno) as identityno -- 证件号码
    ,nvl(n.custno, o.custno) as custno -- 客户号
    ,nvl(n.accountid, o.accountid) as accountid -- 盈米财富ID
    ,nvl(n.phone, o.phone) as phone -- 电话号码
    ,nvl(n.mobile, o.mobile) as mobile -- 手机号码
    ,nvl(n.zipcd, o.zipcd) as zipcd -- 邮政编码
    ,nvl(n.addr, o.addr) as addr -- 通讯地址
    ,nvl(n.email, o.email) as email -- 电子邮件
    ,nvl(n.manager, o.manager) as manager -- 客户经理
    ,nvl(n.isbill, o.isbill) as isbill -- 是否寄送账单
    ,nvl(n.billtype, o.billtype) as billtype -- 账单寄送方式
    ,nvl(n.riskgrade, o.riskgrade) as riskgrade -- 风险等级 5-激进型,4-进取型,3-稳健型,2-谨慎型,1-保守型 0-未评级
    ,nvl(n.stat, o.stat) as stat -- 状态 1-开户 2-销户
    ,nvl(n.upddt, o.upddt) as upddt -- 更新日期
    ,nvl(n.updtm, o.updtm) as updtm -- 更新时间
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 预留1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 预留2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 预留3
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 预留4
    ,nvl(n.custlevel, o.custlevel) as custlevel -- 投资级别 普通投资者-0；专业投资者-1
    ,nvl(n.infoready, o.infoready) as infoready -- 销售适当性信息是否完整 0-不完整;1-完整
    ,nvl(n.levelexpirydate, o.levelexpirydate) as levelexpirydate -- 专业投资者有效期 单位：天
    ,nvl(n.levelbegindate, o.levelbegindate) as levelbegindate -- 专业投资者有效期开始日
    ,nvl(n.levelenddate, o.levelenddate) as levelenddate -- 专业投资者有效期到期日
    ,nvl(n.idenddate, o.idenddate) as idenddate -- 证件到期日
    ,nvl(n.career, o.career) as career -- 职业
    ,nvl(n.nationality, o.nationality) as nationality -- 国籍
    ,nvl(n.investorname, o.investorname) as investorname -- 实际控制投资者姓名
    ,nvl(n.investoridtype, o.investoridtype) as investoridtype -- 实际控制投资者证件类型
    ,nvl(n.investoridinfo, o.investoridinfo) as investoridinfo -- 实际控制投资者证件号
    ,nvl(n.investoridenddate, o.investoridenddate) as investoridenddate -- 实际控制投资者证件到期日
    ,nvl(n.benefyname, o.benefyname) as benefyname -- 投资受益人姓名
    ,nvl(n.benefyidtype, o.benefyidtype) as benefyidtype -- 投资受益人证件类型
    ,nvl(n.benefyidinfo, o.benefyidinfo) as benefyidinfo -- 投资受益人证件号
    ,nvl(n.benefyidenddate, o.benefyidenddate) as benefyidenddate -- 投资受益人证件到期日
    ,nvl(n.terminalip, o.terminalip) as terminalip -- 终端IP地址
    ,nvl(n.terminaltype, o.terminaltype) as terminaltype -- 终端类型
    ,nvl(n.terminalinfo, o.terminalinfo) as terminalinfo -- 终端相关信息
    ,case when
            n.custno is null
            and n.stat is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.custno is null
            and n.stat is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.custno is null
            and n.stat is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a92accinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a92accinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.custno = n.custno
            and o.stat = n.stat
where (
        o.custno is null
        and o.stat is null
    )
    or (
        n.custno is null
        and n.stat is null
    )
    or (
        o.trandt <> n.trandt
        or o.trantm <> n.trantm
        or o.paysys <> n.paysys
        or o.transeqno <> n.transeqno
        or o.brokercode <> n.brokercode
        or o.accountname <> n.accountname
        or o.identitytype <> n.identitytype
        or o.identityno <> n.identityno
        or o.accountid <> n.accountid
        or o.phone <> n.phone
        or o.mobile <> n.mobile
        or o.zipcd <> n.zipcd
        or o.addr <> n.addr
        or o.email <> n.email
        or o.manager <> n.manager
        or o.isbill <> n.isbill
        or o.billtype <> n.billtype
        or o.riskgrade <> n.riskgrade
        or o.upddt <> n.upddt
        or o.updtm <> n.updtm
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.reserve4 <> n.reserve4
        or o.custlevel <> n.custlevel
        or o.infoready <> n.infoready
        or o.levelexpirydate <> n.levelexpirydate
        or o.levelbegindate <> n.levelbegindate
        or o.levelenddate <> n.levelenddate
        or o.idenddate <> n.idenddate
        or o.career <> n.career
        or o.nationality <> n.nationality
        or o.investorname <> n.investorname
        or o.investoridtype <> n.investoridtype
        or o.investoridinfo <> n.investoridinfo
        or o.investoridenddate <> n.investoridenddate
        or o.benefyname <> n.benefyname
        or o.benefyidtype <> n.benefyidtype
        or o.benefyidinfo <> n.benefyidinfo
        or o.benefyidenddate <> n.benefyidenddate
        or o.terminalip <> n.terminalip
        or o.terminaltype <> n.terminaltype
        or o.terminalinfo <> n.terminalinfo
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a92accinfo_cl(
            trandt -- 银行交易日期
            ,trantm -- 银行交易时间
            ,paysys -- 交易渠道 YM
            ,transeqno -- 交易流水号
            ,brokercode -- 商户唯一编号
            ,accountname -- 姓名
            ,identitytype -- 证件类型0-身份证
            ,identityno -- 证件号码
            ,custno -- 客户号
            ,accountid -- 盈米财富ID
            ,phone -- 电话号码
            ,mobile -- 手机号码
            ,zipcd -- 邮政编码
            ,addr -- 通讯地址
            ,email -- 电子邮件
            ,manager -- 客户经理
            ,isbill -- 是否寄送账单
            ,billtype -- 账单寄送方式
            ,riskgrade -- 风险等级 5-激进型,4-进取型,3-稳健型,2-谨慎型,1-保守型 0-未评级
            ,stat -- 状态 1-开户 2-销户
            ,upddt -- 更新日期
            ,updtm -- 更新时间
            ,reserve1 -- 预留1
            ,reserve2 -- 预留2
            ,reserve3 -- 预留3
            ,reserve4 -- 预留4
            ,custlevel -- 投资级别 普通投资者-0；专业投资者-1
            ,infoready -- 销售适当性信息是否完整 0-不完整;1-完整
            ,levelexpirydate -- 专业投资者有效期 单位：天
            ,levelbegindate -- 专业投资者有效期开始日
            ,levelenddate -- 专业投资者有效期到期日
            ,idenddate -- 证件到期日
            ,career -- 职业
            ,nationality -- 国籍
            ,investorname -- 实际控制投资者姓名
            ,investoridtype -- 实际控制投资者证件类型
            ,investoridinfo -- 实际控制投资者证件号
            ,investoridenddate -- 实际控制投资者证件到期日
            ,benefyname -- 投资受益人姓名
            ,benefyidtype -- 投资受益人证件类型
            ,benefyidinfo -- 投资受益人证件号
            ,benefyidenddate -- 投资受益人证件到期日
            ,terminalip -- 终端IP地址
            ,terminaltype -- 终端类型
            ,terminalinfo -- 终端相关信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a92accinfo_op(
            trandt -- 银行交易日期
            ,trantm -- 银行交易时间
            ,paysys -- 交易渠道 YM
            ,transeqno -- 交易流水号
            ,brokercode -- 商户唯一编号
            ,accountname -- 姓名
            ,identitytype -- 证件类型0-身份证
            ,identityno -- 证件号码
            ,custno -- 客户号
            ,accountid -- 盈米财富ID
            ,phone -- 电话号码
            ,mobile -- 手机号码
            ,zipcd -- 邮政编码
            ,addr -- 通讯地址
            ,email -- 电子邮件
            ,manager -- 客户经理
            ,isbill -- 是否寄送账单
            ,billtype -- 账单寄送方式
            ,riskgrade -- 风险等级 5-激进型,4-进取型,3-稳健型,2-谨慎型,1-保守型 0-未评级
            ,stat -- 状态 1-开户 2-销户
            ,upddt -- 更新日期
            ,updtm -- 更新时间
            ,reserve1 -- 预留1
            ,reserve2 -- 预留2
            ,reserve3 -- 预留3
            ,reserve4 -- 预留4
            ,custlevel -- 投资级别 普通投资者-0；专业投资者-1
            ,infoready -- 销售适当性信息是否完整 0-不完整;1-完整
            ,levelexpirydate -- 专业投资者有效期 单位：天
            ,levelbegindate -- 专业投资者有效期开始日
            ,levelenddate -- 专业投资者有效期到期日
            ,idenddate -- 证件到期日
            ,career -- 职业
            ,nationality -- 国籍
            ,investorname -- 实际控制投资者姓名
            ,investoridtype -- 实际控制投资者证件类型
            ,investoridinfo -- 实际控制投资者证件号
            ,investoridenddate -- 实际控制投资者证件到期日
            ,benefyname -- 投资受益人姓名
            ,benefyidtype -- 投资受益人证件类型
            ,benefyidinfo -- 投资受益人证件号
            ,benefyidenddate -- 投资受益人证件到期日
            ,terminalip -- 终端IP地址
            ,terminaltype -- 终端类型
            ,terminalinfo -- 终端相关信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.trandt -- 银行交易日期
    ,o.trantm -- 银行交易时间
    ,o.paysys -- 交易渠道 YM
    ,o.transeqno -- 交易流水号
    ,o.brokercode -- 商户唯一编号
    ,o.accountname -- 姓名
    ,o.identitytype -- 证件类型0-身份证
    ,o.identityno -- 证件号码
    ,o.custno -- 客户号
    ,o.accountid -- 盈米财富ID
    ,o.phone -- 电话号码
    ,o.mobile -- 手机号码
    ,o.zipcd -- 邮政编码
    ,o.addr -- 通讯地址
    ,o.email -- 电子邮件
    ,o.manager -- 客户经理
    ,o.isbill -- 是否寄送账单
    ,o.billtype -- 账单寄送方式
    ,o.riskgrade -- 风险等级 5-激进型,4-进取型,3-稳健型,2-谨慎型,1-保守型 0-未评级
    ,o.stat -- 状态 1-开户 2-销户
    ,o.upddt -- 更新日期
    ,o.updtm -- 更新时间
    ,o.reserve1 -- 预留1
    ,o.reserve2 -- 预留2
    ,o.reserve3 -- 预留3
    ,o.reserve4 -- 预留4
    ,o.custlevel -- 投资级别 普通投资者-0；专业投资者-1
    ,o.infoready -- 销售适当性信息是否完整 0-不完整;1-完整
    ,o.levelexpirydate -- 专业投资者有效期 单位：天
    ,o.levelbegindate -- 专业投资者有效期开始日
    ,o.levelenddate -- 专业投资者有效期到期日
    ,o.idenddate -- 证件到期日
    ,o.career -- 职业
    ,o.nationality -- 国籍
    ,o.investorname -- 实际控制投资者姓名
    ,o.investoridtype -- 实际控制投资者证件类型
    ,o.investoridinfo -- 实际控制投资者证件号
    ,o.investoridenddate -- 实际控制投资者证件到期日
    ,o.benefyname -- 投资受益人姓名
    ,o.benefyidtype -- 投资受益人证件类型
    ,o.benefyidinfo -- 投资受益人证件号
    ,o.benefyidenddate -- 投资受益人证件到期日
    ,o.terminalip -- 终端IP地址
    ,o.terminaltype -- 终端类型
    ,o.terminalinfo -- 终端相关信息
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a92accinfo_bk o
    left join ${iol_schema}.mpcs_a92accinfo_op n
        on
            o.custno = n.custno
            and o.stat = n.stat
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a92accinfo_cl d
        on
            o.custno = d.custno
            and o.stat = d.stat
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a92accinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a92accinfo exchange partition p_19000101 with table ${iol_schema}.mpcs_a92accinfo_cl;
alter table ${iol_schema}.mpcs_a92accinfo exchange partition p_20991231 with table ${iol_schema}.mpcs_a92accinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a92accinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a92accinfo_op purge;
drop table ${iol_schema}.mpcs_a92accinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a92accinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a92accinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
