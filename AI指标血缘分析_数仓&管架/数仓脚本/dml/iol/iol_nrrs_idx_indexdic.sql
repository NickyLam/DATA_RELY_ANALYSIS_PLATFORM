/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nrrs_idx_indexdic
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
create table ${iol_schema}.nrrs_idx_indexdic_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nrrs_idx_indexdic;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nrrs_idx_indexdic_op purge;
drop table ${iol_schema}.nrrs_idx_indexdic_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_idx_indexdic_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nrrs_idx_indexdic where 0=1;

create table ${iol_schema}.nrrs_idx_indexdic_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nrrs_idx_indexdic where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nrrs_idx_indexdic_cl(
            indexcode -- 指标编码
            ,indexname -- 指标名称
            ,indextype -- 指标类别
            ,indexcycle -- 指标周期
            ,placedtable -- 指标存放表
            ,placedfield -- 指标值存放字段
            ,prikeynum -- 指标主键个数
            ,prikey1 -- 指标主键1
            ,prikey2 -- 指标主键2
            ,prikey3 -- 指标主键3
            ,prikey4 -- 指标主键4
            ,prikey5 -- 指标主键5
            ,summarizetype -- 指标汇总方式
            ,algtype -- 指标算法类别
            ,sourcetype -- 指标来源类别
            ,state -- 指标状态
            ,defaultmethod -- 缺值处理方式
            ,units -- 指标单位
            ,flag -- 指标标志
            ,flaginfo -- 指标定性相关信息
            ,fraudtype -- 反欺诈类型
            ,isimportant -- 是否主要指标
            ,trends -- 趋势
            ,indexsubtype -- 指标细类
            ,indexlevel -- 指标层次
            ,istmpindex -- 是否临时指标
            ,sampletype -- 样本类型
            ,remark -- 备注
            ,nounsuper -- 对应字典编号
            ,debtadjustlfid -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nrrs_idx_indexdic_op(
            indexcode -- 指标编码
            ,indexname -- 指标名称
            ,indextype -- 指标类别
            ,indexcycle -- 指标周期
            ,placedtable -- 指标存放表
            ,placedfield -- 指标值存放字段
            ,prikeynum -- 指标主键个数
            ,prikey1 -- 指标主键1
            ,prikey2 -- 指标主键2
            ,prikey3 -- 指标主键3
            ,prikey4 -- 指标主键4
            ,prikey5 -- 指标主键5
            ,summarizetype -- 指标汇总方式
            ,algtype -- 指标算法类别
            ,sourcetype -- 指标来源类别
            ,state -- 指标状态
            ,defaultmethod -- 缺值处理方式
            ,units -- 指标单位
            ,flag -- 指标标志
            ,flaginfo -- 指标定性相关信息
            ,fraudtype -- 反欺诈类型
            ,isimportant -- 是否主要指标
            ,trends -- 趋势
            ,indexsubtype -- 指标细类
            ,indexlevel -- 指标层次
            ,istmpindex -- 是否临时指标
            ,sampletype -- 样本类型
            ,remark -- 备注
            ,nounsuper -- 对应字典编号
            ,debtadjustlfid -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.indexcode, o.indexcode) as indexcode -- 指标编码
    ,nvl(n.indexname, o.indexname) as indexname -- 指标名称
    ,nvl(n.indextype, o.indextype) as indextype -- 指标类别
    ,nvl(n.indexcycle, o.indexcycle) as indexcycle -- 指标周期
    ,nvl(n.placedtable, o.placedtable) as placedtable -- 指标存放表
    ,nvl(n.placedfield, o.placedfield) as placedfield -- 指标值存放字段
    ,nvl(n.prikeynum, o.prikeynum) as prikeynum -- 指标主键个数
    ,nvl(n.prikey1, o.prikey1) as prikey1 -- 指标主键1
    ,nvl(n.prikey2, o.prikey2) as prikey2 -- 指标主键2
    ,nvl(n.prikey3, o.prikey3) as prikey3 -- 指标主键3
    ,nvl(n.prikey4, o.prikey4) as prikey4 -- 指标主键4
    ,nvl(n.prikey5, o.prikey5) as prikey5 -- 指标主键5
    ,nvl(n.summarizetype, o.summarizetype) as summarizetype -- 指标汇总方式
    ,nvl(n.algtype, o.algtype) as algtype -- 指标算法类别
    ,nvl(n.sourcetype, o.sourcetype) as sourcetype -- 指标来源类别
    ,nvl(n.state, o.state) as state -- 指标状态
    ,nvl(n.defaultmethod, o.defaultmethod) as defaultmethod -- 缺值处理方式
    ,nvl(n.units, o.units) as units -- 指标单位
    ,nvl(n.flag, o.flag) as flag -- 指标标志
    ,nvl(n.flaginfo, o.flaginfo) as flaginfo -- 指标定性相关信息
    ,nvl(n.fraudtype, o.fraudtype) as fraudtype -- 反欺诈类型
    ,nvl(n.isimportant, o.isimportant) as isimportant -- 是否主要指标
    ,nvl(n.trends, o.trends) as trends -- 趋势
    ,nvl(n.indexsubtype, o.indexsubtype) as indexsubtype -- 指标细类
    ,nvl(n.indexlevel, o.indexlevel) as indexlevel -- 指标层次
    ,nvl(n.istmpindex, o.istmpindex) as istmpindex -- 是否临时指标
    ,nvl(n.sampletype, o.sampletype) as sampletype -- 样本类型
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.nounsuper, o.nounsuper) as nounsuper -- 对应字典编号
    ,nvl(n.debtadjustlfid, o.debtadjustlfid) as debtadjustlfid -- 
    ,case when
            n.indexcode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.indexcode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.indexcode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nrrs_idx_indexdic_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nrrs_idx_indexdic where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.indexcode = n.indexcode
