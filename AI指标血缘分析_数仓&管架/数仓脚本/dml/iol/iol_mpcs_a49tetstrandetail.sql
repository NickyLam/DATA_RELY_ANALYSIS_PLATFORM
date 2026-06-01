/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a49tetstrandetail
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
create table ${iol_schema}.mpcs_a49tetstrandetail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a49tetstrandetail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a49tetstrandetail_op purge;
drop table ${iol_schema}.mpcs_a49tetstrandetail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a49tetstrandetail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a49tetstrandetail where 0=1;

create table ${iol_schema}.mpcs_a49tetstrandetail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a49tetstrandetail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a49tetstrandetail_cl(
            mqinseq -- 中台流水号
            ,cleartype -- 清算模式：BXT201 实时，PETS02批量
            ,cleardate -- ETS资金对数日期
            ,seqno -- 序号
            ,origcd -- 征收机关代码
            ,commitdate -- 提交日期
            ,origcdseqno -- 征收机关流水号
            ,openbankno -- 经收处商业银行号
            ,sapbankno -- 经收处清算支付行号
            ,trantype -- 交易类型
            ,payeracctno -- 付款账号
            ,taxiname -- 纳税人名称
            ,txpycd -- 纳税人识别号
            ,txpyna -- 附加信息
            ,detailno -- 扣款明细顺序号
            ,itemcd -- 预算外科目
            ,itemnm -- 预算外科目名称
            ,recvbankno -- 代理财政专户银行的支付行号
            ,innerpayeracctno -- 内部付款账号
            ,innerpayeracctname -- 内部付款户名
            ,payeeacctno -- 财政专户账号
            ,payeeacctname -- 财政专户户名
            ,amount -- 明细金额
            ,taxname -- 税种名称
            ,pinmuna -- 品目名称
            ,taxdate -- 所属时期
            ,addinfo -- 密押/附言
            ,hostnbr -- 核心流水号
            ,globalseqno -- 全局流水号
            ,inserttime -- 登记时间
            ,magebrn -- 管理机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a49tetstrandetail_op(
            mqinseq -- 中台流水号
            ,cleartype -- 清算模式：BXT201 实时，PETS02批量
            ,cleardate -- ETS资金对数日期
            ,seqno -- 序号
            ,origcd -- 征收机关代码
            ,commitdate -- 提交日期
            ,origcdseqno -- 征收机关流水号
            ,openbankno -- 经收处商业银行号
            ,sapbankno -- 经收处清算支付行号
            ,trantype -- 交易类型
            ,payeracctno -- 付款账号
            ,taxiname -- 纳税人名称
            ,txpycd -- 纳税人识别号
            ,txpyna -- 附加信息
            ,detailno -- 扣款明细顺序号
            ,itemcd -- 预算外科目
            ,itemnm -- 预算外科目名称
            ,recvbankno -- 代理财政专户银行的支付行号
            ,innerpayeracctno -- 内部付款账号
            ,innerpayeracctname -- 内部付款户名
            ,payeeacctno -- 财政专户账号
            ,payeeacctname -- 财政专户户名
            ,amount -- 明细金额
            ,taxname -- 税种名称
            ,pinmuna -- 品目名称
            ,taxdate -- 所属时期
            ,addinfo -- 密押/附言
            ,hostnbr -- 核心流水号
            ,globalseqno -- 全局流水号
            ,inserttime -- 登记时间
            ,magebrn -- 管理机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.mqinseq, o.mqinseq) as mqinseq -- 中台流水号
    ,nvl(n.cleartype, o.cleartype) as cleartype -- 清算模式：BXT201 实时，PETS02批量
    ,nvl(n.cleardate, o.cleardate) as cleardate -- ETS资金对数日期
    ,nvl(n.seqno, o.seqno) as seqno -- 序号
    ,nvl(n.origcd, o.origcd) as origcd -- 征收机关代码
    ,nvl(n.commitdate, o.commitdate) as commitdate -- 提交日期
    ,nvl(n.origcdseqno, o.origcdseqno) as origcdseqno -- 征收机关流水号
    ,nvl(n.openbankno, o.openbankno) as openbankno -- 经收处商业银行号
    ,nvl(n.sapbankno, o.sapbankno) as sapbankno -- 经收处清算支付行号
    ,nvl(n.trantype, o.trantype) as trantype -- 交易类型
    ,nvl(n.payeracctno, o.payeracctno) as payeracctno -- 付款账号
    ,nvl(n.taxiname, o.taxiname) as taxiname -- 纳税人名称
    ,nvl(n.txpycd, o.txpycd) as txpycd -- 纳税人识别号
    ,nvl(n.txpyna, o.txpyna) as txpyna -- 附加信息
    ,nvl(n.detailno, o.detailno) as detailno -- 扣款明细顺序号
    ,nvl(n.itemcd, o.itemcd) as itemcd -- 预算外科目
    ,nvl(n.itemnm, o.itemnm) as itemnm -- 预算外科目名称
    ,nvl(n.recvbankno, o.recvbankno) as recvbankno -- 代理财政专户银行的支付行号
    ,nvl(n.innerpayeracctno, o.innerpayeracctno) as innerpayeracctno -- 内部付款账号
    ,nvl(n.innerpayeracctname, o.innerpayeracctname) as innerpayeracctname -- 内部付款户名
    ,nvl(n.payeeacctno, o.payeeacctno) as payeeacctno -- 财政专户账号
    ,nvl(n.payeeacctname, o.payeeacctname) as payeeacctname -- 财政专户户名
    ,nvl(n.amount, o.amount) as amount -- 明细金额
    ,nvl(n.taxname, o.taxname) as taxname -- 税种名称
    ,nvl(n.pinmuna, o.pinmuna) as pinmuna -- 品目名称
    ,nvl(n.taxdate, o.taxdate) as taxdate -- 所属时期
    ,nvl(n.addinfo, o.addinfo) as addinfo -- 密押/附言
    ,nvl(n.hostnbr, o.hostnbr) as hostnbr -- 核心流水号
    ,nvl(n.globalseqno, o.globalseqno) as globalseqno -- 全局流水号
    ,nvl(n.inserttime, o.inserttime) as inserttime -- 登记时间
    ,nvl(n.magebrn, o.magebrn) as magebrn -- 管理机构
    ,case when
            n.mqinseq is null
            and n.cleartype is null
            and n.cleardate is null
            and n.seqno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.mqinseq is null
            and n.cleartype is null
            and n.cleardate is null
            and n.seqno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.mqinseq is null
            and n.cleartype is null
            and n.cleardate is null
            and n.seqno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a49tetstrandetail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a49tetstrandetail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.mqinseq = n.mqinseq
            and o.cleartype = n.cleartype
            and o.cleardate = n.cleardate
            and o.seqno = n.seqno
where (
        o.mqinseq is null
        and o.cleartype is null
        and o.cleardate is null
        and o.seqno is null
    )
    or (
        n.mqinseq is null
        and n.cleartype is null
        and n.cleardate is null
        and n.seqno is null
    )
    or (
        o.origcd <> n.origcd
        or o.commitdate <> n.commitdate
        or o.origcdseqno <> n.origcdseqno
        or o.openbankno <> n.openbankno
        or o.sapbankno <> n.sapbankno
        or o.trantype <> n.trantype
        or o.payeracctno <> n.payeracctno
        or o.taxiname <> n.taxiname
        or o.txpycd <> n.txpycd
        or o.txpyna <> n.txpyna
        or o.detailno <> n.detailno
        or o.itemcd <> n.itemcd
        or o.itemnm <> n.itemnm
        or o.recvbankno <> n.recvbankno
        or o.innerpayeracctno <> n.innerpayeracctno
        or o.innerpayeracctname <> n.innerpayeracctname
        or o.payeeacctno <> n.payeeacctno
        or o.payeeacctname <> n.payeeacctname
        or o.amount <> n.amount
        or o.taxname <> n.taxname
        or o.pinmuna <> n.pinmuna
        or o.taxdate <> n.taxdate
        or o.addinfo <> n.addinfo
        or o.hostnbr <> n.hostnbr
        or o.globalseqno <> n.globalseqno
        or o.inserttime <> n.inserttime
        or o.magebrn <> n.magebrn
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a49tetstrandetail_cl(
            mqinseq -- 中台流水号
            ,cleartype -- 清算模式：BXT201 实时，PETS02批量
            ,cleardate -- ETS资金对数日期
            ,seqno -- 序号
            ,origcd -- 征收机关代码
            ,commitdate -- 提交日期
            ,origcdseqno -- 征收机关流水号
            ,openbankno -- 经收处商业银行号
            ,sapbankno -- 经收处清算支付行号
            ,trantype -- 交易类型
            ,payeracctno -- 付款账号
            ,taxiname -- 纳税人名称
            ,txpycd -- 纳税人识别号
            ,txpyna -- 附加信息
            ,detailno -- 扣款明细顺序号
            ,itemcd -- 预算外科目
            ,itemnm -- 预算外科目名称
            ,recvbankno -- 代理财政专户银行的支付行号
            ,innerpayeracctno -- 内部付款账号
            ,innerpayeracctname -- 内部付款户名
            ,payeeacctno -- 财政专户账号
            ,payeeacctname -- 财政专户户名
            ,amount -- 明细金额
            ,taxname -- 税种名称
            ,pinmuna -- 品目名称
            ,taxdate -- 所属时期
            ,addinfo -- 密押/附言
            ,hostnbr -- 核心流水号
            ,globalseqno -- 全局流水号
            ,inserttime -- 登记时间
            ,magebrn -- 管理机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a49tetstrandetail_op(
            mqinseq -- 中台流水号
            ,cleartype -- 清算模式：BXT201 实时，PETS02批量
            ,cleardate -- ETS资金对数日期
            ,seqno -- 序号
            ,origcd -- 征收机关代码
            ,commitdate -- 提交日期
            ,origcdseqno -- 征收机关流水号
            ,openbankno -- 经收处商业银行号
            ,sapbankno -- 经收处清算支付行号
            ,trantype -- 交易类型
            ,payeracctno -- 付款账号
            ,taxiname -- 纳税人名称
            ,txpycd -- 纳税人识别号
            ,txpyna -- 附加信息
            ,detailno -- 扣款明细顺序号
            ,itemcd -- 预算外科目
            ,itemnm -- 预算外科目名称
            ,recvbankno -- 代理财政专户银行的支付行号
            ,innerpayeracctno -- 内部付款账号
            ,innerpayeracctname -- 内部付款户名
            ,payeeacctno -- 财政专户账号
            ,payeeacctname -- 财政专户户名
            ,amount -- 明细金额
            ,taxname -- 税种名称
            ,pinmuna -- 品目名称
            ,taxdate -- 所属时期
            ,addinfo -- 密押/附言
            ,hostnbr -- 核心流水号
            ,globalseqno -- 全局流水号
            ,inserttime -- 登记时间
            ,magebrn -- 管理机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.mqinseq -- 中台流水号
    ,o.cleartype -- 清算模式：BXT201 实时，PETS02批量
    ,o.cleardate -- ETS资金对数日期
    ,o.seqno -- 序号
    ,o.origcd -- 征收机关代码
    ,o.commitdate -- 提交日期
    ,o.origcdseqno -- 征收机关流水号
    ,o.openbankno -- 经收处商业银行号
    ,o.sapbankno -- 经收处清算支付行号
    ,o.trantype -- 交易类型
    ,o.payeracctno -- 付款账号
    ,o.taxiname -- 纳税人名称
    ,o.txpycd -- 纳税人识别号
    ,o.txpyna -- 附加信息
    ,o.detailno -- 扣款明细顺序号
    ,o.itemcd -- 预算外科目
    ,o.itemnm -- 预算外科目名称
    ,o.recvbankno -- 代理财政专户银行的支付行号
    ,o.innerpayeracctno -- 内部付款账号
    ,o.innerpayeracctname -- 内部付款户名
    ,o.payeeacctno -- 财政专户账号
    ,o.payeeacctname -- 财政专户户名
    ,o.amount -- 明细金额
    ,o.taxname -- 税种名称
    ,o.pinmuna -- 品目名称
    ,o.taxdate -- 所属时期
    ,o.addinfo -- 密押/附言
    ,o.hostnbr -- 核心流水号
    ,o.globalseqno -- 全局流水号
    ,o.inserttime -- 登记时间
    ,o.magebrn -- 管理机构
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
from ${iol_schema}.mpcs_a49tetstrandetail_bk o
    left join ${iol_schema}.mpcs_a49tetstrandetail_op n
        on
            o.mqinseq = n.mqinseq
            and o.cleartype = n.cleartype
            and o.cleardate = n.cleardate
            and o.seqno = n.seqno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a49tetstrandetail_cl d
        on
            o.mqinseq = d.mqinseq
            and o.cleartype = d.cleartype
            and o.cleardate = d.cleardate
            and o.seqno = d.seqno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a49tetstrandetail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a49tetstrandetail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a49tetstrandetail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a49tetstrandetail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a49tetstrandetail exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a49tetstrandetail_cl;
alter table ${iol_schema}.mpcs_a49tetstrandetail exchange partition p_20991231 with table ${iol_schema}.mpcs_a49tetstrandetail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a49tetstrandetail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a49tetstrandetail_op purge;
drop table ${iol_schema}.mpcs_a49tetstrandetail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a49tetstrandetail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a49tetstrandetail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
