/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_intstl_bal_h_isbsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_intstl_bal_h add partition p_isbsf1 values ('isbsf1')(
        subpartition p_isbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_isbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_intstl_bal_h_isbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_intstl_bal_h partition for ('isbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_intstl_bal_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_intstl_bal_h_isbsf1_op purge;
drop table ${iml_schema}.agt_intstl_bal_h_isbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_intstl_bal_h_isbsf1_tm nologging
compress ${option_switch} for query high
as select
    bal_id -- 余额编号
    ,lp_id -- 法人编号
    ,agt_id -- 协议编号
    ,src_agt_id -- 源协议编号
    ,agt_type_cd -- 协议类型代码
    ,bus_table_name -- 业务表名称
    ,amt_type_cd -- 金额类型代码
    ,ext_amt_type -- 外部金额类型
    ,amt_vp_start_dt -- 金额有效期开始日期
    ,amt_vp_end_dt -- 金额有效期结束日期
    ,curr_cd -- 币种代码
    ,amt -- 金额
    ,cors_amt_src_id -- 对应金额源编号
    ,froz_id -- 冻结编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_intstl_bal_h partition for ('isbsf1')
where 0=1
;

create table ${iml_schema}.agt_intstl_bal_h_isbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_intstl_bal_h partition for ('isbsf1') where 0=1;

create table ${iml_schema}.agt_intstl_bal_h_isbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_intstl_bal_h partition for ('isbsf1') where 0=1;

-- 3.1 get new data into table
-- isbs_cbb
insert into ${iml_schema}.agt_intstl_bal_h_isbsf1_tm(
    bal_id -- 余额编号
    ,lp_id -- 法人编号
    ,agt_id -- 协议编号
    ,src_agt_id -- 源协议编号
    ,agt_type_cd -- 协议类型代码
    ,bus_table_name -- 业务表名称
    ,amt_type_cd -- 金额类型代码
    ,ext_amt_type -- 外部金额类型
    ,amt_vp_start_dt -- 金额有效期开始日期
    ,amt_vp_end_dt -- 金额有效期结束日期
    ,curr_cd -- 币种代码
    ,amt -- 金额
    ,cors_amt_src_id -- 对应金额源编号
    ,froz_id -- 冻结编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.INR -- 余额编号
    ,'9999' -- 法人编号
    ,case when P1.OBJTYP='BRD' then '222312'||P1.OBJINR
     when P1.OBJTYP='LID' then '222311'||P1.OBJINR
     when P1.OBJTYP='BED' then '222310'||P1.OBJINR
     when P1.OBJTYP='CPD' then '222309'||P1.OBJINR
     when P1.OBJTYP='GID' then '226303'||P1.OBJINR
     when P1.OBJTYP='GWD' then '222306'||P1.OBJINR
     when P1.OBJTYP='LED' then '222307'||P1.OBJINR
     when P1.OBJTYP='BOD' then '222308'||P1.OBJINR
     when P1.OBJTYP='ACT' then '130015'||P1.OBJINR
     when P1.OBJTYP='DBG' then '226101'||P1.OBJINR
     when P1.OBJTYP='DBH' then '226201'||P1.OBJINR
     when P1.OBJTYP='DBK' then '226202'||P1.OBJINR
     when P1.OBJTYP='DBQ' then '226301'||P1.OBJINR
     when P1.OBJTYP='DBR' then '226102'||P1.OBJINR
     when P1.OBJTYP='DBS' then '226302'||P1.OBJINR
     when P1.OBJTYP='CLR' then '222313'||P1.OBJINR
     when P1.OBJTYP='DID' then '222314'||P1.OBJINR
     when P1.OBJTYP='BDD' then '222315'||P1.OBJINR
     when P1.OBJTYP='TRD' then P1.OBJINR
else P1.OBJTYP||P1.OBJINR end -- 协议编号
    ,P1.OBJINR -- 源协议编号
    ,case when P1.OBJTYP='BRD' then '222312'
     when P1.OBJTYP='LID' then '222311'
     when P1.OBJTYP='BED' then '222310'
     when P1.OBJTYP='CPD' then '222309'
     when P1.OBJTYP='GID' then '226303'
     when P1.OBJTYP='GWD' then '222306'
     when P1.OBJTYP='LED' then '222307'
     when P1.OBJTYP='BOD' then '222308'
     when P1.OBJTYP='ACT' then '130015'
     when P1.OBJTYP='DBG' then '226101'
     when P1.OBJTYP='DBH' then '226201'
     when P1.OBJTYP='DBK' then '226202'
     when P1.OBJTYP='DBQ' then '226301'
     when P1.OBJTYP='DBR' then '226102'
     when P1.OBJTYP='DBS' then '226302'
     when P1.OBJTYP='CLR' then '222313'
     when P1.OBJTYP='DID' then '222314'	
     when P1.OBJTYP='BDD' then '222315'	
else P1.OBJTYP end -- 协议类型代码
    ,P1.OBJTYP -- 业务表名称
    ,case when R1.TARGET_CD_VAL is not null then R1.TARGET_CD_VAL else substr('@'|| P1.CBC,1,30) end -- 金额类型代码
    ,P1.EXTID -- 外部金额类型
    ,P1.BEGDAT -- 金额有效期开始日期
    ,P1.ENDDAT -- 金额有效期结束日期
    ,nvl(trim(P1.CUR),'-') -- 币种代码
    ,P1.AMT -- 金额
    ,P1.CBEINR -- 对应金额源编号
    ,P1.FRENUM -- 冻结编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'isbs_cbb' -- 源表名称
    ,'isbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_cbb p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CBC=R1.SRC_CODE_VAL
AND R1.SORC_SYS_CD='ISBS'
AND R1.SRC_TAB_EN_NAME='ISBS_CBB'
AND R1.SRC_FIELD_EN_NAME='CBC'
AND R1.TARGET_TAB_EN_NAME='AGT_INTSTL_BAL_H'
AND R1.TARGET_TAB_FIELD_EN_NAME='AMT_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_intstl_bal_h_isbsf1_cl(
            bal_id -- 余额编号
    ,lp_id -- 法人编号
    ,agt_id -- 协议编号
    ,src_agt_id -- 源协议编号
    ,agt_type_cd -- 协议类型代码
    ,bus_table_name -- 业务表名称
    ,amt_type_cd -- 金额类型代码
    ,ext_amt_type -- 外部金额类型
    ,amt_vp_start_dt -- 金额有效期开始日期
    ,amt_vp_end_dt -- 金额有效期结束日期
    ,curr_cd -- 币种代码
    ,amt -- 金额
    ,cors_amt_src_id -- 对应金额源编号
    ,froz_id -- 冻结编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_intstl_bal_h_isbsf1_op(
            bal_id -- 余额编号
    ,lp_id -- 法人编号
    ,agt_id -- 协议编号
    ,src_agt_id -- 源协议编号
    ,agt_type_cd -- 协议类型代码
    ,bus_table_name -- 业务表名称
    ,amt_type_cd -- 金额类型代码
    ,ext_amt_type -- 外部金额类型
    ,amt_vp_start_dt -- 金额有效期开始日期
    ,amt_vp_end_dt -- 金额有效期结束日期
    ,curr_cd -- 币种代码
    ,amt -- 金额
    ,cors_amt_src_id -- 对应金额源编号
    ,froz_id -- 冻结编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.bal_id, o.bal_id) as bal_id -- 余额编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.src_agt_id, o.src_agt_id) as src_agt_id -- 源协议编号
    ,nvl(n.agt_type_cd, o.agt_type_cd) as agt_type_cd -- 协议类型代码
    ,nvl(n.bus_table_name, o.bus_table_name) as bus_table_name -- 业务表名称
    ,nvl(n.amt_type_cd, o.amt_type_cd) as amt_type_cd -- 金额类型代码
    ,nvl(n.ext_amt_type, o.ext_amt_type) as ext_amt_type -- 外部金额类型
    ,nvl(n.amt_vp_start_dt, o.amt_vp_start_dt) as amt_vp_start_dt -- 金额有效期开始日期
    ,nvl(n.amt_vp_end_dt, o.amt_vp_end_dt) as amt_vp_end_dt -- 金额有效期结束日期
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.amt, o.amt) as amt -- 金额
    ,nvl(n.cors_amt_src_id, o.cors_amt_src_id) as cors_amt_src_id -- 对应金额源编号
    ,nvl(n.froz_id, o.froz_id) as froz_id -- 冻结编号
    ,case when
            n.bal_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bal_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bal_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_intstl_bal_h_isbsf1_tm n
    full join (select * from ${iml_schema}.agt_intstl_bal_h_isbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.bal_id = n.bal_id
            and o.lp_id = n.lp_id
where (
        o.bal_id is null
        and o.lp_id is null
    )
    or (
        n.bal_id is null
        and n.lp_id is null
    )
    or (
        o.agt_id <> n.agt_id
        or o.src_agt_id <> n.src_agt_id
        or o.agt_type_cd <> n.agt_type_cd
        or o.bus_table_name <> n.bus_table_name
        or o.amt_type_cd <> n.amt_type_cd
        or o.ext_amt_type <> n.ext_amt_type
        or o.amt_vp_start_dt <> n.amt_vp_start_dt
        or o.amt_vp_end_dt <> n.amt_vp_end_dt
        or o.curr_cd <> n.curr_cd
        or o.amt <> n.amt
        or o.cors_amt_src_id <> n.cors_amt_src_id
        or o.froz_id <> n.froz_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_intstl_bal_h_isbsf1_cl(
            bal_id -- 余额编号
    ,lp_id -- 法人编号
    ,agt_id -- 协议编号
    ,src_agt_id -- 源协议编号
    ,agt_type_cd -- 协议类型代码
    ,bus_table_name -- 业务表名称
    ,amt_type_cd -- 金额类型代码
    ,ext_amt_type -- 外部金额类型
    ,amt_vp_start_dt -- 金额有效期开始日期
    ,amt_vp_end_dt -- 金额有效期结束日期
    ,curr_cd -- 币种代码
    ,amt -- 金额
    ,cors_amt_src_id -- 对应金额源编号
    ,froz_id -- 冻结编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_intstl_bal_h_isbsf1_op(
            bal_id -- 余额编号
    ,lp_id -- 法人编号
    ,agt_id -- 协议编号
    ,src_agt_id -- 源协议编号
    ,agt_type_cd -- 协议类型代码
    ,bus_table_name -- 业务表名称
    ,amt_type_cd -- 金额类型代码
    ,ext_amt_type -- 外部金额类型
    ,amt_vp_start_dt -- 金额有效期开始日期
    ,amt_vp_end_dt -- 金额有效期结束日期
    ,curr_cd -- 币种代码
    ,amt -- 金额
    ,cors_amt_src_id -- 对应金额源编号
    ,froz_id -- 冻结编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.bal_id -- 余额编号
    ,o.lp_id -- 法人编号
    ,o.agt_id -- 协议编号
    ,o.src_agt_id -- 源协议编号
    ,o.agt_type_cd -- 协议类型代码
    ,o.bus_table_name -- 业务表名称
    ,o.amt_type_cd -- 金额类型代码
    ,o.ext_amt_type -- 外部金额类型
    ,o.amt_vp_start_dt -- 金额有效期开始日期
    ,o.amt_vp_end_dt -- 金额有效期结束日期
    ,o.curr_cd -- 币种代码
    ,o.amt -- 金额
    ,o.cors_amt_src_id -- 对应金额源编号
    ,o.froz_id -- 冻结编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_intstl_bal_h_isbsf1_bk o
    left join ${iml_schema}.agt_intstl_bal_h_isbsf1_op n
        on
            o.bal_id = n.bal_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_intstl_bal_h_isbsf1_cl d
        on
            o.bal_id = d.bal_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_intstl_bal_h;
alter table ${iml_schema}.agt_intstl_bal_h truncate partition for ('isbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_intstl_bal_h exchange subpartition p_isbsf1_19000101 with table ${iml_schema}.agt_intstl_bal_h_isbsf1_cl;
alter table ${iml_schema}.agt_intstl_bal_h exchange subpartition p_isbsf1_20991231 with table ${iml_schema}.agt_intstl_bal_h_isbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_intstl_bal_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_intstl_bal_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_intstl_bal_h_isbsf1_op purge;
drop table ${iml_schema}.agt_intstl_bal_h_isbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_intstl_bal_h_isbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_intstl_bal_h', partname => 'p_isbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