where (
        o.indexcode is null
    )
    or (
        n.indexcode is null
    )
    or (
        o.indexname <> n.indexname
        or o.indextype <> n.indextype
        or o.indexcycle <> n.indexcycle
        or o.placedtable <> n.placedtable
        or o.placedfield <> n.placedfield
        or o.prikeynum <> n.prikeynum
        or o.prikey1 <> n.prikey1
        or o.prikey2 <> n.prikey2
        or o.prikey3 <> n.prikey3
        or o.prikey4 <> n.prikey4
        or o.prikey5 <> n.prikey5
        or o.summarizetype <> n.summarizetype
        or o.algtype <> n.algtype
        or o.sourcetype <> n.sourcetype
        or o.state <> n.state
        or o.defaultmethod <> n.defaultmethod
        or o.units <> n.units
        or o.flag <> n.flag
        or o.flaginfo <> n.flaginfo
        or o.fraudtype <> n.fraudtype
        or o.isimportant <> n.isimportant
        or o.trends <> n.trends
        or o.indexsubtype <> n.indexsubtype
        or o.indexlevel <> n.indexlevel
        or o.istmpindex <> n.istmpindex
        or o.sampletype <> n.sampletype
        or o.remark <> n.remark
        or o.nounsuper <> n.nounsuper
        or o.debtadjustlfid <> n.debtadjustlfid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nrrs_idx_indexdic_cl(
            indexcode -- 指标编码
            ,indexname -- 指标名称
            ,indextype -- 指标类别
            ,indexcycle -- 指标周期
            ,placedtable -- 指标存放表
            ,placedfield -- 指标值存放字段
            ,prikeynum -- 指标主键个数
            ,prikey1 -- 指标主键1
            ,prikey2 -- 指标主键2
            ,prikey3 -- 指标主键3
            ,prikey4 -- 指标主键4
            ,prikey5 -- 指标主键5
            ,summarizetype -- 指标汇总方式
            ,algtype -- 指标算法类别
            ,sourcetype -- 指标来源类别
            ,state -- 指标状态
            ,defaultmethod -- 缺值处理方式
            ,units -- 指标单位
            ,flag -- 指标标志
            ,flaginfo -- 指标定性相关信息
            ,fraudtype -- 反欺诈类型
            ,isimportant -- 是否主要指标
            ,trends -- 趋势
            ,indexsubtype -- 指标细类
            ,indexlevel -- 指标层次
            ,istmpindex -- 是否临时指标
            ,sampletype -- 样本类型
            ,remark -- 备注
            ,nounsuper -- 对应字典编号
            ,debtadjustlfid -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nrrs_idx_indexdic_op(
            indexcode -- 指标编码
            ,indexname -- 指标名称
            ,indextype -- 指标类别
            ,indexcycle -- 指标周期
            ,placedtable -- 指标存放表
            ,placedfield -- 指标值存放字段
            ,prikeynum -- 指标主键个数
            ,prikey1 -- 指标主键1
            ,prikey2 -- 指标主键2
            ,prikey3 -- 指标主键3
            ,prikey4 -- 指标主键4
            ,prikey5 -- 指标主键5
            ,summarizetype -- 指标汇总方式
            ,algtype -- 指标算法类别
            ,sourcetype -- 指标来源类别
            ,state -- 指标状态
            ,defaultmethod -- 缺值处理方式
            ,units -- 指标单位
            ,flag -- 指标标志
            ,flaginfo -- 指标定性相关信息
            ,fraudtype -- 反欺诈类型
            ,isimportant -- 是否主要指标
            ,trends -- 趋势
            ,indexsubtype -- 指标细类
            ,indexlevel -- 指标层次
            ,istmpindex -- 是否临时指标
            ,sampletype -- 样本类型
            ,remark -- 备注
            ,nounsuper -- 对应字典编号
            ,debtadjustlfid -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.indexcode -- 指标编码
    ,o.indexname -- 指标名称
    ,o.indextype -- 指标类别
    ,o.indexcycle -- 指标周期
    ,o.placedtable -- 指标存放表
    ,o.placedfield -- 指标值存放字段
    ,o.prikeynum -- 指标主键个数
    ,o.prikey1 -- 指标主键1
    ,o.prikey2 -- 指标主键2
    ,o.prikey3 -- 指标主键3
    ,o.prikey4 -- 指标主键4
    ,o.prikey5 -- 指标主键5
    ,o.summarizetype -- 指标汇总方式
    ,o.algtype -- 指标算法类别
    ,o.sourcetype -- 指标来源类别
    ,o.state -- 指标状态
    ,o.defaultmethod -- 缺值处理方式
    ,o.units -- 指标单位
    ,o.flag -- 指标标志
    ,o.flaginfo -- 指标定性相关信息
    ,o.fraudtype -- 反欺诈类型
    ,o.isimportant -- 是否主要指标
    ,o.trends -- 趋势
    ,o.indexsubtype -- 指标细类
    ,o.indexlevel -- 指标层次
    ,o.istmpindex -- 是否临时指标
    ,o.sampletype -- 样本类型
    ,o.remark -- 备注
    ,o.nounsuper -- 对应字典编号
    ,o.debtadjustlfid -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.nrrs_idx_indexdic_bk o
    left join ${iol_schema}.nrrs_idx_indexdic_op n
        on
            o.indexcode = n.indexcode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nrrs_idx_indexdic_cl d
        on
            o.indexcode = d.indexcode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.nrrs_idx_indexdic;

-- 4.2 exchange partition
alter table ${iol_schema}.nrrs_idx_indexdic exchange partition p_19000101 with table ${iol_schema}.nrrs_idx_indexdic_cl;
alter table ${iol_schema}.nrrs_idx_indexdic exchange partition p_20991231 with table ${iol_schema}.nrrs_idx_indexdic_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nrrs_idx_indexdic to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nrrs_idx_indexdic_op purge;
drop table ${iol_schema}.nrrs_idx_indexdic_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nrrs_idx_indexdic_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nrrs_idx_indexdic',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
