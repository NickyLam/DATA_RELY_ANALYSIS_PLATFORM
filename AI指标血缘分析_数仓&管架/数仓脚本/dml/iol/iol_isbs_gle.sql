/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_gle
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
create table ${iol_schema}.isbs_gle_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_gle
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_gle_op purge;
drop table ${iol_schema}.isbs_gle_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_gle_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_gle where 0=1;

create table ${iol_schema}.isbs_gle_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_gle where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_gle_cl(
            inr -- 内部唯一ID
            ,objtyp -- 对象表名称
            ,objinr -- 对象表INR
            ,trninr -- TRN表的INR
            ,act -- 帐号
            ,dbtcdt -- 借贷标志
            ,cur -- 记账币种
            ,amt -- 记账金额
            ,syscur -- 规定币种
            ,sysamt -- 规定币种类型金额
            ,valdat -- 起息日
            ,bucdat -- 记录生成日期
            ,txt1 -- 摘要1
            ,txt2 -- 传票摘要
            ,txt3 -- 摘要3
            ,prn -- 分录顺序
            ,expses -- 出口用户会话
            ,expflg -- 出口状态
            ,acttrncod -- 传票打印类型
            ,branchinr -- 业务记账机构
            ,dbtdft -- 借据号（融资时）
            ,peeact -- 对应帐号
            ,rat -- 汇率
            ,trdtyp -- 交易类型
            ,cliextkey -- 客户号
            ,whmtyp -- 结售汇类型
            ,gleord -- 分录顺序号
            ,newactcod -- 核心系统交易代码
            ,trmtyp -- 科目代号
            ,trnman -- 结售汇交易主体
            ,midrat -- 中间价
            ,xrttim -- 中间价的牌价时间
            ,income -- 结售汇损益
            ,sumtyp -- 摘要类型
            ,acttyp -- 帐目类型
            ,cshflg -- 现金标志
            ,tracode -- 交易代码
            ,ctycode -- 国家标志
            ,apvnum -- 批准号
            ,othfin -- 对方银行名称
            ,selrat -- 卖出汇率
            ,buyrat -- 买入汇率
            ,bp -- 优惠点数
            ,stzflg -- 受托支付标识
            ,settyp -- 账务类型 LIA-表外 FEE-费用 JSH-结售汇 通用记账
            ,actseqno -- 账户序号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_gle_op(
            inr -- 内部唯一ID
            ,objtyp -- 对象表名称
            ,objinr -- 对象表INR
            ,trninr -- TRN表的INR
            ,act -- 帐号
            ,dbtcdt -- 借贷标志
            ,cur -- 记账币种
            ,amt -- 记账金额
            ,syscur -- 规定币种
            ,sysamt -- 规定币种类型金额
            ,valdat -- 起息日
            ,bucdat -- 记录生成日期
            ,txt1 -- 摘要1
            ,txt2 -- 传票摘要
            ,txt3 -- 摘要3
            ,prn -- 分录顺序
            ,expses -- 出口用户会话
            ,expflg -- 出口状态
            ,acttrncod -- 传票打印类型
            ,branchinr -- 业务记账机构
            ,dbtdft -- 借据号（融资时）
            ,peeact -- 对应帐号
            ,rat -- 汇率
            ,trdtyp -- 交易类型
            ,cliextkey -- 客户号
            ,whmtyp -- 结售汇类型
            ,gleord -- 分录顺序号
            ,newactcod -- 核心系统交易代码
            ,trmtyp -- 科目代号
            ,trnman -- 结售汇交易主体
            ,midrat -- 中间价
            ,xrttim -- 中间价的牌价时间
            ,income -- 结售汇损益
            ,sumtyp -- 摘要类型
            ,acttyp -- 帐目类型
            ,cshflg -- 现金标志
            ,tracode -- 交易代码
            ,ctycode -- 国家标志
            ,apvnum -- 批准号
            ,othfin -- 对方银行名称
            ,selrat -- 卖出汇率
            ,buyrat -- 买入汇率
            ,bp -- 优惠点数
            ,stzflg -- 受托支付标识
            ,settyp -- 账务类型 LIA-表外 FEE-费用 JSH-结售汇 通用记账
            ,actseqno -- 账户序号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 内部唯一ID
    ,nvl(n.objtyp, o.objtyp) as objtyp -- 对象表名称
    ,nvl(n.objinr, o.objinr) as objinr -- 对象表INR
    ,nvl(n.trninr, o.trninr) as trninr -- TRN表的INR
    ,nvl(n.act, o.act) as act -- 帐号
    ,nvl(n.dbtcdt, o.dbtcdt) as dbtcdt -- 借贷标志
    ,nvl(n.cur, o.cur) as cur -- 记账币种
    ,nvl(n.amt, o.amt) as amt -- 记账金额
    ,nvl(n.syscur, o.syscur) as syscur -- 规定币种
    ,nvl(n.sysamt, o.sysamt) as sysamt -- 规定币种类型金额
    ,nvl(n.valdat, o.valdat) as valdat -- 起息日
    ,nvl(n.bucdat, o.bucdat) as bucdat -- 记录生成日期
    ,nvl(n.txt1, o.txt1) as txt1 -- 摘要1
    ,nvl(n.txt2, o.txt2) as txt2 -- 传票摘要
    ,nvl(n.txt3, o.txt3) as txt3 -- 摘要3
    ,nvl(n.prn, o.prn) as prn -- 分录顺序
    ,nvl(n.expses, o.expses) as expses -- 出口用户会话
    ,nvl(n.expflg, o.expflg) as expflg -- 出口状态
    ,nvl(n.acttrncod, o.acttrncod) as acttrncod -- 传票打印类型
    ,nvl(n.branchinr, o.branchinr) as branchinr -- 业务记账机构
    ,nvl(n.dbtdft, o.dbtdft) as dbtdft -- 借据号（融资时）
    ,nvl(n.peeact, o.peeact) as peeact -- 对应帐号
    ,nvl(n.rat, o.rat) as rat -- 汇率
    ,nvl(n.trdtyp, o.trdtyp) as trdtyp -- 交易类型
    ,nvl(n.cliextkey, o.cliextkey) as cliextkey -- 客户号
    ,nvl(n.whmtyp, o.whmtyp) as whmtyp -- 结售汇类型
    ,nvl(n.gleord, o.gleord) as gleord -- 分录顺序号
    ,nvl(n.newactcod, o.newactcod) as newactcod -- 核心系统交易代码
    ,nvl(n.trmtyp, o.trmtyp) as trmtyp -- 科目代号
    ,nvl(n.trnman, o.trnman) as trnman -- 结售汇交易主体
    ,nvl(n.midrat, o.midrat) as midrat -- 中间价
    ,nvl(n.xrttim, o.xrttim) as xrttim -- 中间价的牌价时间
    ,nvl(n.income, o.income) as income -- 结售汇损益
    ,nvl(n.sumtyp, o.sumtyp) as sumtyp -- 摘要类型
    ,nvl(n.acttyp, o.acttyp) as acttyp -- 帐目类型
    ,nvl(n.cshflg, o.cshflg) as cshflg -- 现金标志
    ,nvl(n.tracode, o.tracode) as tracode -- 交易代码
    ,nvl(n.ctycode, o.ctycode) as ctycode -- 国家标志
    ,nvl(n.apvnum, o.apvnum) as apvnum -- 批准号
    ,nvl(n.othfin, o.othfin) as othfin -- 对方银行名称
    ,nvl(n.selrat, o.selrat) as selrat -- 卖出汇率
    ,nvl(n.buyrat, o.buyrat) as buyrat -- 买入汇率
    ,nvl(n.bp, o.bp) as bp -- 优惠点数
    ,nvl(n.stzflg, o.stzflg) as stzflg -- 受托支付标识
    ,nvl(n.settyp, o.settyp) as settyp -- 账务类型 LIA-表外 FEE-费用 JSH-结售汇 通用记账
    ,nvl(n.actseqno, o.actseqno) as actseqno -- 账户序号
    ,case when
            n.inr is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.inr is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.inr is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.isbs_gle_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_gle where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.objtyp <> n.objtyp
        or o.objinr <> n.objinr
        or o.trninr <> n.trninr
        or o.act <> n.act
        or o.dbtcdt <> n.dbtcdt
        or o.cur <> n.cur
        or o.amt <> n.amt
        or o.syscur <> n.syscur
        or o.sysamt <> n.sysamt
        or o.valdat <> n.valdat
        or o.bucdat <> n.bucdat
        or o.txt1 <> n.txt1
        or o.txt2 <> n.txt2
        or o.txt3 <> n.txt3
        or o.prn <> n.prn
        or o.expses <> n.expses
        or o.expflg <> n.expflg
        or o.acttrncod <> n.acttrncod
        or o.branchinr <> n.branchinr
        or o.dbtdft <> n.dbtdft
        or o.peeact <> n.peeact
        or o.rat <> n.rat
        or o.trdtyp <> n.trdtyp
        or o.cliextkey <> n.cliextkey
        or o.whmtyp <> n.whmtyp
        or o.gleord <> n.gleord
        or o.newactcod <> n.newactcod
        or o.trmtyp <> n.trmtyp
        or o.trnman <> n.trnman
        or o.midrat <> n.midrat
        or o.xrttim <> n.xrttim
        or o.income <> n.income
        or o.sumtyp <> n.sumtyp
        or o.acttyp <> n.acttyp
        or o.cshflg <> n.cshflg
        or o.tracode <> n.tracode
        or o.ctycode <> n.ctycode
        or o.apvnum <> n.apvnum
        or o.othfin <> n.othfin
        or o.selrat <> n.selrat
        or o.buyrat <> n.buyrat
        or o.bp <> n.bp
        or o.stzflg <> n.stzflg
        or o.settyp <> n.settyp
        or o.actseqno <> n.actseqno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_gle_cl(
            inr -- 内部唯一ID
            ,objtyp -- 对象表名称
            ,objinr -- 对象表INR
            ,trninr -- TRN表的INR
            ,act -- 帐号
            ,dbtcdt -- 借贷标志
            ,cur -- 记账币种
            ,amt -- 记账金额
            ,syscur -- 规定币种
            ,sysamt -- 规定币种类型金额
            ,valdat -- 起息日
            ,bucdat -- 记录生成日期
            ,txt1 -- 摘要1
            ,txt2 -- 传票摘要
            ,txt3 -- 摘要3
            ,prn -- 分录顺序
            ,expses -- 出口用户会话
            ,expflg -- 出口状态
            ,acttrncod -- 传票打印类型
            ,branchinr -- 业务记账机构
            ,dbtdft -- 借据号（融资时）
            ,peeact -- 对应帐号
            ,rat -- 汇率
            ,trdtyp -- 交易类型
            ,cliextkey -- 客户号
            ,whmtyp -- 结售汇类型
            ,gleord -- 分录顺序号
            ,newactcod -- 核心系统交易代码
            ,trmtyp -- 科目代号
            ,trnman -- 结售汇交易主体
            ,midrat -- 中间价
            ,xrttim -- 中间价的牌价时间
            ,income -- 结售汇损益
            ,sumtyp -- 摘要类型
            ,acttyp -- 帐目类型
            ,cshflg -- 现金标志
            ,tracode -- 交易代码
            ,ctycode -- 国家标志
            ,apvnum -- 批准号
            ,othfin -- 对方银行名称
            ,selrat -- 卖出汇率
            ,buyrat -- 买入汇率
            ,bp -- 优惠点数
            ,stzflg -- 受托支付标识
            ,settyp -- 账务类型 LIA-表外 FEE-费用 JSH-结售汇 通用记账
            ,actseqno -- 账户序号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_gle_op(
            inr -- 内部唯一ID
            ,objtyp -- 对象表名称
            ,objinr -- 对象表INR
            ,trninr -- TRN表的INR
            ,act -- 帐号
            ,dbtcdt -- 借贷标志
            ,cur -- 记账币种
            ,amt -- 记账金额
            ,syscur -- 规定币种
            ,sysamt -- 规定币种类型金额
            ,valdat -- 起息日
            ,bucdat -- 记录生成日期
            ,txt1 -- 摘要1
            ,txt2 -- 传票摘要
            ,txt3 -- 摘要3
            ,prn -- 分录顺序
            ,expses -- 出口用户会话
            ,expflg -- 出口状态
            ,acttrncod -- 传票打印类型
            ,branchinr -- 业务记账机构
            ,dbtdft -- 借据号（融资时）
            ,peeact -- 对应帐号
            ,rat -- 汇率
            ,trdtyp -- 交易类型
            ,cliextkey -- 客户号
            ,whmtyp -- 结售汇类型
            ,gleord -- 分录顺序号
            ,newactcod -- 核心系统交易代码
            ,trmtyp -- 科目代号
            ,trnman -- 结售汇交易主体
            ,midrat -- 中间价
            ,xrttim -- 中间价的牌价时间
            ,income -- 结售汇损益
            ,sumtyp -- 摘要类型
            ,acttyp -- 帐目类型
            ,cshflg -- 现金标志
            ,tracode -- 交易代码
            ,ctycode -- 国家标志
            ,apvnum -- 批准号
            ,othfin -- 对方银行名称
            ,selrat -- 卖出汇率
            ,buyrat -- 买入汇率
            ,bp -- 优惠点数
            ,stzflg -- 受托支付标识
            ,settyp -- 账务类型 LIA-表外 FEE-费用 JSH-结售汇 通用记账
            ,actseqno -- 账户序号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 内部唯一ID
    ,o.objtyp -- 对象表名称
    ,o.objinr -- 对象表INR
    ,o.trninr -- TRN表的INR
    ,o.act -- 帐号
    ,o.dbtcdt -- 借贷标志
    ,o.cur -- 记账币种
    ,o.amt -- 记账金额
    ,o.syscur -- 规定币种
    ,o.sysamt -- 规定币种类型金额
    ,o.valdat -- 起息日
    ,o.bucdat -- 记录生成日期
    ,o.txt1 -- 摘要1
    ,o.txt2 -- 传票摘要
    ,o.txt3 -- 摘要3
    ,o.prn -- 分录顺序
    ,o.expses -- 出口用户会话
    ,o.expflg -- 出口状态
    ,o.acttrncod -- 传票打印类型
    ,o.branchinr -- 业务记账机构
    ,o.dbtdft -- 借据号（融资时）
    ,o.peeact -- 对应帐号
    ,o.rat -- 汇率
    ,o.trdtyp -- 交易类型
    ,o.cliextkey -- 客户号
    ,o.whmtyp -- 结售汇类型
    ,o.gleord -- 分录顺序号
    ,o.newactcod -- 核心系统交易代码
    ,o.trmtyp -- 科目代号
    ,o.trnman -- 结售汇交易主体
    ,o.midrat -- 中间价
    ,o.xrttim -- 中间价的牌价时间
    ,o.income -- 结售汇损益
    ,o.sumtyp -- 摘要类型
    ,o.acttyp -- 帐目类型
    ,o.cshflg -- 现金标志
    ,o.tracode -- 交易代码
    ,o.ctycode -- 国家标志
    ,o.apvnum -- 批准号
    ,o.othfin -- 对方银行名称
    ,o.selrat -- 卖出汇率
    ,o.buyrat -- 买入汇率
    ,o.bp -- 优惠点数
    ,o.stzflg -- 受托支付标识
    ,o.settyp -- 账务类型 LIA-表外 FEE-费用 JSH-结售汇 通用记账
    ,o.actseqno -- 账户序号
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
from ${iol_schema}.isbs_gle_bk o
    left join ${iol_schema}.isbs_gle_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_gle_cl d
        on
            o.inr = d.inr
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.isbs_gle;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('isbs_gle') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.isbs_gle drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.isbs_gle add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.isbs_gle exchange partition p_${batch_date} with table ${iol_schema}.isbs_gle_cl;
alter table ${iol_schema}.isbs_gle exchange partition p_20991231 with table ${iol_schema}.isbs_gle_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_gle to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_gle_op purge;
drop table ${iol_schema}.isbs_gle_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_gle_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_gle',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
