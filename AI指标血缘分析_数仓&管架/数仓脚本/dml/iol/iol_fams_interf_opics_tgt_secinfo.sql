/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_interf_opics_tgt_secinfo
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
create table ${iol_schema}.fams_interf_opics_tgt_secinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_interf_opics_tgt_secinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_interf_opics_tgt_secinfo_op purge;
drop table ${iol_schema}.fams_interf_opics_tgt_secinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_interf_opics_tgt_secinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_interf_opics_tgt_secinfo where 0=1;

create table ${iol_schema}.fams_interf_opics_tgt_secinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_interf_opics_tgt_secinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_interf_opics_tgt_secinfo_cl(
            secid -- 债券代码
            ,couprate_8 -- 票面利率
            ,ratecode -- 利率代码
            ,spreadrate_8 -- 附加固定利率
            ,ccy -- 币种
            ,descr -- 描述
            ,basis -- 利息基本代码
            ,issuer -- 发行者
            ,intpaycycle -- 支付利息周期
            ,product -- 产品
            ,prodtype -- 业务类型
            ,ratebasic -- 计息基础actual/actuala/aactual/365a/365actual/360a/360
            ,couponspecies -- 息票品种贴现dis零息zco附息npv到期一次还本付息iam
            ,interestrate -- 利率类型固定利率fi浮动利率fl
            ,issdate -- 发行日
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,lstmntdate -- 更新时间
            ,facevalue -- 面值
            ,issueprice -- 发行价格
            ,intpayrule -- 利息分配方式(只针对固定利率债券)平均分配j按实际天数分配d
            ,schecalrule -- 付息生成规则(即付息计划推算方法)起息日向后vf到期日向前mb首次付息日fd
            ,firstrateday -- 首次付息日
            ,workdayrule -- 营业日准则向后next向前last调整的向后adjust不调整un
            ,ratevaluetype -- 基准利率生效方式付息后生效f当期生效d指定条件生效z
            ,ratevalueperiod -- 利率生效时期:计息期有效q计息年度有效y
            ,ratevaluecdtn -- 利率生效条件基准利率变动后固定间隔时间生效h付息前指定日期的有效基准利率q
            ,ratevaluedays -- 生效条件时间差
            ,issueamt -- 发行总额
            ,sectype -- 债券类型国债00政策性金融债01央行票据02普通金融债03普通企业债04公司债05中期06短期融资券07次级债票据08地方政府债券09资产支持证券10
            ,effectflag -- 有效标识
            ,sn -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_interf_opics_tgt_secinfo_op(
            secid -- 债券代码
            ,couprate_8 -- 票面利率
            ,ratecode -- 利率代码
            ,spreadrate_8 -- 附加固定利率
            ,ccy -- 币种
            ,descr -- 描述
            ,basis -- 利息基本代码
            ,issuer -- 发行者
            ,intpaycycle -- 支付利息周期
            ,product -- 产品
            ,prodtype -- 业务类型
            ,ratebasic -- 计息基础actual/actuala/aactual/365a/365actual/360a/360
            ,couponspecies -- 息票品种贴现dis零息zco附息npv到期一次还本付息iam
            ,interestrate -- 利率类型固定利率fi浮动利率fl
            ,issdate -- 发行日
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,lstmntdate -- 更新时间
            ,facevalue -- 面值
            ,issueprice -- 发行价格
            ,intpayrule -- 利息分配方式(只针对固定利率债券)平均分配j按实际天数分配d
            ,schecalrule -- 付息生成规则(即付息计划推算方法)起息日向后vf到期日向前mb首次付息日fd
            ,firstrateday -- 首次付息日
            ,workdayrule -- 营业日准则向后next向前last调整的向后adjust不调整un
            ,ratevaluetype -- 基准利率生效方式付息后生效f当期生效d指定条件生效z
            ,ratevalueperiod -- 利率生效时期:计息期有效q计息年度有效y
            ,ratevaluecdtn -- 利率生效条件基准利率变动后固定间隔时间生效h付息前指定日期的有效基准利率q
            ,ratevaluedays -- 生效条件时间差
            ,issueamt -- 发行总额
            ,sectype -- 债券类型国债00政策性金融债01央行票据02普通金融债03普通企业债04公司债05中期06短期融资券07次级债票据08地方政府债券09资产支持证券10
            ,effectflag -- 有效标识
            ,sn -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.secid, o.secid) as secid -- 债券代码
    ,nvl(n.couprate_8, o.couprate_8) as couprate_8 -- 票面利率
    ,nvl(n.ratecode, o.ratecode) as ratecode -- 利率代码
    ,nvl(n.spreadrate_8, o.spreadrate_8) as spreadrate_8 -- 附加固定利率
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.descr, o.descr) as descr -- 描述
    ,nvl(n.basis, o.basis) as basis -- 利息基本代码
    ,nvl(n.issuer, o.issuer) as issuer -- 发行者
    ,nvl(n.intpaycycle, o.intpaycycle) as intpaycycle -- 支付利息周期
    ,nvl(n.product, o.product) as product -- 产品
    ,nvl(n.prodtype, o.prodtype) as prodtype -- 业务类型
    ,nvl(n.ratebasic, o.ratebasic) as ratebasic -- 计息基础actual/actuala/aactual/365a/365actual/360a/360
    ,nvl(n.couponspecies, o.couponspecies) as couponspecies -- 息票品种贴现dis零息zco附息npv到期一次还本付息iam
    ,nvl(n.interestrate, o.interestrate) as interestrate -- 利率类型固定利率fi浮动利率fl
    ,nvl(n.issdate, o.issdate) as issdate -- 发行日
    ,nvl(n.vdate, o.vdate) as vdate -- 起息日
    ,nvl(n.mdate, o.mdate) as mdate -- 到期日
    ,nvl(n.lstmntdate, o.lstmntdate) as lstmntdate -- 更新时间
    ,nvl(n.facevalue, o.facevalue) as facevalue -- 面值
    ,nvl(n.issueprice, o.issueprice) as issueprice -- 发行价格
    ,nvl(n.intpayrule, o.intpayrule) as intpayrule -- 利息分配方式(只针对固定利率债券)平均分配j按实际天数分配d
    ,nvl(n.schecalrule, o.schecalrule) as schecalrule -- 付息生成规则(即付息计划推算方法)起息日向后vf到期日向前mb首次付息日fd
    ,nvl(n.firstrateday, o.firstrateday) as firstrateday -- 首次付息日
    ,nvl(n.workdayrule, o.workdayrule) as workdayrule -- 营业日准则向后next向前last调整的向后adjust不调整un
    ,nvl(n.ratevaluetype, o.ratevaluetype) as ratevaluetype -- 基准利率生效方式付息后生效f当期生效d指定条件生效z
    ,nvl(n.ratevalueperiod, o.ratevalueperiod) as ratevalueperiod -- 利率生效时期:计息期有效q计息年度有效y
    ,nvl(n.ratevaluecdtn, o.ratevaluecdtn) as ratevaluecdtn -- 利率生效条件基准利率变动后固定间隔时间生效h付息前指定日期的有效基准利率q
    ,nvl(n.ratevaluedays, o.ratevaluedays) as ratevaluedays -- 生效条件时间差
    ,nvl(n.issueamt, o.issueamt) as issueamt -- 发行总额
    ,nvl(n.sectype, o.sectype) as sectype -- 债券类型国债00政策性金融债01央行票据02普通金融债03普通企业债04公司债05中期06短期融资券07次级债票据08地方政府债券09资产支持证券10
    ,nvl(n.effectflag, o.effectflag) as effectflag -- 有效标识
    ,nvl(n.sn, o.sn) as sn -- 
    ,case when
            n.secid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.secid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.secid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_interf_opics_tgt_secinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_interf_opics_tgt_secinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.secid = n.secid
