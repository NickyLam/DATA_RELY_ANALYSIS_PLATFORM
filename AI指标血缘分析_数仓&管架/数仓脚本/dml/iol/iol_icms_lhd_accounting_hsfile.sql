/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_lhd_accounting_hsfile
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
create table ${iol_schema}.icms_lhd_accounting_hsfile_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_lhd_accounting_hsfile
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lhd_accounting_hsfile_op purge;
drop table ${iol_schema}.icms_lhd_accounting_hsfile_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lhd_accounting_hsfile_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lhd_accounting_hsfile where 0=1;

create table ${iol_schema}.icms_lhd_accounting_hsfile_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lhd_accounting_hsfile where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_lhd_accounting_hsfile_cl(
            soursq -- 源系统流水号,按照该流水表内借贷平衡
            ,vchrsq -- 传票序号,流水号+序号能对应到唯一的一条流水数据
            ,assis9 -- 辅助核算9,不启用，传空值
            ,tranbr -- 交易机构编号,一个交易流水的“交易机构”只能有一个
            ,assis0 -- 辅助核算0,渠道号，若无，则提供默认值
            ,chrex1 -- 授权用户,营运复核岗-域用户编号
            ,itemcd -- 科目编号,按照新科目提供
            ,tranam -- 交易金额,支持负数
            ,acctno -- 协议编号,同业系统不提供
            ,sourdt -- 源系统日期,YYYYMMHH
            ,prcscd -- 交易码,处理码，用以价税分离使用，若存在需要做价税分离需要传送
            ,custcd -- 客户号,为了传给增值税系统开具增值税发票
            ,assis2 -- 辅助核算2,不启用，传空值
            ,chrex3 -- 冲抹原交易流水号,同业系统无法提供，核算根据冲抹标记生成冲销分录，该字段为本身GLI_VCHR的字段
            ,amntcd -- 借贷方向,借：D贷：C
            ,assis1 -- 辅助核算1,
            ,assis4 -- 辅助核算4,对应的收入科目是否免税标识：免税、应税、不征税
            ,bsnssq -- 全局流水号,指全局流水，新一代统一规划，按照数据标准提供。
            ,assis3 -- 辅助核算3,不启用，传空值
            ,assis7 -- 辅助核算7,不启用，传空值
            ,prducd -- 产品,即可售产品核心产品工厂统一的编码
            ,chrex0 -- 交易用户,营运经办岗-域用户编号
            ,assis8 -- 辅助核算8,不启用，传空值
            ,crcycd -- 币种,3位字母币种，人民币：CNY
            ,assis5 -- 辅助核算5,不启用，传空值
            ,datex0 -- 交易时间,记账时间HHMMSS
            ,sourst -- 系统代号，外围系统代号
            ,acctbr -- 账务机构编号,客户的开户机构或者核算机构
            ,smrytx -- 摘要,
            ,taxam -- 税额,对于同业系统，为适配金融商品转让税则对应的税额
            ,chrex4 -- 冲抹标记,0-非冲抹账务1-冲抹账务
            ,assis6 -- 辅助核算6,不启用，传空值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_lhd_accounting_hsfile_op(
            soursq -- 源系统流水号,按照该流水表内借贷平衡
            ,vchrsq -- 传票序号,流水号+序号能对应到唯一的一条流水数据
            ,assis9 -- 辅助核算9,不启用，传空值
            ,tranbr -- 交易机构编号,一个交易流水的“交易机构”只能有一个
            ,assis0 -- 辅助核算0,渠道号，若无，则提供默认值
            ,chrex1 -- 授权用户,营运复核岗-域用户编号
            ,itemcd -- 科目编号,按照新科目提供
            ,tranam -- 交易金额,支持负数
            ,acctno -- 协议编号,同业系统不提供
            ,sourdt -- 源系统日期,YYYYMMHH
            ,prcscd -- 交易码,处理码，用以价税分离使用，若存在需要做价税分离需要传送
            ,custcd -- 客户号,为了传给增值税系统开具增值税发票
            ,assis2 -- 辅助核算2,不启用，传空值
            ,chrex3 -- 冲抹原交易流水号,同业系统无法提供，核算根据冲抹标记生成冲销分录，该字段为本身GLI_VCHR的字段
            ,amntcd -- 借贷方向,借：D贷：C
            ,assis1 -- 辅助核算1,
            ,assis4 -- 辅助核算4,对应的收入科目是否免税标识：免税、应税、不征税
            ,bsnssq -- 全局流水号,指全局流水，新一代统一规划，按照数据标准提供。
            ,assis3 -- 辅助核算3,不启用，传空值
            ,assis7 -- 辅助核算7,不启用，传空值
            ,prducd -- 产品,即可售产品核心产品工厂统一的编码
            ,chrex0 -- 交易用户,营运经办岗-域用户编号
            ,assis8 -- 辅助核算8,不启用，传空值
            ,crcycd -- 币种,3位字母币种，人民币：CNY
            ,assis5 -- 辅助核算5,不启用，传空值
            ,datex0 -- 交易时间,记账时间HHMMSS
            ,sourst -- 系统代号，外围系统代号
            ,acctbr -- 账务机构编号,客户的开户机构或者核算机构
            ,smrytx -- 摘要,
            ,taxam -- 税额,对于同业系统，为适配金融商品转让税则对应的税额
            ,chrex4 -- 冲抹标记,0-非冲抹账务1-冲抹账务
            ,assis6 -- 辅助核算6,不启用，传空值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.soursq, o.soursq) as soursq -- 源系统流水号,按照该流水表内借贷平衡
    ,nvl(n.vchrsq, o.vchrsq) as vchrsq -- 传票序号,流水号+序号能对应到唯一的一条流水数据
    ,nvl(n.assis9, o.assis9) as assis9 -- 辅助核算9,不启用，传空值
    ,nvl(n.tranbr, o.tranbr) as tranbr -- 交易机构编号,一个交易流水的“交易机构”只能有一个
    ,nvl(n.assis0, o.assis0) as assis0 -- 辅助核算0,渠道号，若无，则提供默认值
    ,nvl(n.chrex1, o.chrex1) as chrex1 -- 授权用户,营运复核岗-域用户编号
    ,nvl(n.itemcd, o.itemcd) as itemcd -- 科目编号,按照新科目提供
    ,nvl(n.tranam, o.tranam) as tranam -- 交易金额,支持负数
    ,nvl(n.acctno, o.acctno) as acctno -- 协议编号,同业系统不提供
    ,nvl(n.sourdt, o.sourdt) as sourdt -- 源系统日期,YYYYMMHH
    ,nvl(n.prcscd, o.prcscd) as prcscd -- 交易码,处理码，用以价税分离使用，若存在需要做价税分离需要传送
    ,nvl(n.custcd, o.custcd) as custcd -- 客户号,为了传给增值税系统开具增值税发票
    ,nvl(n.assis2, o.assis2) as assis2 -- 辅助核算2,不启用，传空值
    ,nvl(n.chrex3, o.chrex3) as chrex3 -- 冲抹原交易流水号,同业系统无法提供，核算根据冲抹标记生成冲销分录，该字段为本身GLI_VCHR的字段
    ,nvl(n.amntcd, o.amntcd) as amntcd -- 借贷方向,借：D贷：C
    ,nvl(n.assis1, o.assis1) as assis1 -- 辅助核算1,
    ,nvl(n.assis4, o.assis4) as assis4 -- 辅助核算4,对应的收入科目是否免税标识：免税、应税、不征税
    ,nvl(n.bsnssq, o.bsnssq) as bsnssq -- 全局流水号,指全局流水，新一代统一规划，按照数据标准提供。
    ,nvl(n.assis3, o.assis3) as assis3 -- 辅助核算3,不启用，传空值
    ,nvl(n.assis7, o.assis7) as assis7 -- 辅助核算7,不启用，传空值
    ,nvl(n.prducd, o.prducd) as prducd -- 产品,即可售产品核心产品工厂统一的编码
    ,nvl(n.chrex0, o.chrex0) as chrex0 -- 交易用户,营运经办岗-域用户编号
    ,nvl(n.assis8, o.assis8) as assis8 -- 辅助核算8,不启用，传空值
    ,nvl(n.crcycd, o.crcycd) as crcycd -- 币种,3位字母币种，人民币：CNY
    ,nvl(n.assis5, o.assis5) as assis5 -- 辅助核算5,不启用，传空值
    ,nvl(n.datex0, o.datex0) as datex0 -- 交易时间,记账时间HHMMSS
    ,nvl(n.sourst, o.sourst) as sourst -- 系统代号，外围系统代号
    ,nvl(n.acctbr, o.acctbr) as acctbr -- 账务机构编号,客户的开户机构或者核算机构
    ,nvl(n.smrytx, o.smrytx) as smrytx -- 摘要,
    ,nvl(n.taxam, o.taxam) as taxam -- 税额,对于同业系统，为适配金融商品转让税则对应的税额
    ,nvl(n.chrex4, o.chrex4) as chrex4 -- 冲抹标记,0-非冲抹账务1-冲抹账务
    ,nvl(n.assis6, o.assis6) as assis6 -- 辅助核算6,不启用，传空值
    ,case when
            n.soursq is null
            and n.vchrsq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.soursq is null
            and n.vchrsq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.soursq is null
            and n.vchrsq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_lhd_accounting_hsfile_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_lhd_accounting_hsfile where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.soursq = n.soursq
            and o.vchrsq = n.vchrsq
where (
        o.soursq is null
        and o.vchrsq is null
    )
    or (
        n.soursq is null
        and n.vchrsq is null
    )
    or (
        o.assis9 <> n.assis9
        or o.tranbr <> n.tranbr
        or o.assis0 <> n.assis0
        or o.chrex1 <> n.chrex1
        or o.itemcd <> n.itemcd
        or o.tranam <> n.tranam
        or o.acctno <> n.acctno
        or o.sourdt <> n.sourdt
        or o.prcscd <> n.prcscd
        or o.custcd <> n.custcd
        or o.assis2 <> n.assis2
        or o.chrex3 <> n.chrex3
        or o.amntcd <> n.amntcd
        or o.assis1 <> n.assis1
        or o.assis4 <> n.assis4
        or o.bsnssq <> n.bsnssq
        or o.assis3 <> n.assis3
        or o.assis7 <> n.assis7
        or o.prducd <> n.prducd
        or o.chrex0 <> n.chrex0
        or o.assis8 <> n.assis8
        or o.crcycd <> n.crcycd
        or o.assis5 <> n.assis5
        or o.datex0 <> n.datex0
        or o.sourst <> n.sourst
        or o.acctbr <> n.acctbr
        or o.smrytx <> n.smrytx
        or o.taxam <> n.taxam
        or o.chrex4 <> n.chrex4
        or o.assis6 <> n.assis6
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_lhd_accounting_hsfile_cl(
            soursq -- 源系统流水号,按照该流水表内借贷平衡
            ,vchrsq -- 传票序号,流水号+序号能对应到唯一的一条流水数据
            ,assis9 -- 辅助核算9,不启用，传空值
            ,tranbr -- 交易机构编号,一个交易流水的“交易机构”只能有一个
            ,assis0 -- 辅助核算0,渠道号，若无，则提供默认值
            ,chrex1 -- 授权用户,营运复核岗-域用户编号
            ,itemcd -- 科目编号,按照新科目提供
            ,tranam -- 交易金额,支持负数
            ,acctno -- 协议编号,同业系统不提供
            ,sourdt -- 源系统日期,YYYYMMHH
            ,prcscd -- 交易码,处理码，用以价税分离使用，若存在需要做价税分离需要传送
            ,custcd -- 客户号,为了传给增值税系统开具增值税发票
            ,assis2 -- 辅助核算2,不启用，传空值
            ,chrex3 -- 冲抹原交易流水号,同业系统无法提供，核算根据冲抹标记生成冲销分录，该字段为本身GLI_VCHR的字段
            ,amntcd -- 借贷方向,借：D贷：C
            ,assis1 -- 辅助核算1,
            ,assis4 -- 辅助核算4,对应的收入科目是否免税标识：免税、应税、不征税
            ,bsnssq -- 全局流水号,指全局流水，新一代统一规划，按照数据标准提供。
            ,assis3 -- 辅助核算3,不启用，传空值
            ,assis7 -- 辅助核算7,不启用，传空值
            ,prducd -- 产品,即可售产品核心产品工厂统一的编码
            ,chrex0 -- 交易用户,营运经办岗-域用户编号
            ,assis8 -- 辅助核算8,不启用，传空值
            ,crcycd -- 币种,3位字母币种，人民币：CNY
            ,assis5 -- 辅助核算5,不启用，传空值
            ,datex0 -- 交易时间,记账时间HHMMSS
            ,sourst -- 系统代号，外围系统代号
            ,acctbr -- 账务机构编号,客户的开户机构或者核算机构
            ,smrytx -- 摘要,
            ,taxam -- 税额,对于同业系统，为适配金融商品转让税则对应的税额
            ,chrex4 -- 冲抹标记,0-非冲抹账务1-冲抹账务
            ,assis6 -- 辅助核算6,不启用，传空值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_lhd_accounting_hsfile_op(
            soursq -- 源系统流水号,按照该流水表内借贷平衡
            ,vchrsq -- 传票序号,流水号+序号能对应到唯一的一条流水数据
            ,assis9 -- 辅助核算9,不启用，传空值
            ,tranbr -- 交易机构编号,一个交易流水的“交易机构”只能有一个
            ,assis0 -- 辅助核算0,渠道号，若无，则提供默认值
            ,chrex1 -- 授权用户,营运复核岗-域用户编号
            ,itemcd -- 科目编号,按照新科目提供
            ,tranam -- 交易金额,支持负数
            ,acctno -- 协议编号,同业系统不提供
            ,sourdt -- 源系统日期,YYYYMMHH
            ,prcscd -- 交易码,处理码，用以价税分离使用，若存在需要做价税分离需要传送
            ,custcd -- 客户号,为了传给增值税系统开具增值税发票
            ,assis2 -- 辅助核算2,不启用，传空值
            ,chrex3 -- 冲抹原交易流水号,同业系统无法提供，核算根据冲抹标记生成冲销分录，该字段为本身GLI_VCHR的字段
            ,amntcd -- 借贷方向,借：D贷：C
            ,assis1 -- 辅助核算1,
            ,assis4 -- 辅助核算4,对应的收入科目是否免税标识：免税、应税、不征税
            ,bsnssq -- 全局流水号,指全局流水，新一代统一规划，按照数据标准提供。
            ,assis3 -- 辅助核算3,不启用，传空值
            ,assis7 -- 辅助核算7,不启用，传空值
            ,prducd -- 产品,即可售产品核心产品工厂统一的编码
            ,chrex0 -- 交易用户,营运经办岗-域用户编号
            ,assis8 -- 辅助核算8,不启用，传空值
            ,crcycd -- 币种,3位字母币种，人民币：CNY
            ,assis5 -- 辅助核算5,不启用，传空值
            ,datex0 -- 交易时间,记账时间HHMMSS
            ,sourst -- 系统代号，外围系统代号
            ,acctbr -- 账务机构编号,客户的开户机构或者核算机构
            ,smrytx -- 摘要,
            ,taxam -- 税额,对于同业系统，为适配金融商品转让税则对应的税额
            ,chrex4 -- 冲抹标记,0-非冲抹账务1-冲抹账务
            ,assis6 -- 辅助核算6,不启用，传空值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.soursq -- 源系统流水号,按照该流水表内借贷平衡
    ,o.vchrsq -- 传票序号,流水号+序号能对应到唯一的一条流水数据
    ,o.assis9 -- 辅助核算9,不启用，传空值
    ,o.tranbr -- 交易机构编号,一个交易流水的“交易机构”只能有一个
    ,o.assis0 -- 辅助核算0,渠道号，若无，则提供默认值
    ,o.chrex1 -- 授权用户,营运复核岗-域用户编号
    ,o.itemcd -- 科目编号,按照新科目提供
    ,o.tranam -- 交易金额,支持负数
    ,o.acctno -- 协议编号,同业系统不提供
    ,o.sourdt -- 源系统日期,YYYYMMHH
    ,o.prcscd -- 交易码,处理码，用以价税分离使用，若存在需要做价税分离需要传送
    ,o.custcd -- 客户号,为了传给增值税系统开具增值税发票
    ,o.assis2 -- 辅助核算2,不启用，传空值
    ,o.chrex3 -- 冲抹原交易流水号,同业系统无法提供，核算根据冲抹标记生成冲销分录，该字段为本身GLI_VCHR的字段
    ,o.amntcd -- 借贷方向,借：D贷：C
    ,o.assis1 -- 辅助核算1,
    ,o.assis4 -- 辅助核算4,对应的收入科目是否免税标识：免税、应税、不征税
    ,o.bsnssq -- 全局流水号,指全局流水，新一代统一规划，按照数据标准提供。
    ,o.assis3 -- 辅助核算3,不启用，传空值
    ,o.assis7 -- 辅助核算7,不启用，传空值
    ,o.prducd -- 产品,即可售产品核心产品工厂统一的编码
    ,o.chrex0 -- 交易用户,营运经办岗-域用户编号
    ,o.assis8 -- 辅助核算8,不启用，传空值
    ,o.crcycd -- 币种,3位字母币种，人民币：CNY
    ,o.assis5 -- 辅助核算5,不启用，传空值
    ,o.datex0 -- 交易时间,记账时间HHMMSS
    ,o.sourst -- 系统代号，外围系统代号
    ,o.acctbr -- 账务机构编号,客户的开户机构或者核算机构
    ,o.smrytx -- 摘要,
    ,o.taxam -- 税额,对于同业系统，为适配金融商品转让税则对应的税额
    ,o.chrex4 -- 冲抹标记,0-非冲抹账务1-冲抹账务
    ,o.assis6 -- 辅助核算6,不启用，传空值
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
from ${iol_schema}.icms_lhd_accounting_hsfile_bk o
    left join ${iol_schema}.icms_lhd_accounting_hsfile_op n
        on
            o.soursq = n.soursq
            and o.vchrsq = n.vchrsq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_lhd_accounting_hsfile_cl d
        on
            o.soursq = d.soursq
            and o.vchrsq = d.vchrsq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_lhd_accounting_hsfile;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_lhd_accounting_hsfile') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_lhd_accounting_hsfile drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_lhd_accounting_hsfile add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_lhd_accounting_hsfile exchange partition p_${batch_date} with table ${iol_schema}.icms_lhd_accounting_hsfile_cl;
alter table ${iol_schema}.icms_lhd_accounting_hsfile exchange partition p_20991231 with table ${iol_schema}.icms_lhd_accounting_hsfile_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_lhd_accounting_hsfile to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lhd_accounting_hsfile_op purge;
drop table ${iol_schema}.icms_lhd_accounting_hsfile_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_lhd_accounting_hsfile_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_lhd_accounting_hsfile',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
