/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_obank_guar_mimsf1
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
alter table ${iml_schema}.ast_col_obank_guar add partition p_mimsf1 values ('mimsf1')(
        subpartition p_mimsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_mimsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_obank_guar_mimsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_obank_guar partition for ('mimsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ast_col_obank_guar_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_obank_guar_mimsf1_op purge;
drop table ${iml_schema}.ast_col_obank_guar_mimsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_obank_guar_mimsf1_tm nologging
compress ${option_switch} for query high
as select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,hxb_prior_seq_comb_cd -- 我行优先偿权顺序组合代码
    ,obank_name -- 他行名称
    ,obank_set_sec_right_amt -- 他行设定担保权金额
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_obank_guar partition for ('mimsf1')
where 0=1
;

create table ${iml_schema}.ast_col_obank_guar_mimsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_obank_guar partition for ('mimsf1') where 0=1;

create table ${iml_schema}.ast_col_obank_guar_mimsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_obank_guar partition for ('mimsf1') where 0=1;

-- 3.1 get new data into table
-- mims_si_otherguar-
insert into ${iml_schema}.ast_col_obank_guar_mimsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,hxb_prior_seq_comb_cd -- 我行优先偿权顺序组合代码
    ,obank_name -- 他行名称
    ,obank_set_sec_right_amt -- 他行设定担保权金额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SCCODE -- 资产编号
    ,'9999' -- 法人编号
    ,P1.SEQNO -- 序号
    ,P1.SEQNUMBER -- 我行优先偿权顺序组合代码
    ,P1.OTHERBANKNAME -- 他行名称
    ,P1.OTHERMONEY -- 他行设定担保权金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mims_si_otherguar' -- 源表名称
    ,'mimsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_si_otherguar p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ast_col_obank_guar_mimsf1_cl(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,hxb_prior_seq_comb_cd -- 我行优先偿权顺序组合代码
    ,obank_name -- 他行名称
    ,obank_set_sec_right_amt -- 他行设定担保权金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_col_obank_guar_mimsf1_op(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,hxb_prior_seq_comb_cd -- 我行优先偿权顺序组合代码
    ,obank_name -- 他行名称
    ,obank_set_sec_right_amt -- 他行设定担保权金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.asset_id, o.asset_id) as asset_id -- 资产编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.hxb_prior_seq_comb_cd, o.hxb_prior_seq_comb_cd) as hxb_prior_seq_comb_cd -- 我行优先偿权顺序组合代码
    ,nvl(n.obank_name, o.obank_name) as obank_name -- 他行名称
    ,nvl(n.obank_set_sec_right_amt, o.obank_set_sec_right_amt) as obank_set_sec_right_amt -- 他行设定担保权金额
    ,case when
            n.asset_id is null
            and n.lp_id is null
            and n.seq_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.asset_id is null
            and n.lp_id is null
            and n.seq_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.asset_id is null
            and n.lp_id is null
            and n.seq_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_obank_guar_mimsf1_tm n
    full join (select * from ${iml_schema}.ast_col_obank_guar_mimsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
            and o.seq_num = n.seq_num
where (
        o.asset_id is null
        and o.lp_id is null
        and o.seq_num is null
    )
    or (
        n.asset_id is null
        and n.lp_id is null
        and n.seq_num is null
    )
    or (
        o.hxb_prior_seq_comb_cd <> n.hxb_prior_seq_comb_cd
        or o.obank_name <> n.obank_name
        or o.obank_set_sec_right_amt <> n.obank_set_sec_right_amt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ast_col_obank_guar_mimsf1_cl(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,hxb_prior_seq_comb_cd -- 我行优先偿权顺序组合代码
    ,obank_name -- 他行名称
    ,obank_set_sec_right_amt -- 他行设定担保权金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_col_obank_guar_mimsf1_op(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,hxb_prior_seq_comb_cd -- 我行优先偿权顺序组合代码
    ,obank_name -- 他行名称
    ,obank_set_sec_right_amt -- 他行设定担保权金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.asset_id -- 资产编号
    ,o.lp_id -- 法人编号
    ,o.seq_num -- 序号
    ,o.hxb_prior_seq_comb_cd -- 我行优先偿权顺序组合代码
    ,o.obank_name -- 他行名称
    ,o.obank_set_sec_right_amt -- 他行设定担保权金额
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_obank_guar_mimsf1_bk o
    left join ${iml_schema}.ast_col_obank_guar_mimsf1_op n
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
            and o.seq_num = n.seq_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ast_col_obank_guar_mimsf1_cl d
        on
            o.asset_id = d.asset_id
            and o.lp_id = d.lp_id
            and o.seq_num = d.seq_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.ast_col_obank_guar;
alter table ${iml_schema}.ast_col_obank_guar truncate partition for ('mimsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.ast_col_obank_guar exchange subpartition p_mimsf1_19000101 with table ${iml_schema}.ast_col_obank_guar_mimsf1_cl;
alter table ${iml_schema}.ast_col_obank_guar exchange subpartition p_mimsf1_20991231 with table ${iml_schema}.ast_col_obank_guar_mimsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_obank_guar to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ast_col_obank_guar_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_obank_guar_mimsf1_op purge;
drop table ${iml_schema}.ast_col_obank_guar_mimsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ast_col_obank_guar_mimsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_obank_guar', partname => 'p_mimsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