where (
        o.secid is null
    )
    or (
        n.secid is null
    )
    or (
        o.couprate_8 <> n.couprate_8
        or o.ratecode <> n.ratecode
        or o.spreadrate_8 <> n.spreadrate_8
        or o.ccy <> n.ccy
        or o.descr <> n.descr
        or o.basis <> n.basis
        or o.issuer <> n.issuer
        or o.intpaycycle <> n.intpaycycle
        or o.product <> n.product
        or o.prodtype <> n.prodtype
        or o.ratebasic <> n.ratebasic
        or o.couponspecies <> n.couponspecies
        or o.interestrate <> n.interestrate
        or o.issdate <> n.issdate
        or o.vdate <> n.vdate
        or o.mdate <> n.mdate
        or o.lstmntdate <> n.lstmntdate
        or o.facevalue <> n.facevalue
        or o.issueprice <> n.issueprice
        or o.intpayrule <> n.intpayrule
        or o.schecalrule <> n.schecalrule
        or o.firstrateday <> n.firstrateday
        or o.workdayrule <> n.workdayrule
        or o.ratevaluetype <> n.ratevaluetype
        or o.ratevalueperiod <> n.ratevalueperiod
        or o.ratevaluecdtn <> n.ratevaluecdtn
        or o.ratevaluedays <> n.ratevaluedays
        or o.issueamt <> n.issueamt
        or o.sectype <> n.sectype
        or o.effectflag <> n.effectflag
        or o.sn <> n.sn
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_interf_opics_tgt_secinfo_cl(
            secid -- 债券代码
            ,couprate_8 -- 票面利率
            ,ratecode -- 利率代码
            ,spreadrate_8 -- 附加固定利率
            ,ccy -- 币种
            ,descr -- 描述
            ,basis -- 利息基本代码
            ,issuer -- 发行者
            ,intpaycycle -- 支付利息周期
            ,product -- 产品
            ,prodtype -- 业务类型
            ,ratebasic -- 计息基础actual/actuala/aactual/365a/365actual/360a/360
            ,couponspecies -- 息票品种贴现dis零息zco附息npv到期一次还本付息iam
            ,interestrate -- 利率类型固定利率fi浮动利率fl
            ,issdate -- 发行日
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,lstmntdate -- 更新时间
            ,facevalue -- 面值
            ,issueprice -- 发行价格
            ,intpayrule -- 利息分配方式(只针对固定利率债券)平均分配j按实际天数分配d
            ,schecalrule -- 付息生成规则(即付息计划推算方法)起息日向后vf到期日向前mb首次付息日fd
            ,firstrateday -- 首次付息日
            ,workdayrule -- 营业日准则向后next向前last调整的向后adjust不调整un
            ,ratevaluetype -- 基准利率生效方式付息后生效f当期生效d指定条件生效z
            ,ratevalueperiod -- 利率生效时期:计息期有效q计息年度有效y
            ,ratevaluecdtn -- 利率生效条件基准利率变动后固定间隔时间生效h付息前指定日期的有效基准利率q
            ,ratevaluedays -- 生效条件时间差
            ,issueamt -- 发行总额
            ,sectype -- 债券类型国债00政策性金融债01央行票据02普通金融债03普通企业债04公司债05中期06短期融资券07次级债票据08地方政府债券09资产支持证券10
            ,effectflag -- 有效标识
            ,sn -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_interf_opics_tgt_secinfo_op(
            secid -- 债券代码
            ,couprate_8 -- 票面利率
            ,ratecode -- 利率代码
            ,spreadrate_8 -- 附加固定利率
            ,ccy -- 币种
            ,descr -- 描述
            ,basis -- 利息基本代码
            ,issuer -- 发行者
            ,intpaycycle -- 支付利息周期
            ,product -- 产品
            ,prodtype -- 业务类型
            ,ratebasic -- 计息基础actual/actuala/aactual/365a/365actual/360a/360
            ,couponspecies -- 息票品种贴现dis零息zco附息npv到期一次还本付息iam
            ,interestrate -- 利率类型固定利率fi浮动利率fl
            ,issdate -- 发行日
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,lstmntdate -- 更新时间
            ,facevalue -- 面值
            ,issueprice -- 发行价格
            ,intpayrule -- 利息分配方式(只针对固定利率债券)平均分配j按实际天数分配d
            ,schecalrule -- 付息生成规则(即付息计划推算方法)起息日向后vf到期日向前mb首次付息日fd
            ,firstrateday -- 首次付息日
            ,workdayrule -- 营业日准则向后next向前last调整的向后adjust不调整un
            ,ratevaluetype -- 基准利率生效方式付息后生效f当期生效d指定条件生效z
            ,ratevalueperiod -- 利率生效时期:计息期有效q计息年度有效y
            ,ratevaluecdtn -- 利率生效条件基准利率变动后固定间隔时间生效h付息前指定日期的有效基准利率q
            ,ratevaluedays -- 生效条件时间差
            ,issueamt -- 发行总额
            ,sectype -- 债券类型国债00政策性金融债01央行票据02普通金融债03普通企业债04公司债05中期06短期融资券07次级债票据08地方政府债券09资产支持证券10
            ,effectflag -- 有效标识
            ,sn -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.secid -- 债券代码
    ,o.couprate_8 -- 票面利率
    ,o.ratecode -- 利率代码
    ,o.spreadrate_8 -- 附加固定利率
    ,o.ccy -- 币种
    ,o.descr -- 描述
    ,o.basis -- 利息基本代码
    ,o.issuer -- 发行者
    ,o.intpaycycle -- 支付利息周期
    ,o.product -- 产品
    ,o.prodtype -- 业务类型
    ,o.ratebasic -- 计息基础actual/actuala/aactual/365a/365actual/360a/360
    ,o.couponspecies -- 息票品种贴现dis零息zco附息npv到期一次还本付息iam
    ,o.interestrate -- 利率类型固定利率fi浮动利率fl
    ,o.issdate -- 发行日
    ,o.vdate -- 起息日
    ,o.mdate -- 到期日
    ,o.lstmntdate -- 更新时间
    ,o.facevalue -- 面值
    ,o.issueprice -- 发行价格
    ,o.intpayrule -- 利息分配方式(只针对固定利率债券)平均分配j按实际天数分配d
    ,o.schecalrule -- 付息生成规则(即付息计划推算方法)起息日向后vf到期日向前mb首次付息日fd
    ,o.firstrateday -- 首次付息日
    ,o.workdayrule -- 营业日准则向后next向前last调整的向后adjust不调整un
    ,o.ratevaluetype -- 基准利率生效方式付息后生效f当期生效d指定条件生效z
    ,o.ratevalueperiod -- 利率生效时期:计息期有效q计息年度有效y
    ,o.ratevaluecdtn -- 利率生效条件基准利率变动后固定间隔时间生效h付息前指定日期的有效基准利率q
    ,o.ratevaluedays -- 生效条件时间差
    ,o.issueamt -- 发行总额
    ,o.sectype -- 债券类型国债00政策性金融债01央行票据02普通金融债03普通企业债04公司债05中期06短期融资券07次级债票据08地方政府债券09资产支持证券10
    ,o.effectflag -- 有效标识
    ,o.sn -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.fams_interf_opics_tgt_secinfo_bk o
    left join ${iol_schema}.fams_interf_opics_tgt_secinfo_op n
        on
            o.secid = n.secid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_interf_opics_tgt_secinfo_cl d
        on
            o.secid = d.secid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.fams_interf_opics_tgt_secinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.fams_interf_opics_tgt_secinfo exchange partition p_19000101 with table ${iol_schema}.fams_interf_opics_tgt_secinfo_cl;
alter table ${iol_schema}.fams_interf_opics_tgt_secinfo exchange partition p_20991231 with table ${iol_schema}.fams_interf_opics_tgt_secinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_interf_opics_tgt_secinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_interf_opics_tgt_secinfo_op purge;
drop table ${iol_schema}.fams_interf_opics_tgt_secinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_interf_opics_tgt_secinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_interf_opics_tgt_secinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
